Function Get-MachineUserLoggedInTo
    {

    param
    (
    [Parameter(Mandatory=$True,Position=0)] 
    [ValidateNotNull()] 
    [string]$User
    )
    
    $i = 0

    # Gets all DCs from the DCs OU in kuits.local:
    write-host "`nGetting server list." -ForegroundColor Cyan
    $servers = get-adcomputer -filter {(name -like "*KSLNAS01*") -or (name -like "kslpartner") -or (name -like "kslsql01*") -or (name -like "kslfs01")} | sort-object name
    
    # Starts a job for each server
    write-host ""
    write-host 'Querying' $servers.count 'servers.' -ForegroundColor Yellow
    $servercount = $servers.count
    foreach ($server in $servers)
        {
        # Querying each of the servers for connections to shares    
        $servername = $server.name
        $userSessions = Get-WmiObject Win32_ServerConnection -computername $servername -Credential $usercredential
 
        #progress bar
        write-host "Querying $servername" -ForegroundColor DarkYellow
    
        Write-Progress -activity "Servers Processed" -status "Percent Complete : " -PercentComplete (($i++ / $Servers.Length)  * 100)

            # Filtering out the results
            foreach ($userSession in $userSessions)
            {
        
                if ($userSession.username -eq $user)
                {
                #convert ip to hostname
                $IPAddress = $userSession.computername 
                $hostname = Get-WmiObject win32_computersystem -Computer $IPAddress -Credential $usercredentials

                $found = "yes"

                #select user details
                $userDetails = [string]::Format("User {0} is logged on to {1}", $userSession.UserName, $hostname.name)
                
                #print user details
                Write-Host "`n$userDetails" -ForegroundColor Green
                $continue = read-host "`nPress ENTER to exit"
                
                    if ($continue -Ne "C")
                    { 
                    exit
                    }                
                
                }   
                               
                else
                {
                #if no instances are found, continue to search next server
                }  
       
            }
        
        }

     if ($found -ne "yes")
        {
        write-host "I can't find any PCs with $user logged in to them" -ForegroundColor Red
        }

}