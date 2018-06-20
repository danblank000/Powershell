do{ 
cls
$username = ""
$testuser = ""
$dispname = ""
$HDrive = ""
$testechopath = ""
$Dir = ""
$path = ""
$oldfiles = ""
$oldcount = ""
$del = ""
$dircount = ""
$dircount2 = ""
$Dir2 = ""
write-host "This script will clear Echo Directories for DMS Users" -ForegroundColor Yellow
Write-host "`nWho's echo directory needs clearing (Please enter the USERNAME) : " -NoNewline
$username = read-host
try
{
$testuser = get-aduser $username
    if ($testuser)
    {
    $dispname = $testuser.Name
    write-host "`nSearching for $dispname" -ForegroundColor Cyan
    sleep -s 1
    $HDrive = get-aduser $username -Properties homedirectory | select homedirectory
    $HDrive = $HDrive.homedirectory
    write-host "`n$dispname's H: drive has been located at: " -NoNewline
    $HDrive
    sleep -s 1
    $testechopath = test-path $HDrive\NRTEcho\Active\$username
        if ($testechopath -eq "true")
        {    
        $Dir = Get-ChildItem "$HDrive\NRTEcho\Active\$username" -File
        $dircount = $dir.Count
        write-host "`n$dircount " -NoNewline -ForegroundColor Green
        write-host "files have been found in $dispname's Echo Directory"
        $path = "$HDrive\NRTEcho\Active\$username"
        $oldfiles = Get-ChildItem "$path" -File | ? {$_.lastwritetime -lt (Get-Date).adddays(-30)}
        sleep -s 1
        $oldcount = $oldfiles.Count
        Write-Host "There are " -NoNewline
        Write-Host "$oldcount" -ForegroundColor Green -NoNewline
        Write-Host " files older than 30 days in the Echo directory"
        if ($oldcount -ne "0")
        {
            sleep -m 500
            write-host "`nWould you like to display a list of these older files? (Y/N)"
            $list = read-host
                if ($list -eq "y")
                {
                write-host ""
                $oldfiles | select name, lastwritetime| Sort-Object name
                sleep -s 1
                Write-Host "`nWould you like to delete these older files now? (Y/N)"
                $del = read-host
                    if ($del -eq "y")
                    {           
                        foreach ($file in $oldfiles)
                        {
                        $file | Remove-Item -Force
                        }
                    write-host "`nDeleting files...." -f DarkGray
                    sleep -s 1
                    $Dir2 = Get-ChildItem "$HDrive\NRTEcho\Active\$username"
                    $dircount2 = $dir2.Count
                    write-host "The files have been deleted" -f DarkGray
                    sleep -m 500
                    write-host "`nThere are now " -NoNewline
                    write-host "$dircount2" -ForegroundColor Green -NoNewline
                    Write-Host " files in the Echo Directory"
                    sleep -m 500
                    write-host "`nWould you like to run this script for another user? (Y/N)"
                    $continue = read-host
                    }
                    elseif ($del -ne "y")
                    {
                    Write-host "`nNo Files have been deleted" -ForegroundColor DarkGray
                    sleep -s 1
                    write-host "`nWould you like to run this script for another user? (Y/N)"
                    $continue = read-host
                    }
                }
                elseif ($list -ne "y")
                {
                Write-Host "`nWould you like to delete these older files now? (Y/N)"
                $del = read-host
                    if ($del -eq "y")
                    {           
                        foreach ($file in $oldfiles)
                        {
                        $file | Remove-Item -Force
                        }
                    write-host "`nDeleting files...." -f DarkGray
                    sleep -s 1
                    $Dir2 = Get-ChildItem "$HDrive\NRTEcho\Active\$username"
                    $dircount2 = $dir2.Count
                    write-host "The files have been deleted" -f DarkGray
                    sleep -m 500
                    write-host "`nThere are now " -NoNewline
                    write-host "$dircount2" -ForegroundColor Green -NoNewline
                    Write-Host " files in the Echo Directory"
                    sleep -m 500
                    write-host "`nWould you like to run this script for another user? (Y/N)"
                    $continue = read-host
                    }
                    elseif ($del -ne "y")
                    {
                    Write-host "`nNo Files have been deleted" -ForegroundColor DarkGray
                    sleep -s 1
                    write-host "`nWould you like to run this script for another user? (Y/N)"
                    $continue = read-host
                    }
                }
            }
        else
        {
        sleep -s 1
        write-host "`nThere are no legacy files to delete in this folder" -ForegroundColor Red
        sleep -s 1
        write-host "`nWould you like to run this script for another user? (Y/N)"
        $continue = read-host
        }
        }
        else
        {
        write-host "`nThere does not appear to be an Echo Directory on the H: Drive for $dispname" -ForegroundColor Red
        sleep -s 1
        write-host "`nWould you like to run this script for another user? (Y/N)"
        $continue = read-host
        }
    }
}
catch
{
write-host "`nI can not find a user with the username " -NoNewline
write-host "$username" -ForegroundColor red
sleep -s 1
write-host "`nWould you like to run this script for another user? (Y/N)"
$continue = read-host
}
}
Until ($continue -ne "y")