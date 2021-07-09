# Disable Automatic Windows Update
New-ItemProperty -Path 'Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name EnableFeaturedSoftware -Value 1 -Type Dword
New-ItemProperty -Path 'Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name IncludeRecommendedUpdates -Value 1 -Type Dword