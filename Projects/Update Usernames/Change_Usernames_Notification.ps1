$FromEmail = "ITTeam@kuits.com"
$SMTPServer = "EXCHSRV2.kuits.local"
$textEncoding = [System.Text.Encoding]::UTF8 

$people = get-aduser -SearchBase "ou=ksl staff, dc=kuits, dc=local" -Filter * -Properties emailaddress, pager | where {($_.distinguishedname -notlike "*generic*") -and ($_.samaccountname -notlike "*laptop*") -and $_.samaccountname -notlike "*.*"}

    foreach ($person in $people)
    {
    $ToEmail = $person.emailaddress
    $NewUsername = $person.givenname + "." + $person.surname
    $GivenName = $person.GivenName
    
    $Body =" 
    <font face=""verdana""> 
    Hi $GivenName,
    <br><br>
    Please note that as from <b>Monday 5th February</b> your username will be changing to :  
    <br><br><br>
    <p><b><font color=red>$NewUsername</font></b>
    <br><br><br>
    You will need to use this username to log in to your computer in future.
    <br><br>
    If you get your Kuits emails to your mobile phone, you will also need to change your username there.
    <br><br>
    Please contact the IT Department if you have any queries.
    <br><br>
    Thanks
    "

    Send-MailMessage -SmtpServer $SMTPServer -From $FromEmail -Subject "*** Username Change ***" -To $ToEmail -Body $Body -bodyasHTML -priority High -Encoding $textEncoding
    }