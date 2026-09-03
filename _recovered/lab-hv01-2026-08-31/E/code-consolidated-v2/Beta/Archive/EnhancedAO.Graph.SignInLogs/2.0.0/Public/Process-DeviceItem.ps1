# # # # # function Process-DeviceItem {
# # # # #     param (
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Item,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [hashtable]$Context,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [hashtable]$Headers
# # # # #     )

# # # # #     $deviceId = $Item.deviceDetail.deviceId
# # # # #     $userId = $Item.userId

# # # # #     if ($deviceId -eq "{PII Removed}") {
# # # # #         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
# # # # #             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Yellow)
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
# # # # #             $Context.UniqueDeviceIds[$userId] = $true
# # # # #         }
# # # # #         return
# # # # #     }

# # # # #     if ([string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
# # # # #             $Context.UniqueDeviceIds[$userId] = $true
# # # # #         }
# # # # #         return
# # # # #     }

# # # # #     if (-not $Context.UniqueDeviceIds.ContainsKey($deviceId)) {
# # # # #         $Context.UniqueDeviceIds[$deviceId] = $true
# # # # #         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers

# # # # #         try {
# # # # #             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
# # # # #             $hasPremiumLicense = $false

# # # # #             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
# # # # #                 $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
# # # # #             }

# # # # #             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #         } catch {
# # # # #             Handle-Error -ErrorRecord $_
# # # # #         }
# # # # #     }
# # # # # }


# # # # # function Process-DeviceItem {
# # # # #     param (
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Item,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Context,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [hashtable]$Headers
# # # # #     )

# # # # #     $deviceId = $Item.deviceDetail.deviceId
# # # # #     $userId = $Item.userId

# # # # #     # Use .NET methods for string comparison
# # # # #     if ([string]::Equals($deviceId, "{PII Removed}", [System.StringComparison]::OrdinalIgnoreCase)) {
# # # # #         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
# # # # #             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Yellow)
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
# # # # #             $Context.UniqueDeviceIds[$userId] = $true
# # # # #         }
# # # # #         return
# # # # #     }

# # # # #     if ([string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
# # # # #             $Context.UniqueDeviceIds[$userId] = $true
# # # # #         }
# # # # #         return
# # # # #     }

# # # # #     if (-not $Context.UniqueDeviceIds.ContainsKey($deviceId)) {
# # # # #         $Context.UniqueDeviceIds[$deviceId] = $true

# # # # #         # Call the method to check device state
# # # # #         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers

# # # # #         try {
# # # # #             # Fetch user licenses
# # # # #             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
# # # # #             $hasPremiumLicense = $false

# # # # #             # Use .NET method to check for the presence of a license
# # # # #             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
# # # # #                 $hasPremiumLicense = [System.Linq.Enumerable]::Contains($userLicenses, "cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
# # # # #             }

# # # # #             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #         } catch {
# # # # #             Handle-Error -ErrorRecord $_
# # # # #         }
# # # # #     }
# # # # # }




# # # # # function Process-DeviceItem {
# # # # #     param (
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Item,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Context,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [hashtable]$Headers
# # # # #     )

# # # # #     $deviceId = $Item.deviceDetail.deviceId
# # # # #     $userId = $Item.userId

# # # # #     # Use .NET methods for string comparison
# # # # #     if ([string]::Equals($deviceId, "{PII Removed}", [System.StringComparison]::OrdinalIgnoreCase)) {
# # # # #         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
# # # # #             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Yellow)
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
# # # # #             $Context.UniqueDeviceIds[$userId] = $true
# # # # #         }
# # # # #         return
# # # # #     }

# # # # #     if ([string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
# # # # #             $Context.UniqueDeviceIds[$userId] = $true
# # # # #         }
# # # # #         return
# # # # #     }

# # # # #     if (-not $Context.UniqueDeviceIds.ContainsKey($deviceId)) {
# # # # #         $Context.UniqueDeviceIds[$deviceId] = $true

# # # # #         # Call the method to check device state
# # # # #         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers

# # # # #         try {
# # # # #             # Fetch user licenses
# # # # #             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
# # # # #             $hasPremiumLicense = $false

# # # # #             # Use .NET method to check for the presence of a license
# # # # #             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
# # # # #                 $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
# # # # #             }

# # # # #             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #         } catch {
# # # # #             Handle-Error -ErrorRecord $_
# # # # #         }
# # # # #     }
# # # # # }










# # # # # function Process-DeviceItem {
# # # # #     param (
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Item,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Context,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [hashtable]$Headers
# # # # #     )

# # # # #     $deviceId = $Item.deviceDetail.deviceId
# # # # #     $userId = $Item.userId

# # # # #     $DBG

# # # # #     # Use .NET methods for string comparison
# # # # #     if ([string]::Equals($deviceId, "{PII Removed}", [System.StringComparison]::OrdinalIgnoreCase)) {
# # # # #         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
# # # # #             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO"
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
# # # # #             $Context.UniqueDeviceIds[$userId] = $true
# # # # #         }
# # # # #         return
# # # # #     }

# # # # #     if ([string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
# # # # #             $Context.UniqueDeviceIds[$userId] = $true
# # # # #         }
# # # # #         return
# # # # #     }

# # # # #     if (-not $Context.UniqueDeviceIds.ContainsKey($deviceId)) {
# # # # #         $Context.UniqueDeviceIds[$deviceId] = $true

# # # # #         # Call the method to check device state
# # # # #         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers

# # # # #         try {
# # # # #             # Fetch user licenses
# # # # #             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
# # # # #             $hasPremiumLicense = $false

