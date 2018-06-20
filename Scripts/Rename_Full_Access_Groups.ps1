#$groups = Get-ADGroup -SearchBase "ou=H_Drives,ou=security groups,dc=kuits,dc=local"
$groups = Get-ADGroup "jenkinsm_full_access"

    foreach ($group in $groups)
    {
    $name = $group | select name
    $name = $name.name
    $name = $name.ToString()
    $name = $name.Split("_")
    $name = $name[0]
        
        #if ($name -notlike '*.*')
        if ($name -like '*jenkinsm*')
        {
        $test = (get-aduser $name -Properties enabled).enabled
            
            if ($test -eq "enabled")
            {      
            $firstname = (get-aduser $name | select givenname).givenname
            $surname = (get-aduser $name | select surname).surname
            $firstname = $firstname.tostring()
            $surname = $surname.tostring()
            $newname = "$firstname" + "." + "$surname"
            $newnamefull = "$newname" + "_Full_Access"
            Set-ADGroup $group -Description "Members of this group have Full Access to the $newname Folder" -SamAccountName "$newnamefull"
            Rename-ADObject $group -NewName $newnamefull
            }
                   
        }
      
    }

