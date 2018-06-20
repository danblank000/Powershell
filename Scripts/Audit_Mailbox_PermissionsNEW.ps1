
$mailboxes = get-aduser -Filter {(title -like "*partner*") -or (title -like "*head*") -or (title -like "*manager*")} | sort name
write-host "Mailbox Audit Report`n`n" -ForegroundColor Cyan

    foreach ($mailbox in $mailboxes)
    {
    $mailbox = $mailbox.name
    $title = $mailbox.title
    Write-Host "*****************************************************************************************************************************************************************************"

    write-host "$mailbox`n" -ForegroundColor Yellow
    write-host "`n`tFull Access permissions have been granted to : `n" -ForegroundColor DarkYellow
    
    #Full mailbox access
    $permissions = get-mailbox $mailbox | get-MailboxPermission | where {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.user.tostring() -notlike "S-1-5-21*" -and $_.user.tostring() -notlike "*bes_admin*" -and $_.IsInherited -eq $false} | Select User| Sort-Object identity
    
        foreach ($permission in $permissions)
        {
        $permission = ($permission.user).ToString()
        $perm = $permission.split('\')[1]
        $permo = ((get-aduser $perm| select name).name).tostring()
        write-host "	" -NoNewline
        $enabled = ((get-aduser $perm -Properties enabled | select enabled).enabled).tostring()
        
            if ($enabled -eq "True")
            {
            $permo
            write-host ""
            }

        }
        
    #Send on behalf of
    $user = (get-aduser -filter {name -like $mailbox} | select samaccountname).samaccountname
    $delegates = get-aduser $user -Properties * | select publicdelegates
    $delegates = $delegates.publicdelegates
    $count = $delegates.Count
    write-host "`n`tSend of Behalf of permissions have also been granted to $count users :" -ForegroundColor DarkYellow

        foreach ($delegate in $delegates)
        {
        $line = $delegate.split(',')[0]
        $line = $line -replace "cn=" , ""
        write-host ""
        $enabled2 = ((get-aduser -Filter "name -like '*$line*'").enabled).tostring()
        
            if ({$line -notlike "*bes*"} -and {$enabled -eq "True"})
            {
            write-host "`t$line"
            }
        }

    write-host ""
    }