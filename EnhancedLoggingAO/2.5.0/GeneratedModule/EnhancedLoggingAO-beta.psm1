#Unique Tracking ID: 737397f0-c74e-4087-9b99-279b520b7448, Timestamp: 2024-03-20 12:25:26
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



#Unique Tracking ID: 4362313d-3c19-4d0c-933d-99438a6da297, Timestamp: 2024-03-20 12:25:26

function CreateEventSourceAndLog {
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
    
    # Function to create event log and source
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
    
# $LogName = (Get-Date -Format "HHmmss") + "_$LoggingDeploymentName"
# $EventSource = (Get-Date -Format "HHmmss") + "_$LoggingDeploymentName"
    
# Call the Create-EventSourceAndLog function
# CreateEventSourceAndLog -LogName $LogName -EventSource $EventSource
    
# Call the Write-CustomEventLog function with custom parameters and level
# Write-CustomEventLog -LogName $LogName -EventSource $EventSource -EventMessage "Outlook Signature Restore completed with warnings." -EventID 1001 -Level 'WARNING'



#Unique Tracking ID: c00ecaca-dd4b-4c7c-b80e-566b2f627e32, Timestamp: 2024-03-20 12:25:26
function Export-EventLog {
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
    
# # Example usage
# $LogName = '$LoggingDeploymentNameLog'
# # $ExportPath = 'Path\to\your\exported\eventlog.evtx'
# $ExportPath = "C:\code\$LoggingDeploymentName\exports\Logs\$logname.evtx"
# Export-EventLog -LogName $LogName -ExportPath $ExportPath



function Initialize-CSVDirectory {
    param (
        [string]$deploymentName,
        [string]$computerName
    )

    $isWindowsOS = $false
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        $isWindowsOS = $isWindowsOS -or ($PSVersionTable.Platform -eq 'Win32NT')
    } else {
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
    } catch {
        Write-Host "An error occurred while initializing CSV directory: $_" -ForegroundColor Red
    }
}

# # Example usage of Initialize-CSVDirectory
# try {
#     $csvInitResult = Initialize-CSVDirectory -deploymentName "$LoggingDeploymentName" -computerName $env:COMPUTERNAME
#     Write-Host "CSV initialization successful. CSV directory path: $($csvInitResult.CSVFilePath)" -ForegroundColor Green
# } catch {
#     Write-Host "CSV initialization failed: $_" -ForegroundColor Red
# }



#Unique Tracking ID: 132a90f9-6ba2-49cd-878b-279deadb8e22, Timestamp: 2024-03-20 12:25:26

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
    



