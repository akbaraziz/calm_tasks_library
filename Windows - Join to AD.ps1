#converting password to something we can use
$adminpassword = ConvertTo-SecureString -asPlainText -Force -String "@@{ad_password}@@"
#creating the credentials object based on the Calm variables
$credential = New-Object System.Management.Automation.PSCredential("@@{ad_username}@@", $adminpassword)

#joing the domain
try { $result = add-computer -domainname @@{ad_domain }@@ -Credential ($credential) -Force -Options JoinWithNewName, AccountCreate -PassThru -ErrorAction Stop -Verbose }
catch { throw "Could not join Active Directory domain : $($_.Exception.Message)" }
write-host "Successfully joined Active Directory domain @@{ad_domain}@@" -ForegroundColor Green
