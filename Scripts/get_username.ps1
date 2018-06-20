cls
$name = ""
write-host "*** Find Username ***" -ForegroundColor Yellow
sleep -s 1
write-host "`nEnter the persons's name"
$name = read-host
$user = get-aduser -filter * | where {$_.name -like "$name*"} | select samaccountname
$user = $user.samaccountname
$name = get-aduser -filter * | where {$_.name -like "$name*"} | select name
$name = $name.name

write-host "`n$name's username is $user"