function Add-Step {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Description,

        [Parameter(Mandatory = $true)]
        [ScriptBlock]$Action
    )

    Begin {
        Write-EnhancedLog -Message "Starting Add-Step function" -Level "INFO"
        Log-Params -Params @{
            Description = $Description
            Action = $Action.ToString()
        }
    }

    Process {
        try {
            Write-EnhancedLog -Message "Adding step: $Description" -Level "INFO"
            $global:steps.Add([PSCustomObject]@{ Description = $Description; Action = $Action })
        } catch {
            Write-EnhancedLog -Message "An error occurred while adding step: $($_.Exception.Message)" -Level "ERROR"
            Handle-Error -ErrorRecord $_
        }
    }

    End {
        Write-EnhancedLog -Message "Exiting Add-Step function" -Level "INFO"
    }
}

function Export-Data {
    <#
.SYNOPSIS
Exports data to various formats including CSV, JSON, XML, HTML, PlainText, Excel, PDF, Markdown, and YAML.

.DESCRIPTION
The Export-Data function exports provided data to multiple file formats based on switches provided. It supports CSV, JSON, XML, GridView (for display only), HTML, PlainText, Excel, PDF, Markdown, and YAML formats. This function is designed to work with any PSObject.

.PARAMETER Data
The data to be exported. This parameter accepts input of type PSObject.

.PARAMETER BaseOutputPath
The base path for output files without file extension. This path is used to generate filenames for each export format.

.PARAMETER IncludeCSV
Switch to include CSV format in the export.

.PARAMETER IncludeJSON
Switch to include JSON format in the export.

.PARAMETER IncludeXML
Switch to include XML format in the export.

.PARAMETER IncludeGridView
Switch to display the data in a GridView.

.PARAMETER IncludeHTML
Switch to include HTML format in the export.

.PARAMETER IncludePlainText
Switch to include PlainText format in the export.

.PARAMETER IncludePDF
Switch to include PDF format in the export. Requires intermediate HTML to PDF conversion.

.PARAMETER IncludeExcel
Switch to include Excel format in the export.

.PARAMETER IncludeMarkdown
Switch to include Markdown format in the export. Custom or use a module if available.

.PARAMETER IncludeYAML
Switch to include YAML format in the export. Requires 'powershell-yaml' module.

.EXAMPLE
PS> $data = Get-Process | Select-Object -First 10
PS> Export-Data -Data $data -BaseOutputPath "C:\exports\mydata" -IncludeCSV -IncludeJSON

This example exports the first 10 processes to CSV and JSON formats.
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [psobject]$Data,

        [Parameter(Mandatory = $true)]
        [string]$BaseOutputPath,

        [switch]$IncludeCSV,
        [switch]$IncludeJSON,
        [switch]$IncludeXML,
        [switch]$IncludeGridView,
        [switch]$IncludeHTML,
        [switch]$IncludePlainText,
        [switch]$IncludePDF, # Requires intermediate HTML to PDF conversion
        [switch]$IncludeExcel,
        [switch]$IncludeMarkdown, # Custom or use a module if available
        [switch]$IncludeYAML  # Requires 'powershell-yaml' module
    )

    Begin {




        # $modules = @('ImportExcel', 'powershell-yaml' , 'PSWriteHTML')
        # Install-MissingModules -RequiredModules $modules -Verbose


        # Setup the base path without extension
        Write-Host "BaseOutputPath before change: '$BaseOutputPath'"
        $basePathWithoutExtension = [System.IO.Path]::ChangeExtension($BaseOutputPath, $null)

        # Remove extension manually if it exists
        $basePathWithoutExtension = if ($BaseOutputPath -match '\.') {
            $BaseOutputPath.Substring(0, $BaseOutputPath.LastIndexOf('.'))
        }
        else {
            $BaseOutputPath
        }

        # Ensure no trailing periods
        $basePathWithoutExtension = $basePathWithoutExtension.TrimEnd('.')
    }

    Process {
        try {
            if ($IncludeCSV) {
                $csvPath = "$basePathWithoutExtension.csv"
                $Data | Export-Csv -Path $csvPath -NoTypeInformation
            }

            if ($IncludeJSON) {
                $jsonPath = "$basePathWithoutExtension.json"
                $Data | ConvertTo-Json -Depth 10 | Set-Content -Path $jsonPath
            }

            if ($IncludeXML) {
                $xmlPath = "$basePathWithoutExtension.xml"
                $Data | Export-Clixml -Path $xmlPath
            }

            if ($IncludeGridView) {
                $Data | Out-GridView -Title "Data Preview"
            }

            if ($IncludeHTML) {
                # Assumes $Data is the dataset you want to export to HTML
                # and $basePathWithoutExtension is prepared earlier in your script
                
                $htmlPath = "$basePathWithoutExtension.html"
                
                # Convert $Data to HTML using PSWriteHTML
                New-HTML -Title "Data Export Report" -FilePath $htmlPath -ShowHTML {
                    New-HTMLSection -HeaderText "Data Export Details" -Content {
                        New-HTMLTable -DataTable $Data -ScrollX -HideFooter
                    }
                }
            
                Write-Host "HTML report generated: '$htmlPath'"
            }
            

            if ($IncludePlainText) {
                $txtPath = "$basePathWithoutExtension.txt"
                $Data | Out-String | Set-Content -Path $txtPath
            }

            if ($IncludeExcel) {
                $excelPath = "$basePathWithoutExtension.xlsx"
                $Data | Export-Excel -Path $excelPath
            }

            # Assuming $Data holds the objects you want to serialize to YAML
            if ($IncludeYAML) {
                $yamlPath = "$basePathWithoutExtension.yaml"
    
                # Check if the powershell-yaml module is loaded
                if (Get-Module -ListAvailable -Name powershell-yaml) {
                    Import-Module powershell-yaml

                    # Process $Data to handle potentially problematic properties
                    $processedData = $Data | ForEach-Object {
                        $originalObject = $_
                        $properties = $_ | Get-Member -MemberType Properties
                        $clonedObject = New-Object -TypeName PSObject

                        foreach ($prop in $properties) {
                            try {
                                $clonedObject | Add-Member -MemberType NoteProperty -Name $prop.Name -Value $originalObject.$($prop.Name) -ErrorAction Stop
                            }
                            catch {
                                # Optionally handle or log the error. Skipping problematic property.
                                $clonedObject | Add-Member -MemberType NoteProperty -Name $prop.Name -Value "Error serializing property" -ErrorAction SilentlyContinue
                            }
                        }

                        return $clonedObject
                    }

                    # Convert the processed data to YAML and save it with UTF-16 LE encoding
                    $processedData | ConvertTo-Yaml | Set-Content -Path $yamlPath -Encoding Unicode
                    Write-Host "YAML export completed successfully: $yamlPath"
                }
                else {
                    Write-Warning "The 'powershell-yaml' module is not installed. YAML export skipped."
                }
            }

            if ($IncludeMarkdown) {
                # You'll need to implement or find a ConvertTo-Markdown function or use a suitable module
                $markdownPath = "$basePathWithoutExtension.md"
                $Data | ConvertTo-Markdown | Set-Content -Path $markdownPath
            }

            if ($IncludePDF) {
                # Convert HTML to PDF using external tool
                # This is a placeholder for the process. You will need to generate HTML first and then convert it.
                $pdfPath = "$basePathWithoutExtension.pdf"
                # Assuming you have a Convert-HtmlToPdf function or a similar mechanism
                $htmlPath = "$basePathWithoutExtension.html"
                $Data | ConvertTo-Html | Convert-HtmlToPdf -OutputPath $pdfPath
            }

        }
        catch {
            Write-Error "An error occurred during export: $_"
        }
    }

    End {
        Write-Verbose "Export-Data function execution completed."
    }
}

