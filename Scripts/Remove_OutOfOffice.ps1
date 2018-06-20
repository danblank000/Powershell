DO
{

cls
$name = ""

write-host "*** Out of Office Remover ***" -ForegroundColor Yellow
sleep -m 500

write-host "`nEnter the name of the user who's out of office needs removing"
$name = Read-Host

Set-MailboxAutoReplyConfiguration “$name” –AutoReplyState Disabled –ExternalMessage $null –InternalMessage $null

write-host "`nThe Out of Office for $name has now been removed" -ForegroundColor Yellow
sleep -s 1
Get-MailboxAutoReplyConfiguration -Identity $name | fl internalmessage, externalmessage
sleep -Milliseconds 500
write-host "Would you like to remove another Out of Office message? Y/N" -ForegroundColor Yellow
$repeat = read-host
}

Until ($repeat -ne "y")