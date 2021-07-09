# Function for Random Password Generator
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