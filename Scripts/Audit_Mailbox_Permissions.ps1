$mailboxes = Get-Mailbox -OrganizationalUnit "KSL Staff" | sort identity

    foreach ($mailbox in $mailboxes)
    {
    write-host "$Mailbox" -ForegroundColor Yellow
    $permissions = Get-MailboxPermission $mailbox.Name | where {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.IsInherited -eq $false -and $_.user.ToString() -notmatch "^S-1-5-21-(?:\d{10}-){3}\d{4}$"} | Select Identity,User, accessrights
        
        foreach ($permission in $permissions)
        {
        $who = (($permission.user).ToString()).split("\")
        $who = $who[1]
        $who = ((Get-ADUser $who | select name).name).tostring() 
        $what = $permission.accessrights
        Write-Host "$who ----------- $what"
        }

    write-host "*******************`n`n"
    }