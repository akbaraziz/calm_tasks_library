Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Connect-VIServer -Server @@{vCenter }@@ -user administrator@vsphere.local -password @@{vCenter Credential.secret }@@ 
Set-VM -VM @@{VMname }@@ -ToTemplate -Server @@{vCenter }@@ -Confirm:$false

Get-Template