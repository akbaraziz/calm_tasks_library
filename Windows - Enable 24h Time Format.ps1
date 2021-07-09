# Enable 24 hour time format
Set-ItemProperty -Path 'Registry::\HKEY_USERS\.DEFAULT\Control Panel\International' -Name sTimeFormat -Value 'HH:mm:ss'
Set-ItemProperty -Path 'Registry::\HKEY_USERS\.DEFAULT\Control Panel\International' -Name sShortTime -Value 'HH:mm'

Set-ItemProperty -Path 'Registry::\HKEY_CURRENT_USER\Control Panel\International' -Name sTimeFormat -Value 'HH:mm:ss'
Set-ItemProperty -Path 'Registry::\HKEY_CURRENT_USER\Control Panel\International' -Name sShortTime -Value 'HH:mm'