# # # # #             # Use .NET method to check for the presence of a license
# # # # #             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
# # # # #                 $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
# # # # #             }

# # # # #             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #         } catch {
# # # # #             Handle-Error -ErrorRecord $_
# # # # #         }
# # # # #     }
# # # # # }




# # # # # function Process-DeviceItem {
# # # # #     param (
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Item,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Context,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [hashtable]$Headers
# # # # #     )

# # # # #     $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# # # # #     $deviceId = $Item.deviceDetail.deviceId
# # # # #     $userId = $Item.userId

# # # # #     $DBG

# # # # #     # Use .NET methods for string comparison
# # # # #     if ([string]::Equals($deviceId, "{PII Removed}", [System.StringComparison]::OrdinalIgnoreCase)) {
# # # # #         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
# # # # #             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO"
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
# # # # #             $Context.UniqueDeviceIds[$userId] = $true
# # # # #         }
# # # # #         $stopwatch.Stop()
# # # # #         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # # #         return
# # # # #     }

# # # # #     if ([string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
# # # # #             $Context.UniqueDeviceIds[$userId] = $true
# # # # #         }
# # # # #         $stopwatch.Stop()
# # # # #         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # # #         return
# # # # #     }

# # # # #     if (-not $Context.UniqueDeviceIds.ContainsKey($deviceId)) {
# # # # #         $Context.UniqueDeviceIds[$deviceId] = $true

# # # # #         # Call the method to check device state
# # # # #         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers

# # # # #         try {
# # # # #             # Fetch user licenses
# # # # #             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
# # # # #             $hasPremiumLicense = $false

# # # # #             # Use .NET method to check for the presence of a license
# # # # #             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
# # # # #                 $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
# # # # #             }

# # # # #             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #         } catch {
# # # # #             Handle-Error -ErrorRecord $_
# # # # #         }
# # # # #     }

# # # # #     $stopwatch.Stop()
# # # # #     Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # # # }




# # # # # Ensure System.Text.Json is available
# # # # # Add-Type -AssemblyName System.Text.Json

# # # # function ConvertFrom-JsonNet {
# # # #     param (
# # # #         [Parameter(Mandatory = $true)]
# # # #         [string]$Json
# # # #     )
# # # #     [System.Text.Json.JsonSerializer]::Deserialize([System.String]::new($Json), [PSCustomObject])
# # # # }

# # # # function ConvertTo-JsonNet {
# # # #     param (
# # # #         [Parameter(Mandatory = $true)]
# # # #         [object]$Object
# # # #     )
# # # #     [System.Text.Json.JsonSerializer]::Serialize($Object, [System.Text.Json.JsonSerializerOptions]::new())
# # # # }

# # # # # function Process-DeviceItem {
# # # # #     param (
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Item,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Context,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [hashtable]$Headers
# # # # #     )

# # # # #     $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# # # # #     $deviceId = $Item.deviceDetail.deviceId
# # # # #     $userId = $Item.userId

# # # # #     $DBG

# # # # #     # Use .NET methods for string comparison
# # # # #     if ([string]::Equals($deviceId, "{PII Removed}", [System.StringComparison]::OrdinalIgnoreCase)) {
# # # # #         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
# # # # #             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO"
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
# # # # #             $Context.UniqueDeviceIds[$userId] = $true
# # # # #         }
# # # # #         $stopwatch.Stop()
# # # # #         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # # #         return
# # # # #     }

# # # # #     if ([string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
# # # # #             $Context.UniqueDeviceIds[$userId] = $true
# # # # #         }
# # # # #         $stopwatch.Stop()
# # # # #         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # # #         return
# # # # #     }

# # # # #     if (-not $Context.UniqueDeviceIds.ContainsKey($deviceId)) {
# # # # #         $Context.UniqueDeviceIds[$deviceId] = $true

# # # # #         # Call the method to check device state
# # # # #         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers

# # # # #         try {
# # # # #             # Fetch user licenses
# # # # #             $userLicensesJson = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
# # # # #             $userLicenses = ConvertFrom-JsonNet -Json $userLicensesJson
# # # # #             $hasPremiumLicense = $false

# # # # #             # Use .NET method to check for the presence of a license
# # # # #             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
# # # # #                 $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
# # # # #             }

# # # # #             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #         } catch {
# # # # #             Handle-Error -ErrorRecord $_
# # # # #         }
# # # # #     }

# # # # #     $stopwatch.Stop()
# # # # #     Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # # # }






# # # # # Ensure System.Collections.Generic.HashSet is available
# # # # # Add-Type -AssemblyName System.Collections

# # # # # function Process-DeviceItem {
# # # # #     param (
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Item,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Context,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [hashtable]$Headers
# # # # #     )

# # # # #     $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# # # # #     $deviceId = $Item.deviceDetail.deviceId
# # # # #     $userId = $Item.userId

# # # # #     # Initialize the HashSet for tracking unique IDs if not already done
# # # # #     if (-not $Context.UniqueDeviceIds) {
# # # # #         $Context.UniqueDeviceIds = [System.Collections.Generic.HashSet[string]]::new()
# # # # #     }

# # # # #     # Use .NET methods for string comparison
# # # # #     if ($deviceId -ieq "{PII Removed}") {
# # # # #         if ($Context.UniqueDeviceIds.Add($userId)) {
# # # # #             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO"
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
# # # # #         }
# # # # #         $stopwatch.Stop()
# # # # #         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # # #         return
# # # # #     }

