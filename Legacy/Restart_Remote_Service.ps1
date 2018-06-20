DO {

# Setting Variables

Write-Host "This is the Remote Service Restart script" -ForegroundColor Yellow

$ServiceName = read-host 'What service do you want to restart?'
$ComputerName = read-host 'What Computer does it need restarting on?'

# Testing connection to computer

if (test-connection $computername -BufferSize 16 -Count 1 -ea 0 -quiet) 

# If computer is contactable

{
     write-host "$computername is online" -foregroundcolor "green"
     $ServiceName2 = "*" + $ServiceName + "*"

     # If Service exists

     if (get-service $servicename2 -ComputerName $ComputerName)

        {
            write-host "This is the current state of the £servicename service"
            Get-Service -ComputerName $computername -Name $servicename2
            get-service -name $servicename2 -computername $computername | set-service -status stopped
            start-sleep -s 2
            get-service -name $servicename2 -computername $computername | set-service -status running
            write-host "The $servicename Service has been successfully restarted" -foregroundcolor "green"
            Get-Service -ComputerName $computername -Name $servicename2
            $repeat = read-host 'Press N to exit or any key to run again'
        }

     # If Service does not exist

     else

        {
            
            start-sleep -s 2
            Write-Host "No service exists on $computername called $servicename" -foregroundcolor "red"
            $repeat = Read-Host 'Would you like to try again? Press Y to continue or N to exit'
                        
            
        }   

}
else

# if computer is not contactable 

    {
     write-host "$computername is offline" -foregroundcolor "red"
     $repeat = read-host 'Would you like to try again? Press Y to continue or N to exit'

    }
}
Until ($repeat -eq "N")
