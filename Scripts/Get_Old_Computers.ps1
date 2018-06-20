$domain = "domain.mydom.com"  
$DaysInactive = 365  
$time = (Get-Date).Adddays(-($DaysInactive)) 
  
# Get all AD computers with lastLogonTimestamp less than our time 
Get-ADComputer -SearchBase "ou=ksl computers, dc=kuits, dc=local" -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp | where {($_.distinguishedname -notlike "*zz*") -and ($_.distinguishedname -notlike "*training*") -and ($_.distinguishedname -notlike "*pcl*")} | 
  
# Output hostname and lastLogonTimestamp into CSV 
select-object Name,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}}
