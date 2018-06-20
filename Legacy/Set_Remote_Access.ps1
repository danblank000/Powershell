    Function Set_Remote_Access
    {

        param
        (
        [Parameter(Mandatory=$True,Position=0)]
        [string]$user
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