# # # # #     if ([string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if ($Context.UniqueDeviceIds.Add($userId)) {
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
# # # # #         }
# # # # #         $stopwatch.Stop()
# # # # #         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # # #         return
# # # # #     }

# # # # #     $DBG

# # # # #     if ($Context.UniqueDeviceIds.Add($deviceId)) {
# # # # #         # Call the method to check device state
# # # # #         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers

# # # # #         try {
# # # # #             # Fetch user licenses
# # # # #             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
# # # # #             $hasPremiumLicense = $false

# # # # #             # Use .NET method to check for the presence of a license
# # # # #             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
# # # # #                 $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
# # # # #             }

# # # # #             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #         } catch {
# # # # #             Handle-Error -ErrorRecord $_
# # # # #         }
# # # # #     }

# # # # #     $stopwatch.Stop()
# # # # #     Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # # # }





# # # # # Load System.Collections.Generic.HashSet assembly
# # # # Add-Type -AssemblyName System.Collections

# # # # # function Process-DeviceItem {
# # # # #     param (
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Item,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Context,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [hashtable]$Headers
# # # # #     )

# # # # #     $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# # # # #     $deviceId = $Item.deviceDetail.deviceId
# # # # #     $userId = $Item.userId

# # # # #     # Initialize the HashSet for tracking unique IDs if not already done
# # # # #     if (-not $Context.UniqueDeviceIds) {
# # # # #         $Context.UniqueDeviceIds = [System.Collections.Generic.HashSet[string]]::new()
# # # # #     }

# # # # #     # Use .NET methods for string comparison
# # # # #     if ($deviceId -ieq "{PII Removed}") {
# # # # #         if ($Context.UniqueDeviceIds.Add($userId)) {
# # # # #             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO"
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
# # # # #         }
# # # # #         $stopwatch.Stop()
# # # # #         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # # #         return
# # # # #     }

# # # # #     if ([string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if ($Context.UniqueDeviceIds.Add($userId)) {
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
# # # # #         }
# # # # #         $stopwatch.Stop()
# # # # #         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # # #         return
# # # # #     }

# # # # #     if ($Context.UniqueDeviceIds.Add($deviceId)) {
# # # # #         # Measure the device ID check time
# # # # #         $stopwatch.Stop()
# # # # #         Write-Host "Device ID check time: $($stopwatch.Elapsed.TotalMilliseconds) ms"
# # # # #         $stopwatch.Restart()

# # # # #         $DBG

# # # # #         # Call the method to check device state
# # # # #         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers

# # # # #         # Measure the device state check time
# # # # #         $stopwatch.Stop()
# # # # #         Write-Host "Check-DeviceStateInIntune execution time: $($stopwatch.ElapsedMilliseconds) ms"
# # # # #         $stopwatch.Restart()

# # # # #         try {
# # # # #             # Fetch user licenses
# # # # #             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers

# # # # #             # Measure the user licenses fetch time
# # # # #             $stopwatch.Stop()
# # # # #             Write-Host "Fetch-UserLicense execution time: $($stopwatch.ElapsedMilliseconds) ms"
# # # # #             $stopwatch.Restart()

# # # # #             $hasPremiumLicense = $false
# # # # #             # Use .NET method to check for the presence of a license
# # # # #             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
# # # # #                 $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
# # # # #             }

# # # # #             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #         } catch {
# # # # #             Handle-Error -ErrorRecord $_
# # # # #         }
# # # # #     }

# # # # #     # Measure the total function time
# # # # #     $stopwatch.Stop()
# # # # #     Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # # # }






# # # # # function Process-DeviceItem {
# # # # #     param (
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [SignInLog]$Item,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Context,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [hashtable]$Headers
# # # # #     )

# # # # #     $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# # # # #     $deviceId = $Item.DeviceDetail.DeviceId
# # # # #     $userId = $Item.UserId

# # # # #     # Initialize the HashSet for tracking unique IDs if not already done
# # # # #     if (-not $Context.UniqueDeviceIds) {
# # # # #         $Context.UniqueDeviceIds = [System.Collections.Generic.HashSet[string]]::new()
# # # # #     }

# # # # #     # Use .NET methods for string comparison
# # # # #     if ($deviceId -ieq "{PII Removed}") {
# # # # #         if ($Context.UniqueDeviceIds.Add($userId)) {
# # # # #             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.UserDisplayName)" -Level "INFO"
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
# # # # #         }
# # # # #         $stopwatch.Stop()
# # # # #         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # # #         return
# # # # #     }

# # # # #     if ([string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if ($Context.UniqueDeviceIds.Add($userId)) {
# # # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
# # # # #         }
# # # # #         $stopwatch.Stop()
# # # # #         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # # #         return
# # # # #     }

# # # # #     $DBG

# # # # #     if ($Context.UniqueDeviceIds.Add($deviceId)) {
# # # # #         # Measure the device ID check time
# # # # #         $stopwatch.Stop()
# # # # #         Write-Host "Device ID check time: $($stopwatch.Elapsed.TotalMilliseconds) ms"
# # # # #         $stopwatch.Restart()

# # # # #         # Call the method to check device state
# # # # #         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.UserDisplayName -Headers $Headers

# # # # #         # Measure the device state check time
# # # # #         $stopwatch.Stop()
# # # # #         Write-Host "Check-DeviceStateInIntune execution time: $($stopwatch.ElapsedMilliseconds) ms"
# # # # #         $stopwatch.Restart()

# # # # #         try {
# # # # #             # Fetch user licenses
# # # # #             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.UserDisplayName -Headers $Headers

