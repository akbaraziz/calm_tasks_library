#install the NuGet package provider so that we can install modules from the PowerShell Gallery
try { $result = Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction Stop }
catch { throw "Error installing package NuGet : $($_.Exception.Message)" }
write-host "Package $($result.name):$($result.version) was successfully installed" -ForegroundColor Green