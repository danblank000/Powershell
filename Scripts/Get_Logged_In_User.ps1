DO
{
write-host "This script will show you who is currently logged into a specific computer" -ForegroundColor Yellow
sleep -Milliseconds 500
write-host "`nWhat Computer Number?"
$computername = Read-Host

try
{
$cputest = Get-ADComputer $computername

    if ($cputest)
    {
    $test = Test-Connection $computername -BufferSize 16 -Count 1 -Quiet
       
        if ($test -eq "true")
        {
        write-host "`n$computername is currently online!!" -ForegroundColor Green
        $samaccount = get-wmiobject win32_computersystem -computer $computername| select username
        $samaccount = $samaccount.username
        $samaccount = $samaccount.split('\')[1]
        $details = get-aduser $samaccount | select name, samaccountname
        $name = $details.name
        $sam = $details.samaccountname
        sleep -s 1
        Write-Host "`n$name ($sam) is currently logged into $computername"
        }
            
        else
        {
        Write-Host "`nAsset $computername is not online" -ForegroundColor Red
        } 
    }
}
catch
{
write-host "`nAsset $computername does not exist" -ForegroundColor Red
}

sleep -s 1
write-host "`nWould you like to run this again? Press Y to continue or N to quit : " -ForegroundColor Gray
$repeat = Read-Host

}
Until ($Repeat -eq "N")