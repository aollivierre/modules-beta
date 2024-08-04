#Region '.\Classes\Logger.ps1' -1

class Logger {
    [void] LogClassCall([string]$Message, [string]$Level = 'INFO') {
        $callerFunction = ''
        $callerClass = ''

        # Get the PowerShell call stack
        $callStack = Get-PSCallStack

        # Determine the correct index based on the call stack depth
        $stackIndex = if ($callStack.Count -ge 3) { 2 } else { 1 }

        # Capture the calling function if it exists
        if ($callStack.Count -ge $stackIndex + 1) {
            $callerFunction = $callStack[$stackIndex].Command
        }

        # Use .NET stack trace to get the calling class if it exists
        $Loggingstacktrace = [System.Diagnostics.stacktrace]::new($true)
        for ($i = $stackIndex + 1; $i -lt $Loggingstacktrace.FrameCount; $i++) {
            $frame = $Loggingstacktrace.GetFrame($i)
            $methodBase = $frame.GetMethod()
            if ($null -ne $methodBase -and $null -ne $methodBase.DeclaringType) {
                # Check if the declaring type is not a PowerShell internal type
                if ($methodBase.DeclaringType.FullName -notmatch '^System\.|^Microsoft\.') {
                    $callerClass = $methodBase.DeclaringType.FullName
                    break
                }
            }
        }

        $callerInfo = ''
        if ($callerClass) {
            $callerInfo += "[Class: $callerClass] "
        }
        if ($callerFunction) {
            $callerInfo += "[Function: $callerFunction]"
        }

        $formattedMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $($env:COMPUTERNAME): [$Level] $callerInfo $Message"

        # Set foreground color based on log level
        $ForegroundColor = [ConsoleColor]::White
        switch ($Level) {
            'DEBUG' { $ForegroundColor = [ConsoleColor]::Gray }
            'INFO' { $ForegroundColor = [ConsoleColor]::Green }
            'NOTICE' { $ForegroundColor = [ConsoleColor]::Cyan }
            'WARNING' { $ForegroundColor = [ConsoleColor]::Yellow }
            'ERROR' { $ForegroundColor = [ConsoleColor]::Red }
            'CRITICAL' { $ForegroundColor = [ConsoleColor]::Magenta }
            default { $ForegroundColor = [ConsoleColor]::White }
        }

        # Check if $Host.UI.RawUI.ForegroundColor is accessible
        if ($global:Host -and $global:Host.UI -and $global:Host.UI.RawUI) {
            $currentForegroundColor = $global:Host.UI.RawUI.ForegroundColor
            $global:Host.UI.RawUI.ForegroundColor = $ForegroundColor
            Write-Host $formattedMessage
            $global:Host.UI.RawUI.ForegroundColor = $currentForegroundColor
        } else {
            Write-Host $formattedMessage -ForegroundColor $ForegroundColor
        }
    }
}
#EndRegion '.\Classes\Logger.ps1' 64
#Region '.\Private\AppendCSVLog.ps1' -1

function AppendCSVLog {
    param (
        [string]$Message,
        [string]$CSVFilePath_1001
           
    )
    
    $csvData = [PSCustomObject]@{
        TimeStamp    = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
        ComputerName = $env:COMPUTERNAME
        Message      = $Message
    }
    
    $csvData | Export-Csv -Path $CSVFilePath_1001 -Append -NoTypeInformation -Force
}
#EndRegion '.\Private\AppendCSVLog.ps1' 16
#Region '.\Private\CreateEventLogSource.ps1' -1

function CreateEventLogSource($logName, $EventSource) {
    try {
        if ($PSVersionTable.PSVersion.Major -lt 6) {
            New-EventLog -LogName $logName -Source $EventSource
        }
        else {
            [System.Diagnostics.EventLog]::CreateEventSource($EventSource, $logName)
        }
        Write-Host "Event source '$EventSource' created in log '$logName'" -ForegroundColor Green
    }
    catch {
        Write-Warning "Error creating the event log. Make sure you run PowerShell as an Administrator."
    }
}
#EndRegion '.\Private\CreateEventLogSource.ps1' 15
#Region '.\Private\CreateEventSourceAndLog.ps1' -1

