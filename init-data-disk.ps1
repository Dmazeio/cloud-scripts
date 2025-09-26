param(
  [int]$Lun = 0,                  # Azure LUN of the data disk you attached
  [char]$DriveLetter = 'F',       # Desired drive letter
  [string]$Label = 'Data'         # Volume label
)

$disk = Get-Disk | Where-Object {
  $_.PartitionStyle -eq 'RAW' -and $_.Location -match "LUN $Lun"
}

if (-not $disk) {
  Write-Host "No RAW disk found for LUN $Lun. Exiting."
  exit 0
}

# Initialize, create single partition, assign letter, format NTFS
$part = Initialize-Disk -Number $disk.Number -PartitionStyle GPT -PassThru |
        New-Partition -DriveLetter $DriveLetter -UseMaximumSize

Format-Volume -Partition $part -FileSystem NTFS -NewFileSystemLabel $Label -Confirm:$false
Write-Host "Disk at LUN $Lun initialized as $DriveLetter with label '$Label'."