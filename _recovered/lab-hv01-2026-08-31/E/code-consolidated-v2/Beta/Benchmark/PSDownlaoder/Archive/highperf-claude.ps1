function Download-FileParallel {
    param(
        [string]$Url,
        [string]$OutFile,
        [int]$ChunkSize = 10MB,
        [int]$MaxParallelDownloads = 8
    )

    Add-Type -AssemblyName System.Net.Http

    $client = New-Object System.Net.Http.HttpClient
    $response = $client.GetAsync($Url, [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead).Result
    $totalBytes = [long]$response.Content.Headers.ContentLength
    $response.Dispose()

    $chunks = [math]::Ceiling($totalBytes / $ChunkSize)
    $jobs = @()

    0..($chunks-1) | ForEach-Object {
        $start = $_ * $ChunkSize
        $end = [math]::Min($start + $ChunkSize - 1, $totalBytes - 1)

        $job = Start-Job -ScriptBlock {
            param($Url, $Start, $End)
            $client = New-Object System.Net.Http.HttpClient
            $client.DefaultRequestHeaders.Range = New-Object System.Net.Http.Headers.RangeHeaderValue($Start, $End)
            $response = $client.GetByteArrayAsync($Url).Result
            return $response
        } -ArgumentList $Url, $start, $end

        $jobs += $job
        
        if ($jobs.Count -eq $MaxParallelDownloads -or $_ -eq ($chunks-1)) {
            $jobs | Wait-Job | Receive-Job | ForEach-Object {
                $_ | Add-Content -Path $OutFile -Encoding Byte -Force
            }
            $jobs | Remove-Job
            $jobs = @()
        }
    }

    $client.Dispose()
}

# Usage

# Define the URL for the latest PowerShell 7 release
$url = (Invoke-RestMethod https://api.github.com/repos/PowerShell/PowerShell/releases/latest).assets | 
       Where-Object { $_.name -like '*win-x64.msi' } | 
       Select-Object -ExpandProperty browser_download_url

$outFile = "C:\tmp\pwsh.msi"
$startTime = Get-Date
Download-FileParallel -Url $url -OutFile $outFile -ChunkSize 5MB -MaxParallelDownloads 16
$endTime = Get-Date
$duration = $endTime - $startTime
Write-Host "Download completed in $($duration.TotalMilliseconds) ms"