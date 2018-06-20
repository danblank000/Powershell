cls
$servers = ""
$server = ""
$failed = @()
$servers = get-adcomputer -filter * -SearchBase "OU=Domain Controllers,DC=kuits,DC=local" -SearchScope subtree | select name | Sort-Object name
    
Write-host "Testing DC's`n"
sleep -s 1    
    
    foreach ($server in $servers)
    {
    $server = $server.name
    $test = Test-Connection -BufferSize 16 -Count 1 -ea 0 $server

        if ($test)
        {
        write-host "Successful response from : $server" -ForegroundColor Green
        }

        else
        {
        write-host "Failed response from     : $server" -ForegroundColor red
        $failed += "Failed response from     : $server DOMAIN CONTROLLER"
        }
    }

write-host "`n********************************************************"
sleep -s 1

$servers = get-adcomputer -filter * -SearchBase "OU=Servers,DC=dwf,DC=local" -SearchScope subtree | select name | Sort-Object name 
    
Write-host "Testing other Servers`n "
sleep -s 1    
    
    foreach ($server in $servers)
    {
    $server = $server.name
    $test = Test-Connection -BufferSize 16 -Count 1 -ea 0 $server

        if ($test)
        {
        write-host "Successful response from : $server" -ForegroundColor Green
        }

        else
        {
        write-host "Failed response from     : $server" -ForegroundColor red
        $failed += "$server not responding"
        }
    }

write-host ""
write-host "`n********************************************************"
Write-Host "Complete list of non-responsive Servers"
write-host "********************************************************`n"
sleep -s 1

foreach($fail in $failed)
{
write-host "$fail" -ForegroundColor Red
}

$count = $failed.Count
write-host "`n********************************************************"
Write-host "There are currently $count unresponsive Servers`n"

$failed | out-file 'C:\Powershell\Output Files\ServerStatus.txt'