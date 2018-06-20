cls
Write-host "Check for Inactive Computers" -ForegroundColor Yellow
Write-Host "`nHow many inactive days to check for?"
$DaysInactive=  read-host

#$DaysInactive = 40  
$time = (Get-Date).Adddays(-($DaysInactive)) 
  
# Get all AD computers with lastLogonTimestamp less than our time 
Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp | 
  
# Output hostname and lastLogonTimestamp into CSV 
select-object Name,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}} | sort stamp, name #| export-csv OLD_Computer.csv -notypeinformation