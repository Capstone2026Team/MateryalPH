[CmdletBinding()]
param(
    [switch] $GuardOnly,
    [switch] $KeepRunning
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$composeFile = Join-Path $repoRoot 'compose.test.yaml'
$testEnvironment = Join-Path $repoRoot 'services/api/.env.testing'
$projectName = 'materyalph_phase1_test'
$dockerCommand = (Get-Command docker -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty Source)
if (-not $dockerCommand) {
    $dockerCommand = Get-ChildItem "$env:LOCALAPPDATA\Programs\DockerDesktop" -Filter docker.exe -Recurse -ErrorAction SilentlyContinue |
        Select-Object -First 1 -ExpandProperty FullName
}
if (-not $dockerCommand) { throw 'Docker Desktop CLI was not found.' }

function Invoke-TestCompose {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]] $Arguments)
    & $dockerCommand compose --env-file $testEnvironment -f $composeFile -p $projectName @Arguments
    if ($LASTEXITCODE -ne 0) { throw "Docker Compose failed with exit code $LASTEXITCODE." }
}

if (-not (Test-Path -LiteralPath $testEnvironment)) {
    $bytes = New-Object byte[] 32
    [Security.Cryptography.RandomNumberGenerator]::Fill($bytes)
    $password = [Convert]::ToHexString($bytes).ToLowerInvariant()
    $keyBytes = New-Object byte[] 32
    [Security.Cryptography.RandomNumberGenerator]::Fill($keyBytes)
    $applicationKey = 'base64:' + [Convert]::ToBase64String($keyBytes)
    $content = @(
        'APP_NAME=MateryalPH'
        'APP_ENV=testing'
        "APP_KEY=$applicationKey"
        'APP_DEBUG=false'
        'APP_URL=http://localhost:8080'
        'APP_TIMEZONE=UTC'
        'BUSINESS_TIMEZONE=Asia/Manila'
        'HASH_DRIVER=argon2id'
        'DB_CONNECTION=pgsql'
        'DB_HOST=postgres-test'
        'DB_PORT=5432'
        'DB_DATABASE=materyalph_test'
        'DB_USERNAME=materyalph_test_runner'
        "DB_PASSWORD=$password"
        "TEST_DB_PASSWORD=$password"
        'TEST_DB_ALLOWED_HOSTS=postgres-test'
        'CACHE_STORE=array'
        'QUEUE_CONNECTION=sync'
        'SESSION_DRIVER=array'
        'MAIL_MAILER=array'
        'FINANCE_MODE=TEST'
        'WITHHOLDING_SCENARIO=NONE'
        'PLATFORM_TAX_PROFILE=NON_VAT'
        'LIVE_COMMERCE_ENABLED=false'
        'MATERIALS_ANALYTICS_ENABLED=false'
        'RECAPTCHA_ENABLED=false'
    )
    [IO.File]::WriteAllLines($testEnvironment, $content, [Text.UTF8Encoding]::new($false))
}

$testPasswordLine = Get-Content -LiteralPath $testEnvironment | Where-Object { $_ -like 'TEST_DB_PASSWORD=*' } | Select-Object -First 1
if (-not $testPasswordLine -or ($testPasswordLine.Substring('TEST_DB_PASSWORD='.Length)).Length -lt 32) {
    throw 'services/api/.env.testing must contain a test-only TEST_DB_PASSWORD of at least 32 characters.'
}

Push-Location $repoRoot
try {
    Invoke-TestCompose config --quiet
    Invoke-TestCompose up -d --build --wait postgres-test api-test

    $postgresContainer = (Invoke-TestCompose ps -q postgres-test | Select-Object -Last 1).Trim()
    $apiContainer = (Invoke-TestCompose ps -q api-test | Select-Object -Last 1).Trim()
    if (-not $postgresContainer -or -not $apiContainer) { throw 'The isolated test containers are not running.' }

    $postgresInspect = @(& $dockerCommand inspect $postgresContainer | ConvertFrom-Json)
    $apiInspect = @(& $dockerCommand inspect $apiContainer | ConvertFrom-Json)
    $postgresProject = [string]$postgresInspect[0].Config.Labels.'com.docker.compose.project'
    $apiProject = [string]$apiInspect[0].Config.Labels.'com.docker.compose.project'
    if ($postgresProject -ne $projectName -or $apiProject -ne $projectName) {
        throw 'Container labels do not match the isolated Phase 1 project.'
    }

    Invoke-TestCompose exec -T api-test composer install --no-interaction --prefer-dist --no-progress
    Invoke-TestCompose exec -T api-test sh /workspace/scripts/prepare-passport-keys.sh
    Invoke-TestCompose exec -T api-test php /workspace/scripts/verify-passport-keys.php
    Invoke-TestCompose exec -T api-test sh /workspace/scripts/test-passport-key-preparation.sh
    Invoke-TestCompose exec -T postgres-test psql -U materyalph_test_runner -d materyalph_test --set=ON_ERROR_STOP=1 -c 'CREATE TABLE IF NOT EXISTS isolation_guard_sentinel (id integer PRIMARY KEY);' | Out-Null
    Invoke-TestCompose exec -T postgres-test psql -U materyalph_test_runner -d materyalph_test --set=ON_ERROR_STOP=1 -c 'INSERT INTO isolation_guard_sentinel (id) VALUES (1) ON CONFLICT DO NOTHING;' | Out-Null

    Invoke-TestCompose exec -T api-test php /workspace/scripts/verify-test-schema.php --guard-only

    $negativeCases = @(
        @('-e', 'APP_ENV=development'),
        @('-e', 'DB_DATABASE=materyalph_dev'),
        @('-e', 'DB_URL=postgresql://unsafe.invalid/materyalph_dev'),
        @('-e', 'APP_CONFIG_CACHE=/tmp/unsafe-config.php'),
        @('-e', 'DB_PASSWORD=short'),
        @('-e', 'TEST_TOKEN=2')
    )
    foreach ($case in $negativeCases) {
        $previousErrorAction = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        & $dockerCommand compose --env-file $testEnvironment -f $composeFile -p $projectName exec -T @case api-test php /workspace/scripts/verify-test-schema.php --guard-only *> $null
        $negativeExitCode = $LASTEXITCODE
        $ErrorActionPreference = $previousErrorAction
        if ($negativeExitCode -eq 0) { throw "Isolation guard unexpectedly accepted negative case: $($case -join ' ')" }
    }

    $sentinelCount = (Invoke-TestCompose exec -T postgres-test psql -U materyalph_test_runner -d materyalph_test -tA -c 'SELECT count(*) FROM isolation_guard_sentinel;').Trim()
    if ($sentinelCount -ne '1') { throw 'A negative isolation check changed the sentinel database.' }

    Write-Host 'All static and live isolation checks passed.'
    if ($GuardOnly) { return }

    Invoke-TestCompose exec -T api-test php /workspace/scripts/verify-test-schema.php
    Invoke-TestCompose exec -T api-test vendor/bin/pint --test
    Invoke-TestCompose exec -T api-test vendor/bin/phpstan analyse --memory-limit=1G
    Invoke-TestCompose exec -T api-test php artisan test
}
finally {
    Pop-Location
    if (-not $KeepRunning) {
        & $dockerCommand compose --env-file $testEnvironment -f $composeFile -p $projectName stop api-test postgres-test redis-test | Out-Null
    }
}
