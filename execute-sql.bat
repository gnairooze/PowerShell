set servername=".\Dev"
set dbname="Interview"

for %%f in (*.sql) do (
    sqlcmd -S %servername% -d %dbname% -E -i "%%f"
)