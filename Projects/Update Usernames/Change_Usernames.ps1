$homefolderpath = "\\kslnas01\userfolders$\"
$redirectionfolderpath = "\\kslnas01\folderredirection$\"
$profilepath = "\\kslnas01\Profiles$\"
$list = @()
#$unames = (get-aduser -SearchBase "ou=ksl staff, dc=kuits, dc=local" -Filter * | where {($_.distinguishedname -notlike "*generic*") -and ($_.samaccountname -notlike "*laptop*")} | sort samaccountname).samaccountname
$unames = (get-aduser -SearchBase "ou=ksl staff, dc=kuits, dc=local" -Filter * | where {$_.samaccountname -like "*bloggs*"} | sort samaccountname).samaccountname

    foreach ($uname in $unames)
    {
              
        if ($uname -notlike "*.*")
        {
        
         $user = get-aduser $uname -Properties profilepath, homedirectory, givenname, surname
        $HRNETOLD = $user.SamAccountName
        write-host "--------------------------"
        write-host $user.Name -ForegroundColor Green
        write-host ""



        #profile path change
        $C_ProfilePath = $user.ProfilePath
        $N_ProfilePath = $profilepath + $user.GivenName + "." + $user.Surname
        Write-Host "Profile Path - " -ForegroundColor Yellow -NoNewline
        Set-ADUser $user -ProfilePath $N_ProfilePath
            


        #home folder path change
        $C_HomeFolderPath = $user.HomeDirectory
        $N_HomeFolderPath = $homefolderpath + $user.GivenName + "."  + $user.Surname
        Write-Host "Home Folder Path - " -ForegroundColor Yellow -NoNewline
        Set-ADUser $user -HomeDirectory $N_HomeFolderPath
           


        #rename profile folder
        $SAM = $user.SamAccountName
        $folders = gci \\kslnas01\Profiles$ |where name -Like "*$SAM*" | select -ExpandProperty name

            foreach ($folder in $folders)
            {
            $nfolder = $folder.split(".")
            $nfolder[0] = $user.GivenName + "." +$user.Surname + "."
            $NewName = $nFolder[0] + $nfolder[1]
            Rename-Item "$profilepath\$folder" -NewName $NewName
            }
        
        Write-Host "Profile Folder - " -ForegroundColor yellow -NoNewline
        #Rename-Item "$profilepath\$folder" -NewName $NewName
           
           
                
        #rename userfolder
        $C_HomeFolder = $homefolderpath + $user.SamAccountName
        $N_HomeFolder = $user.GivenName + "." + $user.Surname
        Write-Host "Home Folder- " -ForegroundColor Yellow -NoNewline
        Rename-Item $C_HomeFolderPath -NewName $N_HomeFolder
     
            
                    
        #change samaccountname
        $NSA = $user.GivenName + "." +$user.Surname
        $NUPN = $NSA + "@kuits.local"
        set-aduser $user -SamAccountName $NSA -UserPrincipalName $NUPN
            
        

        #Update HR NET Username
        $HRNETUN = "ksl\" + $NSA
       Invoke-Sqlcmd -ServerInstance "kslsql01" -Database "HRnet" -Query "UPDATE pers_option SET network_logon = '$HRNETUN' WHERE network_logon like '%$HRNETOLD%'"

        }
       
    }
