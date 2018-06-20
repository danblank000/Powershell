Function Get-TimFileMissingTime
{
    param
    (
    [Parameter(Position=0)] 
    [ValidateSet('Failed','Working','Pending')] 
    [string]$Location
    )
$NOW = get-date -UFormat %y%m%d
$FileName = "TIM_DAB_$NOW.TIM"
$Path = "\\kslcarpediem01\c$\Program Files (x86)\Tikit\Carpe Diem\CDAdmin\EXPORT"
$Files =  
    If (!($Location))
    {
    $Location = "Failed"
    }
$Files = Get-ChildItem $Path\$Location -File
$NewTim = "C:\Stuff\TimFiles\$FileName"

    foreach ($File in $Files)
    {
    $Lines = get-content $Path\$Location\$File
    
        foreach ($Line in $Lines)
        {
        $ExternalID = ($line.Split(','))[1]
        $Query = "select * 
        from TimeTransactions 
        where ExternalID = '$ExternalID'"
        $SQL = Invoke-Sqlcmd2 -ServerInstance kslsql01 -Database partner -Query $Query
        
            if (!($SQL))
            {

                DO
                {
                if(!(Test-Path $NewTim))
                {New-Item -ItemType file -Path $NewTim -Force}
                }
                UNTIL(Test-Path $NewTim)

            Add-Content $NewTim -Value $Line

            }
        }
    }
}

