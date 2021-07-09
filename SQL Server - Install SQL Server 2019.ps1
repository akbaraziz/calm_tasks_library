# below variables are customizable
$folderpath = "C:\SQL_Server_Enterprise_2019"
$inifile = "$folderpath\ConfigurationFile.ini"
# next line sets user as a SQL sysadmin
$yourusername = "local\administrator"
# path to the SQL media
$SQLsource = "C:\SQL_Server_Enterprise_2019\"
$SQLInstallDrive = "E:"
# SQL memory
$SqlMemMin = 4096
$SqlMemMax = 4096
# configurationfile.ini settings https://msdn.microsoft.com/en-us/library/ms144259.aspx
$ACTION = "Install"
$ASCOLLATION = "Latin1_General_CI_AS"
$ErrorReporting = "False"
$SUPPRESSPRIVACYSTATEMENTNOTICE = "False"
$IACCEPTROPENLICENSETERMS = "False"
$ENU = "True"
$QUIET = "True"
$QUIETSIMPLE = "False"
$UpdateEnabled = "True"
$USEMICROSOFTUPDATE = "False"
$FEATURES = "SQLENGINE"
$UpdateSource = "MU"
$HELP = "False"
$INDICATEPROGRESS = "False"
$X86 = "False"
$INSTANCENAME = "MSSQLSERVER"
$INSTALLSHAREDDIR = "$SQLInstallDrive\Program Files\Microsoft SQL Server"
$INSTALLSHAREDWOWDIR = "$SQLInstallDrive\Program Files (x86)\Microsoft SQL Server"
$INSTANCEID = "MSSQLSERVER"
$RSINSTALLMODE = "DefaultNativeMode"
$SQLTELSVCACCT = "NT Service\SQLTELEMETRY"
$SQLTELSVCSTARTUPTYPE = "Automatic"
$ISTELSVCSTARTUPTYPE = "Automatic"
$ISTELSVCACCT = "NT Service\SSISTELEMETRY130"
$INSTANCEDIR = "$SQLInstallDrive\Program Files\Microsoft SQL Server"
$AGTSVCACCOUNT = "NT AUTHORITY\SYSTEM"
$AGTSVCSTARTUPTYPE = "Automatic"
$ISSVCSTARTUPTYPE = "Disabled"
$ISSVCACCOUNT = "NT AUTHORITY\System"
$COMMFABRICPORT = "0"
$COMMFABRICNETWORKLEVEL = "0"
$COMMFABRICENCRYPTION = "0"
$MATRIXCMBRICKCOMMPORT = "0"
$SQLSVCSTARTUPTYPE = "Automatic"
$FILESTREAMLEVEL = "0"
$ENABLERANU = "False"
$SQLCOLLATION = "SQL_Latin1_General_CP1_CI_AS"
$SQLSVCACCOUNT = "NT AUTHORITY\System"
$SQLSVCINSTANTFILEINIT = "False"
$SQLSYSADMINACCOUNTS = "$yourusername"
$SQLTEMPDBFILECOUNT = "1"
$SQLTEMPDBFILESIZE = "8"
$SQLTEMPDBFILEGROWTH = "64"
$SQLTEMPDBLOGFILESIZE = "8"
$SQLTEMPDBLOGFILEGROWTH = "64"
$ADDCURRENTUSERASSQLADMIN = "True"
$TCPENABLED = "1"
$NPENABLED = "0"
$BROWSERSVCSTARTUPTYPE = "Disabled"
$RSSVCACCOUNT = "NT AUTHORITY\System"
$RSSVCSTARTUPTYPE = "Automatic"
$IAcceptSQLServerLicenseTerms = "True"

# do not edit below this line

