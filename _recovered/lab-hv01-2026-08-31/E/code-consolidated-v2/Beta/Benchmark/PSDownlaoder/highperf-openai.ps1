param (
    [switch]$VerboseOutput
)

# Define the URL for the latest PowerShell 7 release
$url = (Invoke-RestMethod https://api.github.com/repos/PowerShell/PowerShell/releases/latest).assets | 
       Where-Object { $_.name -like '*win-x64.msi' } | 
       Select-Object -ExpandProperty browser_download_url

Write-Host "Downloading PowerShell from $url"

$baseFolder = "C:\tmp"
$minFileSizeMB = 100
$maxRetries = 3
$retryDelaySeconds = 2

# Function to log the time taken for each method
function Log-Time {
    param (
        [string]$MethodName,
        [int]$Time
    )
    Write-Host "$MethodName Time: $Time ms"
    return @{MethodName=$MethodName; Time=$Time}
}

# Function to check if the file size is greater than or equal to $minFileSizeMB
function Verify-FileSize {
    param (
        [string]$filePath,
        [int]$minSizeMB
    )
    $fileInfo = Get-Item $filePath
    return $fileInfo.Length -ge ($minSizeMB * 1MB)
}

# Function to create a folder for a method and return the destination path
function Get-DestinationPath {
    param (
        [string]$MethodName,
        [string]$Extension
    )
    $methodFolder = "$baseFolder\$MethodName"
    if (-not (Test-Path -Path $methodFolder)) {
        New-Item -Path $methodFolder -ItemType Directory | Out-Null
    }
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    return "$methodFolder\pwsh-$timestamp.$Extension"
}

# Function to download file using HttpClient with streaming and retry logic
function Download-FileWithHttpClient {
    param (
        [string]$url,
        [string]$destination
    )

    Add-Type -TypeDefinition @"
using System;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;

public class FileDownloader
{
    public static async Task DownloadFileAsync(string url, string destination, int maxRetries, int retryDelaySeconds, Action<string> logAction)
    {
        var handler = new SocketsHttpHandler
        {
            PooledConnectionLifetime = TimeSpan.FromMinutes(15)
        };

        var httpClient = new HttpClient(handler);
        int attempt = 0;
        while (attempt < maxRetries)
        {
            try
            {
                using (var response = await httpClient.GetAsync(url, HttpCompletionOption.ResponseHeadersRead))
                using (var streamToReadFrom = await response.Content.ReadAsStreamAsync())
                using (var fileStream = new FileStream(destination, FileMode.Create, FileAccess.Write, FileShare.None, bufferSize: 81920, useAsync: true))
                {
                    await streamToReadFrom.CopyToAsync(fileStream);
                }
                break;
            }
            catch (Exception ex)
            {
                logAction?.Invoke($"Attempt {attempt + 1} failed: {ex.Message}");
                attempt++;
                if (attempt >= maxRetries)
                {
                    throw;
                }
                await Task.Delay(TimeSpan.FromSeconds(retryDelaySeconds));
            }
        }
    }
}
"@

    [FileDownloader]::DownloadFileAsync($url, $destination, $maxRetries, $retryDelaySeconds, {
        param($message)
        if ($VerboseOutput) {
            Write-Host $message
        }
    }).GetAwaiter().GetResult()
}

# Create the C:\tmp folder if it doesn't exist
if (-not (Test-Path -Path $baseFolder)) {
    New-Item -Path $baseFolder -ItemType Directory | Out-Null
}

# Initialize stopwatch
$stopwatch = [System.Diagnostics.Stopwatch]::new()

# Collect results
$results = [System.Collections.Generic.List[PSObject]]::new()

# High-Performance Method: Using HttpClient with streaming and retry logic
$destination = Get-DestinationPath -MethodName "HttpClient-HighPerf" -Extension "msi"
$stopwatch.Restart()
try {
    Download-FileWithHttpClient -url $url -destination $destination
}
catch {
    Write-Host "HttpClient-HighPerf: Error downloading file - $_"
}
finally {
    $stopwatch.Stop()
    if (Verify-FileSize -filePath $destination -minSizeMB $minFileSizeMB) {
        $results.Add((Log-Time -MethodName "HttpClient-HighPerf" -Time $stopwatch.ElapsedMilliseconds))
    } else {
        Write-Host "HttpClient-HighPerf: Download failed. File size check failed."
    }
}

# Summary of all methods
Write-Host "Summary:"
foreach ($result in $results) {
    Write-Host "$($result.MethodName) Time: $($result.Time) ms"
}
