write-host "`n`n*** Find Users Initals ***" -BackgroundColor black -ForegroundColor Yellow

write-host "`nPlease enter a name to query:" -ForegroundColor Yellow
$name = read-host 
get-aduser -filter * -Properties initials | where {$_.name -like "$name"}  | select Initials


