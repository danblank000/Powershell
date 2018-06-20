$TimFPath = '\\kslnas01\DeptFolders\IT\_Dan\TIM_Files\FAILED'
$TimCPath = '\\kslnas01\DeptFolders\IT\_Dan\TIM_Files\COMPLETED'
$LogPath = 'C:\CD_Export_Log\log.txt'
$files = Get-ChildItem $TimFPath -Recurse
    foreach ($file in $files)
    {
    $fileC = Get-Content $TimFPath\$file
        foreach ($line in $fileC[0])
        {
        $LogEntry = $file.Name
        $FE = ($line.Split(','))[2]
        $EntMat = ($line.Split(','))[3]
            $Entity = $EntMat.Split('-')[0]
                $EntityC = ($Entity -split '(?=\d)',2)[0]
                $EntityD = ($Entity -split '(?=\d)',2)[1]
            $Matter = $EntMat.Split('-')[1]
        $Date = ($line.Split(','))[4]
            $d1 = $Date.Split('/')[2]
            $d2 = $Date.Split('/')[1]
            $d3 = $Date.Split('/')[0]
                $DateTime = $d1 + '-' + $d2  + '-' + $d3 + ' 00:00:00.000'
        $Narrative = ($line.Split(','))[10]
        $Query = "select * 
        from TimeTransactions 
        where EntityRef like '$EntityC%$EntityD' 
        and MatterNoRef = '$Matter' 
        and Narratives = '$Narrative' 
        and TransactionDate = '$DateTime'"
        $SQL = Invoke-Sqlcmd2 -ServerInstance kslsql01 -Database partner -Query $Query
            if ($SQL){Move-Item "$TimFPath\$file" $TimCPath 
            write-host "Entry found for $FE in $Entity/$Matter on $Date as $Narrative" -ForegroundColor Green}
            else
            {
                DO
                {
                if(!(Test-Path $LogPath))
                {New-Item -ItemType file -Path $LogPath -Force}
                }
                UNTIL(Test-Path $LogPath)
            write-host "No entry found for $FE in $Entity/$Matter on $Date as $Narrative" -ForegroundColor Yellow
            $containsWord = Get-Content $LogPath | Where-Object { $_.Contains("$LogEntry") }
                If(!($containsWord))
                {
                Add-Content C:\CD_Export_Log\log.txt $LogEntry
                write-host "send email" -ForegroundColor Yellow
                $SMTPServer = "EXCHSRV2.kuits.local"
                $Address = "ITTeam@kuits.com"
                $Subject = "ALERT - TIM File Failure"
                $textEncoding = [System.Text.Encoding]::UTF8 
                $Body =" 
                    <font face=""verdana""> 
                    Carpe Diem has failed to transfer time from a file over to Partner :  
                    <p> <b>File Name</b>      : $LogEntry
                    <br> <b>Date of File</b>  : $Date
                    <p> Please check the Time Export Log on KSLCarpeDiem01
                    "
                Send-MailMessage -SmtpServer $SMTPServer -From $Address -Subject $Subject -To "danielblank@kuits.com" -Body $Body -bodyasHTML -priority High -Encoding $textEncoding 
                }
                else
                {write-host "no email to be sent" -ForegroundColor Yellow}
            }
        }
    }