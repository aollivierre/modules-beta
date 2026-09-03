# Set the destination path
$destPath = "C:\tmp\PowerShell"

# Create the destination directory if it doesn't exist
if (-not (Test-Path $destPath)) {
    $null = New-Item -ItemType Directory -Path $destPath
}

# GitHub API endpoint for latest PowerShell release
$apiUrl = "api.github.com"
$apiPath = "/repos/PowerShell/PowerShell/releases/latest"

try {
    # Create a TcpClient and connect to the GitHub API
    $client = [System.Net.Sockets.TcpClient]::new()
    $client.Connect($apiUrl, 443)

    # Create an SSL stream
    $sslStream = [System.Net.Security.SslStream]::new($client.GetStream())
    $sslStream.AuthenticateAsClient($apiUrl)

    # Prepare the HTTP request
    $request = "GET $apiPath HTTP/1.1`r`nHost: $apiUrl`r`nUser-Agent: PowerShell`r`nAccept: application/json`r`nConnection: Close`r`n`r`n"
    $requestBytes = [System.Text.Encoding]::ASCII.GetBytes($request)

    # Send the request
    $sslStream.Write($requestBytes, 0, $requestBytes.Length)

    # Read the response
    $responseBytes = [byte[]]::new(8192)
    $response = [System.Text.StringBuilder]::new()
    do {
        $bytesRead = $sslStream.Read($responseBytes, 0, $responseBytes.Length)
        $null = $response.Append([System.Text.Encoding]::ASCII.GetString($responseBytes, 0, $bytesRead))
    } while ($bytesRead -gt 0)

    # Parse the JSON response
    $responseString = $response.ToString()
    $jsonStart = $responseString.IndexOf('{')
    $jsonEnd = $responseString.LastIndexOf('}')
    
    if ($jsonStart -ge 0 -and $jsonEnd -gt $jsonStart) {
        $jsonContent = $responseString.Substring($jsonStart, $jsonEnd - $jsonStart + 1)
        $jsonResponse = $jsonContent | ConvertFrom-Json

        # Find the asset for Windows x64
        $asset = $jsonResponse.assets | Where-Object { $_.name -like "*win-x64.zip" } | Select-Object -First 1

        if ($asset) {
            $downloadUrl = $asset.browser_download_url
            $fileName = $asset.name
            $filePath = Join-Path $destPath $fileName

            Write-Host "Downloading from: $downloadUrl"
            Write-Host "Saving to: $filePath"

            # Download the file using TcpClient
            $uri = [System.Uri]$downloadUrl
            $client = [System.Net.Sockets.TcpClient]::new()
            $client.Connect($uri.Host, 443)

            $sslStream = [System.Net.Security.SslStream]::new($client.GetStream())
            $sslStream.AuthenticateAsClient($uri.Host)

            $request = "GET $($uri.PathAndQuery) HTTP/1.1`r`nHost: $($uri.Host)`r`nUser-Agent: PowerShell`r`nConnection: Close`r`n`r`n"
            $requestBytes = [System.Text.Encoding]::ASCII.GetBytes($request)
            $sslStream.Write($requestBytes, 0, $requestBytes.Length)

            # Read and save the response
            $fileStream = [System.IO.File]::Create($filePath)
            $responseBytes = [byte[]]::new(8192)
            $headersPassed = $false
            $totalBytesRead = 0
            do {
                $bytesRead = $sslStream.Read($responseBytes, 0, $responseBytes.Length)
                $totalBytesRead += $bytesRead
                if (-not $headersPassed) {
                    $headerEnd = [System.Text.Encoding]::ASCII.GetString($responseBytes).IndexOf("`r`n`r`n")
                    if ($headerEnd -ge 0) {
                        $headersPassed = $true
                        $fileStream.Write($responseBytes, $headerEnd + 4, $bytesRead - $headerEnd - 4)
                    }
                } else {
                    $fileStream.Write($responseBytes, 0, $bytesRead)
                }
            } while ($bytesRead -gt 0)

            $fileStream.Close()
            $sslStream.Close()
            $client.Close()

            Write-Host "Total bytes read: $totalBytesRead"
            $fileInfo = Get-Item $filePath
            Write-Host "File size: $($fileInfo.Length) bytes"

            if ($fileInfo.Length -eq 0) {
                Write-Host "Error: Downloaded file is empty."
                return
            }

            # Extract the zip file
            Write-Host "Extracting $fileName..."
            Expand-Archive -Path $filePath -DestinationPath $destPath -Force

            # Clean up the zip file
            Remove-Item $filePath

            Write-Host "PowerShell has been downloaded and extracted to $destPath"
        } else {
            Write-Host "Could not find a suitable PowerShell release to download."
        }
    } else {
        Write-Host "Failed to parse JSON response from GitHub API."
        Write-Host "Response content:"
        Write-Host $responseString
    }
} catch {
    Write-Host "An error occurred:"
    Write-Host $_.Exception.Message
    Write-Host $_.Exception.StackTrace
}