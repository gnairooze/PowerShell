# count folders in created before 2023-01-01 in c:\temp2 folder

(Get-ChildItem -Path "c:\\temp2" -Directory | Where-Object { $_.CreationTime -lt '2023-01-01' }).Count
