$test = ""
$print = ""
$netprint = ""

$test = test-path "C:\Program Files (x86)\remprint.txt"

    if ($test -eq $false)
    {
    $netprint = get-printer | where {$_.name -like "*kslsrv*"}

        foreach ($print in $netprint)
        {
        Remove-Printer $print.Name
        }

    New-Item "C:\Program Files (x86)\RemPrint.txt" -ItemType file -Force
    }

   