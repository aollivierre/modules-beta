# Create the C:\tmp folder if it doesn't exist
$baseFolder = "C:\tmp"
if (-not (Test-Path -Path $baseFolder)) {
    New-Item -Path $baseFolder -ItemType Directory | Out-Null
}

# Function to log the time taken for each method
function Log-Time {
    param (
        [string]$MethodName,
        [int]$Time
    )
    Write-Host "$MethodName Time: $Time ms"
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

# Get the latest release info from GitHub
$url = (Invoke-RestMethod https://api.github.com/repos/PowerShell/PowerShell/releases/latest).assets | 
       Where-Object { $_.name -like '*win-x64.msi' } | 
       Select-Object -ExpandProperty browser_download_url

Write-Host "Downloading PowerShell from $url"

# Initialize stopwatch
$stopwatch = [System.Diagnostics.Stopwatch]::new()

# Method 1: Using Invoke-WebRequest
$destination = Get-DestinationPath -MethodName "Invoke-WebRequest" -Extension "msi"
$stopwatch.Restart()
Invoke-WebRequest -Uri $url -OutFile $destination
$stopwatch.Stop()
if (Verify-FileSize -filePath $destination -minSizeMB 100) {
    Log-Time -MethodName "Invoke-WebRequest" -Time $stopwatch.ElapsedMilliseconds
} else {
    Write-Host "Invoke-WebRequest: Download failed. File size check failed."
}

# Method 2: Using Invoke-RestMethod
$destination = Get-DestinationPath -MethodName "Invoke-RestMethod" -Extension "msi"
$stopwatch.Restart()
Invoke-RestMethod -Uri $url -OutFile $destination
$stopwatch.Stop()
if (Verify-FileSize -filePath $destination -minSizeMB 100) {
    Log-Time -MethodName "Invoke-RestMethod" -Time $stopwatch.ElapsedMilliseconds
} else {
    Write-Host "Invoke-RestMethod: Download failed. File size check failed."
}

# Method 3: Using System.Net.WebClient
$destination = Get-DestinationPath -MethodName "WebClient" -Extension "msi"
$webclient = [System.Net.WebClient]::new()
$stopwatch.Restart()
$webclient.DownloadFile($url, $destination)
$stopwatch.Stop()
$webclient.Dispose()
if (Verify-FileSize -filePath $destination -minSizeMB 100) {
    Log-Time -MethodName "WebClient" -Time $stopwatch.ElapsedMilliseconds
} else {
    Write-Host "WebClient: Download failed. File size check failed."
}

# Method 4: Using System.Net.Http.HttpClient
$destination = Get-DestinationPath -MethodName "HttpClient" -Extension "msi"
$httpclient = [System.Net.Http.HttpClient]::new()
$stopwatch.Restart()
$response = $httpclient.GetAsync($url).Result
[System.IO.File]::WriteAllBytes($destination, $response.Content.ReadAsByteArrayAsync().Result)
$stopwatch.Stop()
$httpclient.Dispose()
if (Verify-FileSize -filePath $destination -minSizeMB 100) {
    Log-Time -MethodName "HttpClient" -Time $stopwatch.ElapsedMilliseconds
} else {
    Write-Host "HttpClient: Download failed. File size check failed."
}

# Method 5: Using System.Net.Sockets.Socket
$destination = Get-DestinationPath -MethodName "Socket" -Extension "msi"
$stopwatch.Restart()
try {
    $uri = [System.Uri]::new($url)
    $request = [System.Text.Encoding]::ASCII.GetBytes("GET $($uri.AbsolutePath) HTTP/1.1`r`nHost: $($uri.Host)`r`nConnection: close`r`n`r`n")
    $address = [System.Net.Dns]::GetHostAddresses($uri.Host)[0]
    $endpoint = [System.Net.IPEndPoint]::new($address, 443)
    
    $socket = [System.Net.Sockets.Socket]::new([System.Net.Sockets.AddressFamily]::InterNetwork, [System.Net.Sockets.SocketType]::Stream, [System.Net.Sockets.ProtocolType]::Tcp)
    $socket.Connect($endpoint)
    
    $socket.Send($request)
    $response = ""
    $buffer = [byte[]]::new(8192)
    while ($true) {
        $received = $socket.Receive($buffer)
        if ($received -eq 0) { break }
        $response += [System.Text.Encoding]::ASCII.GetString($buffer, 0, $received)
    }
    
    $contentStartIndex = $response.IndexOf("`r`n`r`n") + 4
    if ($contentStartIndex -gt 4) {
        $content = $response.Substring($contentStartIndex)
        [System.IO.File]::WriteAllText($destination, $content)
    } else {
        Write-Host "Socket: Invalid response received."
    }
}
catch {
    Write-Host "Socket: Error downloading file - $_"
}
finally {
    $stopwatch.Stop()
    if (Verify-FileSize -filePath $destination -minSizeMB 100) {
        Log-Time -MethodName "Socket" -Time $stopwatch.ElapsedMilliseconds
    } else {
        Write-Host "Socket: Download failed. File size check failed."
    }
    $socket.Dispose()
}

# Method 6: Using Start-BitsTransfer
$destination = Get-DestinationPath -MethodName "Start-BitsTransfer" -Extension "msi"
$stopwatch.Restart()
$job = Start-BitsTransfer -Source $url -Destination $destination
while ($job.JobState -eq 'Transferring') {
    Start-Sleep -Seconds 1
}
$stopwatch.Stop()
if (Verify-FileSize -filePath $destination -minSizeMB 100) {
    Log-Time -MethodName "Start-BitsTransfer" -Time $stopwatch.ElapsedMilliseconds
} else {
    Write-Host "Start-BitsTransfer: Download failed. File size check failed."
}

# Summary of all methods
Write-Host "Summary:"
