$files = Get-ChildItem -Filter "*_*.tiff"
$total = $files.Count
$i = 0

$files | ForEach-Object {
    $i++
    Write-Progress -Activity "Processing Files" -Status "$i of $total" `
        -PercentComplete (($i / $total) * 100)

    if ($_.BaseName -match '_(\d+)$') {
        $number = [int]$Matches[1]
        $paddedNumber = "{0:D4}" -f $number
        $suffix = "_$paddedNumber" + $_.Extension
        $newName = $_.BaseName -replace '_(\d+)$', $suffix
        # Write-Host "Renaming $($_.FullName) to $newName"

        Rename-Item -Path $_.FullName -NewName $newName
    }
}
