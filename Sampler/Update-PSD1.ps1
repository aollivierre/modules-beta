function Update-ModuleManifest {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ModuleManifestPath,
        [Parameter(Mandatory = $true)]
        [string]$PublicPath,
        [Parameter(Mandatory = $true)]
        [string]$PrivatePath
    )

    # Ensure the manifest file exists
    if (-Not (Test-Path -Path $ModuleManifestPath)) {
        Write-Error "The specified module manifest file does not exist: $ModuleManifestPath"
        return
    }

    # Import the existing module manifest
    $manifest = Import-PowerShellDataFile -Path $ModuleManifestPath

    # Retrieve functions from Public and Private directories
    $publicFunctions = Get-ChildItem -Path $PublicPath -Filter "*.ps1" | ForEach-Object { $_.BaseName }
    $privateFunctions = Get-ChildItem -Path $PrivatePath -Filter "*.ps1" | ForEach-Object { $_.BaseName }
    $nestedModules = @()

    # Add public and private functions to nested modules
    foreach ($file in (Get-ChildItem -Path $PublicPath -Filter "*.ps1") + (Get-ChildItem -Path $PrivatePath -Filter "*.ps1")) {
        $relativePath = $file.FullName.Replace((Get-Item $ModuleManifestPath).Directory.FullName + "\", "")
        $nestedModules += $relativePath
    }

    # Update NestedModules and FunctionsToExport
    $manifest.NestedModules = $nestedModules
    $manifest.FunctionsToExport = $publicFunctions

    # Convert the hashtable back to a format suitable for a .psd1 file
    $psd1Content = $manifest | ConvertTo-Json -Depth 3 | Out-String
    $psd1Content = $psd1Content -replace '"([a-zA-Z_]+)"\s*:', '$1 ='

    # Save the updated manifest
    $psd1Content | Out-File -FilePath $ModuleManifestPath -Encoding UTF8

    Write-Host "Module manifest updated successfully at: $ModuleManifestPath" -ForegroundColor Green
}

# Example usage
$moduleManifestPath = "C:\Code\modules-beta\EnhancedLoggingAO\2.5.0\EnhancedLoggingAO.psd1"
$publicPath = "C:\Code\modules-beta\EnhancedLoggingAO\2.5.0\Public"
$privatePath = "C:\Code\modules-beta\EnhancedLoggingAO\2.5.0\Private"

Update-ModuleManifest -ModuleManifestPath $moduleManifestPath -PublicPath $publicPath -PrivatePath $privatePath