function Handle-Error {
    param (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord
    )

    try {
        if ($PSVersionTable.PSVersion.Major -ge 7) {
            $fullErrorDetails = Get-Error -InputObject $ErrorRecord | Out-String
        } else {
            $fullErrorDetails = $ErrorRecord.Exception | Format-List * -Force | Out-String
        }

        Write-EnhancedLog -Message "Exception Message: $($ErrorRecord.Exception.Message)" -Level "ERROR"
        Write-EnhancedLog -Message "Full Exception: $fullErrorDetails" -Level "ERROR"
    } catch {
        # Fallback error handling in case of an unexpected error in the try block
        Write-EnhancedLog -Message "An error occurred while handling another error. Original Exception: $($ErrorRecord.Exception.Message)" -Level "CRITICAL"
        Write-EnhancedLog -Message "Handler Exception: $($_.Exception.Message)" -Level "CRITICAL"
        Write-EnhancedLog -Message "Handler Full Exception: $($_ | Out-String)" -Level "CRITICAL"
    }
}

function Initialize-ScriptAndLogging {
    $isWindowsOS = $false
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        $isWindowsOS = $isWindowsOS -or ($PSVersionTable.Platform -eq 'Win32NT')
    } else {
        $isWindowsOS = $isWindowsOS -or ($env:OS -eq 'Windows_NT')
    }

    $deploymentName = "$LoggingDeploymentName" # Replace this with your actual deployment name
    $baseScriptPath = if ($isWindowsOS) { "C:\code" } else { "/home/code" }
    $scriptPath_1001 = Join-Path -Path $baseScriptPath -ChildPath $deploymentName
    $computerName = if ($isWindowsOS) { $env:COMPUTERNAME } else { (hostname) }

    try {
        if (-not (Test-Path -Path $scriptPath_1001)) {
            New-Item -ItemType Directory -Path $scriptPath_1001 -Force | Out-Null
            Write-Host "Created directory: $scriptPath_1001" -ForegroundColor Green
        }

        $Filename = "$LoggingDeploymentName"
        $logDir = Join-Path -Path $scriptPath_1001 -ChildPath "exports/Logs/$computerName"
        $logPath = Join-Path -Path $logDir -ChildPath "$(Get-Date -Format 'yyyy-MM-dd-HH-mm-ss')"

        if (-not (Test-Path $logPath)) {
            Write-Host "Did not find log directory at $logPath" -ForegroundColor Yellow
            Write-Host "Creating log directory at $logPath" -ForegroundColor Yellow
            New-Item -ItemType Directory -Path $logPath -Force -ErrorAction Stop | Out-Null
            Write-Host "Created log directory at $logPath" -ForegroundColor Green
        }

        $logFile = Join-Path -Path $logPath -ChildPath "$Filename-Transcript.log"
        Start-Transcript -Path $logFile -ErrorAction Stop | Out-Null

        return @{
            ScriptPath  = $scriptPath_1001
            Filename    = $Filename
            LogPath     = $logPath
            LogFile     = $logFile
        }
    } catch {
        Write-Host "An error occurred while initializing script and logging: $_" -ForegroundColor Red
    }
}

