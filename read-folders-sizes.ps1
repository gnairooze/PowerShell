# read folders sizes for folders created before 2023-01-01 in c:\temp folder and save the result in c:\temp2\before-2023-size.txt file

(Get-ChildItem -Path "c:\\temp" -Directory -Recurse | Where-Object { $_.CreationTime -lt '2023-01-01' } | ForEach-Object { $_.FullName + " -- " + "{0:N2}" -f ((Get-ChildItem $_.FullName -Recurse -Force | Where-Object { $_.PSIsContainer -eq $false } | Measure-Object -Property Length -Sum).Sum / 1MB) + " MB" }).Trim() | Out-File -FilePath "c:\temp2\before-2023-size.txt"
