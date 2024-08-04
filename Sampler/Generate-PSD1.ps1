param (
    [string]$ModulePath = "C:\Code\modules-beta\EnhancedLoggingAO\2.5.0",
    [string]$ModuleName = "EnhancedLoggingAO",
    [string]$ModuleVersion = "1.0.0",
    [string]$Author = "Abdullah Ollivierre",
    [string]$CompanyName = "Your Company",
    [string]$Description = "Enhanced logging module for PowerShell scripts."
)

# Define paths
$publicPath = Join-Path -Path $ModulePath -ChildPath "Public"
$privatePath = Join-Path -Path $ModulePath -ChildPath "Private"
$psd1Path = Join-Path -Path $ModulePath -ChildPath "$ModuleName.psd1"

# Retrieve functions from Public and Private directories
$publicFunctions = Get-ChildItem -Path $publicPath -Filter "*.ps1" | ForEach-Object { $_.BaseName }
$privateFunctions = Get-ChildItem -Path $privatePath -Filter "*.ps1" | ForEach-Object { $_.BaseName }
$nestedModules = @()

# Add public and private functions to nested modules
foreach ($file in (Get-ChildItem -Path $publicPath -Filter "*.ps1") + (Get-ChildItem -Path $privatePath -Filter "*.ps1")) {
    $relativePath = $file.FullName.Replace($ModulePath + "\", "")
    $nestedModules += $relativePath
}

# Generate .psd1 content
$psd1Content = @{
    RootModule = "$ModuleName.psm1"
    ModuleVersion = $ModuleVersion
    CompatiblePSEditions = @("Core", "Desktop")
    GUID = [guid]::NewGuid().ToString()
    Author = $Author
    CompanyName = $CompanyName
    Copyright = "$CompanyName. All rights reserved."
    Description = $Description
    PowerShellVersion = "5.1"
    NestedModules = $nestedModules
    FunctionsToExport = $publicFunctions
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @("Logging", "PowerShell", "Enhanced")
            LicenseUri = "https://your-license-url"
            ProjectUri = "https://your-project-url"
        }
    }
} | ConvertTo-Json -Depth 3 | Out-String

# Add required formatting for PowerShell hashtable
$psd1Content = $psd1Content -replace '"([a-zA-Z_]+)"\s*:', '$1 ='

# Save to .psd1 file
$psd1Content | Out-File -FilePath $psd1Path -Encoding UTF8

Write-Host "Module manifest generated at: $psd1Path" -ForegroundColor Green