# # # # #             # Measure the user licenses fetch time
# # # # #             $stopwatch.Stop()
# # # # #             Write-Host "Fetch-UserLicense execution time: $($stopwatch.ElapsedMilliseconds) ms"
# # # # #             $stopwatch.Restart()

# # # # #             $hasPremiumLicense = $false
# # # # #             # Use .NET method to check for the presence of a license
# # # # #             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
# # # # #                 $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
# # # # #             }

# # # # #             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #         } catch {
# # # # #             Handle-Error -ErrorRecord $_
# # # # #         }
# # # # #     }

# # # # #     # Measure the total function time
# # # # #     $stopwatch.Stop()
# # # # #     Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # # # }









# # # # function Process-DeviceItem {
# # # #     param (
# # # #         [Parameter(Mandatory = $true)]
# # # #         [pscustomobject]$Item,
# # # #         [Parameter(Mandatory = $true)]
# # # #         [pscustomobject]$Context,
# # # #         [Parameter(Mandatory = $true)]
# # # #         [hashtable]$Headers
# # # #     )

# # # #     $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# # # #     $deviceId = $Item.DeviceDetail.DeviceId
# # # #     $userId = $Item.UserId

# # # #     # Initialize the HashSet for tracking unique IDs if not already done
# # # #     if (-not $Context.UniqueDeviceIds) {
# # # #         $Context.UniqueDeviceIds = [System.Collections.Generic.HashSet[string]]::new()
# # # #     }

# # # #     # Use .NET methods for string comparison
# # # #     if ($deviceId -ieq "{PII Removed}") {
# # # #         if ($Context.UniqueDeviceIds.Add($userId)) {
# # # #             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.UserDisplayName)" -Level "INFO"
# # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
# # # #         }
# # # #         $stopwatch.Stop()
# # # #         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # #         return
# # # #     }

# # # #     if ([string]::IsNullOrWhiteSpace($deviceId)) {
# # # #         if ($Context.UniqueDeviceIds.Add($userId)) {
# # # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
# # # #         }
# # # #         $stopwatch.Stop()
# # # #         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # #         return
# # # #     }

# # # #     if ($Context.UniqueDeviceIds.Add($deviceId)) {
# # # #         # Measure the device ID check time
# # # #         $stopwatch.Stop()
# # # #         Write-Host "Device ID check time: $($stopwatch.Elapsed.TotalMilliseconds) ms"
# # # #         $stopwatch.Restart()

# # # #         # Call the method to check device state
# # # #         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.UserDisplayName -Headers $Headers

# # # #         # Measure the device state check time
# # # #         $stopwatch.Stop()
# # # #         Write-Host "Check-DeviceStateInIntune execution time: $($stopwatch.ElapsedMilliseconds) ms"
# # # #         $stopwatch.Restart()

# # # #         try {
# # # #             # Fetch user licenses
# # # #             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.UserDisplayName -Headers $Headers

# # # #             # Measure the user licenses fetch time
# # # #             $stopwatch.Stop()
# # # #             Write-Host "Fetch-UserLicense execution time: $($stopwatch.ElapsedMilliseconds) ms"
# # # #             $stopwatch.Restart()

# # # #             $hasPremiumLicense = $false
# # # #             # Use .NET method to check for the presence of a license
# # # #             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
# # # #                 $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
# # # #             }

# # # #             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # #         } catch {
# # # #             Handle-Error -ErrorRecord $_
# # # #         }
# # # #     }

# # # #     # Measure the total function time
# # # #     $stopwatch.Stop()
# # # #     Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # # }














# # # # # Example usage of Process-DeviceItem
# # # # # $context = [PSCustomObject]@{ UniqueDeviceIds = [System.Collections.Generic.HashSet[string]]::new() }
# # # # # $headers = @{}

# # # # # foreach ($log in $signInLogs) {
# # # # #     Process-DeviceItem -Item $log -Context $context -Headers $headers
# # # # # }





# # # # # function Process-DeviceItem {
# # # # #     param (
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Item,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Context,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [hashtable]$Headers
# # # # #     )

# # # # #     $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# # # # #     $deviceId = $Item.deviceDetail.deviceId
# # # # #     $userId = $Item.userId

# # # # #     # Initialize the HashSet for tracking unique IDs if not already done
# # # # #     if (-not $Context.UniqueDeviceIds) {
# # # # #         $Context.UniqueDeviceIds = [System.Collections.Generic.HashSet[string]]::new()
# # # # #     }

# # # # #     # Handle the most common case first: valid deviceId
# # # # #     if (-not [string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if ($Context.UniqueDeviceIds.Add($deviceId)) {
# # # # #             $stopwatch.Restart()
# # # # #             $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers
# # # # #             $stopwatch.Stop()
# # # # #             Write-Host "Check-DeviceStateInIntune execution time: $($stopwatch.ElapsedMilliseconds) ms"

# # # # #             try {
# # # # #                 $stopwatch.Restart()
# # # # #                 $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
# # # # #                 $stopwatch.Stop()
# # # # #                 Write-Host "Fetch-UserLicense execution time: $($stopwatch.ElapsedMilliseconds) ms"

# # # # #                 $hasPremiumLicense = $null -ne $userLicenses -and $userLicenses.Count -gt 0 -and $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")

# # # # #                 Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #             } catch {
# # # # #                 Handle-Error -ErrorRecord $_
# # # # #             }
# # # # #         }
# # # # #         Write-Host "Total execution time for valid deviceId: $($stopwatch.ElapsedMilliseconds) ms"
# # # # #         return
# # # # #     }

