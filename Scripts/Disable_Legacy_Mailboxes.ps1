# Return users with active mailboxes and disabled AD accounts
$users = (Get-Mailbox -ResultSize Unlimited | ? { $_.ExchangeUserAccountControl -match “AccountDisabled” -and !$_.isLinked -and !$_.isResource } | select alias).alias

    foreach ($user in $users)
    {
    $user = $user.tostring()
    
# Excludes "Discovery Mailbox"
        if ($user -notlike "*discovery*")
        {
        $distname = ((get-aduser $user -Properties distinguishedname | select distinguishedname).distinguishedname).tostring()

# Excludes users not in "Ex KSL Staff" OU            
            if ($distname -like "*ex KSL*")
            {

# Returns last AD logon time of user            
            $time = (get-aduser $user | Get-ADObject -Properties lastlogon).lastlogon
            
# Convert time to datetime object            
            $date = [datetime]::FromFileTime($time)
            
# Sets the 90 day limit based on today's date            
            $90 = (get-date).AddDays(-90)

# If lastlogon date is more than 90 days ago, disable the mailbox                        
                if ($date -lt $90)
                {
                Disable-Mailbox $user -Confirm:$false
                write-host "$user's " -NoNewline -ForegroundColor Yellow
                write-host "mailbox has now been disabled" -ForegroundColor Green
                }

# If lastlogon date is less than 90 days ago, do not disable mailbox                
                else
                {
                write-host "$user's " -NoNewline -ForegroundColor Yellow
                write-host "account has not been inactive for more than 90 days.  The mailbox has now been disabled" -ForegroundColor red
                }
            }
        }
    }

# Updates status in exchange - all disabled mailboxes should appear in "Disconnected Mailboxes"
Clean-MailboxDatabase "Mailbox Database Kuits 1"
