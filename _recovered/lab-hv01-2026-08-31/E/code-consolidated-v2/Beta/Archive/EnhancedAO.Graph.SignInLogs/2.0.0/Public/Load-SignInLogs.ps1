# # # # # # # # # # # # # # # # # # # # # # # # # # # Function to load sign-in logs from the latest JSON file
# # # # # # # # # # # # # # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # # # # # # # # # # # # # #     )

# # # # # # # # # # # # # # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # # # # # # # # # # # # # #         $json = Get-Content -Path $JsonFilePath | ConvertFrom-Json
# # # # # # # # # # # # # # # # # # # # # # # # # #         # Write-EnhancedLog -Message "Sign-in logs loaded successfully from $JsonFilePath." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
# # # # # # # # # # # # # # # # # # # # # # # # # #         return $json
# # # # # # # # # # # # # # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # # # # # # # # # # # # # #         Handle-Error -ErrorRecord $_
        
# # # # # # # # # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # # # # # # # # }



# # # # # # # # # # # # # # # # # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # # # # # # # # # # # # # # # # # class DeviceDetail {
# # # # # # # # # # # # # # # # # # # # # # # # # #     [string]$DeviceId
# # # # # # # # # # # # # # # # # # # # # # # # # #     [string]$DisplayName
# # # # # # # # # # # # # # # # # # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # # # # # # # # # # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # # # # # # # # # # # # # # # # # #     [string]$TrustType

# # # # # # # # # # # # # # # # # # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # # # # # # # # # # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # # # # # # # # # # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # # # # # # # # # # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # # # # # # # # # # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # # # # # # # # # # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # # # # # # # # # # # # # # # # # class SignInLog {
# # # # # # # # # # # # # # # # # # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # # # # # # # # # # # # # # # # # #     [string]$UserId
# # # # # # # # # # # # # # # # # # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # # # # # # # # # # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # # # # # # # # # # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # # # # # # # # # # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # # # # # # # # # # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # # # # # # # # }



# # # # # # # # # # # # # # # # # # # # # # # # # # Function to load sign-in logs from the latest JSON file
# # # # # # # # # # # # # # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # # # # # # # # # # # # # #     )

# # # # # # # # # # # # # # # # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()
# # # # # # # # # # # # # # # # # # # # # # # # # #     $fileStream = [System.IO.File]::OpenRead($JsonFilePath)

# # # # # # # # # # # # # # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # # # # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)

# # # # # # # # # # # # # # # # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # # # # # # # # # # # # # # # #             $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # # # # # # # # # # # # # # # # #                 $element.GetProperty("deviceDetail").GetProperty("deviceId").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # # # #                 $element.GetProperty("deviceDetail").GetProperty("displayName").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # # # #                 $element.GetProperty("deviceDetail").GetProperty("operatingSystem").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # # # #                 $element.GetProperty("deviceDetail").GetProperty("isCompliant").GetBoolean(),
# # # # # # # # # # # # # # # # # # # # # # # # # #                 $element.GetProperty("deviceDetail").GetProperty("trustType").GetString()
# # # # # # # # # # # # # # # # # # # # # # # # # #             )
# # # # # # # # # # # # # # # # # # # # # # # # # #             $signInLog = [SignInLog]::new(
# # # # # # # # # # # # # # # # # # # # # # # # # #                 $element.GetProperty("userDisplayName").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # # # #                 $element.GetProperty("userId").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # # # #                 $deviceDetail
# # # # # # # # # # # # # # # # # # # # # # # # # #             )

# # # # # # # # # # # # # # # # # # # # # # # # # #             $signInLogs.Add($signInLog)
# # # # # # # # # # # # # # # # # # # # # # # # # #         }

# # # # # # # # # # # # # # # # # # # # # # # # # #         # Write-EnhancedLog -Message "Sign-in logs loaded successfully from $JsonFilePath." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
# # # # # # # # # # # # # # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # # # # # # # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # # # # # # # # # # # # # # # # # # #     } finally {
# # # # # # # # # # # # # # # # # # # # # # # # # #         $fileStream.Dispose()
# # # # # # # # # # # # # # # # # # # # # # # # # #     }

# # # # # # # # # # # # # # # # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # # # # # # # # # # # # # # # }




# # # # # # # # # # # # # # # # # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # # # # # # # # # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # # # # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # # # # # # # # # # # # # #     )

# # # # # # # # # # # # # # # # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()
# # # # # # # # # # # # # # # # # # # # # # # # # #     $streamReader = [System.IO.StreamReader]::new($JsonFilePath)

# # # # # # # # # # # # # # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # # # # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($streamReader.BaseStream)

# # # # # # # # # # # # # # # # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # # # # # # # # # # # # # # # #             if ($element.TryGetProperty("deviceDetail", [ref]$null)) {
# # # # # # # # # # # # # # # # # # # # # # # # # #                 $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("deviceDetail").GetProperty("deviceId").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("deviceDetail").GetProperty("displayName").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("deviceDetail").GetProperty("operatingSystem").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("deviceDetail").GetProperty("isCompliant").GetBoolean(),
# # # # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("deviceDetail").GetProperty("trustType").GetString()
# # # # # # # # # # # # # # # # # # # # # # # # # #                 )
# # # # # # # # # # # # # # # # # # # # # # # # # #                 $signInLog = [SignInLog]::new(
# # # # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("userDisplayName").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("userId").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # # # #                     $deviceDetail
# # # # # # # # # # # # # # # # # # # # # # # # # #                 )

# # # # # # # # # # # # # # # # # # # # # # # # # #                 # Example filtering: Only add logs for a specific operating system
# # # # # # # # # # # # # # # # # # # # # # # # # #                 if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # # # # # # # # # # # # # # # # # #                     $signInLogs.Add($signInLog)
# # # # # # # # # # # # # # # # # # # # # # # # # #                 }
# # # # # # # # # # # # # # # # # # # # # # # # # #             }
# # # # # # # # # # # # # # # # # # # # # # # # # #         }

# # # # # # # # # # # # # # # # # # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # # # # # # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # # # # # # # # # # # # # #         Write-Host "Error loading sign-in logs: $($_.Exception.Message)"
# # # # # # # # # # # # # # # # # # # # # # # # # #     } finally {
# # # # # # # # # # # # # # # # # # # # # # # # # #         $streamReader.Close()
# # # # # # # # # # # # # # # # # # # # # # # # # #     }

# # # # # # # # # # # # # # # # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # # # # # Example usage
# # # # # # # # # # # # # # # # # # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath "$pwd\test.json"

# # # # # # # # # # # # # # # # # # # # # # # # # # Accessing properties of the deserialized object
# # # # # # # # # # # # # # # # # # # # # # # # # # foreach ($log in $signInLogs) {
# # # # # # # # # # # # # # # # # # # # # # # # # #     Write-Host "User: $($log.UserDisplayName), Device: $($log.DeviceDetail.DisplayName), OS: $($log.DeviceDetail.OperatingSystem)"
# # # # # # # # # # # # # # # # # # # # # # # # # # }



# # # # # # # # # # # # # # # # # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # # # # # # # # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # # # # # # # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # # # # # # # # # # # # # # # # class DeviceDetail {
# # # # # # # # # # # # # # # # # # # # # # # # #     [string]$DeviceId
# # # # # # # # # # # # # # # # # # # # # # # # #     [string]$DisplayName
# # # # # # # # # # # # # # # # # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # # # # # # # # # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # # # # # # # # # # # # # # # # #     [string]$TrustType

# # # # # # # # # # # # # # # # # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # # # # # # # # # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # # # # # # # # # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # # # # # # # # # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # # # # # # # # # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # # # # # # # # # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # # # # # # # # # # # # # # # # class SignInLog {
# # # # # # # # # # # # # # # # # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # # # # # # # # # # # # # # # # #     [string]$UserId
# # # # # # # # # # # # # # # # # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # # # # # # # # # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # # # # # # # # # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # # # # # # # # # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # # # # # # # # # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # # # # # # # # # # # # #     )

# # # # # # # # # # # # # # # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()
# # # # # # # # # # # # # # # # # # # # # # # # #     $streamReader = [System.IO.StreamReader]::new($JsonFilePath)

# # # # # # # # # # # # # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # # # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($streamReader.BaseStream)

# # # # # # # # # # # # # # # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # # # # # # # # # # # # # # #             if ($element.TryGetProperty("deviceDetail", [ref]$null)) {
# # # # # # # # # # # # # # # # # # # # # # # # #                 $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("deviceDetail").GetProperty("deviceId").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("deviceDetail").GetProperty("displayName").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("deviceDetail").GetProperty("operatingSystem").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("deviceDetail").GetProperty("isCompliant").GetBoolean(),
# # # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("deviceDetail").GetProperty("trustType").GetString()
# # # # # # # # # # # # # # # # # # # # # # # # #                 )
# # # # # # # # # # # # # # # # # # # # # # # # #                 $signInLog = [SignInLog]::new(
# # # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("userDisplayName").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("userId").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # # #                     $deviceDetail
# # # # # # # # # # # # # # # # # # # # # # # # #                 )

# # # # # # # # # # # # # # # # # # # # # # # # #                 # Example filtering: Only add logs for a specific operating system
# # # # # # # # # # # # # # # # # # # # # # # # #                 # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # # # # # # # # # # # # # # # # #                     $signInLogs.Add($signInLog)
# # # # # # # # # # # # # # # # # # # # # # # # #                 # }
# # # # # # # # # # # # # # # # # # # # # # # # #             }
# # # # # # # # # # # # # # # # # # # # # # # # #         }

# # # # # # # # # # # # # # # # # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # # # # # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # # # # # # # # # # # # #         Write-Host "Error loading sign-in logs: $($_.Exception.Message)"
# # # # # # # # # # # # # # # # # # # # # # # # #     } finally {
# # # # # # # # # # # # # # # # # # # # # # # # #         $streamReader.Close()
# # # # # # # # # # # # # # # # # # # # # # # # #     }

# # # # # # # # # # # # # # # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # # # # # Example usage
# # # # # # # # # # # # # # # # # # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath "$pwd\signinlogs.json"

# # # # # # # # # # # # # # # # # # # # # # # # # # Accessing properties of the deserialized object
# # # # # # # # # # # # # # # # # # # # # # # # # # foreach ($log in $signInLogs) {
# # # # # # # # # # # # # # # # # # # # # # # # # #     Write-Host "User: $($log.UserDisplayName), Device: $($log.DeviceDetail.DisplayName), OS: $($log.DeviceDetail.OperatingSystem)"
# # # # # # # # # # # # # # # # # # # # # # # # # # }



# # # # # # # # # # # # # # # # # # # # # # # # # # # Function to load sign-in logs from the latest JSON file
# # # # # # # # # # # # # # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # # # # # # # # # # # # # #     )

# # # # # # # # # # # # # # # # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[PSCustomObject]]::new()
# # # # # # # # # # # # # # # # # # # # # # # # # #     $fileStream = [System.IO.File]::OpenRead($JsonFilePath)

# # # # # # # # # # # # # # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # # # # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)

# # # # # # # # # # # # # # # # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # # # # # # # # # # # # # # # #             $signInLog = [PSCustomObject]@{
# # # # # # # # # # # # # # # # # # # # # # # # # #                 userDisplayName = $element.GetProperty("userDisplayName").GetString()
# # # # # # # # # # # # # # # # # # # # # # # # # #                 userId = $element.GetProperty("userId").GetString()
# # # # # # # # # # # # # # # # # # # # # # # # # #                 deviceDetail = [PSCustomObject]@{
# # # # # # # # # # # # # # # # # # # # # # # # # #                     deviceId = $element.GetProperty("deviceDetail").GetProperty("deviceId").GetString()
# # # # # # # # # # # # # # # # # # # # # # # # # #                     displayName = $element.GetProperty("deviceDetail").GetProperty("displayName").GetString()
# # # # # # # # # # # # # # # # # # # # # # # # # #                     operatingSystem = $element.GetProperty("deviceDetail").GetProperty("operatingSystem").GetString()
# # # # # # # # # # # # # # # # # # # # # # # # # #                     isCompliant = $element.GetProperty("deviceDetail").GetProperty("isCompliant").GetBoolean()
# # # # # # # # # # # # # # # # # # # # # # # # # #                     trustType = $element.GetProperty("deviceDetail").GetProperty("trustType").GetString()
# # # # # # # # # # # # # # # # # # # # # # # # # #                 }
# # # # # # # # # # # # # # # # # # # # # # # # # #             }