# # # # #     # Handle external Azure AD tenant and BYOD cases
# # # # #     if ($deviceId -ieq "{PII Removed}" -or [string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if ($Context.UniqueDeviceIds.Add($userId)) {
# # # # #             $deviceState = $deviceId -ieq "{PII Removed}" ? "External" : "BYOD"
# # # # #             $hasPremiumLicense = $false
# # # # #             $deviceIdDisplay = $deviceId -ieq "{PII Removed}" ? "N/A" : "BYOD"

# # # # #             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO"

# # # # #             Add-Result -Context $Context -Item $Item -DeviceId $deviceIdDisplay -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #         }
# # # # #         Write-Host "Total execution time for special cases: $($stopwatch.ElapsedMilliseconds) ms"
# # # # #         return
# # # # #     }
# # # # # }




# # # # # using namespace System.Text.Json

# # # # # function Process-DeviceItem {
# # # # #     param (
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [string]$ItemJson,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Context,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [hashtable]$Headers
# # # # #     )

# # # # #     $item = $ItemJson | ConvertFrom-Json

# # # # #     $deviceId = $item.deviceDetail.deviceId
# # # # #     $userId = $item.userId
# # # # #     $userDisplayName = $item.userDisplayName

# # # # #     # Check for external Azure AD tenant
# # # # #     if ([string]::Equals($deviceId, "{PII Removed}", [StringComparison]::OrdinalIgnoreCase)) {
# # # # #         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
# # # # #             [Console]::WriteLine("External Azure AD tenant detected for user: $userDisplayName")
# # # # #             Add-Result -Context $Context -ItemJson $ItemJson -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
# # # # #             $Context.UniqueDeviceIds[$userId] = $true
# # # # #         }
# # # # #         return
# # # # #     }

# # # # #     # Check for BYOD device
# # # # #     if ([string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
# # # # #             Add-Result -Context $Context -ItemJson $ItemJson -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
# # # # #             $Context.UniqueDeviceIds[$userId] = $true
# # # # #         }
# # # # #         return
# # # # #     }

# # # # #     # Process device if not already processed
# # # # #     if (-not $Context.UniqueDeviceIds.ContainsKey($deviceId)) {
# # # # #         $Context.UniqueDeviceIds[$deviceId] = $true

# # # # #         # Check device state in Intune
# # # # #         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $userDisplayName -Headers $Headers

# # # # #         try {
# # # # #             # Fetch user licenses
# # # # #             $userLicenses = Fetch-UserLicense -UserId $userId -Username $userDisplayName -Headers $Headers
# # # # #             $hasPremiumLicense = [Guid]::Parse("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46") -in $userLicenses

# # # # #             Add-Result -Context $Context -ItemJson $ItemJson -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #         } catch {
# # # # #             Handle-Error -ErrorRecord $_
# # # # #         }
# # # # #     }
# # # # # }


# # # # # using namespace System.Text.Json

# # # # # function Process-DeviceItem {
# # # # #     param (
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [SignInLog]$Itemjson,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Context,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [hashtable]$Headers
# # # # #     )

# # # # #     $item = [JsonDocument]::Parse($ItemJson).RootElement

# # # # #     $deviceId = $item.GetProperty("deviceDetail").GetProperty("deviceId").GetString()
# # # # #     $userId = $item.GetProperty("userId").GetString()
# # # # #     $userDisplayName = $item.GetProperty("userDisplayName").GetString()

# # # # #     # Check for external Azure AD tenant
# # # # #     if ($deviceId -ieq "{PII Removed}") {
# # # # #         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
# # # # #             [Console]::WriteLine("External Azure AD tenant detected for user: $userDisplayName")
# # # # #             Add-Result -Context $Context -ItemJson $ItemJson -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
# # # # #             $Context.UniqueDeviceIds[$userId] = $true
# # # # #         }
# # # # #         return
# # # # #     }

# # # # #     # Check for BYOD device
# # # # #     if ([string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
# # # # #             Add-Result -Context $Context -ItemJson $ItemJson -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
# # # # #             $Context.UniqueDeviceIds[$userId] = $true
# # # # #         }
# # # # #         return
# # # # #     }

# # # # #     # Process device if not already processed
# # # # #     if (-not $Context.UniqueDeviceIds.ContainsKey($deviceId)) {
# # # # #         $Context.UniqueDeviceIds[$deviceId] = $true

# # # # #         # Check device state in Intune
# # # # #         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $userDisplayName -Headers $Headers

# # # # #         try {
# # # # #             # Fetch user licenses
# # # # #             $userLicenses = Fetch-UserLicense -UserId $userId -Username $userDisplayName -Headers $Headers
# # # # #             $hasPremiumLicense = [Guid]::Parse("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46") -in $userLicenses

# # # # #             Add-Result -Context $Context -ItemJson $ItemJson -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #         } catch {
# # # # #             Handle-Error -ErrorRecord $_
# # # # #         }
# # # # #     }
# # # # # }






# # # # # function Process-DeviceItem {
# # # # #     param (
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Item,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Context,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [hashtable]$Headers
# # # # #     )

# # # # #     $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# # # # #     $deviceId = [string]$Item.deviceDetail.deviceId
# # # # #     $userId = [string]$Item.userId

# # # # #     # Initialize the HashSet for tracking unique IDs if not already done
# # # # #     if (-not $Context.UniqueDeviceIds) {
# # # # #         $Context.UniqueDeviceIds = [System.Collections.Generic.HashSet[string]]::new()
# # # # #     }

