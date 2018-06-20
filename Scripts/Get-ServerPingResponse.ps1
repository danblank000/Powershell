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