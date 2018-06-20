#region <SET-REMOTEACCESS >

##############################################################################
#.SYNOPSIS
# Give's a user remote access permissions
# 
#.DESCRIPTION
# Add's a user to the AD groups "Remote Users", "Remote Workers" and "GPolTS".  also set Dial-In settings to allowed
#
#.PARAMETER User
# The username being queried
#
#.EXAMPLE
# Set-RemoteAccess -User Joe.Bloggs
##############################################################################
    Function Set-RemoteAccess
    {

        param
        (
        [Parameter(Mandatory=$True,Position=0)]
        [string]$User
        )
        
        $nametest = get-aduser $user
    
            if ($nametest)
            {
            write-host "`nUser $user exists" -ForegroundColor Green
            }

            else
            {
            write-host "No user called $user exists" -ForegroundColor Red
            sleep -m 500
            }


        set-aduser $user -replace @{msnpallowdialin=$true}
        Write-host "`nThe Remote Access Dial-In settings for $user have now been set to Allow Access" -ForegroundColor Gray
        sleep -s 1
        Add-ADGroupMember "Remote Users" $user
        Write-host "$user has been added to the Remote Users group" -ForegroundColor Gray
        sleep -s 1
        Add-ADGroupMember "GPOLTS" $user
        Write-host "$user has been added to the GPolTS group" -ForegroundColor Gray
        sleep -s 1
        Add-ADGroupMember "Remote Workers" $user
        Write-host "$user has been added to the Remote Workers group" -ForegroundColor Gray
        sleep -s 1
        write-host "`n$user is now fully configured for remote working" -ForegroundColor Green
        sleep -s 1

    }
#endregion


#region <SET-RESETPASSWORD>

##############################################################################
#.SYNOPSIS
# Reset's a user's password
# 
#.DESCRIPTION
# Sets a users password back to default
#
#.PARAMETER User
# The username being queried
#
#.EXAMPLE
# Set-ResetPassword -User Joe.Bloggs
##############################################################################
    Function Set-ResetPassword
    {

        Param
        (
        [Parameter(Mandatory=$True,Position=0)]
        [string]$User
        )

        $Paswd = ConvertTo-SecureString 'Kuits123' –asplaintext –force 

        Set-ADAccountPassword -Identity $User -NewPassword $Paswd
        Set-ADAccountControl $User -PasswordNeverExpires $false -CannotChangePassword $false
        Set-ADUser $User -ChangePasswordAtLogon $True
        Unlock-ADAccount $User

    }
#endregion



#region <GET-PASSWORDEXPIRATION>

##############################################################################
#.SYNOPSIS
# Get's a users password expiration date
# 
#.DESCRIPTION
# Queries AD and returns a users password expiration date
#
#.PARAMETER User
# The username being queried
#
#.EXAMPLE
# Get-PasswordExpiration -User Joe.Bloggs
##############################################################################
    Function Get-PasswordExpiration
    {

        param
        (
        [Parameter(Mandatory=$True,Position=0)]
        [string]$User
        )
        
        Get-ADUser $user –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

    } 
#endregion



#region <ADD-PHOTO>

##############################################################################
#.SYNOPSIS
# Sets a user's AD / Exchange photo
# 
#.DESCRIPTION
# Looks in kslsrv04\intranet\photos\Outlook for a .jpg with their name (eg "Joe Bloggs.jpg") and sets as the AD / Excahgne photo.
# Note : it must be no more than 100px x 100px and <10kb
#
#.PARAMETER Name
# The name of the user who's photo needs setting
#
#.EXAMPLE
# Add-Photo -Name "Joe Bloggs"
##############################################################################
    Function Add-Photo    
    {

        param
        (
    	[Parameter(Mandatory=$True,Position=0)] 
	[ValidateNotNull()] 	
	[string]$Name
    	)

	Import-RecipientDataProperty -Identity "$name" -Picture -FileData ([Byte[]]$(Get-Content -Path "\\kslsrv04\intranet\photos\Outlook\$name.jpg" -Encoding Byte -ReadCount 0))
	
    }
#endregion


#region <GET-MACHINEUSERLOGGEDINTO>

