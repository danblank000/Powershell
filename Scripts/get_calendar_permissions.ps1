$name = ""
$calendar = ""

write-host "`n`n**********`n`n"
write-host "Calendar Permissions Script" -ForegroundColor Yellow

write-host "`nWho's calendar is being queried?"
$name = read-host
$append = ":\calendar"
$calendar = $name + $append

write-host "`nThese are the current permissions for $name's calendar:" -ForegroundColor Yellow
Get-MailboxFolderPermission "$calendar" | where {($_.user -notlike "*bes*") -and ($_.user -notlike "*NT*") -and ($_.user -notlike "*default*")} | select user, accessrights