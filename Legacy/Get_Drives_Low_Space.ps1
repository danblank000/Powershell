$OnServers = @()
$OnServer = ""
$servers = ""
$server = ""
$OffServers = @()
$OffServer = ""
$Disks = ""
$Disk = ""

write-host "`n************************************" -BackgroundColor black -ForegroundColor Yellow
write-host "  *** Server Disk Space Check ***" -BackgroundColor black -ForegroundColor Yellow
write-host "************************************`n" -BackgroundColor black -ForegroundColor Yellow

sleep -m 500
write-host "Checking for DBA Tools PS Module...`n" -ForegroundColor DarkGray
sleep -m 500

if (Get-Module -ListAvailable -name dbatools)

    {
    write-host "DBATools module installed`n" -ForegroundColor DarkGreen
    }

else

    {
    write-host "DBATools module not installed..." -ForegroundColor darkRed
    wait -m 400
    write-host "Installing DBATools PS Module, please wait...`n" -ForegroundColor DarkGray
    Install-Module dbatools
    }

sleep -m 500
write-host "Gathering list of Servers...`n" -ForegroundColor DarkGray

$servers = (Get-ADComputer -SearchBase "ou=servers,dc=kuits,dc=local" -Filter * | select name | sort name).name

    foreach ($server in $servers)
    {
    
        if(Test-Connection $server -count 2 -ErrorAction SilentlyContinue)
        {
        write-host "$server is on and replying!" -ForegroundColor darkGreen
        $OnServers += $server
        }

        else
        {
        Write-Host "$server is not responding" -ForegroundColor darkRed
        $OffServers += $Server
        }
    
    
    }
Write-Host ""

    foreach($OnServer in $OnServers)
    {
    $Disks = Get-DbaDiskSpace $OnServer -ErrorAction SilentlyContinue

        foreach ($disk in $disks)
        {
            if ($disk.PercentFree -lt "10")
            {
            $Drive = $Disk.name
            $SerName = $Disk.Server
            write-host "Drive $Drive on Server $Sername has less than 10% disk space remaining" -ForegroundColor Red
            }
                        
        }

    }

Write-host "`nThe following servers were unavailable :"
    foreach ($OffServer in $OffServers)
    {
    write-host "$OffServer, " -ForegroundColor Gray
    }








