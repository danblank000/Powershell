Function Update-LocalModule
{
    
    $LiveLocation = Get-ChildItem "\\kslnas01\folderredirection$\$env:USERNAME\My Documents\WindowsPowerShell\Modules\"
    $GitLocation = Get-ChildItem "C:\Stuff\Git\Powershell\Modules\"
    
        foreach($GitMod in $GitLocation)
        {
        
            foreach($LiveMod in $LiveLocation)
            {

                if($GitMod.name -match $LiveMod.name)
                {

                Write-Host "yes $LiveMod and $GitMod"

                }

                else
                {
                Write-Host "No $LiveMod and $GitMod"
                }

            }

        }
}
