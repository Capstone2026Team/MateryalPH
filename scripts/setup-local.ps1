$ErrorActionPreference = 'Stop'

function New-RandomBytes {
    param([Parameter(Mandatory)][int] $Length)
    $bytes = New-Object byte[] $Length
    $generator = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    try { $generator.GetBytes($bytes) } finally { $generator.Dispose() }
    return $bytes
}

function New-LocalSecret {
    $bytes = New-RandomBytes 32
    return [Convert]::ToBase64String($bytes).Replace('+', '-').Replace('/', '_').TrimEnd('=')
}

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$dockerEnvPath = Join-Path $repositoryRoot '.env'
$apiExamplePath = Join-Path $repositoryRoot 'services/api/.env.example'
$apiEnvPath = Join-Path $repositoryRoot 'services/api/.env'

if (-not (Test-Path -LiteralPath $dockerEnvPath)) {
    $dockerTemplate = Get-Content -Raw -LiteralPath (Join-Path $repositoryRoot '.env.docker.example')
    $dockerTemplate = $dockerTemplate.Replace('DB_PASSWORD=', 'DB_PASSWORD=' + (New-LocalSecret))
    $dockerTemplate = $dockerTemplate.Replace('AWS_ACCESS_KEY_ID=', 'AWS_ACCESS_KEY_ID=materyalph-local')
    $dockerTemplate = $dockerTemplate.Replace('AWS_SECRET_ACCESS_KEY=', 'AWS_SECRET_ACCESS_KEY=' + (New-LocalSecret))
    [System.IO.File]::WriteAllText($dockerEnvPath, $dockerTemplate)
}

if (-not (Test-Path -LiteralPath $apiEnvPath)) {
    $apiTemplate = Get-Content -Raw -LiteralPath $apiExamplePath
    $appKey = 'base64:' + [Convert]::ToBase64String((New-RandomBytes 32))
    $apiTemplate = $apiTemplate.Replace('APP_KEY=', 'APP_KEY=' + $appKey)
    $dockerValues = @{}
    Get-Content -LiteralPath $dockerEnvPath | ForEach-Object {
        if ($_ -match '^(?<key>[^#=]+)=(?<value>.*)$') { $dockerValues[$Matches.key] = $Matches.value }
    }
    $apiTemplate = $apiTemplate.Replace('DB_PASSWORD=', 'DB_PASSWORD=' + $dockerValues.DB_PASSWORD)
    $apiTemplate = $apiTemplate.Replace('AWS_ACCESS_KEY_ID=', 'AWS_ACCESS_KEY_ID=' + $dockerValues.AWS_ACCESS_KEY_ID)
    $apiTemplate = $apiTemplate.Replace('AWS_SECRET_ACCESS_KEY=', 'AWS_SECRET_ACCESS_KEY=' + $dockerValues.AWS_SECRET_ACCESS_KEY)
    $apiTemplate = $apiTemplate.Replace('FINANCE_MODE=', 'FINANCE_MODE=DEMO')
    $apiTemplate = $apiTemplate.Replace('WITHHOLDING_SCENARIO=', 'WITHHOLDING_SCENARIO=DEMO_PLATFORM_WITHHOLDER')
    $apiTemplate = $apiTemplate.Replace('PLATFORM_TAX_PROFILE=', 'PLATFORM_TAX_PROFILE=DEMO_NONVAT')
    $apiTemplate = $apiTemplate.Replace('LIVE_COMMERCE_ENABLED=', 'LIVE_COMMERCE_ENABLED=false')
    $apiTemplate = $apiTemplate.Replace('MATERIALS_ANALYTICS_ENABLED=', 'MATERIALS_ANALYTICS_ENABLED=true')
    $apiTemplate = $apiTemplate.Replace('DEMO_DATASET_ID=', 'DEMO_DATASET_ID=materyalph-capstone-demo')
    $apiTemplate = $apiTemplate.Replace('DEMO_DATASET_LABEL=', 'DEMO_DATASET_LABEL="Capstone Demo Dataset"')
    $apiTemplate = $apiTemplate.Replace('DEMO_DATASET_AS_OF=', 'DEMO_DATASET_AS_OF=')
    [System.IO.File]::WriteAllText($apiEnvPath, $apiTemplate)
}

Write-Host 'Local environment files are ready. Secret values were not printed.'