# # # # #     # Handle the most common case first: valid deviceId
# # # # #     if (-not [string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if ($Context.UniqueDeviceIds.Add($deviceId)) {
# # # # #             $stopwatch.Restart()
# # # # #             $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers
# # # # #             $stopwatch.Stop()
# # # # #             Write-Host "Check-DeviceStateInIntune execution time: $($stopwatch.ElapsedMilliseconds) ms"

# # # # #             try {
# # # # #                 $stopwatch.Restart()
# # # # #                 $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
# # # # #                 $stopwatch.Stop()
# # # # #                 Write-Host "Fetch-UserLicense execution time: $($stopwatch.ElapsedMilliseconds) ms"

# # # # #                 $hasPremiumLicense = $null -ne $userLicenses -and $userLicenses.Count -gt 0 -and $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")

# # # # #                 Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #             } catch {
# # # # #                 Handle-Error -ErrorRecord $_
# # # # #             }
# # # # #         }
# # # # #         Write-Host "Total execution time for valid deviceId: $($stopwatch.ElapsedMilliseconds) ms"
# # # # #         return
# # # # #     }

# # # # #     # Handle external Azure AD tenant and BYOD cases
# # # # #     if ($deviceId -ieq "{PII Removed}" -or [string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if ($Context.UniqueDeviceIds.Add($userId)) {
# # # # #             $deviceState = $deviceId -ieq "{PII Removed}" ? "External" : "BYOD"
# # # # #             $hasPremiumLicense = $false
# # # # #             $deviceIdDisplay = $deviceId -ieq "{PII Removed}" ? "N/A" : "BYOD"

# # # # #             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO"

# # # # #             Add-Result -Context $Context -Item $Item -DeviceId $deviceIdDisplay -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #         }
# # # # #         Write-Host "Total execution time for special cases: $($stopwatch.ElapsedMilliseconds) ms"
# # # # #         return
# # # # #     }
# # # # # }








# # # # # function Process-DeviceItem {
# # # # #     param (
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Item,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [PSCustomObject]$Context,
# # # # #         [Parameter(Mandatory = $true)]
# # # # #         [hashtable]$Headers
# # # # #     )

# # # # #     $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# # # # #     $deviceId = [string]$Item.deviceDetail.deviceId
# # # # #     $userId = [string]$Item.userId

# # # # #     $DBG

# # # # #     # Initialize the HashSet for tracking unique IDs if not already done
# # # # #     if (-not $Context.UniqueDeviceIds) {
# # # # #         $Context.UniqueDeviceIds = [System.Collections.Generic.HashSet[string]]::new()
# # # # #     }


# # # # #     $DBG

# # # # #     # Handle the most common case first: valid deviceId
# # # # #     if (-not [string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if ($Context.UniqueDeviceIds.Add($deviceId)) {
# # # # #             $stopwatch.Restart()
# # # # #             $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers
# # # # #             $stopwatch.Stop()
# # # # #             Write-Host "Check-DeviceStateInIntune execution time: $($stopwatch.ElapsedMilliseconds) ms"

# # # # #             $DBG

# # # # #             try {
# # # # #                 $stopwatch.Restart()
# # # # #                 $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
# # # # #                 $stopwatch.Stop()
# # # # #                 Write-Host "Fetch-UserLicense execution time: $($stopwatch.ElapsedMilliseconds) ms"

# # # # #                 $hasPremiumLicense = $null -ne $userLicenses -and $userLicenses.Count -gt 0 -and $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")

# # # # #                 Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #             } catch {
# # # # #                 Handle-Error -ErrorRecord $_
# # # # #             }
# # # # #         }
# # # # #         Write-Host "Total execution time for valid deviceId: $($stopwatch.ElapsedMilliseconds) ms"
# # # # #         return
# # # # #     }

# # # # #     # Handle external Azure AD tenant and BYOD cases
# # # # #     if ($deviceId -ieq "{PII Removed}" -or [string]::IsNullOrWhiteSpace($deviceId)) {
# # # # #         if ($Context.UniqueDeviceIds.Add($userId)) {
# # # # #             $deviceState = $deviceId -ieq "{PII Removed}" ? "External" : "BYOD"
# # # # #             $hasPremiumLicense = $false
# # # # #             $deviceIdDisplay = $deviceId -ieq "{PII Removed}" ? "N/A" : "BYOD"

# # # # #             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO"

# # # # #             Add-Result -Context $Context -Item $Item -DeviceId $deviceIdDisplay -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # # # #         }
# # # # #         Write-Host "Total execution time for special cases: $($stopwatch.ElapsedMilliseconds) ms"
# # # # #         return
# # # # #     }
# # # # # }













# # # function Process-DeviceItem {
# # #     param (
# # #         [Parameter(Mandatory = $true)]
# # #         [pscustomobject]$Item,
# # #         [Parameter(Mandatory = $true)]
# # #         [pscustomobject]$Context,
# # #         [Parameter(Mandatory = $true)]
# # #         [hashtable]$Headers
# # #     )

# # #     $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# # #     $deviceId = $Item.DeviceDetail.DeviceId
# # #     $userId = $Item.UserId

# # #     # Initialize the HashSet for tracking unique IDs if not already done
# # #     if (-not $Context.UniqueDeviceIds) {
# # #         $Context.UniqueDeviceIds = [System.Collections.Generic.HashSet[string]]::new()
# # #     }

# # #     if ($deviceId -ieq "{PII Removed}") {
# # #         if ($Context.UniqueDeviceIds.Add($userId.ToString())) {
# # #             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.UserDisplayName)" -Level "INFO"
# # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
# # #         }
# # #         $stopwatch.Stop()
# # #         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # #         return
# # #     }