# # # # # # # # # # # # # # # # # # # # # # # # # #             $signInLogs.Add($signInLog)
# # # # # # # # # # # # # # # # # # # # # # # # # #         }

# # # # # # # # # # # # # # # # # # # # # # # # # #         # Write-EnhancedLog -Message "Sign-in logs loaded successfully from $JsonFilePath." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
# # # # # # # # # # # # # # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # # # # # # # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # # # # # # # # # # # # # # # # # # #     } finally {
# # # # # # # # # # # # # # # # # # # # # # # # # #         $fileStream.Dispose()
# # # # # # # # # # # # # # # # # # # # # # # # # #     }

# # # # # # # # # # # # # # # # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # # # # # # # # # # # # # # # }













# # # # # # # # # # # # # # # # # # # # # # # # # # class SignInLog {
# # # # # # # # # # # # # # # # # # # # # # # # # #     [string] $userDisplayName
# # # # # # # # # # # # # # # # # # # # # # # # # #     [string] $deviceID
# # # # # # # # # # # # # # # # # # # # # # # # # #     [datetime] $signInDateTime
# # # # # # # # # # # # # # # # # # # # # # # # # #     # Add other relevant properties here
# # # # # # # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # # # # # # Function to load and deserialize sign-in logs from the latest JSON file
# # # # # # # # # # # # # # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # # # # # # # # # # # # # #     )

# # # # # # # # # # # # # # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # # # # # # # # # # # # # #         # Load the JSON file
# # # # # # # # # # # # # # # # # # # # # # # # # #         $reader = [System.IO.StreamReader]::new($JsonFilePath)
# # # # # # # # # # # # # # # # # # # # # # # # # #         $jarray = [Newtonsoft.Json.Linq.JArray]::Load([NewtonSoft.Json.JsonTextReader]$reader)
        
# # # # # # # # # # # # # # # # # # # # # # # # # #         # Filter out specific users and deserialize to SignInLog class
# # # # # # # # # # # # # # # # # # # # # # # # # #         $filteredLogs = $jarray.SelectTokens('$..[?(@.userDisplayName != ''On-Premises Directory Synchronization Service Account'')]').ToObject[SignInLog]()
        
# # # # # # # # # # # # # # # # # # # # # # # # # #         # Write-EnhancedLog -Message "Sign-in logs loaded and filtered successfully from $JsonFilePath." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
# # # # # # # # # # # # # # # # # # # # # # # # # #         return $filteredLogs
# # # # # # # # # # # # # # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # # # # # # # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # # # # # # # # # # # # # # # # # # #         # return $null
# # # # # # # # # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # # # # # # # # }




# # # # # # # # # # # # # # # # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # # # # # # # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # # # # # # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # # # # # # # # # # # # # # # class DeviceDetail {
# # # # # # # # # # # # # # # # # # # # # # # #     [string]$DeviceId
# # # # # # # # # # # # # # # # # # # # # # # #     [string]$DisplayName
# # # # # # # # # # # # # # # # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # # # # # # # # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # # # # # # # # # # # # # # # #     [string]$TrustType

# # # # # # # # # # # # # # # # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # # # # # # # # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # # # # # # # # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # # # # # # # # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # # # # # # # # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # # # # # # # # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # # # # # # # # # # # # # # # class SignInLog {
# # # # # # # # # # # # # # # # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # # # # # # # # # # # # # # # #     [string]$UserId
# # # # # # # # # # # # # # # # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # # # # # # # # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # # # # # # # # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # # # # # # # # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # # # # # # # # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # # # # # # # # # # # #     )

# # # # # # # # # # # # # # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # # # # # # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # # # # # # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # # # # # # # # # # # # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # # # # # # # # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)

# # # # # # # # # # # # # # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # # # # # # # # # # # # # #             if ($element.TryGetProperty("deviceDetail", [ref]$null)) {
# # # # # # # # # # # # # # # # # # # # # # # #                 $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("deviceDetail").GetProperty("deviceId").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("deviceDetail").GetProperty("displayName").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("deviceDetail").GetProperty("operatingSystem").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("deviceDetail").GetProperty("isCompliant").GetBoolean(),
# # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("deviceDetail").GetProperty("trustType").GetString()
# # # # # # # # # # # # # # # # # # # # # # # #                 )
# # # # # # # # # # # # # # # # # # # # # # # #                 $signInLog = [SignInLog]::new(
# # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("userDisplayName").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("userId").GetString(),
# # # # # # # # # # # # # # # # # # # # # # # #                     $deviceDetail
# # # # # # # # # # # # # # # # # # # # # # # #                 )

# # # # # # # # # # # # # # # # # # # # # # # #                 # Example filtering: Only add logs for a specific operating system
# # # # # # # # # # # # # # # # # # # # # # # #                 # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # # # # # # # # # # # # # # # #                     $signInLogs.Add($signInLog)
# # # # # # # # # # # # # # # # # # # # # # # #                 # }
# # # # # # # # # # # # # # # # # # # # # # # #             }
# # # # # # # # # # # # # # # # # # # # # # # #         }

# # # # # # # # # # # # # # # # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # # # # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # # # # # # # # # # # #         Write-Host "Error loading sign-in logs: $($_.Exception.Message)"
# # # # # # # # # # # # # # # # # # # # # # # #         Handle-Error -ErrorRecord $_.
# # # # # # # # # # # # # # # # # # # # # # # #     } finally {
# # # # # # # # # # # # # # # # # # # # # # # #         $fileStream.Close()
# # # # # # # # # # # # # # # # # # # # # # # #     }

# # # # # # # # # # # # # # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # # # # Example usage
# # # # # # # # # # # # # # # # # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath "C:\log.json"

# # # # # # # # # # # # # # # # # # # # # # # # # Display the count of loaded sign-in logs
# # # # # # # # # # # # # # # # # # # # # # # # # Write-Host "Loaded $($signInLogs.Count) sign-in logs."





# # # # # # # # # # # # # # # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # # # # # # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # # # # # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # # # # # # # # # # # # # # class DeviceDetail {
# # # # # # # # # # # # # # # # # # # # # # #     [string]$DeviceId
# # # # # # # # # # # # # # # # # # # # # # #     [string]$DisplayName
# # # # # # # # # # # # # # # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # # # # # # # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # # # # # # # # # # # # # # #     [string]$TrustType

# # # # # # # # # # # # # # # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # # # # # # # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # # # # # # # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # # # # # # # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # # # # # # # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # # # # # # # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # # # # # # # # # # # # # # class SignInLog {
# # # # # # # # # # # # # # # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # # # # # # # # # # # # # # #     [string]$UserId
# # # # # # # # # # # # # # # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # # # # # # # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # # # # # # # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # # # # # # # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # # # # # # # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # # # # # # # # # # #     )

# # # # # # # # # # # # # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # # # # # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # # # # # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # # # # # # # # # # # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # # # # # # # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)

# # # # # # # # # # # # # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # # # # # # # # # # # # #             if ($element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement)) {
# # # # # # # # # # # # # # # # # # # # # # #                 $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("deviceId").GetString(),
# # # # # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("displayName").GetString(),
# # # # # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("operatingSystem").GetString(),
# # # # # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("isCompliant").GetBoolean(),
# # # # # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("trustType").GetString()
# # # # # # # # # # # # # # # # # # # # # # #                 )
# # # # # # # # # # # # # # # # # # # # # # #                 $signInLog = [SignInLog]::new(
# # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("userDisplayName").GetString(),
# # # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("userId").GetString(),
# # # # # # # # # # # # # # # # # # # # # # #                     $deviceDetail
# # # # # # # # # # # # # # # # # # # # # # #                 )

# # # # # # # # # # # # # # # # # # # # # # #                 # Example filtering: Only add logs for a specific operating system
# # # # # # # # # # # # # # # # # # # # # # #                 # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # # # # # # # # # # # # # # #                     $signInLogs.Add($signInLog)
# # # # # # # # # # # # # # # # # # # # # # #                 # }
# # # # # # # # # # # # # # # # # # # # # # #             }
# # # # # # # # # # # # # # # # # # # # # # #         }

# # # # # # # # # # # # # # # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # # # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # # # # # # # # # # #         Write-Host "Error loading sign-in logs: $($_.Exception.Message)"
# # # # # # # # # # # # # # # # # # # # # # #     } finally {
# # # # # # # # # # # # # # # # # # # # # # #         $fileStream.Close()
# # # # # # # # # # # # # # # # # # # # # # #     }

# # # # # # # # # # # # # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # # # Example usage
# # # # # # # # # # # # # # # # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath "C:\log.json"

# # # # # # # # # # # # # # # # # # # # # # # # Display the count of loaded sign-in logs
# # # # # # # # # # # # # # # # # # # # # # # # Write-Host "Loaded $($signInLogs.Count) sign-in logs."







# # # # # # # # # # # # # # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # # # # # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # # # # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # # # # # # # # # # # # # class DeviceDetail {
# # # # # # # # # # # # # # # # # # # # # #     [string]$DeviceId
# # # # # # # # # # # # # # # # # # # # # #     [string]$DisplayName
# # # # # # # # # # # # # # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # # # # # # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # # # # # # # # # # # # # #     [string]$TrustType

# # # # # # # # # # # # # # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # # # # # # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # # # # # # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # # # # # # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # # # # # # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # # # # # # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # # # # # # # # # # # # # class SignInLog {
# # # # # # # # # # # # # # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # # # # # # # # # # # # # #     [string]$UserId
# # # # # # # # # # # # # # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # # # # # # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # # # # # # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # # # # # # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # # # # # # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # # # # # # # # # #     )

# # # # # # # # # # # # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # # # # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # # # # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # # # # # # # # # # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # # # # # # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)

# # # # # # # # # # # # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # # # # # # # # # # # #             $deviceDetailElement = $null
# # # # # # # # # # # # # # # # # # # # # #             if ($element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement)) {
# # # # # # # # # # # # # # # # # # # # # #                 $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("deviceId").GetString(),
# # # # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("displayName").GetString(),
# # # # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("operatingSystem").GetString(),
# # # # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("isCompliant").GetBoolean(),
# # # # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("trustType").GetString()
# # # # # # # # # # # # # # # # # # # # # #                 )
# # # # # # # # # # # # # # # # # # # # # #                 $signInLog = [SignInLog]::new(
# # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("userDisplayName").GetString(),
# # # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("userId").GetString(),
# # # # # # # # # # # # # # # # # # # # # #                     $deviceDetail
# # # # # # # # # # # # # # # # # # # # # #                 )

# # # # # # # # # # # # # # # # # # # # # #                 # Example filtering: Only add logs for a specific operating system
# # # # # # # # # # # # # # # # # # # # # #                 # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # # # # # # # # # # # # # #                     $signInLogs.Add($signInLog)
# # # # # # # # # # # # # # # # # # # # # #                 # }
# # # # # # # # # # # # # # # # # # # # # #             }
# # # # # # # # # # # # # # # # # # # # # #         }

# # # # # # # # # # # # # # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # # # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # # # # # # # # # # # # # # #     } finally {
# # # # # # # # # # # # # # # # # # # # # #         $fileStream.Close()
# # # # # # # # # # # # # # # # # # # # # #     }

# # # # # # # # # # # # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # # Example usage
# # # # # # # # # # # # # # # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath "C:\log.json"

# # # # # # # # # # # # # # # # # # # # # # # Display the count of loaded sign-in logs
# # # # # # # # # # # # # # # # # # # # # # # Write-Host "Loaded $($signInLogs.Count) sign-in logs."



# # # # # # # # # # # # # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # # # # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # # # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # # # # # # # # # # # # class DeviceDetail {
# # # # # # # # # # # # # # # # # # # # #     [string]$DeviceId
# # # # # # # # # # # # # # # # # # # # #     [string]$DisplayName
# # # # # # # # # # # # # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # # # # # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # # # # # # # # # # # # #     [string]$TrustType

# # # # # # # # # # # # # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # # # # # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # # # # # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # # # # # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # # # # # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # # # # # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # # # # # # # # # # # # class SignInLog {
# # # # # # # # # # # # # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # # # # # # # # # # # # #     [string]$UserId
# # # # # # # # # # # # # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # # # # # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # # # # # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # # # # # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # # # # # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # # # # # # # # #     )

# # # # # # # # # # # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # # # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # # # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # # # # # # # # # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # # # # # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)

# # # # # # # # # # # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # # # # # # # # # # #             try {
# # # # # # # # # # # # # # # # # # # # #                 $deviceDetailElement = $element.GetProperty("deviceDetail")
# # # # # # # # # # # # # # # # # # # # #                 $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("deviceId").GetString(),
# # # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("displayName").GetString(),
# # # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("operatingSystem").GetString(),
# # # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("isCompliant").GetBoolean(),
# # # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("trustType").GetString()
# # # # # # # # # # # # # # # # # # # # #                 )
# # # # # # # # # # # # # # # # # # # # #                 $signInLog = [SignInLog]::new(
# # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("userDisplayName").GetString(),
# # # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("userId").GetString(),
# # # # # # # # # # # # # # # # # # # # #                     $deviceDetail
# # # # # # # # # # # # # # # # # # # # #                 )

# # # # # # # # # # # # # # # # # # # # #                 # Example filtering: Only add logs for a specific operating system
# # # # # # # # # # # # # # # # # # # # #                 # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # # # # # # # # # # # # #                     $signInLogs.Add($signInLog)
# # # # # # # # # # # # # # # # # # # # #                 # }
# # # # # # # # # # # # # # # # # # # # #             } catch {
# # # # # # # # # # # # # # # # # # # # #                 # Handle the case where the property does not exist
# # # # # # # # # # # # # # # # # # # # #                 Write-Host "Property missing in one of the elements, skipping this element."
# # # # # # # # # # # # # # # # # # # # #             }
# # # # # # # # # # # # # # # # # # # # #         }

# # # # # # # # # # # # # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # # # # # # # # # # # # # #     } finally {
# # # # # # # # # # # # # # # # # # # # #         $fileStream.Close()
# # # # # # # # # # # # # # # # # # # # #     }

# # # # # # # # # # # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # Example usage
# # # # # # # # # # # # # # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath "C:\log.json"

# # # # # # # # # # # # # # # # # # # # # # Display the count of loaded sign-in logs
# # # # # # # # # # # # # # # # # # # # # # Write-Host "Loaded $($signInLogs.Count) sign-in logs."












# # # # # # # # # # # # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # # # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # # # # # # # # # # # class DeviceDetail {
# # # # # # # # # # # # # # # # # # # #     [string]$DeviceId
# # # # # # # # # # # # # # # # # # # #     [string]$DisplayName
# # # # # # # # # # # # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # # # # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # # # # # # # # # # # #     [string]$TrustType

# # # # # # # # # # # # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # # # # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # # # # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # # # # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # # # # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # # # # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # # # # # # # # # # # class SignInLog {
# # # # # # # # # # # # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # # # # # # # # # # # #     [string]$UserId
# # # # # # # # # # # # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # # # # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # # # # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # # # # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # # # # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # # # # # # # #     )

# # # # # # # # # # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # # # # # # # # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # # # # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)

# # # # # # # # # # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # # # # # # # # # #             try {
# # # # # # # # # # # # # # # # # # # #                 $deviceDetailElement = $element.GetProperty("deviceDetail")
# # # # # # # # # # # # # # # # # # # #                 $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("deviceId").GetString(),
# # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("displayName").GetString(),
# # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("operatingSystem").GetString(),
# # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("isCompliant").GetBoolean(),
# # # # # # # # # # # # # # # # # # # #                     $deviceDetailElement.GetProperty("trustType").GetString()
# # # # # # # # # # # # # # # # # # # #                 )
# # # # # # # # # # # # # # # # # # # #                 $signInLog = [SignInLog]::new(
# # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("userDisplayName").GetString(),
# # # # # # # # # # # # # # # # # # # #                     $element.GetProperty("userId").GetString(),
# # # # # # # # # # # # # # # # # # # #                     $deviceDetail
# # # # # # # # # # # # # # # # # # # #                 )

# # # # # # # # # # # # # # # # # # # #                 # Example filtering: Only add logs for a specific operating system
# # # # # # # # # # # # # # # # # # # #                 # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # # # # # # # # # # # #                     $signInLogs.Add($signInLog)
# # # # # # # # # # # # # # # # # # # #                 # }
# # # # # # # # # # # # # # # # # # # #             } catch {
# # # # # # # # # # # # # # # # # # # #                 # Handle the case where the property does not exist
# # # # # # # # # # # # # # # # # # # #                 Write-Host "Property missing in one of the elements, skipping this element."
# # # # # # # # # # # # # # # # # # # #             }
# # # # # # # # # # # # # # # # # # # #         }

# # # # # # # # # # # # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # # # # # # # # # # # # #     } finally {
# # # # # # # # # # # # # # # # # # # #         $fileStream.Close()
# # # # # # # # # # # # # # # # # # # #     }

# # # # # # # # # # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # # Example usage
# # # # # # # # # # # # # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath "C:\log.json"

# # # # # # # # # # # # # # # # # # # # # # Ensure the signInLogs variable is not null before using it
# # # # # # # # # # # # # # # # # # # # # if ($null -eq $signInLogs) {
# # # # # # # # # # # # # # # # # # # # #     Write-Host "No sign-in logs were loaded."
# # # # # # # # # # # # # # # # # # # # #     exit 1
# # # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # # Display the count of loaded sign-in logs
# # # # # # # # # # # # # # # # # # # # # Write-Host "Loaded $($signInLogs.Count) sign-in logs."

# # # # # # # # # # # # # # # # # # # # # Example call to Process-AllDevices
# # # # # # # # # # # # # # # # # # # # # $results = Process-AllDevices -Json $signInLogs -Headers $Headers










# # # # # # # # # # # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # # # # # # # # # # class DeviceDetail {
# # # # # # # # # # # # # # # # # # #     [string]$DeviceId
# # # # # # # # # # # # # # # # # # #     [string]$DisplayName
# # # # # # # # # # # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # # # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # # # # # # # # # # #     [string]$TrustType

# # # # # # # # # # # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # # # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # # # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # # # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # # # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # # # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # # # # # # # # # # class SignInLog {
# # # # # # # # # # # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # # # # # # # # # # #     [string]$UserId
# # # # # # # # # # # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # # # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # # # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # # # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # # # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # # # # # # #     )

# # # # # # # # # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # # # # # # # # # # # # #         Write-Host "Opening file: $JsonFilePath"
# # # # # # # # # # # # # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # # # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)
# # # # # # # # # # # # # # # # # # #         Write-Host "File opened and parsed successfully."

# # # # # # # # # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # # # # # # # # #             try {
# # # # # # # # # # # # # # # # # # #                 if ($element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement)) {
# # # # # # # # # # # # # # # # # # #                     $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # # # # # # # # # #                         $deviceDetailElement.GetProperty("deviceId").GetString(),
# # # # # # # # # # # # # # # # # # #                         $deviceDetailElement.GetProperty("displayName").GetString(),
# # # # # # # # # # # # # # # # # # #                         $deviceDetailElement.GetProperty("operatingSystem").GetString(),
# # # # # # # # # # # # # # # # # # #                         $deviceDetailElement.GetProperty("isCompliant").GetBoolean(),
# # # # # # # # # # # # # # # # # # #                         $deviceDetailElement.GetProperty("trustType").GetString()
# # # # # # # # # # # # # # # # # # #                     )
# # # # # # # # # # # # # # # # # # #                     $signInLog = [SignInLog]::new(
# # # # # # # # # # # # # # # # # # #                         $element.GetProperty("userDisplayName").GetString(),
# # # # # # # # # # # # # # # # # # #                         $element.GetProperty("userId").GetString(),
# # # # # # # # # # # # # # # # # # #                         $deviceDetail
# # # # # # # # # # # # # # # # # # #                     )

# # # # # # # # # # # # # # # # # # #                     # Example filtering: Only add logs for a specific operating system
# # # # # # # # # # # # # # # # # # #                     # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # # # # # # # # # # #                         $signInLogs.Add($signInLog)
# # # # # # # # # # # # # # # # # # #                     # }
# # # # # # # # # # # # # # # # # # #                 } else {
# # # # # # # # # # # # # # # # # # #                     Write-Host "deviceDetail property not found in element."
# # # # # # # # # # # # # # # # # # #                 }
# # # # # # # # # # # # # # # # # # #             } catch {
# # # # # # # # # # # # # # # # # # #                 # Handle the case where the property does not exist
# # # # # # # # # # # # # # # # # # #                 Write-Host "Property missing in one of the elements, skipping this element."
# # # # # # # # # # # # # # # # # # #             }
# # # # # # # # # # # # # # # # # # #         }

# # # # # # # # # # # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # # # # # # # # # # # #     } finally {
# # # # # # # # # # # # # # # # # # #         $fileStream.Close()
# # # # # # # # # # # # # # # # # # #     }

# # # # # # # # # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # Example usage
# # # # # # # # # # # # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath "C:\log.json"

# # # # # # # # # # # # # # # # # # # # # Ensure the signInLogs variable is not null before using it
# # # # # # # # # # # # # # # # # # # # if ($null -eq $signInLogs) {
# # # # # # # # # # # # # # # # # # # #     Write-Host "No sign-in logs were loaded."
# # # # # # # # # # # # # # # # # # # #     exit 1
# # # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # Display the count of loaded sign-in logs
# # # # # # # # # # # # # # # # # # # # Write-Host "Loaded $($signInLogs.Count) sign-in logs."

# # # # # # # # # # # # # # # # # # # # Example call to Process-AllDevices
# # # # # # # # # # # # # # # # # # # # $results = Process-AllDevices -Json $signInLogs -Headers $Headers












# # # # # # # # # # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # # # # # # # # # class DeviceDetail {
# # # # # # # # # # # # # # # # # #     [string]$DeviceId
# # # # # # # # # # # # # # # # # #     [string]$DisplayName
# # # # # # # # # # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # # # # # # # # # #     [string]$TrustType

# # # # # # # # # # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # # # # # # # # # class SignInLog {
# # # # # # # # # # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # # # # # # # # # #     [string]$UserId
# # # # # # # # # # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # # # # # #     )

# # # # # # # # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # # # # # # # # # # # #         Write-Host "Opening file: $JsonFilePath"
# # # # # # # # # # # # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)
# # # # # # # # # # # # # # # # # #         Write-Host "File opened and parsed successfully."

# # # # # # # # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # # # # # # # #             try {
# # # # # # # # # # # # # # # # # #                 if ($element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement)) {
# # # # # # # # # # # # # # # # # #                     $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # # # # # # # # #                         $deviceDetailElement.GetProperty("deviceId").GetString(),
# # # # # # # # # # # # # # # # # #                         $deviceDetailElement.GetProperty("displayName").GetString(),
# # # # # # # # # # # # # # # # # #                         $deviceDetailElement.GetProperty("operatingSystem").GetString(),
# # # # # # # # # # # # # # # # # #                         $deviceDetailElement.GetProperty("isCompliant").GetBoolean(),
# # # # # # # # # # # # # # # # # #                         $deviceDetailElement.GetProperty("trustType").GetString()
# # # # # # # # # # # # # # # # # #                     )
# # # # # # # # # # # # # # # # # #                     $signInLog = [SignInLog]::new(
# # # # # # # # # # # # # # # # # #                         $element.GetProperty("userDisplayName").GetString(),
# # # # # # # # # # # # # # # # # #                         $element.GetProperty("userId").GetString(),
# # # # # # # # # # # # # # # # # #                         $deviceDetail
# # # # # # # # # # # # # # # # # #                     )

# # # # # # # # # # # # # # # # # #                     # Example filtering: Only add logs for a specific operating system
# # # # # # # # # # # # # # # # # #                     # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # # # # # # # # # #                         $signInLogs.Add($signInLog)
# # # # # # # # # # # # # # # # # #                     # }
# # # # # # # # # # # # # # # # # #                 } else {
# # # # # # # # # # # # # # # # # #                     Write-Host "deviceDetail property not found in element: $($element.GetRawText())"
# # # # # # # # # # # # # # # # # #                 }
# # # # # # # # # # # # # # # # # #             } catch {
# # # # # # # # # # # # # # # # # #                 # Handle the case where the property does not exist
# # # # # # # # # # # # # # # # # #                 Write-Host "Property missing in one of the elements, skipping this element: $($element.GetRawText())"
# # # # # # # # # # # # # # # # # #             }
# # # # # # # # # # # # # # # # # #         }

# # # # # # # # # # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # # # # # # # # # # #     } finally {
# # # # # # # # # # # # # # # # # #         $fileStream.Close()
# # # # # # # # # # # # # # # # # #     }

# # # # # # # # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # Example usage
# # # # # # # # # # # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath "C:\log.json"

