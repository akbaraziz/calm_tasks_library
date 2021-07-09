# Configure WinRM Settings
Stop-Service -Name WinRM
& winrm quickconfig -q

& winrm set winrm/config/client/auth '@{Basic="true"}'
& winrm set winrm/config/service/auth '@{Basic="true"}'
& winrm set winrm/config/service '@{AllowUnencrypted="true"}'
& winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="2048"}'
Restart-Service -Name WinRM