# # #     if ([string]::IsNullOrWhiteSpace($deviceId)) {
# # #         if ($Context.UniqueDeviceIds.Add($userId.ToString())) {
# # #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
# # #         }
# # #         $stopwatch.Stop()
# # #         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # #         return
# # #     }

# # #     if ($Context.UniqueDeviceIds.Add($deviceId.ToString())) {
# # #         # Measure the device ID check time
# # #         $stopwatch.Stop()
# # #         Write-Host "Device ID check time: $($stopwatch.Elapsed.TotalMilliseconds) ms"
# # #         $stopwatch.Restart()

# # #         # Call the method to check device state
# # #         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.UserDisplayName -Headers $Headers

# # #         # Measure the device state check time
# # #         $stopwatch.Stop()
# # #         Write-Host "Check-DeviceStateInIntune execution time: $($stopwatch.ElapsedMilliseconds) ms"
# # #         $stopwatch.Restart()

# # #         try {
# # #             # Fetch user licenses
# # #             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.UserDisplayName -Headers $Headers

# # #             # Measure the user licenses fetch time
# # #             $stopwatch.Stop()
# # #             Write-Host "Fetch-UserLicense execution time: $($stopwatch.ElapsedMilliseconds) ms"
# # #             $stopwatch.Restart()

# # #             $hasPremiumLicense = $false
# # #             # Use .NET method to check for the presence of a license
# # #             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
# # #                 $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
# # #             }

# # #             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# # #         } catch {
# # #             Handle-Error -ErrorRecord $_
# # #         }
# # #     }

# # #     # Measure the total function time
# # #     $stopwatch.Stop()
# # #     Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # # }














# # function Process-DeviceItem {
# #     param (
# #         [Parameter(Mandatory = $true)]
# #         [pscustomobject]$Item,
# #         [Parameter(Mandatory = $true)]
# #         [pscustomobject]$Context,
# #         [Parameter(Mandatory = $true)]
# #         [hashtable]$Headers
# #     )

# #     $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# #     $deviceId = $Item.DeviceDetail.DeviceId
# #     $userId = $Item.UserId

# #     # Initialize the HashSet for tracking unique IDs if not already done
# #     if (-not $Context.ContainsKey('UniqueDeviceIds')) {
# #         $Context.UniqueDeviceIds = [System.Collections.Generic.HashSet[string]]::new()
# #     }

# #     if ($deviceId -ieq "{PII Removed}") {
# #         if ($Context.UniqueDeviceIds.Add([string]$userId)) {
# #             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.UserDisplayName)" -Level "INFO"
# #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
# #         }
# #         $stopwatch.Stop()
# #         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# #         return
# #     }

# #     if ([string]::IsNullOrWhiteSpace($deviceId)) {
# #         if ($Context.UniqueDeviceIds.Add([string]$userId)) {
# #             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
# #         }
# #         $stopwatch.Stop()
# #         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# #         return
# #     }

# #     if ($Context.UniqueDeviceIds.Add([string]$deviceId)) {
# #         # Measure the device ID check time
# #         $stopwatch.Stop()
# #         Write-Host "Device ID check time: $($stopwatch.Elapsed.TotalMilliseconds) ms"
# #         $stopwatch.Restart()

# #         # Call the method to check device state
# #         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.UserDisplayName -Headers $Headers

# #         # Measure the device state check time
# #         $stopwatch.Stop()
# #         Write-Host "Check-DeviceStateInIntune execution time: $($stopwatch.ElapsedMilliseconds) ms"
# #         $stopwatch.Restart()

# #         try {
# #             # Fetch user licenses
# #             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.UserDisplayName -Headers $Headers

# #             # Measure the user licenses fetch time
# #             $stopwatch.Stop()
# #             Write-Host "Fetch-UserLicense execution time: $($stopwatch.ElapsedMilliseconds) ms"
# #             $stopwatch.Restart()

# #             $hasPremiumLicense = $false
# #             # Use .NET method to check for the presence of a license
# #             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
# #                 $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
# #             }

# #             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
# #         } catch {
# #             Handle-Error -ErrorRecord $_
# #         }
# #     }

# #     # Measure the total function time
# #     $stopwatch.Stop()
# #     Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# # }









# function Process-DeviceItem {
#     param (
#         [Parameter(Mandatory = $true)]
#         [pscustomobject]$Item,
#         [Parameter(Mandatory = $true)]
#         [pscustomobject]$Context,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

#     $deviceId = $Item.DeviceDetail.DeviceId
#     $userId = $Item.UserId

#     # Initialize the ArrayList for tracking unique IDs if not already done
#     if (-not $Context.ContainsKey('UniqueDeviceIds')) {
#         $Context.UniqueDeviceIds = New-Object System.Collections.ArrayList
#     }

#     if ($deviceId -ieq "{PII Removed}") {
#         if (-not $Context.UniqueDeviceIds.Contains($userId.ToString())) {
#             $Context.UniqueDeviceIds.Add($userId.ToString()) | Out-Null
#             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.UserDisplayName)" -Level "INFO"
#             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
#         }
#         $stopwatch.Stop()
#         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
#         return
#     }

#     if ([string]::IsNullOrWhiteSpace($deviceId)) {
#         if (-not $Context.UniqueDeviceIds.Contains($userId.ToString())) {
#             $Context.UniqueDeviceIds.Add($userId.ToString()) | Out-Null
#             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
#         }
#         $stopwatch.Stop()
#         Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
#         return
#     }

