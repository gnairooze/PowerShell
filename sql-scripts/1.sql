use Interview
go

update Skill
set Name = 'SQL-2',
    Modified_On = GETDATE()
where Id = 3

go