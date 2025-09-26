$disk = Get-Disk -Number 1
$driveLetter = "S"
if ($disk.partitionstyle -eq 'raw') {
    $disk | Initialize-Disk -PartitionStyle MBR -PassThru |
        New-Partition -UseMaximumSize -DriveLetter $driveLetter |
        Format-Volume -FileSystem NTFS -NewFileSystemLabel "SvcFab" -Confirm:$false -Force
    New-Item -Path "$($driveLetter):\SvcFab" -ItemType Directory
} else {
    $disk | Get-Partition | Set-Partition -NewDriveLetter $driveLetter
}