# # # # # # # # # # # # # # # # # # # # Ensure the signInLogs variable is not null before using it
# # # # # # # # # # # # # # # # # # # if ($null -eq $signInLogs) {
# # # # # # # # # # # # # # # # # # #     Write-Host "No sign-in logs were loaded."
# # # # # # # # # # # # # # # # # # #     exit 1
# # # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # # Display the count of loaded sign-in logs
# # # # # # # # # # # # # # # # # # # Write-Host "Loaded $($signInLogs.Count) sign-in logs."

# # # # # # # # # # # # # # # # # # # # Example call to Process-AllDevices
# # # # # # # # # # # # # # # # # # # $results = Process-AllDevices -Json $signInLogs -Headers $Headers
# # # # # # # # # # # # # # # # # # # Write-Host "Processed $($results.Count) devices."





# # # # # # # # # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # # # # # # # # class DeviceDetail {
# # # # # # # # # # # # # # # # #     [string]$DeviceId
# # # # # # # # # # # # # # # # #     [string]$DisplayName
# # # # # # # # # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # # # # # # # # #     [string]$TrustType

# # # # # # # # # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # # # # # # # # class SignInLog {
# # # # # # # # # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # # # # # # # # #     [string]$UserId
# # # # # # # # # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # # # # #     )

# # # # # # # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # # # # # # # # # # #         Write-Host "Opening file: $JsonFilePath"
# # # # # # # # # # # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)
# # # # # # # # # # # # # # # # #         Write-Host "File opened and parsed successfully."

# # # # # # # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # # # # # # #             try {
# # # # # # # # # # # # # # # # #                 if ($element.TryGetProperty("deviceDetail").ValueKind -eq 'Object') {
# # # # # # # # # # # # # # # # #                     $deviceDetailElement = $element.GetProperty("deviceDetail")
# # # # # # # # # # # # # # # # #                     $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # # # # # # # #                         $deviceDetailElement.GetProperty("deviceId").GetString(),
# # # # # # # # # # # # # # # # #                         $deviceDetailElement.GetProperty("displayName").GetString(),
# # # # # # # # # # # # # # # # #                         $deviceDetailElement.GetProperty("operatingSystem").GetString(),
# # # # # # # # # # # # # # # # #                         $deviceDetailElement.GetProperty("isCompliant").GetBoolean(),
# # # # # # # # # # # # # # # # #                         $deviceDetailElement.GetProperty("trustType").GetString()
# # # # # # # # # # # # # # # # #                     )
# # # # # # # # # # # # # # # # #                     $signInLog = [SignInLog]::new(
# # # # # # # # # # # # # # # # #                         $element.GetProperty("userDisplayName").GetString(),
# # # # # # # # # # # # # # # # #                         $element.GetProperty("userId").GetString(),
# # # # # # # # # # # # # # # # #                         $deviceDetail
# # # # # # # # # # # # # # # # #                     )

# # # # # # # # # # # # # # # # #                     # Example filtering: Only add logs for a specific operating system
# # # # # # # # # # # # # # # # #                     # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # # # # # # # # #                         $signInLogs.Add($signInLog)
# # # # # # # # # # # # # # # # #                     # }
# # # # # # # # # # # # # # # # #                 } else {
# # # # # # # # # # # # # # # # #                     Write-Host "deviceDetail property not found or not an object in element: $($element.GetRawText())"
# # # # # # # # # # # # # # # # #                 }
# # # # # # # # # # # # # # # # #             } catch {
# # # # # # # # # # # # # # # # #                 # Handle the case where the property does not exist
# # # # # # # # # # # # # # # # #                 Write-Host "Property missing in one of the elements, skipping this element: $($element.GetRawText())"
# # # # # # # # # # # # # # # # #             }
# # # # # # # # # # # # # # # # #         }

# # # # # # # # # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # # # # # # # # # #     } finally {
# # # # # # # # # # # # # # # # #         $fileStream.Close()
# # # # # # # # # # # # # # # # #     }

# # # # # # # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # Example usage
# # # # # # # # # # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath "C:\log.json"

# # # # # # # # # # # # # # # # # # # Ensure the signInLogs variable is not null before using it
# # # # # # # # # # # # # # # # # # if ($null -eq $signInLogs) {
# # # # # # # # # # # # # # # # # #     Write-Host "No sign-in logs were loaded."
# # # # # # # # # # # # # # # # # #     exit 1
# # # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # # Display the count of loaded sign-in logs
# # # # # # # # # # # # # # # # # # Write-Host "Loaded $($signInLogs.Count) sign-in logs."

# # # # # # # # # # # # # # # # # # # Example call to Process-AllDevices
# # # # # # # # # # # # # # # # # # $results = Process-AllDevices -Json $signInLogs -Headers $Headers
# # # # # # # # # # # # # # # # # # Write-Host "Processed $($results.Count) devices."















# # # # # # # # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # # # # # # # class DeviceDetail {
# # # # # # # # # # # # # # # #     [string]$DeviceId
# # # # # # # # # # # # # # # #     [string]$DisplayName
# # # # # # # # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # # # # # # # #     [string]$TrustType

# # # # # # # # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # # # # # # # class SignInLog {
# # # # # # # # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # # # # # # # #     [string]$UserId
# # # # # # # # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # # # #     )

# # # # # # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # # # # # # # # # #         Write-Host "Opening file: $JsonFilePath"
# # # # # # # # # # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)
# # # # # # # # # # # # # # # #         Write-Host "File opened and parsed successfully."

# # # # # # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # # # # # #             try {
# # # # # # # # # # # # # # # #                 if ($element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement)) {
# # # # # # # # # # # # # # # #                     $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("deviceId", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("displayName", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("operatingSystem", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("isCompliant", [ref]$temp)) { $temp.GetBoolean() } else { $false },
# # # # # # # # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("trustType", [ref]$temp)) { $temp.GetString() } else { "" }
# # # # # # # # # # # # # # # #                     )
# # # # # # # # # # # # # # # #                     $signInLog = [SignInLog]::new(
# # # # # # # # # # # # # # # #                         if ($element.TryGetProperty("userDisplayName", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # # # # # # # #                         if ($element.TryGetProperty("userId", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # # # # # # # #                         $deviceDetail
# # # # # # # # # # # # # # # #                     )

# # # # # # # # # # # # # # # #                     # Example filtering: Only add logs for a specific operating system
# # # # # # # # # # # # # # # #                     # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # # # # # # # #                         $signInLogs.Add($signInLog)
# # # # # # # # # # # # # # # #                     # }
# # # # # # # # # # # # # # # #                 } else {
# # # # # # # # # # # # # # # #                     Write-Host "deviceDetail property not found in element: $($element.GetRawText())"
# # # # # # # # # # # # # # # #                 }
# # # # # # # # # # # # # # # #             } catch {
# # # # # # # # # # # # # # # #                 # Handle the case where the property does not exist
# # # # # # # # # # # # # # # #                 Write-Host "Property missing in one of the elements, skipping this element: $($element.GetRawText())"
# # # # # # # # # # # # # # # #             }
# # # # # # # # # # # # # # # #         }

# # # # # # # # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # # # # # # # # #     } finally {
# # # # # # # # # # # # # # # #         $fileStream.Close()
# # # # # # # # # # # # # # # #     }

# # # # # # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # Example usage
# # # # # # # # # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath "C:\log.json"

# # # # # # # # # # # # # # # # # # Ensure the signInLogs variable is not null before using it
# # # # # # # # # # # # # # # # # if ($null -eq $signInLogs) {
# # # # # # # # # # # # # # # # #     Write-Host "No sign-in logs were loaded."
# # # # # # # # # # # # # # # # #     exit 1
# # # # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # # # Display the count of loaded sign-in logs
# # # # # # # # # # # # # # # # # Write-Host "Loaded $($signInLogs.Count) sign-in logs."

# # # # # # # # # # # # # # # # # # Example call to Process-AllDevices
# # # # # # # # # # # # # # # # # $results = Process-AllDevices -Json $signInLogs -Headers $Headers
# # # # # # # # # # # # # # # # # Write-Host "Processed $($results.Count) devices."













# # # # # # # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # # # # # # class DeviceDetail {
# # # # # # # # # # # # # # #     [string]$DeviceId
# # # # # # # # # # # # # # #     [string]$DisplayName
# # # # # # # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # # # # # # #     [string]$TrustType

# # # # # # # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # # # # # # class SignInLog {
# # # # # # # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # # # # # # #     [string]$UserId
# # # # # # # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # # #     )

# # # # # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # # # # # # # # #         Write-Host "Opening file: $JsonFilePath"
# # # # # # # # # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)
# # # # # # # # # # # # # # #         Write-Host "File opened and parsed successfully."

# # # # # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # # # # #             try {
# # # # # # # # # # # # # # #                 $deviceDetailElement = $null
# # # # # # # # # # # # # # #                 if ($element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement)) {
# # # # # # # # # # # # # # #                     $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("deviceId", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("displayName", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("operatingSystem", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("isCompliant", [ref]$temp)) { $temp.GetBoolean() } else { $false },
# # # # # # # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("trustType", [ref]$temp)) { $temp.GetString() } else { "" }
# # # # # # # # # # # # # # #                     )
# # # # # # # # # # # # # # #                     $signInLog = [SignInLog]::new(
# # # # # # # # # # # # # # #                         if ($element.TryGetProperty("userDisplayName", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # # # # # # #                         if ($element.TryGetProperty("userId", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # # # # # # #                         $deviceDetail
# # # # # # # # # # # # # # #                     )

# # # # # # # # # # # # # # #                     # Example filtering: Only add logs for a specific operating system
# # # # # # # # # # # # # # #                     # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # # # # # # #                         $signInLogs.Add($signInLog)
# # # # # # # # # # # # # # #                     # }
# # # # # # # # # # # # # # #                 } else {
# # # # # # # # # # # # # # #                     Write-Host "deviceDetail property not found in element: $($element.GetRawText())"
# # # # # # # # # # # # # # #                 }
# # # # # # # # # # # # # # #             } catch {
# # # # # # # # # # # # # # #                 # Handle the case where the property does not exist
# # # # # # # # # # # # # # #                 Write-Host "Property missing in one of the elements, skipping this element: $($element.GetRawText())"
# # # # # # # # # # # # # # #             }
# # # # # # # # # # # # # # #         }

# # # # # # # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # # # # # # # #     } finally {
# # # # # # # # # # # # # # #         $fileStream.Close()
# # # # # # # # # # # # # # #     }

# # # # # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # Example usage
# # # # # # # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath "C:\log.json"

# # # # # # # # # # # # # # # # Ensure the signInLogs variable is not null before using it
# # # # # # # # # # # # # # # if ($null -eq $signInLogs) {
# # # # # # # # # # # # # # #     Write-Host "No sign-in logs were loaded."
# # # # # # # # # # # # # # #     exit 1
# # # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # # Display the count of loaded sign-in logs
# # # # # # # # # # # # # # # Write-Host "Loaded $($signInLogs.Count) sign-in logs."

# # # # # # # # # # # # # # # # Example call to Process-AllDevices
# # # # # # # # # # # # # # # $results = Process-AllDevices -Json $signInLogs -Headers $Headers
# # # # # # # # # # # # # # # Write-Host "Processed $($results.Count) devices."









# # # # # # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # # # # # class DeviceDetail {
# # # # # # # # # # # # # #     [string]$DeviceId
# # # # # # # # # # # # # #     [string]$DisplayName
# # # # # # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # # # # # #     [string]$TrustType

# # # # # # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # # # # # class SignInLog {
# # # # # # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # # # # # #     [string]$UserId
# # # # # # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # # # # # #     }
# # # # # # # # # # # # # # }

# # # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # # #     param (
# # # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # # #     )

# # # # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # # # # # # # #     try {
# # # # # # # # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # # # # # # # #         Write-Host "Opening file: $JsonFilePath"
# # # # # # # # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)
# # # # # # # # # # # # # #         Write-Host "File opened and parsed successfully."

# # # # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # # # #             try {
# # # # # # # # # # # # # #                 $deviceDetailElement = $null
# # # # # # # # # # # # # #                 if ($element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement)) {
# # # # # # # # # # # # # #                     $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("deviceId", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("displayName", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("operatingSystem", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("isCompliant", [ref]$temp)) { $temp.GetBoolean() } else { $false },
# # # # # # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("trustType", [ref]$temp)) { $temp.GetString() } else { "" }
# # # # # # # # # # # # # #                     )
# # # # # # # # # # # # # #                     $signInLog = [SignInLog]::new(
# # # # # # # # # # # # # #                         if ($element.TryGetProperty("userDisplayName", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # # # # # #                         if ($element.TryGetProperty("userId", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # # # # # #                         $deviceDetail
# # # # # # # # # # # # # #                     )

