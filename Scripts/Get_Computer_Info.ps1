Function Model
{
$Description = Get-WmiObject -Class Win32_OperatingSystem -Computer $Computer #-Credential $Credentials
$Model = get-wmiobject -class "Win32_Computersystem" -computer $Computer # -Credential $Credentials 

$Ram = ($Model.TotalPhysicalMemory/1GB)
$Ram = [Math]::Round($Ram, 2)

	Write-host
	Write-host "Computer                :" $Model.Name.ToUpper()

IF ($Description.Description -ne "")
{
	write-host "Computer Description    :" $Description.Description
}
	write-host "Model                   : " -nonewline; Write-Host $model.Model -foregroundcolor "red"
      	write-host "Total Physical Memory   :" $Ram "GB"
        write-host "Physical Processors     :" $Model.NumberOfProcessors
        write-host "Logical Processors      :" $Model.NumberOfLogicalProcessors

IF ($Model.UserName.length -gt 1)
{
        write-host "Logged on User Initials :" $Model.UserName
	$UN = $Model.UserName -replace ('ksl\\')
	$FullName = dsquery user -samid $UN | dsget user -display
        write-host "Logged on User Name     : " -nonewline; Write-Host $Fullname[1].substring(2) -foregroundcolor "red"
}
}

Function Processor
{
	$CPU = get-wmiobject -class "Win32_Processor" -Computer $Computer #-Credential $Credentials 
#	foreach ($Item in $CPU)
#	{ 
#	$i += 1
IF ($CPU.Length -gt 1)
{
        write-host "Processor Speed $i        :" ($CPU[0].MaxclockSpeed / 1000) "Ghz"
	}
	ELSE
	{
	write-host "Processor Speed $i        :" ($CPU.MaxclockSpeed / 1000) "Ghz"
	}
}

Function OS
{
$OS = get-wmiobject -class "Win32_OperatingSystem" -Computer $Computer #-Credential $Credentials 

$Version = $OS.Version
$Version = $Version.substring(0,$Version.Length-1)

switch -wildcard ($Version) 
{
     "5.0.219" {$os = "Windows 2000"; break}
     "5.1.260" {$os = "Windows XP"; break}
     "5.2.379" {$os = "Windows Server 2003"; break}
     "6.0.600" {$os = "Windows Vista/Windows 2008 R1"; break}
     "6.1.760" {$os = "Windows 7/Windows 2008 R2"; break}
     "6.2.920" {$os = "Windows 8/Windows 2012"; break}
     "6.3.960" {$os = "Windows 8.1/Windows 2012 R2"; break}
     "10.*" {$os = "Windows 10/Windows 2016"; break}
        default {$os = "OS Cannot be determind"}
}

 Write-Host "Running OS              :" $os
}

Function IP
{
$IP = gwmi Win32_NetworkAdapterConfiguration -computer $computer | Where { $_.IPAddress } | Select -Expand IPAddress | Where { $_ -like '1*' }
Write-Host "IP Address    	        : " -nonewline; Write-Host $IP -foregroundcolor "red"
}


Function Uptime
{
$wmi = Get-WmiObject -Class Win32_OperatingSystem -computer $Computer # -Credential $Credentials 
$uptime = $wmi.ConvertToDateTime($wmi.LocalDateTime) – $wmi.ConvertToDateTime($wmi.LastBootUpTime)
Write-Host
Write-Host "Uptime Report      Days :" $uptime.Days
Write-Host "    	          Hours :" $uptime.Hours
Write-Host "    	           Mins :" $uptime.Minutes
} #End Function Uptime


function Diskinfo 
{

# Create a Table

$tabName = "Disk Results"

#Create Table object
$Table = New-Object system.Data.DataTable “$tabName”

#Define Columns
$ColDisk = New-Object system.Data.DataColumn Disk,([string])
$ColName = New-Object system.Data.DataColumn Name,([string])
$colSize = New-Object system.Data.DataColumn Size,([string])
$colFree = New-Object system.Data.DataColumn Freespace,([string])

$table.columns.add($colDisk)
$table.columns.add($colName)
$table.columns.add($colSize)
$table.columns.add($colFree)

$DiskInfo = get-wmiobject win32_logicaldisk –filter “drivetype = 3” -computer $Computer # -Credential $Credentials 

foreach ($Item in $DiskInfo)
{
	#Create a row
	$row = $table.NewRow()

	$Row.Disk = $Item.DeviceID
	$Row.Name = $Item.VolumeName

	$Size = ($Item.Size/1GB)
	$Row.Size = [Math]::Round($Size, 2)

	$Free = ($Item.freespace / $Item.Size)
	$PercentFree = "{0:P0}" -f $Free
	$Row.Freespace = $PercentFree


	#Add the row to the table
	$table.Rows.Add($row)

}
$Table | format-table -AutoSize 

} #end Function Disk Info



#$Credentials = Get-Credential -Username ksl\admin_db -message "Enter Password for Authentification"

Do
{
#Clear-Host
Write-Host
$Computer = Read-Host "Enter Computer/Server Name"
Write-Host
Write-Host "Querying Host " $computer.ToUpper()


if(!(Test-Connection -Cn $Computer -BufferSize 16 -Count 1 -ea 0 -quiet))
{
  $on = "0"
  Write-Host
  Write-Host "The Device $Computer Is Not Contactable" -ForegroundColor red
  Write-Host
}

Else
{

Model
Processor
OS
IP
Uptime
Diskinfo
}
$Repeat = Read-Host "Query Another Machine (Y/N)"
}
Until ($Repeat -eq "N")