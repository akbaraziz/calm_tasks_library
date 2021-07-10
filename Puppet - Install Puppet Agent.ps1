# Stop IES for Administrator Only
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0

$puppet_agent = puppet-agent-6.12.0-x86.msi
$puppet_url = @@{PUPPET_DOWNLOAD_URL}@@
$puppet_master = @@{PUPPET_MASTER_SERVER}@@

# Download Puppet Agent for Windows
Invoke-WebRequest -Uri $puppet_url -outfile "c:\windows\temp\$puppet_agent"

# Install Puppet Agent on Windows Core
Start-Process -Filepath "c:\windows\temp\$puppet_agent" -ArgumentList "/quiet /norestart PUPPET_MASTER_SERVER=$puppet_master" -Wait

# Remove Installer When Finished
Remove-Item -recurse "C:\windows\temp\$puppet_agent"