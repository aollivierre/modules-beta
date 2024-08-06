# Define the script directory in the script scope
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path

function Publish-ModuleToGallery {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$SecretsPath = 'C:\Code\CB\ModuleBuilder\Sampler\secrets.psd1'
    )

    begin {
        Write-EnhancedLog -Message "Starting Publish-ModuleToGallery function" -Level "INFO"
        Log-Params -Params $PSCmdlet.MyInvocation.BoundParameters

        # Construct the module path correctly
        $moduleBasePath = (Get-Item -Path $scriptDirectory).Parent.Parent.FullName
        $moduleName = Split-Path -Leaf $moduleBasePath
        $modulePath = Join-Path -Path $moduleBasePath -ChildPath "output\module\$moduleName"
        Write-EnhancedLog -Message "Dynamically constructed module path: $modulePath" -Level "INFO"
    }

    process {
        try {
            Write-EnhancedLog -Message "Secrets path: $SecretsPath" -Level "INFO"

            # Import secrets
            if (Test-Path -Path $SecretsPath) {
                $splatImportSecrets = @{
                    Path = $SecretsPath
                }
                $secrets = Import-PowerShellDataFile @splatImportSecrets
                $apiKey = $secrets.PSGalleryAPIKey

                Write-EnhancedLog -Message "Secrets imported." -Level "INFO"

                if (-not $apiKey) {
                    throw "API Key is not provided."
                }
            } else {
                throw "Secrets file not found at $SecretsPath."
            }

            # Log secrets path and API key status
            $params = @{
                SecretsPath = $SecretsPath
                ApiKey      = $apiKey
            }
            Log-Params -Params $params

            # Process the current module
            Write-EnhancedLog -Message "Processing module at path: $modulePath" -Level "INFO"

            $DBG

            if (Test-Path -Path $modulePath) {
                Write-EnhancedLog -Message "Output path exists: $modulePath" -Level "INFO"

                $moduleVersions = Get-ChildItem -Path $modulePath -Directory
                foreach ($moduleVersion in $moduleVersions) {
                    $moduleVersionPath = $moduleVersion.FullName
                    Write-EnhancedLog -Message "Processing module version path: $moduleVersionPath" -Level "INFO"

                    # Validate the module path
                    if (-not (Test-Path $moduleVersionPath)) {
                        throw "Module path '$moduleVersionPath' does not exist."
                    }

                    # Check if the module version already exists in the gallery
                    $moduleVersion = Split-Path -Path $moduleVersionPath -Leaf
                    $moduleName = Split-Path -Path $modulePath -Leaf
                    $moduleCheck = Find-Module -Name $moduleName -Repository PSGallery -ErrorAction SilentlyContinue
                    if ($moduleCheck -and $moduleCheck.Version -eq $moduleVersion) {
                        Write-EnhancedLog -Message "Module '$moduleName' version '$moduleVersion' already exists in the gallery. Skipping." -Level "WARNING"
                        continue
                    }

                    $DBG

                    # Publish module
                    $splatPublishModule = @{
                        Path        = $moduleVersionPath
                        NuGetApiKey = $apiKey
                    }
                    Write-EnhancedLog -Message "Publishing module from path: $moduleVersionPath" -Level "INFO"
                    Log-Params -Params $splatPublishModule

                    try {
                        Publish-Module @splatPublishModule
                        Write-EnhancedLog -Message "Module published from $moduleVersionPath." -Level "INFO"
                    }
                    catch {
                        Write-EnhancedLog -Message "Failed to publish module: $_" -Level "ERROR"
                    }
                }
            } else {
                Write-EnhancedLog -Message "Output path '$modulePath' does not exist." -Level "WARNING"
            }
        }
        catch {
            Write-EnhancedLog -Message "An error occurred while publishing the module: $_" -Level "ERROR"
            Handle-Error -ErrorRecord $_
            throw $_
        }
    }

    end {
        Write-EnhancedLog -Message "Publish-ModuleToGallery function execution completed." -Level "INFO"
    }
}

# Example of how to use the Publish-ModuleToGallery function
$splatPublishModuleToGallery = @{
    SecretsPath = 'C:\Code\CB\ModuleBuilder\Sampler\secrets.psd1'
}

Publish-ModuleToGallery @splatPublishModuleToGallery
