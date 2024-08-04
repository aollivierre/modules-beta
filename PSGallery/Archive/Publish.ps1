$secretsPath = "$PSScriptroot\secrets.psd1"
$secrets = Import-PowerShellDataFile -Path $secretsPath
$apiKey = $secrets.PSGalleryAPIKey




Publish-Module -Path $ModulePath -NuGetApiKey $ApiKey


# ./build.ps1 -Tasks publish -ApiKey $apiKey


# Publish-Module -Name <moduleName> -NuGetApiKey <apiKey>