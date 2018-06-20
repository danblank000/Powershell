$path = "\\ksldc01\MachineLogons\logonlog.txt"
$name = ""
$nameok = ""
$nametest = ""
$user = ""
$line = ""
$l = ""
$pc = ""
$newdate = ""
#title
write-host "`n`n*** Get Last Machine User Logged Into ***`n`n" -ForegroundColor Yellow -BackgroundColor black

#region <Checking User Exisits>
 DO
    {
    write-host "Enter the name of the user to query?" -ForegroundColor Yellow
    $name = read-host
    $nametest = get-aduser -filter * | where {$_.name -like "*$name*"}
    
        if ($nametest)
        {
        write-host "`nUser $name exists" -ForegroundColor Green
        $user = get-aduser -filter * | where {$_.name -like "$name"} | select samaccountname
        $user = $user.samaccountname
        $nameok = "ok"
        write-host "`n$name's username is $user" -ForegroundColor Gray
        }

        else
        {
        write-host "No user called $name exists" -ForegroundColor Red
        sleep -m 500
        }

    }
    Until ($nameok -eq "OK")
    sleep -m 500
#endregion

#region <Search Login Log File>

$pattern = "(?<date>\d{2}\/\d{2}\/\d{4} \d{2}:\d{2}:\d{2})\t$user\t(?<computer>\w{1,7})$"
#select-String -Path $path -Pattern "$pattern"
$line = (gc $path) | ? { $_ -match $pattern } | select -last 2
    foreach ($l in $line)
    {
    $l = $l.Split()
    $pc = $l[3]
    $newdate =$l[0]
    $time = $l[1]
    write-host "`n$name logged on to $pc on $newdate at $time`n" -ForegroundColor Cyan
    }
#endregion
