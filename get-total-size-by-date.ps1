# calculate the total size of files created after a specific date in a directory

$sourcePath = "c:\uploads"
$creationDate = Get-Date -Year 2023 -Month 3 -Day 15

function Get-DirectorySize($source, $date) {
    Get-ChildItem -Recurse $source | Where-Object { -not $_.PSIsContainer -and $_.CreationTime -gt $date } |
        Measure-Object -Sum -Property Length |
        Select-Object -ExpandProperty Sum
}

$totalSizeInBytes = Get-DirectorySize $sourcePath $creationDate
$totalSizeInMB = [math]::Round($totalSizeInBytes / 1MB, 2)

Write-Host "Total size in megabytes: $totalSizeInMB MB"
