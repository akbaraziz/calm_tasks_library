$User = "domain\username"
$PWord = ConvertTo-SecureString -String "passgoeshere" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
New-PSDrive -Name "K" -PSProvider "FileSystem" -Root \\UNCPathGoesHere -Credential $Credential -Persist