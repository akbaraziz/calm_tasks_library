$swhost = '@@{SOLARWINDS_SERVER}@@'
$swuser = '@@{SolarAdmin.username}@@'
$swpassword = '@@{SolarAdmin.secret}@@'
$swis = Connect-Swis -Hostname $swhost -Username $swuser -Password $swpassword

Invoke-SwisVerb $swis IPAM.SubnetManagement ChangeIPStatus @("@@{ipaddress}@@", "Available")