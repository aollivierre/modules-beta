$ModulePath = 'C:\Code\modules-beta\EnhancedBoilerPlateAO-Sampler-Simple-BTP\EnhancedBoilerPlateAO\output\module\EnhancedBoilerPlateAO\0.0.1'

$secretsPath = "C:\Code\modules-beta\EnhancedBoilerPlateAO-Sampler-Simple-BTP\EnhancedBoilerPlateAO\.build\tasks\secrets.psd1"
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