# # # # # # # # # # # # # #                     # Example filtering: Only add logs for a specific operating system
# # # # # # # # # # # # # #                     # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # # # # # #                         $signInLogs.Add($signInLog)
# # # # # # # # # # # # # #                     # }
# # # # # # # # # # # # # #                 } else {
# # # # # # # # # # # # # #                     Write-Host "deviceDetail property not found in element: $($element.GetRawText())"
# # # # # # # # # # # # # #                 }
# # # # # # # # # # # # # #             } catch {
# # # # # # # # # # # # # #                 # Handle the case where the property does not exist
# # # # # # # # # # # # # #                 Write-Host "Property missing in one of the elements, skipping this element: $($element.GetRawText())"
# # # # # # # # # # # # # #             }
# # # # # # # # # # # # # #         }

# # # # # # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # # # # # # #     } finally {
# # # # # # # # # # # # # #         $fileStream.Close()
# # # # # # # # # # # # # #     }

# # # # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # Example usage
# # # # # # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath "C:\log.json"

# # # # # # # # # # # # # # # Ensure the signInLogs variable is not null before using it
# # # # # # # # # # # # # # if ($null -eq $signInLogs) {
# # # # # # # # # # # # # #     Write-Host "No sign-in logs were loaded."
# # # # # # # # # # # # # #     exit 1
# # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # Display the count of loaded sign-in logs
# # # # # # # # # # # # # # Write-Host "Loaded $($signInLogs.Count) sign-in logs."

# # # # # # # # # # # # # # # Example call to Process-AllDevices
# # # # # # # # # # # # # # $results = Process-AllDevices -Json $signInLogs -Headers $Headers
# # # # # # # # # # # # # # Write-Host "Processed $($results.Count) devices."









# # # # # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # # # # class DeviceDetail {
# # # # # # # # # # # # #     [string]$DeviceId
# # # # # # # # # # # # #     [string]$DisplayName
# # # # # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # # # # #     [string]$TrustType

# # # # # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # # # # #     }
# # # # # # # # # # # # # }

# # # # # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # # # # class SignInLog {
# # # # # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # # # # #     [string]$UserId
# # # # # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # # # # #     }
# # # # # # # # # # # # # }

# # # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # # #     param (
# # # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # # #     )

# # # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # # # # # # #     try {
# # # # # # # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # # # # # # #         Write-Host "Opening file: $JsonFilePath"
# # # # # # # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)
# # # # # # # # # # # # #         Write-Host "File opened and parsed successfully."

# # # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # # #             try {
# # # # # # # # # # # # #                 $deviceDetailElement = $null
# # # # # # # # # # # # #                 if ($element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement)) {
# # # # # # # # # # # # #                     $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("deviceId", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("displayName", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("operatingSystem", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("isCompliant", [ref]$temp) ? $temp.GetBoolean() : $false),
# # # # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("trustType", [ref]$temp) ? $temp.GetString() : "")
# # # # # # # # # # # # #                     )
# # # # # # # # # # # # #                     $signInLog = [SignInLog]::new(
# # # # # # # # # # # # #                         ($element.TryGetProperty("userDisplayName", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # # # #                         ($element.TryGetProperty("userId", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # # # #                         $deviceDetail
# # # # # # # # # # # # #                     )

# # # # # # # # # # # # #                     # Example filtering: Only add logs for a specific operating system
# # # # # # # # # # # # #                     # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # # # # #                     $signInLogs.Add($signInLog)
# # # # # # # # # # # # #                     # }
# # # # # # # # # # # # #                 } else {
# # # # # # # # # # # # #                     Write-Host "deviceDetail property not found in element: $($element.GetRawText())"
# # # # # # # # # # # # #                 }
# # # # # # # # # # # # #             } catch {
# # # # # # # # # # # # #                 # Handle the case where the property does not exist
# # # # # # # # # # # # #                 # Write-Host "Property missing in one of the elements, skipping this element: $($element.GetRawText())"
# # # # # # # # # # # # #             }
# # # # # # # # # # # # #         }

# # # # # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # # # # #     } catch {
# # # # # # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # # # # # #     } finally {
# # # # # # # # # # # # #         $fileStream.Close()
# # # # # # # # # # # # #     }

# # # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # # }

# # # # # # # # # # # # # # # Example usage
# # # # # # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath "C:\log.json"

# # # # # # # # # # # # # # # Ensure the signInLogs variable is not null before using it
# # # # # # # # # # # # # # if ($null -eq $signInLogs) {
# # # # # # # # # # # # # #     Write-Host "No sign-in logs were loaded."
# # # # # # # # # # # # # #     exit 1
# # # # # # # # # # # # # # }

# # # # # # # # # # # # # # # Display the count of loaded sign-in logs
# # # # # # # # # # # # # # Write-Host "Loaded $($signInLogs.Count) sign-in logs."

# # # # # # # # # # # # # # # Example call to Process-AllDevices
# # # # # # # # # # # # # # $results = Process-AllDevices -Json $signInLogs -Headers $Headers
# # # # # # # # # # # # # # Write-Host "Processed $($results.Count) devices."






# # # # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # # # class DeviceDetail {
# # # # # # # # # # # #     [string]$DeviceId
# # # # # # # # # # # #     [string]$DisplayName
# # # # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # # # #     [string]$TrustType

# # # # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # # # #     }
# # # # # # # # # # # # }

# # # # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # # # class SignInLog {
# # # # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # # # #     [string]$UserId
# # # # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # # # #     }
# # # # # # # # # # # # }

# # # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # # #     param (
# # # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # # #     )

# # # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # # # # # #     try {
# # # # # # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # # # # # #         Write-Host "Opening file: $JsonFilePath"
# # # # # # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)
# # # # # # # # # # # #         Write-Host "File opened and parsed successfully."

# # # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # # #             try {
# # # # # # # # # # # #                 $deviceDetailElement = $null
# # # # # # # # # # # #                 if ($element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement)) {
# # # # # # # # # # # #                     $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("deviceId", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("displayName", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("operatingSystem", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("isCompliant", [ref]$temp) ? $temp.GetBoolean() : $false),
# # # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("trustType", [ref]$temp) ? $temp.GetString() : "")
# # # # # # # # # # # #                     )
# # # # # # # # # # # #                     $signInLog = [SignInLog]::new(
# # # # # # # # # # # #                         ($element.TryGetProperty("userDisplayName", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # # #                         ($element.TryGetProperty("userId", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # # #                         $deviceDetail
# # # # # # # # # # # #                     )

# # # # # # # # # # # #                     # Example filtering: Only add logs for a specific operating system
# # # # # # # # # # # #                     # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # # # #                     $signInLogs.Add($signInLog)
# # # # # # # # # # # #                     # }
# # # # # # # # # # # #                 } else {
# # # # # # # # # # # #                     Write-Warning "deviceDetail property not found in element: $($element.GetRawText())"
# # # # # # # # # # # #                 }
# # # # # # # # # # # #             } catch {
# # # # # # # # # # # #                 # Handle the case where the property does not exist
# # # # # # # # # # # #                 Write-Warning "Property missing in one of the elements, skipping this element: $($element.GetRawText())"
# # # # # # # # # # # #             }
# # # # # # # # # # # #         }

# # # # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # # # #     } catch {
# # # # # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # # # # #     } finally {
# # # # # # # # # # # #         $fileStream.Close()
# # # # # # # # # # # #     }

# # # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # # }



# # # # # # # # # # # # # # Example call to Process-AllDevices
# # # # # # # # # # # # # $results = Process-AllDevices -Json $signInLogs -Headers $Headers
# # # # # # # # # # # # # Write-Host "Processed $($results.Count) devices."

















# # # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # # class DeviceDetail {
# # # # # # # # # # #     [string]$DeviceId
# # # # # # # # # # #     [string]$DisplayName
# # # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # # #     [string]$TrustType

# # # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # # #     }
# # # # # # # # # # # }

# # # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # # class SignInLog {
# # # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # # #     [string]$UserId
# # # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # # #     }
# # # # # # # # # # # }

# # # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # # #     param (
# # # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # # #     )

# # # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # # # # #     try {
# # # # # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # # # # #         Write-Host "Opening file: $JsonFilePath"
# # # # # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)
# # # # # # # # # # #         Write-Host "File opened and parsed successfully."

# # # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # # #             try {
# # # # # # # # # # #                 $deviceDetailElement = $null
# # # # # # # # # # #                 if ($element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement)) {
# # # # # # # # # # #                     $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("deviceId", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("displayName", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("operatingSystem", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("isCompliant", [ref]$temp) ? $temp.GetBoolean() : $false),
# # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("trustType", [ref]$temp) ? $temp.GetString() : "")
# # # # # # # # # # #                     )
# # # # # # # # # # #                     $signInLog = [SignInLog]::new(
# # # # # # # # # # #                         ($element.TryGetProperty("userDisplayName", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # #                         ($element.TryGetProperty("userId", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # #                         $deviceDetail
# # # # # # # # # # #                     )

# # # # # # # # # # #                     # Example filtering: Only add logs for a specific operating system
# # # # # # # # # # #                     # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # # #                     $signInLogs.Add($signInLog)
# # # # # # # # # # #                     # }
# # # # # # # # # # #                 } elseif ($element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement)) {
# # # # # # # # # # #                     # Handle the case where the deviceDetail object has different properties
# # # # # # # # # # #                     $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("deviceId", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("displayName", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("operatingSystem", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("isCompliant", [ref]$temp) ? $temp.GetBoolean() : $false),
# # # # # # # # # # #                         ($deviceDetailElement.TryGetProperty("trustType", [ref]$temp) ? $temp.GetString() : "")
# # # # # # # # # # #                     )

# # # # # # # # # # #                     # Check if the required properties are present
# # # # # # # # # # #                     if (-not [string]::IsNullOrEmpty($deviceDetail.DeviceId) -and
# # # # # # # # # # #                         -not [string]::IsNullOrEmpty($deviceDetail.DisplayName) -and
# # # # # # # # # # #                         -not [string]::IsNullOrEmpty($deviceDetail.OperatingSystem) -and
# # # # # # # # # # #                         -not [string]::IsNullOrEmpty($deviceDetail.TrustType)) {
# # # # # # # # # # #                         $signInLog = [SignInLog]::new(
# # # # # # # # # # #                             ($element.TryGetProperty("userDisplayName", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # #                             ($element.TryGetProperty("userId", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # # # #                             $deviceDetail
# # # # # # # # # # #                         )

# # # # # # # # # # #                         $signInLogs.Add($signInLog)
# # # # # # # # # # #                     } else {
# # # # # # # # # # #                         Write-Warning "Required properties missing in deviceDetail object: $($deviceDetailElement.GetRawText())"
# # # # # # # # # # #                     }
# # # # # # # # # # #                 } else {
# # # # # # # # # # #                     Write-Warning "deviceDetail property not found in element: $($element.GetRawText())"
# # # # # # # # # # #                 }
# # # # # # # # # # #             } catch {
# # # # # # # # # # #                 # Handle the case where the property does not exist
# # # # # # # # # # #                 Write-Warning "Property missing in one of the elements, skipping this element: $($element.GetRawText())"
# # # # # # # # # # #             }
# # # # # # # # # # #         }

# # # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # # #     } catch {
# # # # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # # # #     } finally {
# # # # # # # # # # #         $fileStream.Close()
# # # # # # # # # # #     }

# # # # # # # # # # #     return $signInLogs
# # # # # # # # # # # }

# # # # # # # # # # # # Example usage
# # # # # # # # # # # # $jsonFilePath = "C:\Code\CB\Entra\ICTC\Entra\Devices\Beta\CustomExports\CustomSignInlogs\log.json"
# # # # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath $jsonFilePath

# # # # # # # # # # # # # Ensure the signInLogs variable is not null before using it
# # # # # # # # # # # # if ($null -eq $signInLogs) {
# # # # # # # # # # # #     Write-Warning "No sign-in logs were loaded."
# # # # # # # # # # # #     exit 1
# # # # # # # # # # # # }

# # # # # # # # # # # # # Display the count of loaded sign-in logs
# # # # # # # # # # # # Write-Host "Loaded $($signInLogs.Count) sign-in logs."

