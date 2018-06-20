$users = Get-ADUser -SearchBase "ou=ksl staff,dc=kuits,dc=local" -SearchScope Subtree -Filter * | sort samaccountname
$folderpath = "\\kslnas01\UserFolders$"

foreach ($user in $users)
{
    
    if(test-path "$folderpath\$($user.samaccountname)")
    {
        
        $acl = get-acl -Path "$folderpath\$($user.samaccountname)"
        foreach ($access in $acl.Access)
        {
        
            if($access.identityreference -match $user.samaccountname)
            {
                $acl.RemoveAccessRule($access)
                $acl | Set-ACL
            }
        }
    }
}