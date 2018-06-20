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

                Write-Host "yes $LiveMod and $GitMod"



                Write-Host "*************************"
                Write-Host ""

                }

                else
                {
                Write-Host "No $LiveMod and $GitMod"
                Write-Host "*************************"
                Write-Host ""
                }

            }

        }
}