# # # # # # # # # # # # # Debugging: Print the first sign-in log entry
# # # # # # # # # # # # if ($signInLogs.Count -gt 0) {
# # # # # # # # # # # #     $firstSignInLog = $signInLogs[0]
# # # # # # # # # # # #     Write-Host "First sign-in log entry:"
# # # # # # # # # # # #     Write-Host "UserDisplayName: $($firstSignInLog.UserDisplayName)"
# # # # # # # # # # # #     Write-Host "UserId: $($firstSignInLog.UserId)"
# # # # # # # # # # # #     Write-Host "DeviceDetail:"
# # # # # # # # # # # #     Write-Host "  DeviceId: $($firstSignInLog.DeviceDetail.DeviceId)"
# # # # # # # # # # # #     Write-Host "  DisplayName: $($firstSignInLog.DeviceDetail.DisplayName)"
# # # # # # # # # # # #     Write-Host "  OperatingSystem: $($firstSignInLog.DeviceDetail.OperatingSystem)"
# # # # # # # # # # # #     Write-Host "  IsCompliant: $($firstSignInLog.DeviceDetail.IsCompliant)"
# # # # # # # # # # # #     Write-Host "  TrustType: $($firstSignInLog.DeviceDetail.TrustType)"
# # # # # # # # # # # # }

# # # # # # # # # # # # # Example call to Process-AllDevices
# # # # # # # # # # # # $results = Process-AllDevices -Json $signInLogs -Headers $Headers
# # # # # # # # # # # # Write-Host "Processed $($results.Count) devices."
















# # # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # # class DeviceDetail {
# # # # # # # # # #     [string]$DeviceId
# # # # # # # # # #     [string]$DisplayName
# # # # # # # # # #     [string]$OperatingSystem
# # # # # # # # # #     [bool]$IsCompliant
# # # # # # # # # #     [string]$TrustType

# # # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # # #     }
# # # # # # # # # # }

# # # # # # # # # # # Define the SignInLog class
# # # # # # # # # # class SignInLog {
# # # # # # # # # #     [string]$UserDisplayName
# # # # # # # # # #     [string]$UserId
# # # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # # #         $this.UserId = $userId
# # # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # # #     }
# # # # # # # # # # }

# # # # # # # # # # function Load-SignInLogs {
# # # # # # # # # #     param (
# # # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # # #         [string]$JsonFilePath
# # # # # # # # # #     )

# # # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # # # #     try {
# # # # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # # # #         Write-Host "Opening file: $JsonFilePath"
# # # # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)
# # # # # # # # # #         Write-Host "File opened and parsed successfully."

# # # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # # #             try {
# # # # # # # # # #                 $deviceDetailElement = $null
# # # # # # # # # #                 if ($element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement)) {
# # # # # # # # # #                     $deviceDetail = [DeviceDetail]::new(
# # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("deviceId", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("displayName", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("operatingSystem", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("isCompliant", [ref]$temp)) { $temp.GetBoolean() } else { $false },
# # # # # # # # # #                         if ($deviceDetailElement.TryGetProperty("trustType", [ref]$temp)) { $temp.GetString() } else { "" }
# # # # # # # # # #                     )

# # # # # # # # # #                     $signInLog = [SignInLog]::new(
# # # # # # # # # #                         if ($element.TryGetProperty("userDisplayName", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # #                         if ($element.TryGetProperty("userId", [ref]$temp)) { $temp.GetString() } else { "" },
# # # # # # # # # #                         $deviceDetail
# # # # # # # # # #                     )

# # # # # # # # # #                     # Example filtering: Only add logs for a specific operating system
# # # # # # # # # #                     # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # # #                     $signInLogs.Add($signInLog)
# # # # # # # # # #                     # }
# # # # # # # # # #                 } else {
# # # # # # # # # #                     Write-Warning "deviceDetail property not found in element: $($element.GetRawText())"
# # # # # # # # # #                 }
# # # # # # # # # #             } catch {
# # # # # # # # # #                 # Handle the case where the property does not exist
# # # # # # # # # #                 Write-Warning "Property missing in one of the elements, skipping this element: $($element.GetRawText())"
# # # # # # # # # #             }
# # # # # # # # # #         }

# # # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # # #     } catch {
# # # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # # #     } finally {
# # # # # # # # # #         $fileStream.Close()
# # # # # # # # # #     }

# # # # # # # # # #     return $signInLogs
# # # # # # # # # # }

# # # # # # # # # # # Example usage
# # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath "C:\log.json"

# # # # # # # # # # # Ensure the signInLogs variable is not null before using it
# # # # # # # # # # if ($null -eq $signInLogs) {
# # # # # # # # # #     Write-Host "No sign-in logs were loaded."
# # # # # # # # # #     exit 1
# # # # # # # # # # }

# # # # # # # # # # # Example call to Process-AllDevices
# # # # # # # # # # $results = Process-AllDevices -Json $signInLogs -Headers $Headers
# # # # # # # # # # Write-Host "Processed $($results.Count) devices."























# # # # # # # # # # Load System.Text.Json assembly
# # # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # # Define the DeviceDetail class
# # # # # # # # # class DeviceDetail {
# # # # # # # # #     [string]$DeviceId
# # # # # # # # #     [string]$DisplayName
# # # # # # # # #     [string]$OperatingSystem
# # # # # # # # #     [bool]$IsCompliant
# # # # # # # # #     [string]$TrustType

# # # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # # #         $this.DisplayName = $displayName
# # # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # # #         $this.TrustType = $trustType
# # # # # # # # #     }
# # # # # # # # # }

# # # # # # # # # # Define the SignInLog class
# # # # # # # # # class SignInLog {
# # # # # # # # #     [string]$UserDisplayName
# # # # # # # # #     [string]$UserId
# # # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # # #         $this.UserId = $userId
# # # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # # #     }
# # # # # # # # # }

# # # # # # # # # function Load-SignInLogs {
# # # # # # # # #     param (
# # # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # # #         [string]$JsonFilePath
# # # # # # # # #     )

# # # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # # #     try {
# # # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # # #         Write-Host "Opening file: $JsonFilePath"
# # # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)
# # # # # # # # #         Write-Host "File opened and parsed successfully."

# # # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # # #             try {
# # # # # # # # #                 $deviceDetailElement = $null
# # # # # # # # #                 if ($element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement)) {
# # # # # # # # #                     $deviceDetail = [DeviceDetail]::new(
# # # # # # # # #                         ($deviceDetailElement.TryGetProperty("deviceId", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # #                         ($deviceDetailElement.TryGetProperty("displayName", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # #                         ($deviceDetailElement.TryGetProperty("operatingSystem", [ref]$temp) ? $temp.GetString() : ""),
# # # # # # # # #                         ($deviceDetailElement.TryGetProperty("isCompliant", [ref]$temp) ? $temp.GetBoolean() : $false),
# # # # # # # # #                         ($deviceDetailElement.TryGetProperty("trustType", [ref]$temp) ? $temp.GetString() : "")
# # # # # # # # #                     )

# # # # # # # # #                     # Ignore additional properties like browser and isManaged
# # # # # # # # #                     $deviceDetailElement.TryGetProperty("browser", [ref]$null) | Out-Null
# # # # # # # # #                     $deviceDetailElement.TryGetProperty("isManaged", [ref]$null) | Out-Null

# # # # # # # # #                     $userDisplayName = $null
# # # # # # # # #                     $userId = $null
# # # # # # # # #                     $element.TryGetProperty("userDisplayName", [ref]$userDisplayName) | Out-Null
# # # # # # # # #                     $element.TryGetProperty("userId", [ref]$userId) | Out-Null

# # # # # # # # #                     $signInLog = [SignInLog]::new(
# # # # # # # # #                         ($userDisplayName ? $userDisplayName.GetString() : ""),
# # # # # # # # #                         ($userId ? $userId.GetString() : ""),
# # # # # # # # #                         $deviceDetail
# # # # # # # # #                     )

# # # # # # # # #                     # Example filtering: Only add logs for a specific operating system
# # # # # # # # #                     # if ($deviceDetail.OperatingSystem -eq "Windows") {
# # # # # # # # #                     $signInLogs.Add($signInLog)
# # # # # # # # #                     # }
# # # # # # # # #                 } else {
# # # # # # # # #                     Write-Warning "deviceDetail property not found in element: $($element.GetRawText())"
# # # # # # # # #                 }
# # # # # # # # #             } catch {
# # # # # # # # #                 # Handle the case where the property does not exist
# # # # # # # # #                 Write-Warning "Property missing in one of the elements, skipping this element: $($element.GetRawText())"
# # # # # # # # #             }
# # # # # # # # #         }

# # # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # # #     } catch {
# # # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # # #     } finally {
# # # # # # # # #         $fileStream.Close()
# # # # # # # # #     }

# # # # # # # # #     return $signInLogs
# # # # # # # # # }

# # # # # # # # # # # Example usage
# # # # # # # # # # $signInLogs = Load-SignInLogs -JsonFilePath "C:\log.json"

# # # # # # # # # # # Ensure the signInLogs variable is not null before using it
# # # # # # # # # # if ($null -eq $signInLogs) {
# # # # # # # # # #     Write-Host "No sign-in logs were loaded."
# # # # # # # # # #     exit 1
# # # # # # # # # # }

# # # # # # # # # # # Example call to Process-AllDevices
# # # # # # # # # # $results = Process-AllDevices -Json $signInLogs -Headers $Headers
# # # # # # # # # # Write-Host "Processed $($results.Count) devices."



























# # # # # # # # # Load System.Text.Json assembly
# # # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # # Define the DeviceDetail class
# # # # # # # # class DeviceDetail {
# # # # # # # #     [string]$DeviceId
# # # # # # # #     [string]$DisplayName
# # # # # # # #     [string]$OperatingSystem
# # # # # # # #     [bool]$IsCompliant
# # # # # # # #     [string]$TrustType

# # # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # # #         $this.DeviceId = $deviceId
# # # # # # # #         $this.DisplayName = $displayName
# # # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # # #         $this.TrustType = $trustType
# # # # # # # #     }
# # # # # # # # }

# # # # # # # # # Define the SignInLog class
# # # # # # # # class SignInLog {
# # # # # # # #     [string]$UserDisplayName
# # # # # # # #     [string]$UserId
# # # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # # #         $this.UserId = $userId
# # # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # # #     }
# # # # # # # # }

# # # # # # # # function Load-SignInLogs {
# # # # # # # #     param (
# # # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # # #         [string]$JsonFilePath
# # # # # # # #     )

# # # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # # #     try {
# # # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # # #         Write-Host "Opening file: $JsonFilePath"
# # # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)
# # # # # # # #         Write-Host "File opened and parsed successfully."

# # # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # # #             try {
# # # # # # # #                 $deviceDetailElement = $null
# # # # # # # #                 if ($element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement)) {
# # # # # # # #                     $deviceId = $null
# # # # # # # #                     $displayName = $null
# # # # # # # #                     $operatingSystem = $null
# # # # # # # #                     $isCompliant = $null
# # # # # # # #                     $trustType = $null

# # # # # # # #                     if ($deviceDetailElement.TryGetProperty("deviceId", [ref]$temp)) { $deviceId = $temp.GetString() }
# # # # # # # #                     if ($deviceDetailElement.TryGetProperty("displayName", [ref]$temp)) { $displayName = $temp.GetString() }
# # # # # # # #                     if ($deviceDetailElement.TryGetProperty("operatingSystem", [ref]$temp)) { $operatingSystem = $temp.GetString() }
# # # # # # # #                     if ($deviceDetailElement.TryGetProperty("isCompliant", [ref]$temp)) { $isCompliant = $temp.GetBoolean() }
# # # # # # # #                     if ($deviceDetailElement.TryGetProperty("trustType", [ref]$temp)) { $trustType = $temp.GetString() }

# # # # # # # #                     $deviceDetail = [DeviceDetail]::new(
# # # # # # # #                         $deviceId,
# # # # # # # #                         $displayName,
# # # # # # # #                         $operatingSystem,
# # # # # # # #                         $isCompliant,
# # # # # # # #                         $trustType
# # # # # # # #                     )

# # # # # # # #                     $userDisplayName = $null
# # # # # # # #                     $userId = $null
# # # # # # # #                     if ($element.TryGetProperty("userDisplayName", [ref]$temp)) { $userDisplayName = $temp.GetString() }
# # # # # # # #                     if ($element.TryGetProperty("userId", [ref]$temp)) { $userId = $temp.GetString() }

# # # # # # # #                     $signInLog = [SignInLog]::new(
# # # # # # # #                         $userDisplayName,
# # # # # # # #                         $userId,
# # # # # # # #                         $deviceDetail
# # # # # # # #                     )

