$computer = gc env:computername

$key = "@@{ACTIVATION_KEY}@@"

$service = get-wmiObject -query "select * from SoftwareLicensingService" -computername $computer

$service.InstallProductKey($key)

$service.RefreshLicenseStatus()