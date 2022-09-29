# input parameters

$filename= 'c:\temp\sql-script.sql'

$server=".\Dev"
$dbname="interview"

#$username="user"
#$password="password"

$connectionstring = "Server = $server; Database = $dbname; Integrated Security = True;"
# $connectionstring = "Server = $server; Database = $dbname; UId = $username; Password = $password"

# set db objects to be generated
$filter = @(
    "[dbo].[Employee]",
    "[dbo].[Skill]"
)

# end of input parameters

# set sql connection
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = $connectionstring

# drop a re-create the file
if(Test-Path $filename)
{
    Remove-Item $filename
}

New-Item -Path $filename -ItemType File

"Connecting..."

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null
$SMOserver = New-Object ('Microsoft.SqlServer.Management.Smo.Server') -argumentlist $conn
$db = $SMOserver.databases[$dbname]

"Connected to $($SMOserver.Name)-$($db.Name)"

$Objects = @()

"Reading Tables..."
$Objects = $db.Tables | where {$_ -iin $filter}

"Reading Views..."
$Objects += $db.Views | where {$_ -iin $filter}

"Reading UserDefinedTableTypes..."
$Objects += $db.UserDefinedTableTypes | where {$_ -iin $filter}

"Reading UserDefinedFunctions..."
$Objects += $db.UserDefinedFunctions | where {$_ -iin $filter}

"Reading StoredProcedures..."
$Objects += $db.StoredProcedures | where {$_ -iin $filter}


# $objects | foreach {Write-Host $_}

"Staring Process..."
"----------------------------"

# create scripter object and set its options
$scripter = new-object (‘Microsoft.SqlServer.Management.Smo.Scripter’) ($SMOserver)
$scripter.Options.AppendToFile = $True
$scripter.Options.AllowSystemObjects = $False
$scripter.Options.ClusteredIndexes = $True
$scripter.Options.NonClusteredIndexes = $True
$scripter.Options.DriAll = $True
$scripter.Options.ScriptDrops = $False
$scripter.Options.IncludeHeaders = $True
$scripter.Options.ToFileOnly = $True
$scripter.Options.Indexes = $True
$scripter.Options.Default = $True
$scripter.Options.Triggers = $True
$scripter.Options.Permissions = $False
$scripter.Options.WithDependencies = $False
$scripter.Options.FileName = $filename

foreach ($dbObj in $Objects) {  
    #This is where each object actually gets scripted one at a time.
    "Process: $dbObj"
    $scripter.Script($dbObj)
} #This ends the loop
