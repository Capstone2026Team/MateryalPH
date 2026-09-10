[CmdletBinding()]
param([switch] $KeepRunning, [string] $ResumeClone, [switch] $ResumeContracts)

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$runId = [Guid]::NewGuid().ToString('N').Substring(0, 12)
$sourceRoot = Join-Path $env:TEMP "materyalph-phase1-source-$runId"
$cloneRoot = Join-Path $env:TEMP "materyalph-phase1-clone-$runId"
$projectName = "materyalph_clean_$runId"
if ($ResumeContracts -and -not $ResumeClone) { throw 'ResumeContracts requires ResumeClone.' }
if ($ResumeClone) {
    $resolvedResume = [IO.Path]::GetFullPath($ResumeClone)
    if ((Split-Path -Parent $resolvedResume) -ne [IO.Path]::GetFullPath($env:TEMP).TrimEnd('\') -or
        (Split-Path -Leaf $resolvedResume) -notmatch '^materyalph-phase1-clone-([a-f0-9]{12})$') {
        throw 'ResumeClone must name a verifier-created clone directly under TEMP.'
    }
    $runId = $Matches[1]
    $cloneRoot = $resolvedResume
    $projectName = "materyalph_clean_$runId"
}

function Invoke-CleanCompose {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]] $Arguments)
    Invoke-Checked -Executable $dockerCommand -Arguments (@('compose', '--project-name', $projectName) + $Arguments)
}

function Invoke-Checked {
    param(
        [Parameter(Mandatory)][string] $Executable,
        [Parameter(ValueFromRemainingArguments = $true)][string[]] $Arguments
    )
    & $Executable @Arguments
    if ($LASTEXITCODE -ne 0) { throw "$Executable failed with exit code $LASTEXITCODE." }
}

function Set-DotEnvValue {
    param(
        [Parameter(Mandatory)][string] $Path,
        [Parameter(Mandatory)][string] $Name,
        [Parameter(Mandatory)][string] $Value
    )
    $lines = [Collections.Generic.List[string]](Get-Content -LiteralPath $Path)
    $index = -1
    for ($position = 0; $position -lt $lines.Count; $position++) {
        if ($lines[$position].StartsWith("$Name=", [StringComparison]::Ordinal)) {
            $index = $position
            break
        }
    }
    if ($index -ge 0) { $lines[$index] = "$Name=$Value" } else { $lines.Add("$Name=$Value") }
    [IO.File]::WriteAllLines($Path, $lines, [Text.UTF8Encoding]::new($false))
}

$dockerCommand = (Get-Command docker -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty Source)
if (-not $dockerCommand) {
    $dockerCommand = Get-ChildItem "$env:LOCALAPPDATA\Programs\DockerDesktop" -Filter docker.exe -Recurse -ErrorAction SilentlyContinue |
        Select-Object -First 1 -ExpandProperty FullName
}
if (-not $dockerCommand) { throw 'Docker Desktop CLI was not found.' }

if (-not $ResumeClone) {
New-Item -ItemType Directory -Path $sourceRoot | Out-Null
$files = & git -C $repositoryRoot -c core.quotepath=false ls-files --cached --others --exclude-standard
if ($LASTEXITCODE -ne 0) { throw 'Unable to enumerate the intended source tree.' }
foreach ($relativePath in $files) {
    $portablePath = $relativePath.Replace('\', '/')
    $excluded = $portablePath.StartsWith('materials/', [StringComparison]::OrdinalIgnoreCase) -or $portablePath -eq '.agents/skills/impeccable/scripts/bin/windows-x64/impeccable.exe'
    if ($excluded) {
        continue
    }
    $sourcePath = Join-Path $repositoryRoot $relativePath
    if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) { continue }
    $destinationPath = Join-Path $sourceRoot $relativePath
    $destinationDirectory = Split-Path -Parent $destinationPath
    New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
    Copy-Item -LiteralPath $sourcePath -Destination $destinationPath
}

Invoke-Checked -Executable git -Arguments @('-C', $sourceRoot, 'init', '--quiet')
Invoke-Checked -Executable git -Arguments @('-C', $sourceRoot, 'config', 'user.name', 'MateryalPH clean-start verifier')
Invoke-Checked -Executable git -Arguments @('-C', $sourceRoot, 'config', 'user.email', 'clean-start@materyalph.invalid')
Invoke-Checked -Executable git -Arguments @('-C', $sourceRoot, 'config', 'core.autocrlf', 'false')
Invoke-Checked -Executable git -Arguments @('-C', $sourceRoot, 'config', 'core.safecrlf', 'false')
Invoke-Checked -Executable git -Arguments @('-C', $sourceRoot, 'add', '--all')
Invoke-Checked -Executable git -Arguments @('-C', $sourceRoot, 'commit', '--quiet', '-m', 'test: isolated phase one clean start')
Invoke-Checked -Executable git -Arguments @('clone', '--quiet', $sourceRoot, $cloneRoot)

if (Test-Path -LiteralPath (Join-Path $cloneRoot 'materials')) {
    throw 'The excluded materials directory appeared in the clean clone.'
}
if (Test-Path -LiteralPath (Join-Path $cloneRoot 'services/api/.env')) {
    throw 'A credential file appeared in the clean clone before setup.'
}
if (Get-Command gitleaks -ErrorAction SilentlyContinue) {
    Invoke-Checked -Executable gitleaks -Arguments @('git', '--no-banner', '--redact', $cloneRoot)
} else {
    throw 'Gitleaks is required for the clean-source verification.'
}
} else {
    # Only the verifier itself may change when resuming a pre-test tooling failure.
    $files = & git -C $cloneRoot ls-files
    foreach ($relativePath in $files) {
        if ($relativePath -eq 'scripts/verify-clean-start.ps1') { continue }
        $candidatePath = Join-Path $repositoryRoot $relativePath
        $clonePath = Join-Path $cloneRoot $relativePath
        if (-not (Test-Path -LiteralPath $candidatePath) -or
            [IO.File]::ReadAllText($candidatePath).Replace("`r`n", "`n") -cne [IO.File]::ReadAllText($clonePath).Replace("`r`n", "`n")) {
            throw "Candidate changed; cannot resume: $relativePath"
        }
    }
    Copy-Item -LiteralPath $PSCommandPath -Destination (Join-Path $cloneRoot 'scripts/verify-clean-start.ps1')
}

