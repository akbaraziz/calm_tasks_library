#change UI settings to max performance (for the administrator user)
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name VisualFXSetting -Value 2

#disable background image
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\System" -Name DisableLogonBackgroundImage -Value 1

#disable paging executive
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Memory Management" -Name DisablePagingExecutive -Value 1

#change power plan to maximum performance
$powerPlan = Get-WmiObject -Namespace root\cimv2\power -Class Win32_PowerPlan -Filter "ElementName = 'High Performance'"
$powerPlan.Activate()

#disable scheduled tasks
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Autochk\Proxy"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Bluetooth\UninstallDeviceTask"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Defrag\ScheduledDefrag"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Diagnosis\Scheduled"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Location\Notifications"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Maintenance\WinSAT"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Maps\MapsToastTask"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Maps\MapsUpdateTask"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Ras\MobilityManager"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\RecoveryEnvironment\VerifyWinRE"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Registry\RegIdleBackup"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\UPnP\UPnPHostConfig"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\WDI\ResolutionHost"
disable-scheduledtask -taskname "\Microsoft\Windows\Customer Experience Improvement Program\consolidator"
disable-scheduledtask -taskname "\Microsoft\Windows\Customer Experience Improvement Program\kernelceiptask"
disable-scheduledtask -taskname "\Microsoft\Windows\Customer Experience Improvement Program\usbceip"
disable-scheduledtask -taskname "\Microsoft\Windows\Customer Experience Improvement Program\kernelceiptask"
disable-scheduledtask -taskname "\Microsoft\Windows\DiskCleanup\SilentCleanup"
disable-scheduledtask -taskname "\Microsoft\Windows\Servicing\StartComponentCleanup"