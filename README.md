# PowerShell

PowerShell Scripts

## Grant-UserFullRights.ps1

This script file is taken from [techibee.com](https://techibee.com/powershell/grant-fullcontrol-permission-to-usergroup-on-filefolder-using-powershell/2158).

I modified the function name to be distiguished from the file name. And used different constructor for System.Security.AccessControl.FileSystemAccessRule.

### Example usage

```powershell
. "full-path-to-the-file\Grant-UserFullRights.ps1"  
Grant-UserFullControl -Files .\filename -Username "domain\username"  
```

## Extract Data from XML to CSV

This script extract data from XML files and add it to CSV file.

### Example Usage

```powershell
. "full-path-to-the-file\extract-from-xml-2-csv.ps1"
Read-Data -sourcePath "c:\Users\George\Downloads\1\" -outputFile "c:\Users\George\Downloads\1\exracted-data.csv"
```

## Generate SQL Scripts

This script generate SQL scripts for db objects like tables, views, user defined functions, ...

## Execute Multiple SQL Scripts

This script loop over sql scripts files and execute them in order

## remove bin and obj folders

This script deletes bin and obj folders from all subfolders

## count folders

This script counts the number of folders created before certain date in a given path.

## move folders

This script moves folders created before certain date in a given path to another path.

## read folders sizes

This script reads the size of folders in a given path that were created before certain date and export the result to text file.
