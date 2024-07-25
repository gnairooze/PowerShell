# calculate the total size of files created after a specific date in a directory
# last write time is used instead of creation time because the creation time can be changed if the file copied from another location.

$sourcePath = "c:\temp\1"
$creationDate = Get-Date -Year 2024 -Month 7 -Day 10

function Get-DirectorySize($source, $date) {
    Get-ChildItem -Recurse $source | Where-Object { -not $_.PSIsContainer -and $_.LastWriteTime -lt $date } |
        Measure-Object -Sum -Property Length |
        Select-Object -ExpandProperty Sum
}

$totalSizeInBytes = Get-DirectorySize $sourcePath $creationDate
$totalSizeInMB = [math]::Round($totalSizeInBytes / 1MB, 2)

Write-Host "Total size in megabytes: $totalSizeInMB MB"
