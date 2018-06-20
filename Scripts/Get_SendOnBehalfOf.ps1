DO
{

# clearing variables
$remove = ""
$repeat = ""
$user = ""
$usertest = ""
$delegates = ""
$delegate = ""
$line = ""
$line2 = ""
$leavers = ""
$Deligates =@()

cls
Write-Host "  ### Send on Behalf of Permissions Finder###  "
write-host ""
sleep -Milliseconds 250

# get the username
write-host "Who's mailbox do you want to query: " -ForegroundColor Yellow
$name = read-host
Write-Host ""

    # test the user exists
    try
    {
    $usertest = Get-ADUser -filter * | where {$_.name -eq "$name"} | select samaccountname
    $usertest = $usertest.samaccountname
    
        # if user exists get public delegate info
        if ($usertest)
        {
        cls
        write-host "    Retrieving Public Delegate info for $name" -ForegroundColor Cyan
        write-host ""
        sleep -s 1

        $delegates = get-aduser $usertest -Properties * | select publicdelegates
        $delegates = $delegates.publicdelegates
        $count = $delegates.Count

        Write-Host "$name has $count public delegates"
        Write-Host ""
        Write-Host ""
        sleep -s 1


            # format the delegate info
            foreach ($delegate in $delegates)
            {

            $line = $delegate.split(',')[0]
            $line2 = $delegate.Split(',')[1]
            $line = $line -replace "cn=" , ""
            $line2 = $line2 -replace "OU=" , "in OU : "
            $Email = $line -replace " " , "."
            $Email = $Email + "@kuits.com"

                # colour the delegate info
                if ($line2 -ne "in OU : Ex KSL Staff")
                {
                write-host "$line $line2"
                $Deligates += $Email
                }

                else
                {
                write-host "$line $line2" -ForegroundColor Red
                $leavers = "true"
                }

            }
        }

        # if leavers exist should they be removed
        if ($leavers -eq "true")
        {
        write-host ""
        write-host ""
        sleep -s 1
        write-host "  *** It appears that some of the Public Delegates for $usertest are Leavers ***  "
        Write-Host "  *** Press Y to remove these Leavers from the Public Delegates or Press N to continue ***  "
        $remove = read-host

            # remove leavers
            if ($remove -eq "Y")
            {
            Write-Host "Removing the Leavers from Public Delegates"
            get-mailbox $usertest
            Set-Mailbox $usertest -GrantSendOnBehalfTo $deligates
            sleep -s 1
            Write-Host "Leavers have now been removed"
            sleep -s 1
            Write-Host " *** NOTE : Please allow 15 mins replication time *** " -ForegroundColor Red
            sleep -s 1
            }

            # do not remove leavers
            else
            {
            sleep -s 1
            }
        
        }

        
     }
     #if user does not exist
    catch
    {
    cls
    Write-Host "    The username $user does not exist" -ForegroundColor Red
    
    sleep -s 1
    }

# repeat
Write-Host ""
Write-Host ""
write-host "Would you like to run this for another user? Press Y to run again or N to quit..." -ForegroundColor Yellow
$repeat = read-host
cls
}
Until ($repeat -eq "n") 
