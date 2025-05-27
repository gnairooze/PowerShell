# PowerShell script to compare files between two directories
# Compares files between "f:\Repos\github\SimpleHooks\" and "f:\Repos\az\Reusable\simple-hooks\"
# Excluding specific directories and outputs the results to a markdown file

# Define directories to compare
$sourceDir = "c:\Repos\github\SimpleHooks\"
$targetDir = "c:\Repos\az\simple-hooks\"
$outputFile = "c:\temp\simplehooks-comparison-result.md"

# Directories to exclude
$excludeDirs = @(
    ".git",
    ".github",
    ".vs",
    ".vscode",
	".idea",
    "docs",
    "bin",
    "obj",
    "publish"
)

# Ensure output directory exists
$outputDir = Split-Path -Path $outputFile -Parent
if (-not (Test-Path -Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory -Force | Out-Null
}

# Function to get files recursively, excluding specified directories
function Get-FilesRecursively {
    param (
        [string]$rootDir,
        [string[]]$excludeDirs
    )

    # Get all files
    $allFiles = Get-ChildItem -Path $rootDir -Recurse -File | Where-Object {
        $relPath = $_.FullName.Substring($rootDir.Length)
        $exclude = $false
        foreach ($dir in $excludeDirs) {
            if ($relPath -match "\\$dir\\") {
                $exclude = $true
                break
            }
        }
        -not $exclude
    }

    # Create a hashtable with relative paths as keys
    $filesHashtable = @{}
    foreach ($file in $allFiles) {
        $relativePath = $file.FullName.Substring($rootDir.Length).Replace('\', '/')
        $filesHashtable[$relativePath] = $file.FullName
    }

    return $filesHashtable
}

# Get files from both directories
Write-Host "Getting files from source directory..."
$sourceFiles = Get-FilesRecursively -rootDir $sourceDir -excludeDirs $excludeDirs
Write-Host "Found $($sourceFiles.Count) files in source directory."

Write-Host "Getting files from target directory..."
$targetFiles = Get-FilesRecursively -rootDir $targetDir -excludeDirs $excludeDirs
Write-Host "Found $($targetFiles.Count) files in target directory."

# Combine all unique file paths
$allPaths = @($sourceFiles.Keys) + @($targetFiles.Keys) | Sort-Object -Unique

# Initialize result arrays
$inBothSame = @()
$inBothDifferent = @()
$onlyInSource = @()
$onlyInTarget = @()

# Compare files
Write-Host "Comparing files..."
$totalFiles = $allPaths.Count
$processedFiles = 0

foreach ($path in $allPaths) {
    $processedFiles++
    if ($processedFiles % 10 -eq 0) {
        Write-Host "Processed $processedFiles of $totalFiles files..."
    }

    $inSource = $sourceFiles.ContainsKey($path)
    $inTarget = $targetFiles.ContainsKey($path)

    if ($inSource -and $inTarget) {
        # File exists in both directories, compare content
        $sourceHash = Get-FileHash -Path $sourceFiles[$path] -Algorithm SHA256
        $targetHash = Get-FileHash -Path $targetFiles[$path] -Algorithm SHA256

        if ($sourceHash.Hash -eq $targetHash.Hash) {
            $inBothSame += $path
        } else {
            $inBothDifferent += $path
        }
    } elseif ($inSource) {
        $onlyInSource += $path
    } else {
        $onlyInTarget += $path
    }
}

# Generate markdown report
Write-Host "Generating markdown report..."
$markdown = @"
# Directory Comparison Report

## Summary

* Source Directory: `$sourceDir`
* Target Directory: `$targetDir`
* Comparison Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
* Excluded Directories: $($excludeDirs -join ', ')

## Statistics

* Total Unique Files: $($allPaths.Count)
* Files in Both Directories (Same Content): $($inBothSame.Count)
* Files in Both Directories (Different Content): $($inBothDifferent.Count)
* Files Only in Source: $($onlyInSource.Count)
* Files Only in Target: $($onlyInTarget.Count)

## Files in Both Directories with Same Content ($($inBothSame.Count))

| File Path |
| --- |
$(if ($inBothSame.Count -gt 0) { $inBothSame | ForEach-Object { "| ``$_`` |`r`n" } } else { "| *None* |`r`n" })

## Files in Both Directories with Different Content ($($inBothDifferent.Count))

| File Path |
| --- |
$(if ($inBothDifferent.Count -gt 0) { $inBothDifferent | ForEach-Object { "| ``$_`` |`r`n" } } else { "| *None* |`r`n" })

## Files Only in Source Directory ($($onlyInSource.Count))

| File Path |
| --- |
$(if ($onlyInSource.Count -gt 0) { $onlyInSource | ForEach-Object { "| ``$_`` |`r`n" } } else { "| *None* |`r`n" })

## Files Only in Target Directory ($($onlyInTarget.Count))

| File Path |
| --- |
$(if ($onlyInTarget.Count -gt 0) { $onlyInTarget | ForEach-Object { "| ``$_`` |`r`n" } } else { "| *None* |`r`n" })

"@

# Save the markdown report
$markdown | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "Comparison completed."
Write-Host "Results saved to: $outputFile"

