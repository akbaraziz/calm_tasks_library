echo "Creating Windows Failover Cluster @@{WSFC_NAME}@@"

$clusterComputerObj = "@@{WSFC_NAME}@@" + "$"
$node1ComputerObj = "@@{AD.NODE1_NAME}@@" + "$"
$node2ComputerObj = "@@{AD.NODE2_NAME}@@" + "$"
$filesharewitness = "@@{FILESHARE}@@@@{WSFC_NAME}@@"
#echo $clusterComputerObj,$node1ComputerObj,$node2ComputerObj,$filesharewitness
#echo "CN=@@{WSFC_NAME}@@,@@{OU}@@"
$createCluster = @'
Import-Module failoverclusters
$clusterComputerObj = "@@{WSFC_NAME}@@"  + "$"
$filesharewitness = "@@{FILESHARE}@@@@{WSFC_NAME}@@"
New-Cluster -Name "CN=@@{WSFC_NAME}@@,@@{OU}@@" -Node "@@{AD.NODE1_NAME}@@","@@{AD.NODE2_NAME}@@" -StaticAddress "@@{PreDeployment.WSFC_IP}@@" -NoStorage
New-Item -Path $filesharewitness -ItemType Container
$acl = Get-Acl $filesharewitness
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($clusterComputerObj,"FullControl","ContainerInherit, ObjectInherit", "None", "Allow")
$acl.SetAccessRule($AccessRule)
$acl | Set-Acl $filesharewitness
Set-ClusterQuorum –NodeAndFileShareMajority $filesharewitness
'@
echo $createCluster | Out-File -FilePath 'C:\Windows\Temp\createCluster.ps1'

$taskAction = New-ScheduledTaskAction -Execute 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -Argument 'C:\Windows\Temp\createCluster.ps1'
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(5)
Register-ScheduledTask -Action $taskAction -Trigger $trigger -TaskName cluster -Description "Create Cluster" -User "@@{DomainAdmin.username}@@" -Password "@@{DomainAdmin.secret}@@"

Start-Sleep -s 60

echo "Done!"