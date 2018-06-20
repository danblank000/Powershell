$LogPath = 'C:\CD_Export_Log\log.txt'
DO
{
if(!(Test-Path $LogPath))
{New-Item -ItemType file -Path $LogPath -Force}
}
UNTIL(Test-Path $LogPath)

$locations = '\\kslcarpediem01\c$\Program Files (x86)\Tikit\Carpe Diem\CDAdmin\EXPORT'
    foreach ($location in (Get-ChildItem $locations -Directory))
    {
        If ((!($location -like "*completed*")) -and ((($files = gci "$locations\$location" | select -ExpandProperty Name).count) -gt 0))
        {
            Foreach ($file in $files)
            {
            $containsWord = Get-Content $LogPath | Where-Object { $_.Contains("$file") } 
                
                If(!($containsWord))
                {
                Add-Content C:\CD_Export_Log\log.txt $file
                $SMTPServer = "EXCHSRV2.kuits.local"
                $Address = "ITTeam@kuits.com"
                $Subject = "ALERT - TIM File Failure"
                $textEncoding = [System.Text.Encoding]::UTF8 
                $Body =" 
                    <font face=""verdana""> 
                    Carpe Diem has failed to transfer time from a file over to Partner :  
                    <p> <b>File Names</b>         : $file
                    <br> <b>Location of File</b>  : $location
                    <p> Please check the Time Export Log and/or PAS Event Viewer on KSLCarpeDiem01 
                    "
                Send-MailMessage -SmtpServer $SMTPServer -From $Address -Subject $Subject -To "danielblank@kuits.com" -Body $Body -bodyasHTML -priority High -Encoding $textEncoding 
                }
            }
        }
    }