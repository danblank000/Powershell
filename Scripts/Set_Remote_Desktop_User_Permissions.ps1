cls

$user = ""
$pc = ""
$objUser = ""
$objGroup = ""

write-host "Add Remote Desktop Users Permissions`n" -ForegroundColor Yellow

$user = Read-Host "Enter user name" 
$pc = Read-Host "Enter PC number" 
$objUser = [ADSI]("WinNT://kuits.local/$user") 
$objGroup = [ADSI]("WinNT://$pc/Remote Desktop Users") 
$objGroup.PSBase.Invoke("Add",$objUser.PSBase.Path)

write-host "$user has been granted remote desktop permissions"