function CreateEventSourceAndLog {

# $LogName = (Get-Date -Format "HHmmss") + "_$LoggingDeploymentName"
# $EventSource = (Get-Date -Format "HHmmss") + "_$LoggingDeploymentName"
    
# Call the Create-EventSourceAndLog function
# CreateEventSourceAndLog -LogName $LogName -EventSource $EventSource
    
# Call the Write-CustomEventLog function with custom parameters and level
# Write-CustomEventLog -LogName $LogName -EventSource $EventSource -EventMessage "Outlook Signature Restore completed with warnings." -EventID 1001 -Level 'WARNING'

    param (
        [string]$LogName,
        [string]$EventSource
    )
    
    
    # Validate parameters
    if (-not $LogName) {
        Write-Warning "LogName is required."
        return
    }
    if (-not $EventSource) {
        Write-Warning "Source is required."
        return
    }

    
    
    # Check if the event log exists
    if (-not (Get-WinEvent -ListLog $LogName -ErrorAction SilentlyContinue)) {
        # CreateEventLogSource $LogName $EventSource
    }
    # Check if the event source exists
    elseif (-not ([System.Diagnostics.EventLog]::SourceExists($EventSource))) {
        # Unregister the source if it's registered with a different log
        $existingLogName = (Get-WinEvent -ListLog * | Where-Object { $_.LogName -contains $EventSource }).LogName
        if ($existingLogName -ne $LogName) {
            Remove-EventLog -Source $EventSource -ErrorAction SilentlyContinue
        }
        # CreateEventLogSource $LogName $EventSource
    }
    else {
        Write-Host "Event source '$EventSource' already exists in log '$LogName'" -ForegroundColor Yellow
    }
}
#EndRegion '.\Private\CreateEventSourceAndLog.ps1' 47
#Region '.\Private\Export-EventLog.ps1' -1

function Export-EventLog {

        
    # # Example usage
    # $LogName = '$LoggingDeploymentNameLog'
    # # $ExportPath = 'Path\to\your\exported\eventlog.evtx'
    # $ExportPath = "C:\code\$LoggingDeploymentName\exports\Logs\$logname.evtx"
    # Export-EventLog -LogName $LogName -ExportPath $ExportPath


    param (
        [Parameter(Mandatory = $true)]
        [string]$LogName,
        [Parameter(Mandatory = $true)]
        [string]$ExportPath
    )
    
    try {
        wevtutil epl $LogName $ExportPath
    
        if (Test-Path $ExportPath) {
            Write-EnhancedLog -Message "Event log '$LogName' exported to '$ExportPath'" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
        }
        else {
            Write-EnhancedLog -Message "Event log '$LogName' not exported: File does not exist at '$ExportPath'" -Level "WARNING" -ForegroundColor ([ConsoleColor]::Yellow)
        }
    }
    catch {
        Write-EnhancedLog -Message "Error exporting event log '$LogName': $($_.Exception.Message)" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
    }
}
#EndRegion '.\Private\Export-EventLog.ps1' 32
#Region '.\Private\Initialize-CSVDirectory.ps1' -1

function Initialize-CSVDirectory {

    # # Example usage of Initialize-CSVDirectory
    # try {
    #     $csvInitResult = Initialize-CSVDirectory -deploymentName "$LoggingDeploymentName" -computerName $env:COMPUTERNAME
    #     Write-Host "CSV initialization successful. CSV directory path: $($csvInitResult.CSVFilePath)" -ForegroundColor Green
    # } catch {
    #     Write-Host "CSV initialization failed: $_" -ForegroundColor Red
    # }


    param (
        [string]$deploymentName,
        [string]$computerName
    )

    $isWindowsOS = $false
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        $isWindowsOS = $isWindowsOS -or ($PSVersionTable.Platform -eq 'Win32NT')
    }
    else {
        $isWindowsOS = $isWindowsOS -or ($env:OS -eq 'Windows_NT')
    }

    $baseScriptPath = if ($isWindowsOS) { "C:\code" } else { "/home/code" }
    $scriptPath_1001 = Join-Path -Path $baseScriptPath -ChildPath $deploymentName
    $CSVDir_1001 = Join-Path -Path $scriptPath_1001 -ChildPath "exports/CSV"
    $CSVFilePath_1001 = Join-Path -Path $CSVDir_1001 -ChildPath "$computerName"

    try {
        if (-not (Test-Path $CSVFilePath_1001)) {
            Write-Host "Did not find CSV directory at $CSVFilePath_1001" -ForegroundColor Yellow
            Write-Host "Creating CSV directory at $CSVFilePath_1001" -ForegroundColor Yellow
            New-Item -ItemType Directory -Path $CSVFilePath_1001 -Force -ErrorAction Stop | Out-Null
            Write-Host "Created CSV directory at $CSVFilePath_1001" -ForegroundColor Green
        }

        return @{
            CSVFilePath = $CSVFilePath_1001
        }
    }
    catch {
        Write-Host "An error occurred while initializing CSV directory: $_" -ForegroundColor Red
    }
}

#EndRegion '.\Private\Initialize-CSVDirectory.ps1' 47
#Region '.\Private\Write-EventLogMessage.ps1' -1

function Write-EventLogMessage {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message,
    
        [string]$LogName = "$LoggingDeploymentName",
        [string]$EventSource,
    
        [int]$EventID = 1000  # Default event ID
    )
    
    $ErrorActionPreference = 'SilentlyContinue'
    $hadError = $false
    
    try {
        if (-not $EventSource) {
            throw "EventSource is required."
        }
    
        if ($PSVersionTable.PSVersion.Major -lt 6) {
            # PowerShell version is less than 6, use Write-EventLog
            Write-EventLog -LogName $logName -Source $EventSource -EntryType Information -EventId $EventID -Message $Message
        }
        else {
            # PowerShell version is 6 or greater, use System.Diagnostics.EventLog
            $eventLog = New-Object System.Diagnostics.EventLog($logName)
            $eventLog.Source = $EventSource
            $eventLog.WriteEntry($Message, [System.Diagnostics.EventLogEntryType]::Information, $EventID)
        }
    
        # Write-Host "Event log entry created: $Message" 
    }
    catch {
        Write-Host "Error creating event log entry: $_" 
        $hadError = $true
    }
    
    if (-not $hadError) {
        # Write-Host "Event log message writing completed successfully."
    }
}
    
