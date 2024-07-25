# copy files from a source directory to a destination directory based on the creation date of the files

$sourcePath = "c:\uploads"
$destinationPath = "C:\temp\1"
$creationDate = Get-Date -Year 2024 -Month 3 -Day 15

function Copy-FilesToDestination($source, $destination, $date) {
    Get-ChildItem -Recurse $source | Where-Object { -not $_.PSIsContainer -and $_.CreationTime -gt $date } |
        ForEach-Object {
            $relativePath = $_.FullName.Substring($source.Length)
            $destinationFile = Join-Path -Path $destination -ChildPath $relativePath
            $destinationDir = Split-Path -Path $destinationFile -Parent

            if (-not (Test-Path -Path $destinationDir)) {
                New-Item -ItemType Directory -Path $destinationDir | Out-Null
            }

            Copy-Item -Path $_.FullName -Destination $destinationFile
        }
}

Copy-FilesToDestination -source $sourcePath -destination $destinationPath -date $creationDate
Write-Host "Files copied successfully!"
