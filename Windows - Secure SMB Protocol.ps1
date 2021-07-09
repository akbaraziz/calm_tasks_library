# Disable SMBv1
Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol -norestart

# Enable SMBv2/3
Set-SmbServerConfiguration -EnableSMB2Protocol $true -Force

# Configure Member Server LMCompatibilityLevel
Set-ItemProperty -Path 'Registry::\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\LSA' -Name LMCompatibilityLevel -Value 3 -Type Dword

# SMB Extended Protection
Set-ItemProperty -Path 'Registry::\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' -Name SmbServerNameHardeningLevel -Value 1 -Type Dword