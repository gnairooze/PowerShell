# copy files from a source directory to a destination directory based on the creation date of the files
# last write time is used instead of creation time because the creation time can be changed if the file copied from another location.

$sourcePath = "c:\uploads"
$destinationPath = "C:\temp\1"
$creationDate = Get-Date -Year 2024 -Month 3 -Day 15

function Copy-FilesToDestination($source, $destination, $date) {
    Get-ChildItem -Recurse $source | Where-Object { -not $_.PSIsContainer -and $_.LastWriteTime -gt $date } |
        ForEach-Object {
            $relativePath = $_.FullName.Substring($source.Length)
            $destinationFile = Join-Path -Path $destination -ChildPath $relativePath
            $destinationDir = Split-Path -Path $destinationFile -Parent

            if (-not (Test-Path -Path $destinationDir)) {
                Write-Host "Creating directory: $destinationDir"

                New-Item -ItemType Directory -Path $destinationDir | Out-Null
            }

            Write-Host "Copying file: $($_.FullName) to $destinationFile"
            Copy-Item -Path $_.FullName -Destination $destinationFile
        }
}

Copy-FilesToDestination -source $sourcePath -destination $destinationPath -date $creationDate
Write-Host "Files copied successfully!"
