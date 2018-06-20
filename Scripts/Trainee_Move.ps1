######################################################
#                                                    #
######## Trainee Move Script - Daniel Blank ##########
#                                                    #
######################################################
#                                                    #
######################################################
#                                                    #
######## Latest version Date - 01 / 09 / 2015 ########
#                                                    #
######################################################

Do
{
cls
$continue = ""
$ticketcheck = ""
$ticket = ""
$ticketref = ""
$nameok = ""
$name = ""
$nametest = ""
$nameok = ""
$ticketnew = ""
$continue = ""
$user = ""
$department = ""
$trdept = ""

write-host "*** Trainee Moves***`n" -ForegroundColor Yellow
sleep -m 500

### Spiceworks Ticket Details
write-host "`nIs there a Spiceworks ticket logged for the Trainee Move? y/n" -ForegroundColor Cyan
$ticketcheck = read-host

    if ($ticketcheck -eq "y")
    {
    $ticket = "1"
    write-host "`nPlease enter the Spiceworks ticket refernce number"
    $ticketref = read-host
    sleep -s 1
    write-host "`nThis ticket will be updated at the end of this process "
    }

    elseif ($initialscheck -ne "y")
    {
    write-host "`nWould you like to log a Spiceworks ticket? y/n" -ForegroundColor Cyan
    $ticketnew = read-host

        if ($ticketnew -eq "y")
        {
        $ticket = "2"
        sleep -s 1
        Write-Host "`nA new ticket will be logged at the end of this process" -ForegroundColor Gray
        }

        elseif ($ticketnew -ne "y")
        {
        $ticket = "3"
        sleep -s 1
        write-host "`nNo ticket will be logged for this New Starter" -ForegroundColor Gray
        }
    }

### Checking the users name
DO
{
$name = read-host "`nEnter the name"
$nametest = get-aduser -filter * -Properties * | where {$_.name -like "*$name*"}
    
    if ($nametest)
    {
    write-host "`nUser $name exists" -ForegroundColor Green
    $user = get-aduser -filter * -Properties * | where {$_.name -like "$name"} | select samaccountname
    $user = $user.samaccountname
    $nameok = "ok"
    write-host "`n$name's username is $user"
    $department = get-aduser $user -Properties department | select department
    $department = $department.department
    }

    else
    {
    write-host "No user called $name exists" -ForegroundColor Red
    sleep -m 500
    }

}
Until ($nameok -eq "OK")
sleep -m 500

### Department New

write-host "`nWhat department will $name be moving to? (Please ensure you use the FULL DEPARTMENTAL NAME!!!)"
$trdept = read-host

    If ($trdept -eq "intellectual property")
    {
    $newpath = "OU=IP,OU=FeeEarners,OU=KSL Staff,DC=kuits,DC=local"
    }

    elseif ($trdept -eq "banking")
    {
    $newpath = "OU=Banking and Real Estate Finance,OU=FeeEarners,OU=KSL Staff,DC=kuits,DC=local"
    }

    else
    {
    $newpath = "OU=$trdept,OU=FeeEarners,OU=KSL Staff,DC=kuits,DC=local"
    }


#applying changes

Get-ADUser -identity $user | Move-ADObject -TargetPath "$newpath"
sleep -s 1
set-aduser -Identity $user -Department $trdept

### EMAIL to spiceworks and IT Team

write-host "`n **** Please wait for process to complete ****" -ForegroundColor Yellow

if ($ticket -eq "1")
{
Send-MailMessage -From ITTeam@kuits.com -Subject "[Ticket #$ticketref]" -To ITDept@kuits.com -Body "Trainee $name has been moved to the $trdept department." -SmtpServer EXCHSRV2.kuits.local
}

elseif ($ticket -eq "2")
{
Send-MailMessage -From ITTeam@kuits.com -Subject "Trainee Move - $name" -To ITDept@kuits.com -Body "Trainee $name has been moved to the $trdept department." -SmtpServer EXCHSRV2.kuits.local
}


### repeat
write-host "`nwould you like to process another trainee move? type n to exit" -foregroundcolor yellow
$continue = read-host

}

Until ($continue -ne "y")