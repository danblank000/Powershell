$faxstatus = ""
$PSEmailServer = "Exchsrv2"


$faxstatus = get-service -name "faxmaker fax server" -ComputerName kslsrv12 | select status
$status = $faxstatus.status

if ($status -ne "running")
    {
    Send-MailMessage -to "ITDept@kuits.com" -from "itdept@kuits.com" -Subject "Fax Server Service Does Not Appear to be Running" -Priority High
    }

exit