##############################################################################
#.SYNOPSIS
# Finds the machine a user is logged in to
# 
#.DESCRIPTION
# Queries the 4 mainly accessed server (KSLNAS01, KSLPARTNER, KSLSQL01 and KSLFS01) and checkls for active session from the specified user
#
#.PARAMETER User
# Username to quert
#
#.EXAMPLE
# Get-MachineUserLoggedInTo -User Joe.Bloggs
##############################################################################
Function Get-MachineUserLoggedInTo
    {

    param
    (
    [Parameter(Mandatory=$True,Position=0)] 
    [ValidateNotNull()] 
    [string]$User
    )
    
    $i = 0

    # Gets all DCs from the DCs OU in kuits.local:
    write-host "`nGetting server list." -ForegroundColor Cyan
    $servers = get-adcomputer -filter {(name -like "*KSLNAS01*") -or (name -like "kslpartner") -or (name -like "kslsql01*") -or (name -like "kslfs01")} | sort-object name
    
    # Starts a job for each server
    write-host ""
    write-host 'Querying' $servers.count 'servers.' -ForegroundColor Yellow
    $servercount = $servers.count
    foreach ($server in $servers)
        {
        # Querying each of the servers for connections to shares    
        $servername = $server.name
        $userSessions = Get-WmiObject Win32_ServerConnection -computername $servername -Credential $usercredential
 
        #progress bar
        write-host "Querying $servername" -ForegroundColor DarkYellow
    
        Write-Progress -activity "Servers Processed" -status "Percent Complete : " -PercentComplete (($i++ / $Servers.Length)  * 100)

            # Filtering out the results
            foreach ($userSession in $userSessions)
            {
        
                if ($userSession.username -eq $user)
                {
                #convert ip to hostname
                $IPAddress = $userSession.computername 
                $hostname = Get-WmiObject win32_computersystem -Computer $IPAddress -Credential $usercredentials

                $found = "yes"

                #select user details
                $userDetails = [string]::Format("User {0} is logged on to {1}", $userSession.UserName, $hostname.name)
                
                #print user details
                Write-Host "`n$userDetails" -ForegroundColor Green
                
                
                    if ($continue -Ne "C")
                    { 
                    return
                    }                
                
                }   
                               
                else
                {
                #if no instances are found, continue to search next server
                }  
       
            }
        
        }

     if ($found -ne "yes")
        {
        write-host "I can't find any PCs with $user logged in to them" -ForegroundColor Red
        }

}
#endregion


#region <SET-OUTOFOFFICE>

##############################################################################
#.SYNOPSIS
# Sets a users out of office auto-reply
# 
#.DESCRIPTION
# Use this function to return a users out of office, enable / disable it, and edit it.
#
#.PARAMETER User
# Username to set out of office of
#
#.EXAMPLE
# Set-OutOfOffice -User Joe.Bloggs
##############################################################################
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
            Set-MailboxAutoReplyConfiguration $user -AutoReplyState disabled
            write-host "$user's Out of Office has now been disbaled"
            }

        }

        if ($status -eq "disabled")
        {
        Write-Host "Would you like to enable the current out of office? Y/N" -ForegroundColor Yellow
        $yn = read-host

            if ($yn -eq "y")
            {
            Set-MailboxAutoReplyConfiguration $user -AutoReplyState enabled
            Write-Host "$user's Out of Office has now been enabled"
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
            Set-MailboxAutoReplyConfiguration -Identity "$user" -StartTime "$start" -AutoReplyState Enabled -InternalMessage "$internal" -ExternalMessage "$internal" -ExternalAudience 'All'
            }

            else
            {
            write-host "`nWhat would you like the external message to say?"
            $external = read-host
            Set-MailboxAutoReplyConfiguration -Identity "$user" -StartTime "$start" -AutoReplyState Enabled -InternalMessage "$internal" -ExternalMessage "$external" -ExternalAudience 'All'
            }


        write-host "`nThe Out of Office for $user has now been set as : `n" -ForegroundColor Yellow
        sleep -s 1
        $setinternal = Get-MailboxAutoReplyConfiguration -Identity $user | fl internalmessage
        write-host "Internal: " -ForegroundColor Yellow
        $setinternal
        $setexternal = Get-MailboxAutoReplyConfiguration -Identity $user | fl externalmessage
        write-host "External: " -ForegroundColor Yellow
        $setexternal

     }

 }

#endregion <SET-OUTOFOFFICE>


#region <GET-SERVERPINGRESPONSE>

##############################################################################
#.SYNOPSIS
# Checks ping response for all server
# 
#.DESCRIPTION
# Use this function to Ping each enabled server and check the response
#
#.EXAMPLE
# Get-ServerPingResponse
##############################################################################
Function Get-ServerPingResponse
{

$servers = (Get-ADComputer -SearchBase "ou=servers,dc=kuits,dc=local" -Filter {enabled -eq $true} | select name | sort name).name

    foreach ($Server in $servers)
    {
    $test = Test-Connection $server -Count 1 -Quiet
    
        if (!$test)
        {
        write-host "check $server ping response" -ForegroundColor Red
        }

        else
        {
        write-host "$server is ok" -ForegroundColor Green
        }
        
    }

}
#endregion


#region <GET-LOGGEDINUSER>

##############################################################################
#.SYNOPSIS
# Gets user currently logged in to pc
# 
#.DESCRIPTION
# Gets user currently logged in to pc
#
#.PARAMETER Computer
# Name of computer being queried
#
#.EXAMPLE
# Get-LoggedInUser -Computer pcm1002
##############################################################################
Function Get-LoggedInUser
{

    [cmdletbinding()]
    param(
    [Parameter(Mandatory=$True,Position=0)] 
    [ValidateNotNull()] 
    [string]$Computer
    )


    get-wmiobject win32_computersystem -computer $Computer | select username
    
}