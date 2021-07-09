$SA_PASS = "@@{SA_PASSWORD}@@"

Invoke-Command {
    C:\SQL_Server_Enterprise_2019\setup.exe /Q /SAPWD=$SA_PASS /ConfigurationFile=C:\SQL_Server_Enterprise_2019\custom\Post_Image_ConfigurationFile.ini /SQLSVCPASSWORD=$SA_PASS /IACCEPTSQLSERVERLICENSETERMS
}