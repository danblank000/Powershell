$servers = Get-ADComputer -SearchBase "ou=servers,dc=kuits,dc=local" -SearchScope Subtree -Filter 'enabled -eq $true' | select name | sort name
$user = read-host "Which user needs admin rights?`n"
foreach ($pc in $servers)
    {
    $pc = $pc.Name
    $objUser = [ADSI]("WinNT://kuits.local/fifosys") 
    $objGroup = [ADSI]("WinNT://$pc/Administrators") 
    $objGroup.PSBase.Invoke("Add",$objUser.PSBase.Path)
    }
