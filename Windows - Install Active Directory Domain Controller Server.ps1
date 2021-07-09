# set the execution policy on the server (atleast temporarily)
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

# install the needed roles\features
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# they should import automatically, but just in case
Import-Module ADDSDeployment

# build the credential
$safeModePW = ConvertTo-SecureString -AsPlainText "@@{DSRM_PASSWORD}@@" -Force
$domainname = "@@{NETBIOS_DOMAIN_NAME}@@"
$domainAdmin = "@@{DOMAIN_ADMIN}@@"
$domainPass = ConvertTo-SecureString -AsPlainText "@@{DOMAIN_ADMIN_PASSWORD}@@"  -Force

$DACredential = New-Object System.Management.Automation.PSCredential("$($domainName)\$($domainAdmin)", $domainPass)

# promote the server to a DC
# -----------     $FQDN = @@{FQDN_DOMAIN_NAME}@@ 

Install-ADDSDomainController -NoGlobalCatalog:$false -Credential $DACredential -CriticalReplicationOnly:$false -DomainName "$($domainName)" -InstallDns:$true -NoRebootOnCompletion:$false -Force:$true -SafeModeAdministratorPassword $safeModePW