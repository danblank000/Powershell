######################################################
#                                                    #
########## Server Status - Daniel Blank ##############
#                                                    #
######################################################
#                                                    #
######################################################
#                                                    #
######## Latest version Date - 24 / 09 / 2015 ########
#                                                    #
######################################################


cls
$servers = @()

# Get list of Server Names from AD

$servers = get-adcomputer -filter {enabled -eq $true} -SearchBase "OU=Domain Controllers,DC=kuits,DC=local" -SearchScope subtree | select name | Sort-Object name
$servers += get-adcomputer -filter {enabled -eq $true} -SearchBase "OU=Servers,DC=kuits,DC=local" -SearchScope subtree | select name | Sort-Object name

# Ping each

    foreach ($server in $servers)
    {
    $server = $server.name
    $ping = Test-Connection $server -quiet
        
        if ($ping -eq "$true")
        {
        write-host "$server is responding ok" -ForegroundColor Green
        }

        else
        {
        write-host "$server is not responding" -ForegroundColor Red
        }
    }


# For each server check specific tasks

    # disc space
    # specific services
    # RAM usage
    # CPU usage


# If anything fails, try 3 times and send email.

# Check internet connectivity

$extping = test-netconnection

    if ($extping.PingSucceeded -eq "true")
    {
    write-host "`nExternal internet connection seems to be ok :)" -ForegroundColor Green
    }

    else
    {
    write-host "`nExternal internet connection seems to be down :(" -ForegroundColor Red
    }