Function Set-OutOfoffice
{

    param
    (
    [Parameter(Mandatory=$True,Position=0)]
    [string]$User
    )

    ### Get Details ###
    $status = Get-MailboxAutoReplyConfiguration $user | select -ExpandProperty autoreplystate

    write-host "`nThe Out of Office for $user is currently" -NoNewline -ForegroundColor Yellow
    write-host " $status" -NoNewline -ForegroundColor Cyan
    write-host " and set as : `n" -ForegroundColor Yellow
    sleep -s 1
    $setinternal = Get-MailboxAutoReplyConfiguration -Identity $user | fl internalmessage
    write-host "Internal: " -ForegroundColor Yellow
    $setinternal
    $setexternal = Get-MailboxAutoReplyConfiguration -Identity $user | fl externalmessage
    write-host "External: " -ForegroundColor Yellow
    $setexternal
    
        ### Enable / Disable ###
        if ($status -eq "enabled")
        {
        Write-Host "Would you like to disable the current out of office? Y/N" -ForegroundColor Yellow
        $yn = read-host

            if ($yn -eq "y")
            {
            Set-MailboxAutoReplyConfiguration $name -AutoReplyState disabled
            write-host "$name's Out of Office has now been disbaled"
            }

        }

        if ($status -eq "disabled")
        {
        Write-Host "Would you like to enable the current out of office? Y/N" -ForegroundColor Yellow
        $yn = read-host

            if ($yn -eq "y")
            {
            Set-MailboxAutoReplyConfiguration $name -AutoReplyState enabled
            Write-Host "$name's Out of Office has now been enabled"
            }

        }

    Write-host "`nContinue editing Out of Office? Y/N?" -ForegroundColor Yellow
    $exit = read-host

        if ($exit -eq "n")
        {
        Write-Host "`nExiting script..."
        sleep -Milliseconds 100
        Return
        }
        
    Write-Host "`nWould you like to alter the current message? y/n" -ForegroundColor Yellow
    $edit = read-host

        if ($edit -eq "y")
        {
        write-host "`nEnter the message you would like to set as the internal Out of Office message" -ForegroundColor Yellow
        $internal = Read-Host

        $start = Get-Date

        write-host "`nDo you want the external message to be the same as the internal message? Y / N?" -ForegroundColor Yellow
        $ext = read-host

            if ($ext -eq "y")
            {
            Set-MailboxAutoReplyConfiguration -Identity "$name" -StartTime "$start" -AutoReplyState Enabled -InternalMessage "$internal" -ExternalMessage "$internal" -ExternalAudience 'All'
            }

            else
            {
            write-host "`nWhat would you like the external message to say?"
            $external = read-host
            Set-MailboxAutoReplyConfiguration -Identity "$name" -StartTime "$start" -AutoReplyState Enabled -InternalMessage "$internal" -ExternalMessage "$external" -ExternalAudience 'All'
            }


        write-host "`nThe Out of Office for $name has now been set as : `n" -ForegroundColor Yellow
        sleep -s 1
        $setinternal = Get-MailboxAutoReplyConfiguration -Identity $name | fl internalmessage
        write-host "Internal: " -ForegroundColor Yellow
        $setinternal
        $setexternal = Get-MailboxAutoReplyConfiguration -Identity $name | fl externalmessage
        write-host "External: " -ForegroundColor Yellow
        $setexternal

     }

 }