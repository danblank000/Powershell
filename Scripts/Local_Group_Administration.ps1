cls
Write-host "`nThis script will allow you to manage the local user groups on a remote computer`n*******************************************************************************" -ForegroundColor Yellow

$pc = Read-Host "What is the asset tag of the required computer? "
$group = Read-Host "`What group do you want to query? "
$objGroup = [ADSI]("WinNT://$pc/$group")
$members = @($objgroup.psbase.Invoke("Members"))
$members = $members | foreach {$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}  

sleep -s 1
write-host "`nCurrent Members of $group group are :" -ForegroundColor Yellow
$members | Sort-Object


sleep -s 1
write-host "`nDo you want to add or remove a member of this group? Press Y for Yes or N for no : " -NoNewline -ForegroundColor Cyan
$doyou = read-host

    if ($doyou -eq "Y")
    {
    $user = Read-Host "`nWhat is the Username "
    $name = get-aduser $user | select name
    $name = $name.name
    
    sleep -s 1
    write-host "`n`nDo you want to add or remove $name ($user) from the $group group?"  -ForegroundColor Cyan
    write-host "`n`n Press 1 to add the user`n Press 2 to remove the user`n"
    $addremove = Read-Host

        if ($addremove -eq "1")
        {
        $objUser = [ADSI]("WinNT://DWF/$user")
        $objGroup.PSBase.Invoke("Add",$objUser.PSBase.Path)
        sleep -s 1
        write-host "`n$name ($user) has now been added to the $group group on $pc" -ForegroundColor Green
        $members = @($objgroup.psbase.Invoke("Members"))
        $members = $members | foreach {$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}  
        sleep -s 1
        write-host "`nCurrent Members of $group group are :" -ForegroundColor Yellow
        $members | Sort-Object
        }

        elseif ($addremove -eq "2")
        {
        $objUser = [ADSI]("WinNT://DWF/$user")
        $objGroup.PSBase.Invoke("remove",$objUser.PSBase.Path)
        sleep -s 1
        write-host "`n$name ($user) has now been removed from the $group group on $pc" -ForegroundColor Green
        $members = @($objgroup.psbase.Invoke("Members"))
        $members = $members | foreach {$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}  
        sleep -s 1
        write-host "`nCurrent Members of $group group are :" -ForegroundColor Yellow
        $members | Sort-Object
        }
    }