# # # # # # # #                     $signInLogs.Add($signInLog)
# # # # # # # #                 } else {
# # # # # # # #                     Write-Warning "deviceDetail property not found in element: $($element.GetRawText())"
# # # # # # # #                 }
# # # # # # # #             } catch {
# # # # # # # #                 # Handle the case where the property does not exist
# # # # # # # #                 # Write-Warning "Property missing in one of the elements, skipping this element: $($element.GetRawText())"
# # # # # # # #             }
# # # # # # # #         }

# # # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # # #     } catch {
# # # # # # # #         Handle-Error -ErrorRecord $_
# # # # # # # #     } finally {
# # # # # # # #         $fileStream.Close()
# # # # # # # #     }

# # # # # # # #     return $signInLogs
# # # # # # # # }





# # # # # # # # Load System.Text.Json assembly
# # # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # # Define the DeviceDetail class
# # # # # # # class DeviceDetail {
# # # # # # #     [string]$DeviceId
# # # # # # #     [string]$DisplayName
# # # # # # #     [string]$OperatingSystem
# # # # # # #     [bool]$IsCompliant
# # # # # # #     [string]$TrustType

# # # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # # #         $this.DeviceId = $deviceId
# # # # # # #         $this.DisplayName = $displayName
# # # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # # #         $this.IsCompliant = $isCompliant
# # # # # # #         $this.TrustType = $trustType
# # # # # # #     }
# # # # # # # }

# # # # # # # # Define the SignInLog class
# # # # # # # class SignInLog {
# # # # # # #     [string]$UserDisplayName
# # # # # # #     [string]$UserId
# # # # # # #     [DeviceDetail]$DeviceDetail

# # # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # # #         $this.UserId = $userId
# # # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # # #     }
# # # # # # # }

# # # # # # # function Load-SignInLogs {
# # # # # # #     param (
# # # # # # #         [Parameter(Mandatory = $true)]
# # # # # # #         [string]$JsonFilePath
# # # # # # #     )

# # # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # # #     try {
# # # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # # #         Write-Host "Opening file: $JsonFilePath"
# # # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)
# # # # # # #         Write-Host "File opened and parsed successfully."

# # # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # # #             try {
# # # # # # #                 $deviceDetailElement = $null
# # # # # # #                 if ($element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement)) {
# # # # # # #                     $deviceId = $null
# # # # # # #                     $displayName = $null
# # # # # # #                     $operatingSystem = $null
# # # # # # #                     $isCompliant = $false
# # # # # # #                     $trustType = $null

# # # # # # #                     if ($deviceDetailElement.TryGetProperty("deviceId", [ref]$temp)) { $deviceId = $temp.GetString() }
# # # # # # #                     if ($deviceDetailElement.TryGetProperty("displayName", [ref]$temp)) { $displayName = $temp.GetString() }
# # # # # # #                     if ($deviceDetailElement.TryGetProperty("operatingSystem", [ref]$temp)) { $operatingSystem = $temp.GetString() }
# # # # # # #                     if ($deviceDetailElement.TryGetProperty("isCompliant", [ref]$temp)) { $isCompliant = $temp.GetBoolean() }
# # # # # # #                     if ($deviceDetailElement.TryGetProperty("trustType", [ref]$temp)) { $trustType = $temp.GetString() }

# # # # # # #                     $deviceDetail = [DeviceDetail]::new(
# # # # # # #                         $deviceId,
# # # # # # #                         $displayName,
# # # # # # #                         $operatingSystem,
# # # # # # #                         $isCompliant,
# # # # # # #                         $trustType
# # # # # # #                     )

# # # # # # #                     $userDisplayName = $null
# # # # # # #                     $userId = $null
# # # # # # #                     if ($element.TryGetProperty("userDisplayName", [ref]$temp)) { $userDisplayName = $temp.GetString() }
# # # # # # #                     if ($element.TryGetProperty("userId", [ref]$temp)) { $userId = $temp.GetString() }

# # # # # # #                     $signInLog = [SignInLog]::new(
# # # # # # #                         $userDisplayName,
# # # # # # #                         $userId,
# # # # # # #                         $deviceDetail
# # # # # # #                     )

# # # # # # #                     $signInLogs.Add($signInLog)
# # # # # # #                 } else {
# # # # # # #                     Write-Warning "deviceDetail property not found in element: $($element.GetRawText())"
# # # # # # #                 }
# # # # # # #             } catch {
# # # # # # #                 Write-Warning "Error processing element: $($_.Exception.Message)"
# # # # # # #             }
# # # # # # #         }

# # # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # # #     } catch {
# # # # # # #         Write-Error "Error loading sign-in logs: $($_.Exception.Message)"
# # # # # # #     } finally {
# # # # # # #         $fileStream.Close()
# # # # # # #     }

# # # # # # #     return $signInLogs
# # # # # # # }



















# # # # # # # Load System.Text.Json assembly
# # # # # # Add-Type -AssemblyName System.Text.Json

# # # # # # # Define the DeviceDetail class
# # # # # # class DeviceDetail {
# # # # # #     [string]$DeviceId
# # # # # #     [string]$DisplayName
# # # # # #     [string]$OperatingSystem
# # # # # #     [bool]$IsCompliant
# # # # # #     [string]$TrustType

# # # # # #     DeviceDetail([string]$deviceId, [string]$displayName, [string]$operatingSystem, [bool]$isCompliant, [string]$trustType) {
# # # # # #         $this.DeviceId = $deviceId
# # # # # #         $this.DisplayName = $displayName
# # # # # #         $this.OperatingSystem = $operatingSystem
# # # # # #         $this.IsCompliant = $isCompliant
# # # # # #         $this.TrustType = $trustType
# # # # # #     }
# # # # # # }

# # # # # # # Define the SignInLog class
# # # # # # class SignInLog {
# # # # # #     [string]$UserDisplayName
# # # # # #     [string]$UserId
# # # # # #     [DeviceDetail]$DeviceDetail

# # # # # #     SignInLog([string]$userDisplayName, [string]$userId, [DeviceDetail]$deviceDetail) {
# # # # # #         $this.UserDisplayName = $userDisplayName
# # # # # #         $this.UserId = $userId
# # # # # #         $this.DeviceDetail = $deviceDetail
# # # # # #     }
# # # # # # }

# # # # # # function Load-SignInLogs {
# # # # # #     param (
# # # # # #         [Parameter(Mandatory = $true)]
# # # # # #         [string]$JsonFilePath
# # # # # #     )

# # # # # #     $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()

# # # # # #     try {
# # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # #         Write-Host "Opening file: $JsonFilePath"
# # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)
# # # # # #         Write-Host "File opened and parsed successfully."

# # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # #             $deviceDetailElement = $null
# # # # # #             $element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement) | Out-Null

# # # # # #             $deviceDetail = [DeviceDetail]::new(
# # # # # #                 ($deviceDetailElement.GetProperty("deviceId").GetString()),
# # # # # #                 ($deviceDetailElement.GetProperty("displayName").GetString()),
# # # # # #                 ($deviceDetailElement.GetProperty("operatingSystem").GetString()),
# # # # # #                 ($deviceDetailElement.GetProperty("isCompliant").GetBoolean()),
# # # # # #                 ($deviceDetailElement.GetProperty("trustType").GetString())
# # # # # #             )

# # # # # #             $userDisplayName = $element.GetProperty("userDisplayName").GetString()
# # # # # #             $userId = $element.GetProperty("userId").GetString()

# # # # # #             $signInLog = [SignInLog]::new(
# # # # # #                 $userDisplayName,
# # # # # #                 $userId,
# # # # # #                 $deviceDetail
# # # # # #             )

# # # # # #             $signInLogs.Add($signInLog)
# # # # # #         }

# # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # #     } catch {
# # # # # #         Write-Error "Error loading sign-in logs: $($_.Exception.Message)"
# # # # # #     } finally {
# # # # # #         $fileStream.Close()
# # # # # #     }

# # # # # #     return $signInLogs
# # # # # # }






# # # # # # function Load-SignInLogs {
# # # # # #     param (
# # # # # #         [Parameter(Mandatory = $true)]
# # # # # #         [string]$JsonFilePath
# # # # # #     )

# # # # # #     $signInLogs = @()

# # # # # #     try {
# # # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # # #         Write-Host "Opening file: $JsonFilePath"
# # # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)
# # # # # #         Write-Host "File opened and parsed successfully."

# # # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # # #             $log = @{
# # # # # #                 UserDisplayName = $element.GetProperty("userDisplayName").GetString()
# # # # # #                 UserId = $element.GetProperty("userId").GetString()
# # # # # #                 DeviceId = $element.GetProperty("deviceDetail").GetProperty("deviceId").GetString()
# # # # # #                 DisplayName = $element.GetProperty("deviceDetail").GetProperty("displayName").GetString()
# # # # # #                 OperatingSystem = $element.GetProperty("deviceDetail").GetProperty("operatingSystem").GetString()
# # # # # #                 IsCompliant = $element.GetProperty("deviceDetail").GetProperty("isCompliant").GetBoolean()
# # # # # #                 TrustType = $element.GetProperty("deviceDetail").GetProperty("trustType").GetString()
# # # # # #             }
# # # # # #             $signInLogs += $log
# # # # # #         }

# # # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # # #     } catch {
# # # # # #         Write-Error "Error loading sign-in logs: $($_.Exception.Message)"
# # # # # #     } finally {
# # # # # #         $fileStream.Close()
# # # # # #     }

# # # # # #     return $signInLogs
# # # # # # }

# # # # # # # Example usage
# # # # # # $logs = Load-SignInLogs -JsonFilePath "path_to_your_json_file.json"
# # # # # # $logs | Format-Table -AutoSize









# # # # # function Load-SignInLogs {
# # # # #     param (
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [string]$JsonFilePath
# # # # #     )

# # # # #     $signInLogs = @()

# # # # #     try {
# # # # #         # Open the file using FileStream with buffering and SequentialScan
# # # # #         Write-Host "Opening file: $JsonFilePath"
# # # # #         $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
# # # # #         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)
# # # # #         Write-Host "File opened and parsed successfully."

# # # # #         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
# # # # #             try {
# # # # #                 $userDisplayName = if ($element.TryGetProperty("userDisplayName", [ref]$temp)) { $temp.GetString() } else { "" }
# # # # #                 $userId = if ($element.TryGetProperty("userId", [ref]$temp)) { $temp.GetString() } else { "" }
# # # # #                 $deviceDetailElement = $null
# # # # #                 $element.TryGetProperty("deviceDetail", [ref]$deviceDetailElement) | Out-Null

# # # # #                 $deviceId = if ($deviceDetailElement -and $deviceDetailElement.TryGetProperty("deviceId", [ref]$temp)) { $temp.GetString() } else { "" }
# # # # #                 $displayName = if ($deviceDetailElement -and $deviceDetailElement.TryGetProperty("displayName", [ref]$temp)) { $temp.GetString() } else { "" }
# # # # #                 $operatingSystem = if ($deviceDetailElement -and $deviceDetailElement.TryGetProperty("operatingSystem", [ref]$temp)) { $temp.GetString() } else { "" }
# # # # #                 $isCompliant = if ($deviceDetailElement -and $deviceDetailElement.TryGetProperty("isCompliant", [ref]$temp)) { $temp.GetBoolean() } else { $false }
# # # # #                 $trustType = if ($deviceDetailElement -and $deviceDetailElement.TryGetProperty("trustType", [ref]$temp)) { $temp.GetString() } else { "" }

# # # # #                 $log = @{
# # # # #                     UserDisplayName = $userDisplayName
# # # # #                     UserId = $userId
# # # # #                     DeviceId = $deviceId
# # # # #                     DisplayName = $displayName
# # # # #                     OperatingSystem = $operatingSystem
# # # # #                     IsCompliant = $isCompliant
# # # # #                     TrustType = $trustType
# # # # #                 }

# # # # #                 $signInLogs += [pscustomobject]$log
# # # # #             } catch {
# # # # #                 Write-Warning "Error processing element: $($_.Exception.Message)"
# # # # #             }
# # # # #         }

# # # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # # #     } catch {
# # # # #         Write-Error "Error loading sign-in logs: $($_.Exception.Message)"
# # # # #     } finally {
# # # # #         $fileStream.Close()
# # # # #     }

# # # # #     return [System.Collections.ArrayList]$signInLogs
# # # # # }

# # # # # # Example usage
# # # # # # $logs = Load-SignInLogs -JsonFilePath "path_to_your_json_file.json"

# # # # # # # Debug output to check if logs are loaded correctly
# # # # # # Write-Host "Loaded $($logs.Count) sign-in logs."
# # # # # # if ($logs.Count -gt 0) {
# # # # # #     Write-Host "First sign-in log entry:"
# # # # # #     $logs[0] | Format-List
# # # # # # }

