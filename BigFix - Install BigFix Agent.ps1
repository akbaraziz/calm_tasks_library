# Download the BigFix Agent Files
if ((Test-Path -Path "c:\installs\BigFix") -eq $false) {
    New-Item c:\installs\BigFix -ItemType Directory -Force
}

Invoke-WebRequest http://archive.site.com/software/bigfix/BigFixAgent.msi -OutFile c:\installs\BigFix\BigFixAgent.msi
Invoke-WebRequest http://archive.site.com/software/bigfix/actionsite.afxm -OutFile c:\installs\BigFix\actionsite.afxm
Invoke-WebRequest http://archive.site.com/software/bigfix/masthead.afxm -OutFile c:\installs\BigFix\masthead.afxm
Invoke-WebRequest http://archive.site.com/software/bigfix/setup.exe -OutFile c:\installs\BigFix\setup.exe

# Create the Configuration File
$Customer_ID = "Customer_ID=@@{TCA}@@"
$Customer_ID | Set-Content c:\installs\BigFix\clientsettings.cfg
$CI_Status = "CI_Status=INTRANSITION"
$CI_Status | Add-Content c:\installs\BigFix\clientsettings.cfg
$RelayServer = "__RelayServer1=http://bfr1.site.com:52311/bfmirror/downloads"
$RelayServer | Add-Content c:\installs\BigFix\clientsettings.cfg
$PatchReady = "PatchReady=False"
$PatchReady | Add-Content c:\installs\BigFix\clientsettings.cfg
$SecureRegistration = "_BESClient_SecureRegistration=Password"
$SecureRegistration | Add-Content c:\installs\BigFix\clientsettings.cfg
$Datacenter = "DataCenter_Location=INET"
$Datacenter | Add-Content c:\installs\BigFix\clientsettings.cfg
$clientsettings = Get-Content -Path c:\installs\BigFix\clientsettings.cfg
$clientsettings

# Install Agent
$installArg = "/i c:\installs\BigFix\BigFixAgent.msi /qn"
Start-Process msiexec.exe -ArgumentList $installArg -Wait