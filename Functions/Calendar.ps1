Function Get-CalendarPermissions
{
    
    [cmdletbinding()]
    param(
    [Parameter(Mandatory=$true, Position=0)] 
    [string]$Name
    )

$Append = ":\calendar"
$Calendar = $Name + $Append

write-host "`nThese are the current permissions for $name's calendar:" -ForegroundColor Yellow
Get-MailboxFolderPermission "$calendar" | where {($_.user -notlike "*bes*") -and ($_.user -notlike "*NT*") -and ($_.user -notlike "*default*") -and ($_.user -notlike "*anonymous*")} | select user, accessrights


}





Function Add-CalendarPermissions
{

    [cmdletbinding()]
    param(
    [Parameter(Mandatory=$true, Position=0)] 
    [string]$Name,
    
    [Parameter(Mandatory=$true, Position=0)] 
    [string]$Requester
    )

$Append = ":\calendar"
$Calendar = $Name + $Append

Add-MailboxFolderPermission -identity "$Calendar" -user "$Requester" -AccessRights editor
sleep -m 400
write-host "`nPermissions have been added for $Requester.  These are the current permissions for $Name's calendar:" -ForegroundColor Yellow
Get-MailboxFolderPermission "$calendar" | where {($_.user -notlike "*bes*") -and ($_.user -notlike "*NT*") -and ($_.user -notlike "*default*") -and ($_.user -notlike "*anonymous*")} | select user, accessrights
}





Function Remove-CalendarPermissions
{

    [cmdletbinding()]
    param(
    [Parameter(Mandatory=$true, Position=0)] 
    [string]$Name,
    
    [Parameter(Mandatory=$true, Position=0)] 
    [string]$Requester
    )

$Append = ":\calendar"
$Calendar = $Name + $Append

Remove-MailboxFolderPermission -Identity "$Calendar" -user "$Requester" -confirm:$False
sleep -m 400
write-host "`nPermissions have beeb removed for $Requester. These are the current permissions for $Name's calendar:" -ForegroundColor Yellow
Get-MailboxFolderPermission "$calendar" | where {($_.user -notlike "*bes*") -and ($_.user -notlike "*NT*") -and ($_.user -notlike "*default*") -and ($_.user -notlike "*anonymous*")} | select user, accessrights
}
