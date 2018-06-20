$groups = Get-ADObject -SearchBase 'OU=H_Drives,OU=Security Groups,DC=kuits,DC=local' -Filter *
$folders = Get-ChildItem "\\kslnas01\UserFolders$" -Directory

    foreach ($folder in $folders)
    {
    $folder = $folder.Name
    $folder = $folder.ToString()
      
        foreach ($group in $groups)
        {
        $group = $group.Name
        $grouptest = $group.ToString()
        $grouptest = $grouptest.Split("_")
        $grouptest = $grouptest[0]
                    
            if ($grouptest -like "$folder")
            {
            $path = "\\kslnas01\userfolders$\$folder"
            $acl = get-acl $path
            $inherit = [system.security.accesscontrol.InheritanceFlags]"ContainerInherit, ObjectInherit"
            $propagation = [system.security.accesscontrol.PropagationFlags]"None"
            $Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("$group","FullControl",$inherit,$propagation,"Allow")
            write-host " $group and $folder match" -ForegroundColor Green
            $acl.SetAccessRule($ar)
            set-acl $path $acl
            }
        }
    }
