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

# Function to download the file using TcpClient and NetworkStream
function Download-FileUsingSocket {
    param (
        [string]$url,
        [string]$destination
    )
    $uri = [System.Uri]::new($url)
    $client = [System.Net.Sockets.TcpClient]::new($uri.Host, 443)
    $sslStream = [System.Net.Security.SslStream]::new($client.GetStream())
    $sslStream.AuthenticateAsClient($uri.Host)
    
    $request = "GET $($uri.AbsolutePath)$($uri.Query) HTTP/1.1`r`nHost: $($uri.Host)`r`nUser-Agent: PowerShell/7.4.3`r`nConnection: close`r`n`r`n"
    $requestBytes = [System.Text.Encoding]::ASCII.GetBytes($request)
    $sslStream.Write($requestBytes)
    $sslStream.Flush()

    $buffer = [byte[]]::new(8192)
    $response = [System.IO.MemoryStream]::new()
    
    while ($true) {
        $received = $sslStream.Read($buffer, 0, $buffer.Length)
        if ($received -eq 0) { break }
        $response.Write($buffer, 0, $received)
    }

    $response.Position = 0
    $reader = [System.IO.StreamReader]::new($response)
    $headers = ""
    while (($line = $reader.ReadLine()) -ne "") {
        $headers += $line + "`r`n"
    }

    if ($VerboseOutput) {
        Write-Host "Response Headers:`r`n$headers"
    }

    if ($headers -match "Location: (.+)") {
        $redirectUrl = $matches[1].Trim()
        if ($VerboseOutput) {
            Write-Host "Following redirect to $redirectUrl"
        }
        Download-FileUsingSocket -url $redirectUrl -destination $destination
        return
    }

    if ($headers -match "Content-Length: (\d+)") {
        $contentLength = [int]$matches[1]
        $contentBytes = [byte[]]::new($contentLength)
        $response.Read($contentBytes, 0, $contentLength)
        [System.IO.File]::WriteAllBytes($destination, $contentBytes)
    } else {
        Write-Host "Socket: Content-Length not found in headers."
    }
    
    $sslStream.Close()
    $client.Close()
}

# Create the C:\tmp folder if it doesn't exist
if (-not (Test-Path -Path $baseFolder)) {
    New-Item -Path $baseFolder -ItemType Directory | Out-Null
}

# Initialize stopwatch
$stopwatch = [System.Diagnostics.Stopwatch]::new()

# Collect results
$results = [System.Collections.Generic.List[PSObject]]::new()

# Method 1: Using Invoke-WebRequest
$destination = Get-DestinationPath -MethodName "Invoke-WebRequest" -Extension "msi"
$stopwatch.Restart()
Invoke-WebRequest -Uri $url -OutFile $destination
$stopwatch.Stop()
if (Verify-FileSize -filePath $destination -minSizeMB $minFileSizeMB) {
    $results.Add((Log-Time -MethodName "Invoke-WebRequest" -Time $stopwatch.ElapsedMilliseconds))
} else {
    Write-Host "Invoke-WebRequest: Download failed. File size check failed."
}

# Method 2: Using Invoke-RestMethod
$destination = Get-DestinationPath -MethodName "Invoke-RestMethod" -Extension "msi"
$stopwatch.Restart()
Invoke-RestMethod -Uri $url -OutFile $destination
$stopwatch.Stop()
if (Verify-FileSize -filePath $destination -minSizeMB $minFileSizeMB) {
    $results.Add((Log-Time -MethodName "Invoke-RestMethod" -Time $stopwatch.ElapsedMilliseconds))
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
if (Verify-FileSize -filePath $destination -minSizeMB $minFileSizeMB) {
    $results.Add((Log-Time -MethodName "WebClient" -Time $stopwatch.ElapsedMilliseconds))
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
if (Verify-FileSize -filePath $destination -minSizeMB $minFileSizeMB) {
    $results.Add((Log-Time -MethodName "HttpClient" -Time $stopwatch.ElapsedMilliseconds))
} else {
    Write-Host "HttpClient: Download failed. File size check failed."
}

# Method 5: Using TcpClient and SslStream (Socket)
$destination = Get-DestinationPath -MethodName "Socket" -Extension "msi"
$stopwatch.Restart()
try {
    Download-FileUsingSocket -url $url -destination $destination
}
catch {
    Write-Host "Socket: Error downloading file - $_"
}
finally {
    $stopwatch.Stop()
    if (Verify-FileSize -filePath $destination -minSizeMB $minFileSizeMB) {
        $results.Add((Log-Time -MethodName "Socket" -Time $stopwatch.ElapsedMilliseconds))
    } else {
        Write-Host "Socket: Download failed. File size check failed."
    }
}

# Method 6: Using Start-BitsTransfer
$destination = Get-DestinationPath -MethodName "Start-BitsTransfer" -Extension "msi"
$stopwatch.Restart()
$job = Start-BitsTransfer -Source $url -Destination $destination
while ($job.JobState -eq 'Transferring') {
    Start-Sleep -Seconds 1
}
$stopwatch.Stop()
if (Verify-FileSize -filePath $destination -minSizeMB $minFileSizeMB) {
    $results.Add((Log-Time -MethodName "Start-BitsTransfer" -Time $stopwatch.ElapsedMilliseconds))
} else {
    Write-Host "Start-BitsTransfer: Download failed. File size check failed."
}

# Summary of all methods
Write-Host "Summary:"
foreach ($result in $results) {
    Write-Host "$($result.MethodName) Time: $($result.Time) ms"
}
