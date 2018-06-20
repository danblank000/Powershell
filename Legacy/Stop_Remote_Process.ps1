$Computer = Read-Host "Enter Host"
$Credentials = Get-Credential -username ksl\admin_db -Message "Enter Password"
# Testing connection to computer

if (test-connection $computer -BufferSize 16 -Count 1 -ea 0 -quiet) 
# If computer is contactable
    {
    write-host "$computer is online" -foregroundcolor "green"
    sleep -s 1
    cls
    get-process -ComputerName $Computer | select-object ProcessName | Sort-Object processname
    write-host "`nEnter Process name to kill" -ForegroundColor Magenta
    $ProcessName = read-host
    Write-Host ""

        if (get-process $processname -ComputerName $Computer)
        # if process is running
            {
            Invoke-Command -ComputerName $Computer -Scriptblock {get-process $args[0]| Stop-Process -Force} -argumentlist $processname
            sleep -s 1
            Write-Host "`n$processname has been stopped successfully" -ForegroundColor Green
            }

        else
        # if process is not running
            {
            Write-Host "No process is running on $computer called $processname" -foregroundcolor "red"
            Read-Host "Press enter to exit"
            }    
            
    }
else
# if computer is not contactable 
    {
     write-host "$computer is not responding" -foregroundcolor "red"
     Read-Host "Press enter to exit"
    }