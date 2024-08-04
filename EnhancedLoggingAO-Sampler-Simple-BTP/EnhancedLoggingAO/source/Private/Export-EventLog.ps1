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
