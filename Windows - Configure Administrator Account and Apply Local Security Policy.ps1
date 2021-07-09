Function for Random Password Generator
$alphabet = $NULL; For ($a = 65; $a -le 90; $a++) { $alphabet += , [char][byte]$a }
$ascii = $NULL; For ($a = 33; $a -le 126; $a++) { $ascii += , [char][byte]$a }

Function GET-RandomPassword() {
    Param([int]$length = 24, [string[]]$sourcedata)
    For ($loop = 1; $loop -le $length; $loop++) {
        $GeneratedPassword += ($sourcedata | GET-RANDOM)
    }
    return $GeneratedPassword
}

# Rename Administrator to OneAdmin
$user = Get-WMIObject Win32_UserAccount -Filter "Name='Administrator'"
$result = $user.Rename('OneAdmin')

# Create User Variant Administrator
$randomPassword = GET-RandomPassword -length 24 -sourcedata $ascii
$localhost = [ADSI]"WinNT://localhost"
$newuser = $localhost.Create("User", "Administrator")
$newuser.setpassword($randomPassword)
$newuser.Setinfo()

# Import Local Security Database
$script1 = { secedit /import /db c:\windows\security\local.sdb /cfg c:\@OneNeck\LocalSecurityPolicy\OneNeck_DefaultServer_LocalSecurityPolicy_2016.inf /areas SECURITYPOLICY /quiet }
Invoke-Command -ScriptBlock $script1
# Update Local Security Database
$script2 = { secedit /configure /db c:\windows\security\local.sdb /cfg c:\@OneNeck\LocalSecurityPolicy\OneNeck_DefaultServer_LocalSecurityPolicy_2016.inf /overwrite /areas SECURITYPOLICY /quiet }
Invoke-Command -ScriptBlock $script2

Restart-Computer -Force