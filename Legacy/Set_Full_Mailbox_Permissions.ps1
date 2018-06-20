Do
{
cls
$user = ""
$identity = ""
$uname = ""
$iname = ""
$permissionlist = ""
$perm = ""
write-host "Which user is going to need the full access permissions?  "-ForegroundColor Yellow -NoNewline
$user = read-host 
Write-Host "Who's mailbox does the user need Full Access to?  "-ForegroundColor Yellow -NoNewline
$identity = read-host
write-host ""
$uname = get-aduser $user | select name
$uname = $uname.name
$iname = get-aduser $identity | select name
$iname = $iname.name
$permissionlist = Get-MailboxPermission $identity | Where-Object {$_.accessrights -like "*full*" -and $_.user -like "*dwf*"} |select user | Sort-Object name
write-host "Currently the following have full access permissions to $iname's mailbox:"
write-host ""
sleep -s 1
    
    foreach ($perm in $permissionlist)
    {
    $perm = $perm.user
    $perm = $perm.split('\')[1]
    write-host "$perm" -ForegroundColor Gray
    } 
    
    try
    {
    add-mailboxpermission -Identity $identity -user $user -accessrights fullaccess
    sleep -s 1
    Write-Host "`n$uname now has full access permissions to $iname's email account" -ForegroundColor Green
    }

    catch
    {
    sleep -s 1
    write-host "There appears to be some problem setting the permissions" -ForegroundColor Red
    }

sleep -s 1
Write-Host "`nWould you like to run this for another mailbox?  Press Y to rerun or N to exit" -ForegroundColor Yellow
$continue = Read-Host
}
until ($continue -ne "y")