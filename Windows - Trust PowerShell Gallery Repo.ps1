#trust the Windows PowerShell Gallery repository
try { $result = Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted -ErrorAction Stop }
catch { throw "Error trusting the PowerShell Gallery repository : $($_.Exception.Message)" }
write-host "Now trusting PowerShell Gallery repository" -ForegroundColor Green
$Error.Clear() #required as PoSH populates $error even though the cmdlet completed successfully