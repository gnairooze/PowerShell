# Load required .NET assembly
Add-Type -AssemblyName System.Drawing

# Configure paths
$sourceDir = "g:\pdf-extract\1\"

# Create output directory if missing
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir | Out-Null }

# Process all TIFF files
$files = Get-ChildItem -Path $sourceDir -Filter *.tif*
$total = $files.Count
$i = 0

$files | ForEach-Object {
    $i++
    Write-Progress -Activity "Processing Files" -Status "$i of $total" `
        -PercentComplete (($i / $total) * 100)
 
        $image = [System.Drawing.image]::FromFile( $_ )
        $image.rotateflip("Rotate90FlipNone")
        $image.save($_)
        $image.Dispose()
}
