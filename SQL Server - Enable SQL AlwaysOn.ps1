Start-Sleep -s 60
echo "Enabling SqlAlwaysOn on @@{AD.NODE1_NAME}@@"
Enable-SqlAlwaysOn -ServerInstance @@{AD.NODE1_NAME }@@ -Force
exit 0