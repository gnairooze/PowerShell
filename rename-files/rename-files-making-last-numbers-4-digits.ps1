Get-ChildItem -Filter "*_*.tiff" | ForEach-Object {
    if ($_.BaseName -match '_(\d+)$') {
        $number = [int]$Matches[1]
        $paddedNumber = "{0:D4}" -f $number
        $suffix = "_$paddedNumber" + $_.Extension
        $newName = $_.BaseName -replace '_(\d+)$', $suffix
        Write-Host "Renaming $($_.FullName) to $newName"

        Rename-Item -Path $_.FullName -NewName $newName
    }
}
