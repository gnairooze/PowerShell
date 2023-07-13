set source="sql-scripts\source\*.sql"
set servername=".\Dev"
set sqlusername="sample"
set sqlpassword="P@ssw0rd"
::by default sqlcmd uses windows authentication
::use the arguments -U username -P password at the end of the sqlcmd command to use SQL authentication

for %%f in (%source%) do (
    sqlcmd -S %servername% -i "%%f" -U %sqlusername% -P %sqlpassword%
)
