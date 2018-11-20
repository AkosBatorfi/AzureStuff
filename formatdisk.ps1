Param
 (
     $LunID,
     $DriveLetter,
     $Label,
     $AllocationUnit
 )

Get-Disk|Where Number -eq $LunID | Initialize-Disk -PartitionStyle GPT -PassThru | New-Partition DriveLetter $DriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel $Label -AllocationUnitSize $AllocationUnitSize -Confirm:$false
