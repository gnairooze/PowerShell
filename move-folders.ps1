# Move folders in c:\temp folder, created before 2023-07-01 to c:\temp2 folder

Get-ChildItem -Path "c:\\temp" -Directory -Recurse | Where-Object { $_.CreationTime -lt '2023-07-01' } | Move-Item -Destination "c:\\temp2"
