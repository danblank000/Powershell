$groups = Get-ADObject -SearchBase 'OU=H_Drives,OU=Security Groups,DC=kuits,DC=local' -Filter *
$users = Get-ADUser -SearchBase 'OU=KSL Staff,DC=kuits,DC=local' -SearchScope Subtree -Filter *
$number = 0
    foreach ($group in $groups)
    {
    $group = $group.Name
    $grouptest = $group.ToString()
    $grouptest = $grouptest.Split("_")
    $grouptest = $grouptest[0]
                    
        foreach ($name in $users)
        {
        $name = $name.samaccountname
                      
            if ($grouptest -like "$name")
            {
            write-host "$grouptest and $name match" -ForegroundColor Green
            Add-ADGroupMember $group $name
            $number++
            }
        }
    }
