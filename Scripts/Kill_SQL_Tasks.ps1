$logs = @()
$processes = Invoke-Sqlcmd -ServerInstance kslsql01 -Database partner -Query @"
SELECT req.session_id
	, req.status
	, req.command
	, req.cpu_time
	, req.total_elapsed_time
    , sqltext.TEXT
FROM sys.dm_exec_requests req
CROSS APPLY sys.dm_exec_sql_text(sql_handle)
AS sqltext
ORDER BY req.total_elapsed_time
"@

foreach ($process in $processes)
{

    if($process.total_elapsed_time -gt "20000")
    {
    $id = $process.session_id
    $user = (Invoke-Sqlcmd -ServerInstance kslsql01 -Database partner -Query "EXEC sp_who '$id'").loginame
    $user = $user.TrimStart("ksl\")
    
    
    Invoke-Sqlcmd -ServerInstance kslsql01 -Database partner -Query "kill $id"
    
    $log = New-Object System.Object
    $log | Add-Member -Type NoteProperty -Name Name -Value $user
    $log | Add-Member -Type NoteProperty -Name Session_ID -Value $id
    $log | Add-Member -Type NoteProperty -Name Status -Value $process.status
    $log | Add-Member -Type NoteProperty -Name CPU_Time -Value $process.cpu_time
    $log | Add-Member -Type NoteProperty -Name T_E_Time -Value $process.total_elapsed_time
    $log | Add-Member -Type NoteProperty -Name Query -Value $processes.TEXT
    
    $logs += $log
    }

}

$logs | Out-GridView

