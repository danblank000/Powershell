DO
{
$calendar = ""
$calendar2 = ""
$continue = ""
$permuser = ""
$permissions = ""

write-host "`n`n**********`n`n"
write-host "Calendar Permissions Script" -ForegroundColor Yellow

write-host "`nWho's calendar is being queried?"
$calendar = read-host
$calendar2 = $calendar + ":\calendar"

Write-Host "`nDo you want to Add or Remove Calendar Permissions? A/R"
$addrem = Read-Host

    if ($addrem -eq  "a")
    {
    write-host "`nEnter the email address of the person who needs permissions adding to $calendar's calendar? :"
    $permuser = read-host

    Write-Host "`nWhat permissions does $permuser require to $calendar's calendar?  Press 1 for reviewer or 2 for editor : " -NoNewline
    $permissions = read-host

        if ($permissions -eq "1")
        {
        Add-MailboxFolderPermission -identity "$calendar2" -user "$permuser" -AccessRights Reviewer
        }

        elseif ($permissions -eq "2")
        {
        Add-MailboxFolderPermission -identity "$calendar2" -user "$permuser" -AccessRights editor
        }

    sleep -s 1

    Write-Host "`nThese are now the current permissions for $calendar's calendar`n" -ForegroundColor Yellow
    Get-MailboxFolderPermission "$calendar2" | where {($_.user -notlike "*bes*") -and ($_.user -notlike "*NT*") -and ($_.user -notlike "*default*")} | select user, accessrights
    }

    else
    {
    write-host "`nWho's permissions need removing from $calendar's calendar? :"
    $permuser = read-host

    Remove-MailboxFolderPermission -Identity "$calendar2" -user "$permuser" -confirm:$False

    sleep -s 1

    Write-Host "`nEnter the email address of the person who needs permissions removign from  $calendar's calendar`n" -ForegroundColor Yellow
    Get-MailboxFolderPermission "$calendar2" | where {($_.user -notlike "*bes*") -and ($_.user -notlike "*NT*") -and ($_.user -notlike "*default*")} | select user, accessrights
    }



# Try Again?
sleep -s 1
write-host "`nWould you like to run this again on for another user? Press Y for yes or N for no"
$continue = read-host
}
Until ($continue -eq "N") 


