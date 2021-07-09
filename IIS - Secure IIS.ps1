# +------------------------------------------------------+
# | Script Name: Harden-TLS.ps1                          |
# | Version: 1.0                                         |
# | Author: John Suslavage                               |
# | PowerShell Version: 2.0                              |
# |------------------------------------------------------|
# | The purpose of this script is to modify the Windows  |
# | Registry to remediate IIS encryption                 |
# | vulnerabilities.                                     |
# |------------------------------------------------------|
# | Change Log                                           |
# |                                                      |
# | 1.0 - Initial Script Creation                        |
# +------------------------------------------------------+
 
# +---------------------------------+
# | Load Snapins and Functions      |
# +---------------------------------+
# Test for PowerShell Version
# If ($host.version.major -lt 2) {
#   Write-Host "You must be running PowerShell version 2.0 or later.  Exiting..." -ForegroundColor Yellow
#   Exit 1
#}
 
# +---------------------------------+
# | Variables                       |
# +---------------------------------+
[string] $global:SchannelKey = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\"
[string] $global:CipherList = "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
[string] $global:ErrorLog = ""
 
# +---------------------------------+
# | Functions                       |
# +---------------------------------+
Function Update-Registry {
    Param (
        [parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true, HelpMessage = "The registry key")]
        [string]$key,
        [parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true, HelpMessage = "The name for the registry entry")]
        [string]$name,
        [parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true, HelpMessage = "The value for the registry entry")]
        [string]$value,
        [parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $false, HelpMessage = "The type of registry entry to create such as dword or string")]
        [string]$type
    )
    If ($type -eq "1") {
        If (!(Test-Path -Path $key)) {
            $junk = New-Item -Path $key
            $junk = $null
        }
    }
    Else {
        Write-Host $key
        If (!(Test-Path -Path $key)) {
            $junk = New-Item -Path $key -Force
            $junk = $null
        }
        $tasked = ""
        If (($type -eq "2") -OR ($type -eq "4") -OR ($type -ilike "[A-Z]*")) {
            If ($type -ne "2") {
                Set-ItemProperty -Path $key -Name $name -Value "$($value)" -Type "$($type)"
            }
            Else {
                Set-ItemProperty -Path $key -Name $name -Value $value
            }
        }
        $test = Get-ItemProperty -Path $key -Name $name
        $test = $test.psobject.Properties[$name]
        If ($test.value -eq $value) {
            $test = "1"
        }
        Else {
            $global:ErrorLog += "Registry: $key for $name with a value of $value was not set`r`n"
            $test = "0"
        }
        $tasked = $null; $test = $null; $item = $null; $key = $null; $name = $null; $value = $null; $type = $null
    }
}
 
# +---------------------------------+
# | Main                            |
# +---------------------------------+
Update-Registry -Key "$($global:SchannelKey)Ciphers\DES 56/56" -Name "Enabled" -Type "4" -Value 00000000
Update-Registry -Key "$($global:SchannelKey)Ciphers\NULL" -Name "Enabled" -Type "4" -Value 00000000
Update-Registry -Key "$($global:SchannelKey)Ciphers\RC2 40/128" -Name "Enabled" -Type "4" -Value 00000000
Update-Registry -Key "$($global:SchannelKey)Ciphers\RC2 56/56" -Name "Enabled" -Type "4" -Value 00000000
Update-Registry -Key "$($global:SchannelKey)Ciphers\RC2 56/128" -Name "Enabled" -Type "4" -Value 00000000
Update-Registry -Key "$($global:SchannelKey)Ciphers\RC2 128/128" -Name "Enabled" -Type "4" -Value 00000000
Update-Registry -Key "$($global:SchannelKey)Ciphers\RC4 40/128" -Name "Enabled" -Type "4" -Value 00000000
Update-Registry -Key "$($global:SchannelKey)Ciphers\RC4 56/128" -Name "Enabled" -Type "4" -Value 00000000
Update-Registry -Key "$($global:SchannelKey)Ciphers\RC4 64/128" -Name "Enabled" -Type "4" -Value 00000000
Update-Registry -Key "$($global:SchannelKey)Ciphers\RC4 128/128" -Name "Enabled" -Type "4" -Value 00000000
Update-Registry -Key "$($global:SchannelKey)Protocols\PCT 1.0\Server" -Name "Enabled" -Type "4" -Value 00000000
Update-Registry -Key "$($global:SchannelKey)Protocols\SSL 2.0\Server" -Name "Enabled" -Type "4" -Value 00000000
Update-Registry -Key "$($global:SchannelKey)Protocols\SSL 3.0\Server" -Name "Enabled" -Type "4" -Value 00000000
Update-Registry -Key "$($global:SchannelKey)Protocols\SSL 3.0\Client" -Name "DisabledByDefault" -Type "4" -Value 00000001
Update-Registry -Key "$($global:SchannelKey)Protocols\TLS 1.1\Server" -Name "Enabled" -Type "4" -Value 00000001
Update-Registry -Key "$($global:SchannelKey)Protocols\TLS 1.1\Server" -Name "DisabledByDefault" -Type "4" -Value 00000000
Update-Registry -Key "$($global:SchannelKey)Protocols\TLS 1.1\Client" -Name "Enabled" -Type "4" -Value 00000001
Update-Registry -Key "$($global:SchannelKey)Protocols\TLS 1.1\Client" -Name "DisabledByDefault" -Type "4" -Value 00000000
Update-Registry -Key "$($global:SchannelKey)Protocols\TLS 1.2\Server" -Name "Enabled" -Type "4" -Value 00000001
Update-Registry -Key "$($global:SchannelKey)Protocols\TLS 1.2\Server" -Name "DisabledByDefault" -Type "4" -Value 00000000
Update-Registry -Key "$($global:SchannelKey)Protocols\TLS 1.2\Client" -Name "Enabled" -Type "4" -Value 00000001
Update-Registry -Key "$($global:SchannelKey)Protocols\TLS 1.2\Client" -Name "DisabledByDefault" -Type "4" -Value 00000000
Update-Registry -Key $global:CipherList -Name "Functions" -type "string" -Value "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384_P384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256_P256,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384_P384,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256_P256,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P384,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P384,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P256,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P384,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P256,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P256,TLS_DHE_DSS_WITH_AES_256_CBC_SHA256,TLS_DHE_DSS_WITH_AES_128_CBC_SHA256,TLS_DHE_DSS_WITH_AES_256_CBC_SHA,TLS_DHE_DSS_WITH_AES_128_CBC_SHA,TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256,TLS_RSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_128_CBC_SHA, TLS_RSA_WITH_3DES_EDE_CBC_SHA"
 
If ($global:ErrorLog) {
    Write-Host "Errors encountered!`r`n$($global:ErrorLog)" -ForegroundColor Red
}
 
Exit 0
 
# +---------------------------------+
# | Help                            |
# +---------------------------------+
 
<#
    .DESCRIPTION
        The purpose of this script is to remediate identified vulnerabilities with the encryption Microsoft IIS (web server) services utilize.  This disables outdated and easily broken encryption methods.
 
    .EXAMPLE
        ./remediate_iis_vulnerability.ps1
#>