# # # # # # Call the Process-AllDevices function and pass the loaded logs
# # # # # # Ensure Process-AllDevices is defined before this call
# # # # # # $results = Process-AllDevices -Json $logs -Headers $Headers
















# # # # function Load-SignInLogs {
# # # #     param (
# # # #         [Parameter(Mandatory = $true)]
# # # #         [string]$JsonFilePath
# # # #     )

# # # #     $signInLogs = @()

# # # #     try {
# # # #         # Read the JSON file content
# # # #         Write-Host "Reading file: $JsonFilePath"
# # # #         $jsonContent = Get-Content -Path $JsonFilePath -Raw
# # # #         $jsonArray = $jsonContent | ConvertFrom-Json
# # # #         Write-Host "File read and parsed successfully."

# # # #         foreach ($element in $jsonArray) {
# # # #             $log = @{
# # # #                 UserDisplayName = $element.userDisplayName
# # # #                 UserId = $element.userId
# # # #                 DeviceId = $element.deviceDetail.deviceId
# # # #                 DisplayName = $element.deviceDetail.displayName
# # # #                 OperatingSystem = $element.deviceDetail.operatingSystem
# # # #                 IsCompliant = $element.deviceDetail.isCompliant
# # # #                 TrustType = $element.deviceDetail.trustType
# # # #             }

# # # #             $signInLogs += [pscustomobject]$log
# # # #         }

# # # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # # #     } catch {
# # # #         Write-Error "Error loading sign-in logs: $($_.Exception.Message)"
# # # #     }

# # # #     return $signInLogs
# # # # }

# # # # # # Example usage
# # # # # $logs = Load-SignInLogs -JsonFilePath "path_to_your_json_file.json"

# # # # # # Debug output to check if logs are loaded correctly
# # # # # Write-Host "Loaded $($logs.Count) sign-in logs."
# # # # # if ($logs.Count -gt 0) {
# # # # #     Write-Host "First sign-in log entry:"
# # # # #     $logs[0] | Format-List
# # # # # }

# # # # # # Call the Process-AllDevices function and pass the loaded logs
# # # # # # Ensure Process-AllDevices is defined before this call
# # # # # $results = Process-AllDevices -Json $logs -Headers $Headers












# # # function Load-SignInLogs {
# # #     param (
# # #         [Parameter(Mandatory = $true)]
# # #         [string]$JsonFilePath
# # #     )

# # #     $signInLogs = @()

# # #     try {
# # #         # Read the JSON file content
# # #         Write-Host "Reading file: $JsonFilePath"
# # #         $jsonContent = Get-Content -Path $JsonFilePath -Raw
# # #         $jsonArray = $jsonContent | ConvertFrom-Json
# # #         Write-Host "File read and parsed successfully."

# # #         foreach ($element in $jsonArray) {
# # #             if ($null -ne $element) {
# # #                 $log = @{
# # #                     UserDisplayName = $element.userDisplayName
# # #                     UserId = $element.userId
# # #                     DeviceId = $element.deviceDetail.deviceId
# # #                     DisplayName = $element.deviceDetail.displayName
# # #                     OperatingSystem = $element.deviceDetail.operatingSystem
# # #                     IsCompliant = $element.deviceDetail.isCompliant
# # #                     TrustType = $element.deviceDetail.trustType
# # #                 }

# # #                 $signInLogs += [pscustomobject]$log
# # #             } else {
# # #                 Write-Warning "Encountered a null element in the JSON array."
# # #             }
# # #         }

# # #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# # #     } catch {
# # #         Write-Error "Error loading sign-in logs: $($_.Exception.Message)"
# # #     }

# # #     return $signInLogs
# # # }





# # function Load-SignInLogs {
# #     param (
# #         [Parameter(Mandatory = $true)]
# #         [string]$JsonFilePath
# #     )

# #     $signInLogs = @()

# #     try {
# #         # Read the JSON file content
# #         Write-Host "Reading file: $JsonFilePath"
# #         $jsonContent = Get-Content -Path $JsonFilePath -Raw
# #         $jsonArray = $jsonContent | ConvertFrom-Json
# #         Write-Host "File read and parsed successfully."

# #         foreach ($element in $jsonArray) {
# #             if ($null -ne $element) {
# #                 $log = @{
# #                     UserDisplayName = $element.userDisplayName
# #                     UserId = $element.userId
# #                     DeviceId = $element.deviceDetail.deviceId
# #                     DisplayName = $element.deviceDetail.displayName
# #                     OperatingSystem = $element.deviceDetail.operatingSystem
# #                     IsCompliant = $element.deviceDetail.isCompliant
# #                     TrustType = $element.deviceDetail.trustType
# #                 }

# #                 $signInLogs += [pscustomobject]$log
# #             } else {
# #                 Write-Warning "Encountered a null element in the JSON array."
# #             }
# #         }

# #         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
# #     } catch {
# #         Write-Error "Error loading sign-in logs: $($_.Exception.Message)"
# #     }

# #     return $signInLogs
# # }







# function Load-SignInLogs {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$JsonFilePath
#     )

#     $signInLogs = @()

#     try {
#         # Read the JSON file content
#         Write-Host "Reading file: $JsonFilePath"
#         $jsonContent = Get-Content -Path $JsonFilePath -Raw
#         $jsonArray = $jsonContent | ConvertFrom-Json
#         Write-Host "File read and parsed successfully."

#         foreach ($element in $jsonArray) {
#             if ($null -ne $element) {
#                 $log = [pscustomobject]@{
#                     UserDisplayName = $element.userDisplayName
#                     UserId = $element.userId
#                     DeviceId = $element.deviceDetail.deviceId
#                     DisplayName = $element.deviceDetail.displayName
#                     OperatingSystem = $element.deviceDetail.operatingSystem
#                     IsCompliant = $element.deviceDetail.isCompliant
#                     TrustType = $element.deviceDetail.trustType
#                 }

#                 $signInLogs += $log
#             } else {
#                 Write-Warning "Encountered a null element in the JSON array."
#             }
#         }

#         Write-Host "Sign-in logs loaded successfully from $JsonFilePath."
#     } catch {
#         Write-Error "Error loading sign-in logs: $($_.Exception.Message)"
#     }

#     return $signInLogs
# }

# function Process-DeviceItem {
#     param (
#         [Parameter(Mandatory = $true)]
#         [PSCustomObject]$Item,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers,
#         [Parameter(Mandatory = $true)]
#         [PSCustomObject]$Context
#     )

#     # Implement your logic to process each device item here
#     Write-Host "Processing item: $($Item.UserDisplayName)"
    
#     # Example logic (to be replaced with your actual logic)
#     $result = [pscustomobject]@{
#         UserDisplayName = $Item.UserDisplayName
#         UserId = $Item.UserId
#         DeviceId = $Item.DeviceId
#         DisplayName = $Item.DisplayName
#         OperatingSystem = $Item.OperatingSystem
#         IsCompliant = $Item.IsCompliant
#         TrustType = $Item.TrustType
#     }

#     # Add result to context
#     $Context.Results += $result
# }


















# # Function to load sign-in logs from the latest JSON file
# function Load-SignInLogs {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$JsonFilePath
#     )

#     try {
#         $json = Get-Content -Path $JsonFilePath | ConvertFrom-Json
#         # Write-EnhancedLog -Message "Sign-in logs loaded successfully from $JsonFilePath." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
#         return $json
#     } catch {
#         Handle-Error -ErrorRecord $_
        
#     }
# }



# class SignInLog {
#     [string] $userDisplayName
#     [string] $userId
#     [DeviceDetail] $deviceDetail

#     SignInLog([string] $userDisplayName, [string] $userId, [DeviceDetail] $deviceDetail) {
#         $this.userDisplayName = $userDisplayName
#         $this.userId = $userId
#         $this.deviceDetail = $deviceDetail
#     }
# }

# class DeviceDetail {
#     [string] $deviceId
#     [string] $displayName
#     [string] $operatingSystem
#     [bool] $isCompliant
#     [string] $trustType

#     DeviceDetail([string] $deviceId, [string] $displayName, [string] $operatingSystem, [bool] $isCompliant, [string] $trustType) {
#         $this.deviceId = $deviceId
#         $this.displayName = $displayName
#         $this.operatingSystem = $operatingSystem
#         $this.isCompliant = $isCompliant
#         $this.trustType = $trustType
#     }
# }

# class ProcessingContext {
#     [System.Collections.Generic.HashSet[string]]$UniqueDeviceIds
#     [System.Collections.Generic.List[SignInLog]]$Results

#     ProcessingContext() {
#         $this.UniqueDeviceIds = [System.Collections.Generic.HashSet[string]]::new()
#         $this.Results = [System.Collections.Generic.List[SignInLog]]::new()
#     }
# }




# Function to load sign-in logs from the latest JSON file
function Load-SignInLogs {
    param (
        [Parameter(Mandatory = $true)]
        [string]$JsonFilePath
    )

    $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()
    # $fileStream = [System.IO.File]::OpenRead($JsonFilePath)
    Write-EnhancedLog -Message "Opening file: $JsonFilePath" -Level 'Debug'
    $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)

    try {
        $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)

        foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
            $deviceDetail = [DeviceDetail]::new(
                $element.GetProperty("deviceDetail").GetProperty("deviceId").GetString(),
                $element.GetProperty("deviceDetail").GetProperty("displayName").GetString(),
                $element.GetProperty("deviceDetail").GetProperty("operatingSystem").GetString(),
                $element.GetProperty("deviceDetail").GetProperty("isCompliant").GetBoolean(),
                $element.GetProperty("deviceDetail").GetProperty("trustType").GetString()
            )
            $signInLog = [SignInLog]::new(
                $element.GetProperty("userDisplayName").GetString(),
                $element.GetProperty("userId").GetString(),
                $deviceDetail
            )

            $signInLogs.Add($signInLog)
        }

        # Write-EnhancedLog -Message "Sign-in logs loaded successfully from $JsonFilePath." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
    } catch {
        Handle-Error -ErrorRecord $_
    } finally {
        $fileStream.Dispose()
    }

    return $signInLogs
}










# # Function to load sign-in logs from the latest JSON file
# function Load-SignInLogs {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$JsonFilePath
#     )

#     $signInLogs = [System.Collections.Generic.List[PSCustomObject]]::new()
#     $fileStream = [System.IO.File]::OpenRead($JsonFilePath)

#     try {
#         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)

#         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
#             $signInLog = [PSCustomObject]@{
#                 userDisplayName = $element.GetProperty("userDisplayName").GetString()
#                 userId = $element.GetProperty("userId").GetString()
#                 deviceDetail = [PSCustomObject]@{
#                     deviceId = $element.GetProperty("deviceDetail").GetProperty("deviceId").GetString()
#                     displayName = $element.GetProperty("deviceDetail").GetProperty("displayName").GetString()
#                     operatingSystem = $element.GetProperty("deviceDetail").GetProperty("operatingSystem").GetString()
#                     isCompliant = $element.GetProperty("deviceDetail").GetProperty("isCompliant").GetBoolean()
#                     trustType = $element.GetProperty("deviceDetail").GetProperty("trustType").GetString()
#                 }
#             }

#             $signInLogs.Add($signInLog)
#         }

#         # Write-EnhancedLog -Message "Sign-in logs loaded successfully from $JsonFilePath." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
#     } catch {
#         Handle-Error -ErrorRecord $_
#     } finally {
#         $fileStream.Dispose()
#     }

#     return $signInLogs
# }













# class SignInLog {
#     [string] $userDisplayName
#     [string] $deviceID
#     [datetime] $signInDateTime
#     # Add other relevant properties here
# }

# # Function to load and deserialize sign-in logs from the latest JSON file
# function Load-SignInLogs {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$JsonFilePath
#     )

#     try {
#         # Load the JSON file
#         $reader = [System.IO.StreamReader]::new($JsonFilePath)
#         $jarray = [Newtonsoft.Json.Linq.JArray]::Load([NewtonSoft.Json.JsonTextReader]$reader)
        
#         # Filter out specific users and deserialize to SignInLog class
#         $filteredLogs = $jarray.SelectTokens('$..[?(@.userDisplayName != ''On-Premises Directory Synchronization Service Account'')]').ToObject[SignInLog]()
        
#         # Write-EnhancedLog -Message "Sign-in logs loaded and filtered successfully from $JsonFilePath." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
#         return $filteredLogs
#     } catch {
#         Handle-Error -ErrorRecord $_
#         # return $null
#     }
# }