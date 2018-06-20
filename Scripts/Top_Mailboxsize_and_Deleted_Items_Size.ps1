$mailsize = ""
$deletedmailsize = ""

write-host "Please Note : This script can take a few minues to complete" -ForegroundColor Yellow

$mailsize = Get-Mailbox -ResultSize unlimited -Filter {servername -eq "exchsrv2"} | Get-MailboxStatistics | Sort-Object totalitemsize -descending | select displayname, totalitemsize -First 30 | ft -a
$deletedmailsize = Get-Mailbox -ResultSize unlimited -Filter {servername -eq "exchsrv2"} | Get-MailboxStatistics | Sort-Object totaldeleteditemsize -descending | select displayname, totaldeleteditemsize -First 30 | ft -a
Write-Host "`The largest 30 mailboxes are currently : ` " -ForegroundColor Yellow
$mailsize
Write-Host "`The 30 mailboxes with the most deleted items are currently : ` " -ForegroundColor Yellow
$deletedmailsize
