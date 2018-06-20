##################
# creating table #
##################

$tabname = "Output Info"

# create the table
$table = New-Object system.data.datatable "$tabname"


# create the columns
$col1 = New-Object System.Data.DataColumn "UserName",([string])
$col2 = New-Object System.Data.DataColumn "Namename",([string])
$col3 = New-Object System.Data.DataColumn "Token",([string])


# add the columns
$table.Columns.Add($col1)
$table.Columns.Add($col2)
$table.Columns.Add($col3)

#########################################################################

$list = get-aduser -filter * -Properties samaccountname, displayname, securecomputingCom2000-SafeWord-UserID | select samaccountname, displayname, securecomputingCom2000-SafeWord-UserID | Where-Object {$_.'securecomputingCom2000-SafeWord-UserID' -ne ""}

Foreach ($MoPa in $list)
    {
    
    $username = $MoPa.samaccountname
    $namename = $mopa.displayname
    $token = $mopa.'securecomputingCom2000-SafeWord-UserID'[0]


    #Create a row
    $row = $table.NewRow()
        
    #Enter data in the row
    $row."UserName" = $UserName
    $row."NameName" = $NameName
    $row."Token" = $token
                 
    #Add the row to the table
    $table.Rows.Add($row)

    }


    $table
    sleep -s 1
    
    $number = $table | measure
    $number = $number.Count
    
    Write-Host "Total number of active Hardware and Software tokens = $number" -ForegroundColor Green

    $table | Sort-Object namename | export-csv 'C:\powershell\Output Files\MobilePass\MobilePass.csv' -NoTypeInformation
