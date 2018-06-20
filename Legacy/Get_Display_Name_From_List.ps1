<####################################

This script pulls samaccountnames from display names.

Requirements
------------

1. CSV files containing names and a heading of "displayname"
2. File needs to be in directory "C:\Powershell\Input Files\names.csv" 
3. It will output to 'C:\Powershell\Output Files\UserNames.csv'

#####################################>

$names = ""
$name = ""
$Sam = @()
$names = Import-csv "C:\powershell\Input Files\Display Names\Names.csv"
write-host "`nPulling usernames.... Please wait" -ForegroundColor Gray
foreach ($name in $names.displayname) 
    {
    $sam += get-aduser -filter {name -like $name} -properties samaccountname | Select name, Samaccountname | sort samaccountname
    }
sleep -Milliseconds 500
$Sam | export-csv 'C:\Powershell\Output Files\Display Names\UserNames.csv' -Encoding Unicode -Delimiter "," -NoTypeInformation
$Sam