#     if (-not $Context.UniqueDeviceIds.Contains($deviceId.ToString())) {
#         $Context.UniqueDeviceIds.Add($deviceId.ToString()) | Out-Null

#         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.UserDisplayName -Headers $Headers

#         try {
#             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.UserDisplayName -Headers $Headers
#             $hasPremiumLicense = $false

#             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
#                 $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
#             }

#             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
#         } catch {
#             Handle-Error -ErrorRecord $_
#         }
#     }

#     $stopwatch.Stop()
#     Write-EnhancedLog -Message "Process-DeviceItem function took $($stopwatch.Elapsed.TotalMilliseconds) ms" -Level "DEBUG"
# }










# function Process-DeviceItem {
#     param (
#         [Parameter(Mandatory = $true)]
#         [PSCustomObject]$Item,
#         [Parameter(Mandatory = $true)]
#         [PSCustomObject]$Context,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     $deviceId = $Item.deviceDetail.deviceId
#     $userId = $Item.userId

#     # Use .NET methods for string comparison
#     if ([string]::Equals($deviceId, "{PII Removed}", [System.StringComparison]::OrdinalIgnoreCase)) {
#         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
#             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO"
#             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
#             $Context.UniqueDeviceIds[$userId] = $true
#         }
#         return
#     }

#     if ([string]::IsNullOrWhiteSpace($deviceId)) {
#         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
#             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
#             $Context.UniqueDeviceIds[$userId] = $true
#         }
#         return
#     }

#     if (-not $Context.UniqueDeviceIds.ContainsKey($deviceId)) {
#         $Context.UniqueDeviceIds[$deviceId] = $true

#         # Call the method to check device state
#         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers

#         try {
#             # Fetch user licenses
#             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
#             $hasPremiumLicense = $false

#             # Use .NET method to check for the presence of a license
#             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
#                 $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
#             }

#             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
#         } catch {
#             Handle-Error -ErrorRecord $_
#         }
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


# function Process-DeviceItem {
#     param (
#         [Parameter(Mandatory = $true)]
#         [SignInLog]$Item,
#         [Parameter(Mandatory = $true)]
#         [ProcessingContext]$Context,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     $deviceId = $Item.deviceDetail.deviceId
#     $userId = $Item.userId

#     # Use .NET methods for string comparison
#     if ([string]::Equals($deviceId, "{PII Removed}", [System.StringComparison]::OrdinalIgnoreCase)) {
#         if ($Context.UniqueDeviceIds.Add($userId)) {
#             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO"
#             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
#         }
#         return
#     }

#     if ([string]::IsNullOrWhiteSpace($deviceId)) {
#         if ($Context.UniqueDeviceIds.Add($userId)) {
#             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
#         }
#         return
#     }

#     if ($Context.UniqueDeviceIds.Add($deviceId)) {
#         # Call the method to check device state
#         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers

#         try {
#             # Fetch user licenses
#             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
#             $hasPremiumLicense = $false

#             # Use .NET method to check for the presence of a license
#             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
#                 $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
#             }

#             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
#         } catch {
#             Handle-Error -ErrorRecord $_
#         }
#     }
# }





# function Process-DeviceItem {
#     param (
#         [Parameter(Mandatory = $true)]
#         [SignInLog]$Item,
#         [Parameter(Mandatory = $true)]
#         [ProcessingContext]$Context,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     $deviceId = $Item.DeviceId
#     $userId = $Item.UserId

#     # Use .NET methods for string comparison
#     if ([string]::Equals($deviceId, "{PII Removed}", [System.StringComparison]::OrdinalIgnoreCase)) {
#         if ($Context.UniqueDeviceIds.Add($userId)) {
#             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.UserDisplayName)" -Level "INFO"
#             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
#         }
#         return
#     }

#     if ([string]::IsNullOrWhiteSpace($deviceId)) {
#         if ($Context.UniqueDeviceIds.Add($userId)) {
#             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
#         }
#         return
#     }

#     if ($Context.UniqueDeviceIds.Add($deviceId)) {
#         # Call the method to check device state
#         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.UserDisplayName -Headers $Headers

#         try {
#             # Fetch user licenses
#             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.UserDisplayName -Headers $Headers
#             $hasPremiumLicense = $false

#             # Use .NET method to check for the presence of a license
#             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
#                 $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
#             }

#             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
#         } catch {
#             Handle-Error -ErrorRecord $_
#         }
#     }
# }




function Process-DeviceItem {
    param (
        [Parameter(Mandatory = $true)]
        [SignInLog]$Item,
        [Parameter(Mandatory = $true)]
        [ProcessingContext]$Context,
        [Parameter(Mandatory = $true)]
        [hashtable]$Headers
    )

    $deviceId = $Item.deviceDetail.deviceId
    $userId = $Item.userId

    # Use .NET methods for string comparison
    if ([string]::Equals($deviceId, "{PII Removed}", [System.StringComparison]::OrdinalIgnoreCase)) {
        if ($Context.UniqueDeviceIds.Add($userId)) {
            Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO"
            Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
        }
        return
    }

    if ([string]::IsNullOrWhiteSpace($deviceId)) {
        if ($Context.UniqueDeviceIds.Add($userId)) {
            Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
        }
        return
    }

    if ($Context.UniqueDeviceIds.Add($deviceId)) {
        # Call the method to check device state
        $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers

        try {
            # Fetch user licenses
            $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
            $hasPremiumLicense = $false

            # Use .NET method to check for the presence of a license
            if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
                $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
            }

            Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
        } catch {
            Handle-Error -ErrorRecord $_
        }
    }
}