$conffile = @"
[OPTIONS]
Action="$ACTION"
ErrorReporting="$ERRORREPORTING"
Quiet="$Quiet"
Features="$FEATURES"
InstanceName="$INSTANCENAME"
InstanceDir="$INSTANCEDIR"
SQLSVCAccount="$SQLSVCACCOUNT"
SQLSysAdminAccounts="$SQLSYSADMINACCOUNTS"
SQLSVCStartupType="$SQLSVCSTARTUPTYPE"
AGTSVCACCOUNT="$AGTSVCACCOUNT"
AGTSVCSTARTUPTYPE="$AGTSVCSTARTUPTYPE"
RSSVCACCOUNT="$RSSVCACCOUNT"
RSSVCSTARTUPTYPE="$RSSVCSTARTUPTYPE"
ISSVCACCOUNT="$ISSVCACCOUNT" 
ISSVCSTARTUPTYPE="$ISSVCSTARTUPTYPE"
ASCOLLATION="$ASCOLLATION"
SQLCOLLATION="$SQLCOLLATION"
TCPENABLED="$TCPENABLED"
NPENABLED="$NPENABLED"
IAcceptSQLServerLicenseTerms="$IAcceptSQLServerLicenseTerms"
"@


# Check for Script Directory & file
if (Test-Path "$folderpath") {
    write-host "The folder '$folderpath' already exists, will not recreate it."
}
else {
    mkdir "$folderpath"
}
if (Test-Path "$folderpath\ConfigurationFile.ini") {
    write-host "The file '$folderpath\ConfigurationFile.ini' already exists, removing..."
    Remove-Item -Path "$folderpath\ConfigurationFile.ini" -Force
}
else {

}
# Create file:
write-host "Creating '$folderpath\ConfigurationFile.ini'..."
New-Item -Path "$folderpath\ConfigurationFile.ini" -ItemType File -Value $Conffile

# Configure Firewall settings for SQL

write-host "Configuring SQL Server 2017 Firewall settings..."

#Enable SQL Server Ports

New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound –Protocol TCP –LocalPort 1433 -Action allow
New-NetFirewallRule -DisplayName "SQL Admin Connection" -Direction Inbound –Protocol TCP –LocalPort 1434 -Action allow
New-NetFirewallRule -DisplayName "SQL Database Management" -Direction Inbound –Protocol UDP –LocalPort 1434 -Action allow
New-NetFirewallRule -DisplayName "SQL Service Broker" -Direction Inbound –Protocol TCP –LocalPort 4022 -Action allow
New-NetFirewallRule -DisplayName "SQL Debugger/RPC" -Direction Inbound –Protocol TCP –LocalPort 135 -Action allow

#Enable SQL Analysis Ports

New-NetFirewallRule -DisplayName "SQL Analysis Services" -Direction Inbound –Protocol TCP –LocalPort 2383 -Action allow
New-NetFirewallRule -DisplayName "SQL Browser" -Direction Inbound –Protocol TCP –LocalPort 2382 -Action allow

#Enabling related Applications

New-NetFirewallRule -DisplayName "HTTP" -Direction Inbound –Protocol TCP –LocalPort 80 -Action allow
New-NetFirewallRule -DisplayName "SQL Server Browse Button Service" -Direction Inbound –Protocol UDP –LocalPort 1433 -Action allow
New-NetFirewallRule -DisplayName "SSL" -Direction Inbound –Protocol TCP –LocalPort 443 -Action allow

#Enable Windows Firewall
Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Allow -NotifyOnListen True -AllowUnicastResponseToMulticast True

Write-Host "done!" -ForegroundColor Green

# start the SQL installer
Try {
    if (Test-Path $SQLsource) {
        write-host "about to install SQL Server 2017..." -nonewline
        $fileExe = "$SQLsource\setup.exe"
        $CONFIGURATIONFILE = "$folderpath\ConfigurationFile.ini"
        & $fileExe  /CONFIGURATIONFILE=$CONFIGURATIONFILE
        Write-Host "done!" -ForegroundColor Green
    }
    else {
        write-host "Could not find the media for SQL Server 2017..."
        break
    }
}
catch {
    write-host "Something went wrong with the installation of SQL Server 2019, aborting."
    break
}


# Configure SQL memory (thanks Skatterbrainz)
write-host "Configuring SQL memory..." -nonewline

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | Out-Null
$SQLMemory = New-Object ('Microsoft.SqlServer.Management.Smo.Server') ("(local)")
$SQLMemory.Configuration.MinServerMemory.ConfigValue = $SQLMemMin
$SQLMemory.Configuration.MaxServerMemory.ConfigValue = $SQLMemMax
$SQLMemory.Configuration.Alter()
Write-Host "done!" -ForegroundColor Green
write-host ""

# exit script
write-host "Exiting script, goodbye."

