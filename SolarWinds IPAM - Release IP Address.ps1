$swhost = '@@{SOLARWINDS_SERVER}@@'
$swuser = '@@{SOLARWINDS_ADMIN.username}@@'
$swpassword = '@@{SOLARWINDS_ADMIN.secret}@@'
$swis = Connect-Swis -Hostname $swhost -Username $swuser -Password $swpassword

Invoke-SwisVerb $swis IPAM.SubnetManagement ChangeIPStatus @("@@{ipaddress}@@", "Available")