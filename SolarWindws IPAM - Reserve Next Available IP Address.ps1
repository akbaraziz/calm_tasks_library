$swhost = '@@{SolarWinds-HostIP}@@'
$swuser = '@@{SolarWindsAdmin.username}@@'
$swpassword = '@@{SolarWindowsAdmin.secret}@@'
$swis = Connect-Swis -Hostname $swhost -Username $swuser -Password $swpassword

$ip_address = Invoke-SwisVerb $swis IPAM.SubnetManagement StartIpReservation @("@@{Network}@@", "24", "0") -Verbose | select -expand '#text'

Invoke-SwisVerb -SwisConnection $swis -EntityName IPAM.SubnetManagement -Verb ChangeIpStatus @($ip_address, "Blocked") -Verbose
Invoke-SwisVerb -SwisConnection $swis -EntityName IPAM.SubnetManagement -Verb FinishIpReservation @($ip_address, "Reserved") -Verbose

write-host "ip_address=$ip_address"