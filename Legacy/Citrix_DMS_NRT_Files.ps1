<# 

This script will search each Citrix DMS desktop for NRTEcho and NRPortbl folders for a specified username.  
It will then return the 5 newest file in each of these locations in date order

#>

Do
{
cls
$nametest = ""
$continue = ""

write-host "This script will allow you to recover files from Citrix DMS Sessions" -ForegroundColor Green
Write-Host ""
write-host "Created by Dan Blank (c) 2014" -ForegroundColor DarkGreen
Write-Host ""
sleep -s 1

##################
# creating table #
##################

$tabname = "Output Info"

# create the table
$table = New-Object system.data.datatable "$tabname"

# create the columns
$col1 = New-Object System.Data.DataColumn "Server Name",([string])
$col2 = New-Object System.Data.DataColumn "File Name",([string])
$col3 = New-Object System.Data.DataColumn "Last Write Date",([datetime])

# add the columns
$table.Columns.Add($col1)
$table.Columns.Add($col2)
$table.Columns.Add($col3)

#########################################################################

# variables
$path =""
$DMS = ""
$fileinfo = ""

write-host "Please enter a user name to search against" -ForegroundColor Yellow
$name = read-host
try
{
$nametest = Get-ADUser $name | select name
$nametest = $nametest.name

    # testing the usernames
   
    if ($nametest)
    {
    cls
    write-host "    Retrieving file info for $nametest" -ForegroundColor Cyan
    write-host ""
    sleep -s 1
    
    # getting the DMS Citrix Server list
$servers = get-adcomputer -filter * -SearchBase "OU=DMS,OU=XenApp Servers,OU=XenApp,OU=Servers,DC=dwf,DC=local" -SearchScope subtree | select name | Sort-Object name
    
    ###############
    #  NRT  ECHO  #
    ###############
        
    foreach ($server in $servers)
    {
    $DMS = $server.name
    $path = "\\$DMS\c$\NRTEcho\ACTIVE\$name"
    $testpath = test-path $path
            
        if ($testpath -eq "true")
        {
        $count = Get-ChildItem $path | measure
        $count = $count.Count
        write-host "$DMS NRTEcho folder contains a directory for user $name containing $count files" -ForegroundColor Green
        sleep -Milliseconds 200
        $gc = get-ChildItem $path -file | select name, lastwritetime | Sort-Object lastwritetime -Descending | select -Last 5
        
            foreach ($file in $gc)
            {

            $gcfile = $file.name
            $gcdate = $file.lastwritetime
            
            #Create a row
            $row = $table.NewRow()
        
            #Enter data in the row
            $row."Server name" = "$DMS in NRTEcho folder"
            $row."File Name" = $gcfile
            $row."Last Write Date" = $gcdate
                 
            #Add the row to the table
            $table.Rows.Add($row)
            }
        
        }
        else
        {
        write-host "$DMS NRTEcho folder does not contain files for user $name" -ForegroundColor Red
        sleep -Milliseconds 200
        }

    }
  
    ###############
    # NRT  PORTBL #
    ###############
    
    
    foreach ($server in $servers)
    {
    $DMS2 = $server.name
    $path2 = "\\$DMS2\c$\NRPortbl\ACTIVE\$name"
    $testpath2 = test-path $path2    
        
        if ($testpath2 -eq "true")
        {
        $count2 = Get-ChildItem $path2 | measure
        $count2 = $count2.Count
        write-host "$DMS2 NRPortbl folder contains a directory for user $name containing $count2 files" -ForegroundColor Green
        $gc2 = get-ChildItem $path2 -file | select name, lastwritetime | Sort-Object lastwritetime -Descending | select -Last 5
        sleep -Milliseconds 200
           foreach ($file2 in $gc2)
           {

           $gcfile2 = $file2.name
           $gcdate2 = $file2.lastwritetime
            
           #Create a row
           $row = $table.NewRow()
        
           #Enter data in the row
           $row."Server name" = "$DMS2 in NRPORTBL folder"
           $row."File Name" = $gcfile2
           $row."Last Write Date" = $gcdate2
                 
           #Add the row to the table
           $table.Rows.Add($row)
           }
        }
        
      else
      {
      write-host "$DMS2 NRPortbl folder does not contain files for user $name" -ForegroundColor Red
      sleep -Milliseconds 200
      }

    }

#Display the table
$table | Sort-Object "last write date" -Descending |  Format-table
    }
           
    }

catch
{
cls
Write-Host "    The username $name does not exist" -ForegroundColor Red
Write-Host ""
sleep -s 1
}

write-host ""
write-host "Would you like to run this for another user? Press 'Y' to try again or 'N' to exit" -ForegroundColor Yellow
$repeat = read-host
}

Until ($repeat -eq "N")