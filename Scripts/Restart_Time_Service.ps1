$computers = Get-ADComputer -Filter {name -like "pc*"} | select -ExpandProperty name

    foreach ($computer in $computers)
    {

    $test = Test-Connection $computer -Count 1 -Quiet
        
        if($test)
        {
        Write-Host "***"
        write-host "$computer is on" -ForegroundColor Green
        Get-Service -ComputerName $computer -DisplayName "*windows time*" | Set-Service -Status Stopped
        Get-Service -ComputerName $computer -DisplayName "*windows time*" | Set-Service -Status Running
        }

        else
        {
        Write-Host "***"
        Write-Host "$computer is off" -ForegroundColor Red
        }

    }
