Function Get-CalendarPermission
{

    [cmdletbinding()]
    param
    (
    [Parameter(Mandatory=$true, Position=0)] 
    [string]$Name
    )

$Append = ":\calendar"
$Calendar = $Name + $Append

write-host "`nThese are the current permissions for $name's calendar:" -ForegroundColor Yellow
Get-MailboxFolderPermission "$calendar" | where {($_.user -notlike "*bes*") -and ($_.user -notlike "*NT*") -and ($_.user -notlike "*default*")} | select user, accessrights

}