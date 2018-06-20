############################################################################################
#                                                                                          #
#                                                                                          #
# This script sets up the Powershell profile and scripting directory for 1st line analysts #                                                                                        #
#                                                                                          #
#                                                                                          #
############################################################################################

#setting initial variable for file import
$team = Import-Csv C:\Powershell\Team_Assett_Tags.csv
foreach ($user in $team)
#for each user in the csv file
{
    $ADM = $user.User_Name + "-adm"
    $pc = $user.Asset_Tag
    if (Test-Connection $pc -count 1 -Quiet)
        #testing connection to the computer
        {
        Write-Host "$pc is currently online" -ForegroundColor cyan
        sleep -s 1
        $test = test-path \\$pc\c$\users\$adm\documents\WindowsPowershell\Microsoft.Powershell_profile.ps1
        
            if ($test -eq 'true')
                #if profile directory exists
                {
                write-host '$Profile path already exists' -ForegroundColor green    
                Copy-Item 'C:\Powershell\1st Line\Microsoft.Powershell_profile.ps1' -Destination "\\$pc\c$\users\$adm\documents\WindowsPowershell"
                write-host "Profile has now been updated" -ForegroundColor DarkGreen
                sleep -s 1
                }

            else
                #if profile directory does not exist
                {
                write-host "The Powersehll Profile directory does not currently exist on $pc"
                sleep -s 1
                New-Item \\$pc\c$\users\$adm\documents\WindowsPowershell -ItemType directory 
                Write-Host "The Powershell Profile directory has been created" -ForegroundColor Green
                sleep -s 1
                Copy-Item 'C:\Powershell\1st Line\Microsoft.Powershell_profile.ps1' -Destination "\\$pc\c$\users\$adm\documents\WindowsPowershell"
                write-host "Profile file copied to path" -ForegroundColor Green
                sleep -s 1
                Write-Host "Retesting file path"
                sleep -s 1
                $test2 = (Test-Path \\$pc\c$\users\$adm\documents\WindowsPowershell\Microsoft.Powershell_profile.ps1)
                    
                    if ($test2 -eq 'true')
                    #confirming the the profile file copied accross
                    {
                    write-host "Confirmed that the Profile file has copied over" -ForegroundColor Green
                    sleep -s 1
                    }
                    else
                    #if the profile file did not copy accross
                    {
                    Write-Host "Profile file copy to \\\\$pc\c$\users\$adm\documents\WindowsPowershell has failed" -ForegroundColor red
                    sleep -s 1
                    }    
        }
    $test3 = Test-Path \\$pc\C$\Powershell

        if($test3 -eq 'true')
        #teting if C:\Powershell exists
        {
        Write-Host "Powershell script directory on $pc already exists" -ForegroundColor green
        Copy-Item 'C:\Powershell\1st Line\Powershell' -Destination "\\$pc\c$\Powershell" -recurse -Force
                Write-Host "The Powershell script directory has been updated" -ForegroundColor DarkGreen
        sleep -s 1
        }

        else
        #if C:\powershell does not exist
        {
        Copy-Item 'C:\Powershell\1st Line\Powershell' -Destination "\\$pc\c$\Powershell" -recurse
        Write-Host "Scripts copied to script directory" -ForegroundColor Green
        sleep -s 1
        write-host "Confirming directory creation..."
        sleep -s 1
        $test4 = test-path \\$pc\c$\Powershell
                           
            if($test4 -eq 'true')
            #confirming the C:/powershell has been created
            {
            write-host "\\$pc\c$\Powershell now exists" -ForegroundColor Green
            sleep -s 1
            }
                            
            else
            #if creating C:\powershell fails
            {
            write-host "Creating directory \\$pc\C$\Powershell has failed" -ForegroundColor Red
            sleep -s 1
            }

            }

        }
    else
        #if computer is offline
        {
        Write-Host "$pc is not contactable" -ForegroundColor Red
        sleep -s 1
                }

}
read-host "Press ENTER to exit"
    

  