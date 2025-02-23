# Load required .NET assembly
Add-Type -AssemblyName System.Drawing

# Configure paths
$sourceDir = "g:\pdf-extract\"
$outputDir = "c:\temp\"

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

    $image = [System.Drawing.Image]::FromFile($_.FullName)
    $jpgPath = Join-Path $outputDir ($_.BaseName + ".jpg")
    
    # Save as JPG with quality control (optional: set quality parameter)
    $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters
    $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter (
        [System.Drawing.Imaging.Encoder]::Quality,
        [long]90
    )
    
    $image.Save(
        $jpgPath,
        [System.Drawing.Imaging.ImageFormat]::Jpeg
    )
    
    $image.Dispose()
}