function Log-And-Execute-Step {
    [CmdletBinding()]
    param ()

    Begin {
        Write-EnhancedLog -Message "Starting Log-And-Execute-Step function" -Level "INFO"
    }

    Process {
        try {
            $global:currentStep++
            $totalSteps = $global:steps.Count
            $step = $global:steps[$global:currentStep - 1]
            Write-EnhancedLog -Message "Step [$global:currentStep/$totalSteps]: $($step.Description)" -Level "INFO"
            
            & $step.Action
        } catch {
            Write-EnhancedLog -Message "Error in step: $($step.Description) - $($_.Exception.Message)" -Level "ERROR"
            Handle-Error -ErrorRecord $_
        }
    }

    End {
        Write-EnhancedLog -Message "Exiting Log-And-Execute-Step function" -Level "INFO"
    }
}

function Log-Params {
    <#
    .SYNOPSIS
    Logs the provided parameters and their values.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable]$Params
    )

    Begin {
        # Write-EnhancedLog -Message "Starting Log-Params function" -Level "INFO"
    }

    Process {
        try {
            foreach ($key in $Params.Keys) {
                Write-EnhancedLog -Message "$key $($Params[$key])" -Level "INFO"
            }
        } catch {
            Write-EnhancedLog -Message "An error occurred while logging parameters: $($_.Exception.Message)" -Level "ERROR"
            Handle-Error -ErrorRecord $_
        }
    }

    End {
        # Write-EnhancedLog -Message "Exiting Log-Params function" -Level "INFO"
    }
}

function Write-EnhancedLog {
    param (
        [string]$Message,
        [string]$Level = 'INFO',
        [ConsoleColor]$ForegroundColor = [ConsoleColor]::White,
        [switch]$UseModule = $false
    )

    $logger = [Logger]::new()
    $logger.LogClassCall($Message, $Level)
}

Export-ModuleMember -function Add-Step, Export-Data, Handle-Error, Initialize-ScriptAndLogging, Log-And-Execute-Step, Log-Params, Write-EnhancedLog