Push-Location $cloneRoot
try {
    if (-not $ResumeContracts) {
    & powershell -ExecutionPolicy Bypass -File scripts/setup-local.ps1
    if ($LASTEXITCODE -ne 0) { throw 'Local environment setup failed in the clean clone.' }

    foreach ($name in @(
        'POSTGRES_PORT', 'REDIS_PORT', 'MAILPIT_SMTP_PORT', 'MAILPIT_UI_PORT',
        'MINIO_API_PORT', 'MINIO_CONSOLE_PORT', 'API_PORT'
    )) {
        Set-DotEnvValue -Path (Join-Path $cloneRoot '.env') -Name $name -Value '0'
    }

    foreach ($path in @('.env', 'services/api/.env')) {
        Set-DotEnvValue -Path (Join-Path $cloneRoot $path) -Name 'DB_DATABASE' -Value 'materyalph_test'
        Set-DotEnvValue -Path (Join-Path $cloneRoot $path) -Name 'DB_USERNAME' -Value 'materyalph_test_runner'
    }
    $testSettings = @{
        APP_ENV = 'testing'; APP_DEBUG = 'false'; DB_HOST = 'postgres-test'
        TEST_DB_ALLOWED_HOSTS = 'postgres-test'; CACHE_STORE = 'array'
        QUEUE_CONNECTION = 'sync'; SESSION_DRIVER = 'array'; MAIL_MAILER = 'array'
        FINANCE_MODE = 'TEST'; WITHHOLDING_SCENARIO = 'NONE'; PLATFORM_TAX_PROFILE = 'NON_VAT'
        LIVE_COMMERCE_ENABLED = 'false'; MATERIALS_ANALYTICS_ENABLED = 'false'; RECAPTCHA_ENABLED = 'false'
    }
    foreach ($name in $testSettings.Keys) {
        Set-DotEnvValue -Path (Join-Path $cloneRoot 'services/api/.env') -Name $name -Value $testSettings[$name]
    }
    # The alternate hostname is confined to this disposable clone. No development
    # Compose file, environment file, container, or volume is modified.
    [IO.File]::WriteAllText((Join-Path $cloneRoot 'compose.override.yaml'), @'
services:
  postgres:
    networks:
      default:
        aliases: [postgres-test]
'@)
    Invoke-CleanCompose config --quiet
    $configuration = (& $dockerCommand compose --project-name $projectName config --format json | ConvertFrom-Json)
    if ($LASTEXITCODE -ne 0 -or $configuration.name -ne $projectName) { throw 'Unexpected Compose project.' }
    foreach ($service in $configuration.services.PSObject.Properties.Value) {
        foreach ($mount in $service.volumes) {
            if ($mount.type -eq 'bind') {
                $actual = [IO.Path]::GetFullPath($mount.source).TrimEnd('\', '/')
                $expected = [IO.Path]::GetFullPath($cloneRoot).TrimEnd('\', '/')
                if ($actual -ne $expected -and -not $actual.StartsWith($expected + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
                    throw 'Compose contains a bind mount outside the clean clone.'
                }
            }
        }
    }
    foreach ($volume in $configuration.volumes.PSObject.Properties.Value) {
        if ($volume.external -or -not $volume.name.StartsWith($projectName + '_', [StringComparison]::Ordinal)) {
            throw 'Compose contains a non-isolated volume.'
        }
    }
    Invoke-CleanCompose up -d --wait postgres redis mailpit
    $ids = @(Invoke-CleanCompose ps -q)
    foreach ($id in $ids) {
        $container = @(& $dockerCommand inspect $id | ConvertFrom-Json)[0]
        if ($LASTEXITCODE -ne 0 -or $container.Config.Labels.'com.docker.compose.project' -ne $projectName) {
            throw 'Clean-clone container project identity could not be proven.'
        }
        foreach ($mount in $container.Mounts) {
            if ($mount.Type -eq 'volume' -and -not $mount.Name.StartsWith($projectName + '_', [StringComparison]::Ordinal)) {
                throw 'Refusing a volume outside the isolated clean-clone project.'
            }
            if ($mount.Type -eq 'bind') {
                $actual = $mount.Source.Replace('\', '/').ToLowerInvariant()
                $expected = $cloneRoot.Replace('\', '/').ToLowerInvariant()
                if ($actual -match '^/run/desktop/mnt/host/([a-z])/(.*)$') {
                    $actual = $Matches[1] + ':/' + $Matches[2]
                }
                if ($actual -ne $expected -and -not $actual.StartsWith($expected + '/', [StringComparison]::Ordinal)) {
                    throw 'Refusing a bind mount outside the clean clone.'
                }
            }
        }
    }
    $identity = (Invoke-CleanCompose exec -T postgres psql -U materyalph_test_runner -d materyalph_test -tA -c "SELECT current_database() || '|' || current_user || '|' || current_setting('server_version_num') || '|' || postgis_version();").Trim()
    if ($identity -notmatch '^materyalph_test\|materyalph_test_runner\|16[0-9]{4}\|3\.') {
        throw 'The live isolated PostgreSQL 16/PostGIS identity did not match.'
    }
    Write-Host "Pre-migration isolation passed: $projectName; $identity"
    Invoke-CleanCompose build api
    Invoke-CleanCompose run --rm --no-deps api composer install --no-interaction --prefer-dist --no-progress
    Invoke-CleanCompose run --rm --no-deps api php /workspace/scripts/verify-test-schema.php --guard-only
    Invoke-CleanCompose up -d --build --wait
    Invoke-CleanCompose exec -T api php /workspace/scripts/verify-passport-keys.php
    Invoke-CleanCompose exec -T api sh /workspace/scripts/test-passport-key-preparation.sh
    Invoke-CleanCompose exec -T api php artisan route:list --path=api/v1
    Invoke-CleanCompose exec -T api php artisan schedule:list
    Invoke-CleanCompose exec -T api php /workspace/scripts/verify-smtp-connectivity.php
    Invoke-CleanCompose stop horizon scheduler
    Invoke-CleanCompose exec -T api php /workspace/scripts/verify-test-schema.php
    Invoke-CleanCompose exec -T api vendor/bin/pint --test
    Invoke-CleanCompose exec -T api vendor/bin/phpstan analyse --memory-limit=1G
    Invoke-CleanCompose exec -T api php artisan test
    }

    Push-Location packages/api-contract
    try {
        Invoke-Checked -Executable npm.cmd -Arguments @('--script-shell=cmd.exe', 'ci', '--no-audit', '--no-fund')
        Invoke-Checked -Executable npm.cmd -Arguments @('--script-shell=cmd.exe', 'run', 'validate')
        Invoke-Checked -Executable npm.cmd -Arguments @('--script-shell=cmd.exe', 'run', 'generate')
        Push-Location generated/dart
        try {
            Invoke-Checked -Executable dart.bat -Arguments @('pub', 'get')
            Invoke-Checked -Executable dart.bat -Arguments @('run', 'build_runner', 'build')
        } finally { Pop-Location }
    } finally { Pop-Location }
    Invoke-Checked -Executable git -Arguments @('diff', '--exit-code', '--', 'packages/api-contract/generated', 'docs/architecture/erd.md', 'docs/architecture/data-dictionary.md')
    $newGenerated = & git ls-files --others --exclude-standard -- packages/api-contract/generated
    if ($newGenerated) { throw 'Regeneration produced new untracked contract files.' }
    Write-Host 'Candidate snapshot commit:'
    Invoke-Checked -Executable git -Arguments @('rev-parse', 'HEAD')
    Write-Host 'Exact API image:'
    Invoke-CleanCompose images -q api
    Write-Host "Clean-start verification passed in $cloneRoot"
} finally {
    if (-not $KeepRunning) {
        & $dockerCommand compose --project-name $projectName stop
    }
    Pop-Location
}
