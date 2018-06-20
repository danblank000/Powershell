DO
{

$mailbox = ""
$choice = ""
$add = ""

Write-host "*** Mailbox Permission Checker ***" -ForegroundColor cyan
write-host "`nEnter the name of the user" -ForegroundColor Yellow
$mail = read-host
write-host "`n`nCurrent mailbox permission for $mail`n" -ForegroundColor Gray
$mailboxes = Get-Mailbox "$mail"
 
ForEach ($mailbox in $mailboxes) 
	{
    $permissions = $mailbox | Get-MailboxPermission | Where-Object {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.user.tostring() -notlike "S-1-5-21*" -and $_.user.tostring() -notlike "*TFB*" -and $_.IsInherited -eq $false}
    $permissions = ForEach($permission in $permissions) 
		{
        $display = Get-Mailbox $permission.user.toString() | Select-Object -ExpandProperty DisplayName
        $permission | Select-Object AccessRights,@{n='Display';e={$display}}
		}
    }
   
$lines = ForEach ($permission in $permissions) 
    {
    $readable_rights = ForEach ($right in $permission.accessrights) 
        {
        ($right -csplit "([A-Z][a-z]*)" | ? {$_ -ne ""}) -join " "
        }

    write-host "$($permission.display) : $readable_rights"

    }
sleep -s 1

write-host "**********************************************************************" -ForegroundColor Gray
write-host "`nWould you like to :`n`n`t1: Add permissions to the mailbox`n`t2: Remove permissions from the mailbox`n`t3: Exit`n`nPlease enter 1, 2 or 3."
$choice = read-host

    if ($choice -eq "1")
    {
    write-host "`nWho would you like to grant full acceess permissions to?"
    $add = read-host
    add-MailboxPermission -Identity $mail -User $add -AccessRights Fullaccess -InheritanceType all
    sleep -s 1
    write-host "`nNow the mailbox permissions for $mailbox are: `n" -ForegroundColor Yellow
    $mailboxes = Get-Mailbox "$mail"
 
ForEach ($mailbox in $mailboxes) 
	{
    $permissions = $mailbox | Get-MailboxPermission | Where-Object {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.user.tostring() -notlike "S-1-5-21*" -and $_.user.tostring() -notlike "*TFB*" -and $_.IsInherited -eq $false}
    $permissions = ForEach($permission in $permissions) 
		{
        $display = Get-Mailbox $permission.user.toString() | Select-Object -ExpandProperty DisplayName
        $permission | Select-Object AccessRights,@{n='Display';e={$display}}
		}
    }
   
$lines = ForEach ($permission in $permissions) 
    {
    $readable_rights = ForEach ($right in $permission.accessrights) 
        {
        ($right -csplit "([A-Z][a-z]*)" | ? {$_ -ne ""}) -join " "
        }

    write-host "$($permission.display) : $readable_rights"

    }
    }

    elseif ($choice -eq "2")
    {
    write-host "`nWho would you like to remove full acceess permissions from?"
    $add = read-host
    remove-MailboxPermission -Identity $mail -User $add -AccessRights Fullaccess -InheritanceType all -Confirm:$false
    sleep -s 1
    write-host "`nNow the mailbox permissions for $mailbox are: `n" -ForegroundColor Yellow
    $mailboxes = Get-Mailbox "$mail"
 
ForEach ($mailbox in $mailboxes) 
	{
    $permissions = $mailbox | Get-MailboxPermission | Where-Object {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.user.tostring() -notlike "S-1-5-21*" -and $_.user.tostring() -notlike "*TFB*" -and $_.IsInherited -eq $false}
    $permissions = ForEach($permission in $permissions) 
		{
        $display = Get-Mailbox $permission.user.toString() | Select-Object -ExpandProperty DisplayName
        $permission | Select-Object AccessRights,@{n='Display';e={$display}}
		}
    }
   
$lines = ForEach ($permission in $permissions) 
    {
    $readable_rights = ForEach ($right in $permission.accessrights) 
        {
        ($right -csplit "([A-Z][a-z]*)" | ? {$_ -ne ""}) -join " "
        }

    write-host "$($permission.display) : $readable_rights"

    }
    }

    elseif ($choice -eq "3")
    {
    }
    
sleep -s 1
write-host "`nWould you like to query another mailbox? y/n"
$repeat = read-host
}

Until ($repeat -ne "y")
