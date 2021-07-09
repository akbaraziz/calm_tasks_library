try { Set-ExecutionPolicy Unrestricted -Force -Confirm:$false -ErrorAction Stop }
catch { throw "Error setting Powershell execution policy to unrestricted : $($_.Exception.Message)" }
write-host "Successfully set Powershell execution policy to unrestricted." -ForegroundColor Green

iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))