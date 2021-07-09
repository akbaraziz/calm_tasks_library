# Install Windows Updates
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
$ProgressPreference = "SilentlyContinue"

Install-WindowsUpdate -AcceptAll -ForceDownload -Install -AutoReboot