TRY
{Remove-Variable computers}
Catch {}

$computers = Get-ADComputer -SearchBase "ou=desktops,ou=ksl computers,dc=kuits,dc=local" -Filter * | Where-Object { (Get-Content C:\stuff\bhlog.txt) -notcontains $_.Name } | select -ExpandProperty name | sort name
$computers += Get-ADComputer -SearchBase "ou=laptops,ou=ksl computers,dc=kuits,dc=local" -Filter * | Where-Object { (Get-Content C:\stuff\bhlog.txt) -notcontains $_.Name } | select -ExpandProperty name | sort name
$logpath = "C:\stuff\BHLog.txt"

    foreach ($computer in $computers)
    {

    $test = Test-Connection $computer -Count 1 -Quiet
    
        if ($test)
        {
        
        $containsword = Get-Content $LogPath | Where-Object { $_.Contains("$computer")}
        If(!($containsWord))
        
            {
            write-host "$computer receiving file"
            Copy-Item '\\kslnas01\gpapps$\Bighand\v5.1.1.1\BigHand.Client.exe.config' -Destination "\\$computer\c$\Program Files (x86)\BigHand\BigHand" -Force
            Add-Content $logpath $computer
            }
        
        }

    }