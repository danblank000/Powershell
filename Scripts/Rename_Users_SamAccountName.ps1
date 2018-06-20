$users = get-aduser "jenkinsm"
#$users = get-aduser -SearchBase "ou=ksl staff,dc=kuits,dc=local" -Filter {(samaccountname -notlike "accounts") -and (samaccountname -notlike "librarian") -and (samaccountname -notlike "reception") -and (samaccountname -notlike "train*")} | select samaccountname | sort samaccountname

    foreach ($user in $users)
    {
    $sam = ($user.samaccountname).tostring()
    
        if ($sam -notlike "*.*")
        {
        $firstname = (get-aduser $name | select givenname).givenname
        $surname = (get-aduser $name | select surname).surname
        $firstname = $firstname.tostring()
        $surname = $surname.tostring()
        $newname = "$firstname" + "." + "$surname"
        set-aduser $sam -ProfilePath "\\kslnas01\Profiles$\$newname" -HomeDirectory "\\kslnas01\userfolders$\$newname" -HomeDrive "H:"
        set-aduser $sam -SamAccountName $newname -UserPrincipalName "$nemname@kuits.local"
        }   
        
    }


