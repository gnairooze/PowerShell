# delete files from a source directory and its sub-directories based on the creation date of the files
# last write time is used instead of creation time because the creation time can be changed if the file copied from another location.

$sourcePath = "c:\temp\1"
$creationDate = Get-Date -Year 2024 -Month 7 -Day 1

Get-ChildItem -Path $sourcePath -Recurse -File | Where-Object { -not $_.PSIsContainer -and $_.LastWriteTime -lt $creationDate } | ForEach-Object {
    Write-Host "Deleting file: $($_.FullName)"
    $_ | Remove-Item -Force
}

# Delete any empty directories left behind after deleting the old files.
Get-ChildItem -Path $sourcePath -Recurse -Directory | Where-Object { (Get-ChildItem -Path $_.FullName -Recurse -File) -eq $null } | ForEach-Object {
    Write-Host "Removing empty directory: $($_.FullName)"
    $_ | Remove-Item -Force -Recurse
}

Write-Host "Files deleted successfully!"
