# Download  and Install Module PSWindowsUpdate
Write-Output "Starting PSWindowsUpdate Installation"

# Install PSWindowsUpdate for scriptable Windows Updates
$webDeployURL = "https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc/file/66095/1/PSWindowsUpdate_1.4.5.zip"
$filePath = "$($env:TEMP)\PSWindowsUpdate.zip"

(New-Object System.Net.WebClient).DownloadFile($webDeployURL, $filePath)

Expand-Archive -LiteralPath $filePath -Destination "C:\Windows\system32\WindowsPowerShell\v1.0\Modules" -Force