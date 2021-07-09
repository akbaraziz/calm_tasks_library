# Apply Standard UI Customizations

# Enable 24 hour time format
Set-ItemProperty -Path 'Registry::\HKEY_USERS\.DEFAULT\Control Panel\International' -Name sTimeFormat -Value 'HH:mm:ss'
Set-ItemProperty -Path 'Registry::\HKEY_USERS\.DEFAULT\Control Panel\International' -Name sShortTime -Value 'HH:mm'

Set-ItemProperty -Path 'Registry::\HKEY_CURRENT_USER\Control Panel\International' -Name sTimeFormat -Value 'HH:mm:ss'
Set-ItemProperty -Path 'Registry::\HKEY_CURRENT_USER\Control Panel\International' -Name sShortTime -Value 'HH:mm'

# Configure IE Enhanced Security
Set-ItemProperty -Path 'Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name ConsentPromptBehaviorAdmin -Value 0 -Type Dword
Set-ItemProperty -Path 'Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name ConsentPromptBehaviorUser -Value 3 -Type Dword

# Configure Desktop Icons
New-ItemProperty -Path 'Registry::\HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{59031a47-3f72-44a7-89c5-5595fe6b30ee}' -Value 0 -Type Dword
New-ItemProperty -Path 'Registry::\HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -Value 0 -Type Dword
New-ItemProperty -Path 'Registry::\HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}' -Value 0 -Type Dword
New-ItemProperty -Path 'Registry::\HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}' -Value 0 -Type Dword

New-ItemProperty -Path 'Registry::\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{59031a47-3f72-44a7-89c5-5595fe6b30ee}' -Value 0 -Type Dword
New-ItemProperty -Path 'Registry::\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -Value 0 -Type Dword
New-ItemProperty -Path 'Registry::\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}' -Value 0 -Type Dword
New-ItemProperty -Path 'Registry::\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}' -Value 0 -Type Dword

# Enable AutoTray
New-ItemProperty -Path 'Registry::\HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name EnableAutoTray -Value 0 -Type Dword

New-ItemProperty -Path 'Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name EnableAutoTray -Value 0 -Type Dword

New-ItemProperty -Path 'Registry::\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name EnableAutoTray -Value 0 -Type Dword

# Disable Hibernate
Set-ItemProperty -Path 'Registry::\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power' -Name HibernateEnabled -Value 0 -Type Dword

# Disable UAC
Set-ItemProperty -Path 'Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name EnableLUA -Value 0 -Type Dword

# Configure a small taskbar
New-ItemProperty -Path 'Registry::\HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name TaskbarSmallIcons -Value 1 -Type Dword

New-ItemProperty -Path 'Registry::\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name TaskbarSmallIcons -Value 1 -Type Dword

# Configure VFX Profile
New-ItemProperty -Path 'Registry::\HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name VisualFXSetting -Value 2 -Type Dword

New-ItemProperty -Path 'Registry::\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name VisualFXSetting -Value 2 -Type Dword

# Disable Automatic Windows Update
New-ItemProperty -Path 'Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name EnableFeaturedSoftware -Value 1 -Type Dword
New-ItemProperty -Path 'Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name IncludeRecommendedUpdates -Value 1 -Type Dword

# Enable Diskperf in Task Manager
& diskperf -Y

# Modify CD-ROM Drive Letter to X:
$drives_content = 'select disk 0
select volume d
assign letter x noerr' 

set-content -Value $drives_content -path C:\windows\Temp\drives.txt

cmd /c diskpart /s C:\windows\temp\drives.txt