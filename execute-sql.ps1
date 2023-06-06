
$server=".\Dev"
$dbname="interview"

#$username="user"
#$password="password"

$connectionstring = "Server = $server; Database = $dbname; Integrated Security = True;"
# $connectionstring = "Server = $server; Database = $dbname; UId = $username; Password = 

$rootPath = "./sql-scripts"

Import-Module sqlps

# add the files in order of execution
$files = @(
    "1.sql",
    "2.sql"
)

foreach ($file in $files) {
    Write-Host $rootPath/$file

    Invoke-Sqlcmd -InputFile $rootPath/$file -ConnectionString $connectionString
}
