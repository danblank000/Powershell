cls
$test = ""
$path = ""
$continue = ""
$ammend = ""
$choice = ""
$indorgrp = ""
$remove = ""
$ammend = ""
$adduser = ""
$addgroup = ""

DO
{
cls
write-host "Please enter the path of the folder you wish to query" -ForegroundColor Yellow
$path = read-host 
$test = Test-path $path

    # Display Permissions
    if ($test -eq "true")
    {
    write-host ""
    write-host "$path is online" -ForegroundColor green
    sleep -s 1
    get-acl $path | select -ExpandProperty access | select identityreference, filesystemrights | ft
    write-host "Would you like to ammend the permissions on this folder? Press Y for yes or N for no" -foregroundcolor yellow
    $ammend = read-host
    
       
        # Ammend Permissions
        if ($ammend -eq "y")
        {
        write-host "`nAre you wanting to add, remove or ammend folder permissions?" -ForegroundColor Yellow
        sleep -Milliseconds 500
        Write-Host "`n`tPress 1 to add permissions`n`tPress 2 to remove permissions`n`tPress 3 to ammend existing permissions."
        $choice = read-host
        
            # Add Permissions
            if ($choice -eq "1")
            {
            Write-Host "`nDo you want to add an individual user or a security group to the permissions?" -ForegroundColor Yellow
            sleep -Milliseconds 500
            write-host "`n`tPress 1 for an individual user`n`tPress 2 for a Security Group"
            $indorgrp = Read-Host
            
                # Individual Permissions
                if ($indorgrp -eq "1")
                {
                
                    do
                    {
                    Write-Host "`nPlease enter the username of the person requiring permissions" -ForegroundColor Yellow
                    $adduser = Read-Host
                
                        try
                        {
                        $testuser = get-aduser $adduser
                        }

                        Catch [Exception]
                        {
                        write-host "`n$adduser does not seem to exist, would you like to try another user? Press Enter to Try again" -ForegroundColor Red
                        $continue = Read-Host
                        $test = "FALSE"
                        Continue
                        }

                    $test = "TRUE"
                }
                    Until ($test -eq "true")

                        # test user exists
                        if($test -eq "true")
                        {
                        $testusername = $testuser.Name
                        write-host "`nWhat permissions would you like to give to $testusername ($adduser) on $path" -ForegroundColor Yellow
                        write-host "`n`tPress 1 for Full Access (add, remove, modify)`n`tPress 2 for Modify (add, modify but NOT remove)`n`tPress 3 for Read Only"
                        $indpermissions = Read-Host
                    
                            if($indpermissions -eq "1")
                            {
                            sleep -s 1
                            Write-Host "`nFull Access permissions have been given to $testusername ($adduser) on $path" -ForegroundColor Green
                            }

                            elseif($indpermissions -eq "2")
                            {
                            sleep -s 1
                            Write-Host "`nModify permissions have been given to $testusername ($adduser) on $path" -ForegroundColor Green
                            }

                            elseif($indpermissions -eq "3")
                            {
                            sleep -s 1
                            Write-Host "`nRead Only permissions have been given to $testusername ($adduser) on $path" -ForegroundColor Green
                            }
                    
                        }

                        elseif ($test -eq "false")
                        {
                        write-host "$adduser does not seem to exist, would you like to try another user?  Press Y for yes or N for No"
                        $continue = Read-Host
                        }
            
    }
    # Security Group Permissions
                elseif ($indorgrp -eq "2")
                {
                
                    do
                    {
                    Write-Host "`nPlease enter the name of the Group requiring permissions" -ForegroundColor Yellow
                    $addgroup = Read-Host
                
                        try
                        {
                        $testgroup = get-adgroup $addgroup
                        }

                        Catch [Exception]
                        {
                        write-host "`n$addgroup does not seem to exist, would you like to try another group? Press Enter to Try again" -ForegroundColor Red
                        $continue = Read-Host
                        $test = "FALSE"
                        Continue
                        }
                    $test = "TRUE"
                }
                    Until ($test -eq "true")
                    
                    
                        # test group exists
                        if($test -eq "true")
                        {
                        $testgroupname = $testgroup.Name
                        write-host "`nWhat permissions would you like to give to $testgroupname on $path" -ForegroundColor Yellow
                        write-host "`n`tPress 1 for Full Access (add, remove, modify)`n`tPress 2 for Modify (add, modify but NOT remove)`n`tPress 3 for Read Only"
                        $grppermissions = Read-Host

                            if($grppermissions -eq "1")
                            {
                            sleep -s 1
                            Write-Host "`nFull Access permissions have been given to $testgroupname on $path" -ForegroundColor Green
                            }

                            elseif($grppermissions -eq "2")
                            {
                            sleep -s 1
                            Write-Host "`nModify permissions have been given to $testgroupname on $path" -ForegroundColor Green
                            }

                            elseif($grppermissions -eq "3")
                            {
                            sleep -s 1
                            Write-Host "`nRead Only permissions have been given to $testgroupname on $path" -ForegroundColor Green
                            }
                    
                        }

                        else
                        {
                        write-host "$addgroup does not seem to exist, would you like to try another user?  Press Y for yes or N for No" 
                        }

        }

       }

              # Remove Permissions
       elseif ($choice -eq "2")
       {
       Write-Host "`nPlease enter the user or security group who's permissions you would like to remove" -ForegroundColor Yellow
       $remove = read-host
       }

       # Ammend Permissions
       elseif ($choice -eq "3")
       {
       Write-Host "`nPlease enter the user or security group who's permissions you would like to ammend" -ForegroundColor Yellow
       $ammend = read-host
       }
    }
    
    # Path is not accessible
    else
    {
    write-host ""
    write-host "$path cannot be found" -ForegroundColor red
    write-host ""
    }

# Try Again?
sleep -s 1
write-host "`nWould you like to run this again on another folder? Press Y for yes or N for no"
$continue = read-host
}
}
Until ($continue -eq "N") 
