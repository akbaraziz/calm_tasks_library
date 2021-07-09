$createAG = @'
:Connect @@{AD.NODE2_NAME}@@

IF (SELECT state FROM sys.endpoints WHERE name = N'Hadr_endpoint') <> 0
BEGIN
	ALTER ENDPOINT [Hadr_endpoint] STATE = STARTED
END


GO

use [master]

GO

GRANT CONNECT ON ENDPOINT::[Hadr_endpoint] TO [@@{DomainAdmin.username}@@]

GO

:Connect @@{AD.NODE2_NAME}@@

IF EXISTS(SELECT * FROM sys.server_event_sessions WHERE name='AlwaysOn_health')
BEGIN
  ALTER EVENT SESSION [AlwaysOn_health] ON SERVER WITH (STARTUP_STATE=ON);
END
IF NOT EXISTS(SELECT * FROM sys.dm_xe_sessions WHERE name='AlwaysOn_health')
BEGIN
  ALTER EVENT SESSION [AlwaysOn_health] ON SERVER STATE=START;
END

GO

:Connect @@{AD.NODE1_NAME}@@ -U sa -P @@{SQLAdmin.secret}@@

USE [master]

GO

CREATE ENDPOINT [Hadr_endpoint] 
	AS TCP (LISTENER_PORT = 5022)
	FOR DATA_MIRRORING (ROLE = ALL, ENCRYPTION = REQUIRED ALGORITHM AES)

GO

IF (SELECT state FROM sys.endpoints WHERE name = N'Hadr_endpoint') <> 0
BEGIN
	ALTER ENDPOINT [Hadr_endpoint] STATE = STARTED
END


GO

use [master]

GO

GRANT CONNECT ON ENDPOINT::[Hadr_endpoint] TO [@@{DomainAdmin.username}@@]

GO

:Connect @@{AD.NODE1_NAME}@@ -U sa -P @@{SQLAdmin.secret}@@

IF EXISTS(SELECT * FROM sys.server_event_sessions WHERE name='AlwaysOn_health')
BEGIN
  ALTER EVENT SESSION [AlwaysOn_health] ON SERVER WITH (STARTUP_STATE=ON);
END
IF NOT EXISTS(SELECT * FROM sys.dm_xe_sessions WHERE name='AlwaysOn_health')
BEGIN
  ALTER EVENT SESSION [AlwaysOn_health] ON SERVER STATE=START;
END

GO

:Connect @@{AD.NODE2_NAME}@@

USE [master]

GO

CREATE AVAILABILITY GROUP [@@{calm_application_name}@@AAG]
WITH (AUTOMATED_BACKUP_PREFERENCE = SECONDARY,
DB_FAILOVER = OFF,
DTC_SUPPORT = NONE)
FOR DATABASE [@@{calm_application_name}@@]
REPLICA ON N'@@{AD.NODE1_NAME}@@' WITH (ENDPOINT_URL = N'TCP://@@{AD.NODE1_NAME}@@.@@{DOMAIN}@@:5022', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 50, SEEDING_MODE = AUTOMATIC, SECONDARY_ROLE(ALLOW_CONNECTIONS = NO)),
	N'@@{AD.NODE2_NAME}@@' WITH (ENDPOINT_URL = N'TCP://@@{AD.NODE2_NAME}@@.@@{DOMAIN}@@:5022', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 50, SEEDING_MODE = AUTOMATIC, SECONDARY_ROLE(ALLOW_CONNECTIONS = NO));

GO

:Connect @@{AD.NODE2_NAME}@@

USE [master]

GO

ALTER AVAILABILITY GROUP [@@{calm_application_name}@@AAG]
ADD LISTENER N'@@{calm_application_name}@@lsnt' (
WITH IP
((N'@@{PreDeployment.SQLCLUSTER_IP}@@', N'255.255.255.0')
)
, PORT=1433);

GO

:Connect @@{AD.NODE1_NAME}@@ -U sa -P @@{SQLAdmin.secret}@@

ALTER AVAILABILITY GROUP [ag_group] JOIN;

GO

ALTER AVAILABILITY GROUP [ag_group] GRANT CREATE ANY DATABASE;

GO

GO

'@

echo $createAG | Out-File -FilePath "c:\windows\temp\CreateAG.txt"


$result = Start-Process -FilePath "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\sqlcmd.exe" -ArgumentList "-U sa -P @@{SQLAdmin.secret}@@ -i c:\windows\temp\CreateAG.txt -o C:\windows\Temp\result_CreateAG.txt" -NoNewWindow -Wait -PassThru

if ($result.ExitCode -eq 0) {
    echo "SQL AlwaysOn Availability Group successfully created, for troubleshooting, see C:\windows\Temp\result_CreateAG.txt"
}
