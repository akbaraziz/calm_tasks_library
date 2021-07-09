# Download the BigFix Agent Files
if ((Test-Path -Path "c:\@oneneck\installs\BigFix") -eq $false) {
    New-Item c:\@oneneck\installs\BigFix -ItemType Directory -Force
}

Invoke-WebRequest http://archive.oneneck.com/software/bigfix/BigFixAgent.msi -OutFile c:\@oneneck\installs\BigFix\BigFixAgent.msi
Invoke-WebRequest http://archive.oneneck.com/software/bigfix/actionsite.afxm -OutFile c:\@oneneck\installs\BigFix\actionsite.afxm
Invoke-WebRequest http://archive.oneneck.com/software/bigfix/masthead.afxm -OutFile c:\@oneneck\installs\BigFix\masthead.afxm
Invoke-WebRequest http://archive.oneneck.com/software/bigfix/setup.exe -OutFile c:\@oneneck\installs\BigFix\setup.exe

# Create the Configuration File
$Customer_ID = "Customer_ID=@@{TCA}@@"
$Customer_ID | Set-Content c:\@oneneck\installs\BigFix\clientsettings.cfg
$CI_Status = "CI_Status=INTRANSITION"
$CI_Status | Add-Content c:\@oneneck\installs\BigFix\clientsettings.cfg
$RelayServer = "__RelayServer1=http://bfr1.oneneck.com:52311/bfmirror/downloads"
$RelayServer | Add-Content c:\@oneneck\installs\BigFix\clientsettings.cfg
$PatchReady = "PatchReady=False"
$PatchReady | Add-Content c:\@oneneck\installs\BigFix\clientsettings.cfg
$SecureRegistration = "_BESClient_SecureRegistration=Password"
$SecureRegistration | Add-Content c:\@oneneck\installs\BigFix\clientsettings.cfg
$Datacenter = "_OneNeck_DataCenter_Location=INET"
$Datacenter | Add-Content c:\@oneneck\installs\BigFix\clientsettings.cfg
$clientsettings = Get-Content -Path c:\@oneneck\installs\BigFix\clientsettings.cfg
$clientsettings
# Install Agent
$installArg = "/i c:\@oneneck\installs\BigFix\BigFixAgent.msi /qn"
Start-Process msiexec.exe -ArgumentList $installArg -Wait