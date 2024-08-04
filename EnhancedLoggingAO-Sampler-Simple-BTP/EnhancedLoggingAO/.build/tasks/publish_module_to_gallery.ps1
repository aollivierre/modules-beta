$ModulePath = 'C:\Code\modules-beta\EnhancedLoggingAO-Sampler-Simple-BTP\EnhancedLoggingAO\output\module\EnhancedLoggingAO\0.0.1'

$secretsPath = "C:\Code\modules-beta\EnhancedLoggingAO-Sampler-Simple-BTP\EnhancedLoggingAO\.build\tasks\secrets.psd1"
$secrets = Import-PowerShellDataFile -Path $secretsPath
$apiKey = $secrets.PSGalleryAPIKey

Write-Host "Module Path: $ModulePath"
Write-Host "API Key: $ApiKey"

if (-not (Test-Path $ModulePath)) {
    throw "Module path '$ModulePath' does not exist."
}

if (-not $ApiKey) {
    throw "API Key is not provided."
}

Publish-Module -Path $ModulePath -NuGetApiKey $ApiKey