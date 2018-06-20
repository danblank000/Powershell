DO
{
cls
$name = ""
$path = ""
$newpath = ""
$answer = ""
$filename = ""
$continue = ""


#get user
Write-Host "Mailbox Export Script" -ForegroundColor Yellow
sleep -Milliseconds 10
Write-Host "`nEnter the name of the users who's mailbox needs to be exported : " -NoNewline
$name = read-host

write-host "`nIs this a leavers mailbox? Y/N"
$leaver = read-host
$filename = $name.split(" ")
$filename = $filename[0] + $filename[1]
    
    if ($leaver -eq "y")
    {
    $path = "\\kslnas01\PSTFiles$\Leavers\$filename.pst"
    }

    else
    {
    $path = "\\kslnas01\PSTFiles$\$filename.pst"
    }

#confirm
Write-Host "`n$name's mailbox will be exported to $path"
sleep -s 1
Write-Host "Press 1 to continue or press 2 to specify a different path : " -NoNewline
$answer = Read-Host

if ($answer -eq "1")
    {
    New-MailboxExportRequest -Mailbox "$name" -Filepath "$path"
    }

Elseif ($answer -eq "2")
    {
    Write-Host "please enter the path to export the mailbox to : "
    $newpath = Read-Host
    sleep -m 100
    Write-Host "$name's mailbox will now be exported to $path"
    sleep -s 1
    New-MailboxExportRequest -Mailbox "$name" -Filepath "$newpath"
    }

sleep -s 1

# Try Again?
sleep -s 1
write-host "`nWould you like to run this again on for another user? Press Y for yes or N for no"
$continue = read-host
}
Until ($continue -eq "N") 
