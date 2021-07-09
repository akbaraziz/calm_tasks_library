$start_time = Get-Date

# we need to do some drive cleanup
# change drive letter of CD
Write-Host "Changing drive letter for cdrom" -ForegroundColor Green
Get-WmiObject -Class Win32_volume -Filter 'DriveType=5' | Select-Object -First 1 | Set-WmiInstance -Arguments @{DriveLetter = 'X:' }

# Bring all the drives online
$disks = get-disk | where-object { $_.operationalstatus -eq "Offline" }
foreach ($disk in $disks) {
    $disk | set-disk -isoffline $false 
    $disk | set-disk -isReadOnly $false
}


# Drive 1 - needs to be D
$partition = get-disk 1 | get-partition | where-object { $_.size -gt 100000000 }
if ($partition.driveletter -ne "D") {
    $partition | Set-Partition -newDriveLetter D
    Get-Volume -DriveLetter D | Set-Volume -NewFileSystemLabel APPS
}

# Initialize and Format Drive L - LOGS
Initialize-Disk -Number 2 -PartitionStyle GPT -PassThru -ErrorAction SilentlyContinue
New-Partition -DiskNumber 2 -DriveLetter L -UseMaximumSize
Format-Volume -DriveLetter L -FileSystem NTFS -AllocationUnitSize 65536 -NewFileSystemLabel "SQL_LOGS" -Confirm:$false

# Initialize and Format Drive S - SQL DATA
Initialize-Disk -Number 3 -PartitionStyle GPT -PassThru -ErrorAction SilentlyContinue
New-Partition -DiskNumber 3 -DriveLetter S -UseMaximumSize
Format-Volume -DriveLetter S -FileSystem NTFS -AllocationUnitSize 65536 -NewFileSystemLabel "SQL_DATA" -Confirm:$false

# Initialize and Format Drive T - TEMP DB
Initialize-Disk -Number 4 -PartitionStyle GPT -PassThru -ErrorAction SilentlyContinue
New-Partition -DiskNumber 4 -DriveLetter T -UseMaximumSize
Format-Volume -DriveLetter T -FileSystem NTFS -AllocationUnitSize 65536 -NewFileSystemLabel "SQL_TEMPDB" -Confirm:$false