#EndRegion '.\Private\Write-EventLogMessage.ps1' 44
#Region '.\Public\Add-Step.ps1' -1

function Add-Step {


# Example usage
# Add-Step -Description "Sample step description" -Action { Write-Output "Sample action" }

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

#EndRegion '.\Public\Add-Step.ps1' 39
#Region '.\Public\Export-Data.ps1' -1

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
#EndRegion '.\Public\Export-Data.ps1' 206
#Region '.\Public\Handle-Error.ps1' -1

function Handle-Error {

    # # Example usage of Handle-Error
    # try {
    #     # Intentionally cause an error for demonstration purposes
    #     throw "This is a test error"
    # } catch {
    #     Handle-Error -ErrorRecord $_
    # }

    param (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord
    )

    try {
        if ($PSVersionTable.PSVersion.Major -ge 7) {
            $fullErrorDetails = Get-Error -InputObject $ErrorRecord | Out-String
        }
        else {
            $fullErrorDetails = $ErrorRecord.Exception | Format-List * -Force | Out-String
        }

        Write-EnhancedLog -Message "Exception Message: $($ErrorRecord.Exception.Message)" -Level "ERROR"
        Write-EnhancedLog -Message "Full Exception: $fullErrorDetails" -Level "ERROR"
    }
    catch {
        # Fallback error handling in case of an unexpected error in the try block
        Write-EnhancedLog -Message "An error occurred while handling another error. Original Exception: $($ErrorRecord.Exception.Message)" -Level "CRITICAL"
        Write-EnhancedLog -Message "Handler Exception: $($_.Exception.Message)" -Level "CRITICAL"
        Write-EnhancedLog -Message "Handler Full Exception: $($_ | Out-String)" -Level "CRITICAL"
    }
}
#EndRegion '.\Public\Handle-Error.ps1' 34
#Region '.\Public\Initialize-ScriptAndLogging.ps1' -1




function Initialize-ScriptAndLogging {

    
    # Example usage of Initialize-ScriptAndLogging
    # try {
    #     $initResult = Initialize-ScriptAndLogging
    #     Write-Host "Initialization successful. Log file path: $($initResult.LogFile)" -ForegroundColor Green
    # } catch {
    #     Write-Host "Initialization failed: $_" -ForegroundColor Red
    # }

    $LoggingDeploymentName = $config.LoggingDeploymentName


    $isWindowsOS = $false
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        $isWindowsOS = $isWindowsOS -or ($PSVersionTable.Platform -eq 'Win32NT')
    }
    else {
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
            ScriptPath = $scriptPath_1001
            Filename   = $Filename
            LogPath    = $logPath
            LogFile    = $logFile
        }
    }
    catch {
        Write-Host "An error occurred while initializing script and logging: $_" -ForegroundColor Red
    }
}
#EndRegion '.\Public\Initialize-ScriptAndLogging.ps1' 62
#Region '.\Public\Log-And-Execute-Step.ps1' -1

function Log-And-Execute-Step {

    # Example usage
    # Log-And-Execute-Step

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
        }
        catch {
            Write-EnhancedLog -Message "Error in step: $($step.Description) - $($_.Exception.Message)" -Level "ERROR"
            Handle-Error -ErrorRecord $_
        }
    }

    End {
        Write-EnhancedLog -Message "Exiting Log-And-Execute-Step function" -Level "INFO"
    }
}
#EndRegion '.\Public\Log-And-Execute-Step.ps1' 32
#Region '.\Public\Log-Params.ps1' -1

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
#EndRegion '.\Public\Log-Params.ps1' 31
#Region '.\Public\Write-EnhancedLog.ps1' -1



function Write-EnhancedLog {

    # Example usage:
    # class TestClass {
    #     [Logger]$logger

    #     TestClass() {
    #         $this.logger = [Logger]::new()
    #     }

    #     [void] TestMethod() {
    #         Write-EnhancedLog -Message "This is a test message from TestClass."
    #     }
    # }

    # Direct call to Write-EnhancedLog for testing
    # Write-EnhancedLog -Message "This is a direct test message."

    # $testInstance = [TestClass]::new()
    # $testInstance.TestMethod()

    param (
        [string]$Message,
        [string]$Level = 'INFO',
        [ConsoleColor]$ForegroundColor = [ConsoleColor]::White,
        [switch]$UseModule = $false
    )

    $logger = [Logger]::new()
    $logger.LogClassCall($Message, $Level)
}
#EndRegion '.\Public\Write-EnhancedLog.ps1' 34