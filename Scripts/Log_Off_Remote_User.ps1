$computer = ""
$credential = ""
$session = ""
$ID = ""

cls
$computer = read-host "`nWhat machine are we querying?`n"
#$credential = get-credential

$session = New-PSSession -ComputerName $Computer #-Credential $credential

    Invoke-Command -Session $session {
    write-host ""
    qwinsta
    write-host ""
    $ID = read-host "`nEnter ID from above of user to be logged off`n"
    logoff $ID}

Exit-PSSession
Remove-PSSession -Session $Session