Function Update-LocalModule
{
    
    $LiveLocation = Get-ChildItem "\\kslnas01\folderredirection$\$env:USERNAME\My Documents\WindowsPowerShell\Modules\"
    $GitLocation = Get-ChildItem "C:\Stuff\Git\Powershell\Modules\"
    
        foreach($GitMod in $GitLocation)
        {
        $GitModName = $GitMod.Name
            
            foreach($LiveMod in $LiveLocation)
            {
            $LiveModName = $LiveMod.Name

                if($GitMod.name -match $LiveMod.name)
                {

                $FromPath = "C:\Stuff\Git\Powershell\Modules\$GitModName"
                set-location $FromPath
                $GitTest = git pull

                    if ($GitTest -match "Already up to date.")
                    {
                    write-host "Match"
                    Copy-Item $FromPath $ToPath -Recurse
                    }

                    $ToPath = "\\kslnas01\folderredirection$\daniel.blank\My Documents\WindowsPowerShell\Modules\$LiveModName"

                }
                
            }

        }
}
