# Disable Hibernate
Set-ItemProperty -Path 'Registry::\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power' -Name HibernateEnabled -Value 0 -Type Dword