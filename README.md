# PowerShell
PowerShell Scripts

## Grant-UserFullRights.ps1

This script file is taken from [techibee.com](https://techibee.com/powershell/grant-fullcontrol-permission-to-usergroup-on-filefolder-using-powershell/2158).

I modified the function name to be distiguished from the file name. And used different constructor for System.Security.AccessControl.FileSystemAccessRule.

### Example usage

```powershell 
  PS C:\> . "full-path-to-the-file\Grant-UserFullRights.ps1"  
  PS C:\> Grant-UserFullControl -Files .\filename -Username "domain\username"  
```
