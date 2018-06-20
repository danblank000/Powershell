do
{

### clearing screen and variables
$name = ""
$nametest = ""
$nameok = ""
$departmentchoice = ""
$department = ""
$namecont = ""
$namecheck = ""
$continue = ""
$fss = ""
$ok = ""
$feeearner = ""
$ou = ""
$username = ""
$untest = ""
$usernameconfirm = ""
$conf = ""
$jobtitle = ""
$office = ""
$job = ""
$email = ""
$email2 = ""
$emailcont = ""
$emailtest = ""
$extensionattribute1 = ""
$adou = ""
$newname = ""
$GivenName = ""
$Surname = ""
$userprinc = ""
$ticketcheck = ""
$ticket = ""
$ticketref = ""
$originalOU = ""
$company = ""
$displayname = ""
$userprinc = ""
$password = ""
$initials = ""
$initialscheck = ""
$ticketnew = ""
$delegates = ""
$delegate = ""
$Permissions = ""
$permission = ""
$deptgroup = ""
$HDRIVEGroup = ""
$HSecGroup = ""

### title
write-host "*** new user creation ***" -foregroundcolor yellow
sleep -m 500

### Spiceworks Ticket Details
write-host "`nIs there a Spiceworks ticket logged for the New Starter? y/n" -ForegroundColor Cyan
$ticketcheck = read-host

    if ($ticketcheck -eq "y")
    {
    $ticket = "1"
    write-host "`nPlease enter the Spiceworks ticket refernce number"
    $ticketref = read-host
    sleep -s 1
    write-host "`nThis ticket will be updated at the end of this process "
    }

    elseif ($initialscheck -ne "y")
    {
    write-host "`nWould you like to log a Spiceworks ticket? y/n" -ForegroundColor Cyan
    $ticketnew = read-host

        if ($ticketnew -eq "y")
        {
        $ticket = "2"
        sleep -s 1
        Write-Host "`nA new ticket will be logged at the end of this process" -ForegroundColor Gray
        }

        elseif ($ticketnew -ne "y")
        {
        $ticket = "3"
        sleep -s 1
        write-host "`nNo ticket will be logged for this New Starter" -ForegroundColor Gray
        }
    }


### checking for pre exisiting users with the same name and setting fee earner / department value
do
{
sleep -s 1
write-host "`nEnter the name of the new starter"
$name = read-host
write-host "`nwill $name be: "
write-host "`n`t1 - fee earner" -foregroundcolor gray
write-host "`t2 - secretarial" -foregroundcolor gray
write-host "`t3 - support" -foregroundcolor gray
write-host "`t4 - it`n" -foregroundcolor gray
$fss = read-host

    ### if fee earner
    if ($fss -eq "1")
    {
        do
        {
        $feeearner = "y"
        $extensionattribute1 = "fe"
        write-host "`nwhat department will $name be joining?`n"
        write-host "`1.  banking and real estate finance" -foregroundcolor gray
        write-host "`2.  commercial and ip" -foregroundcolor gray 
        write-host "`3.  commercial property" -foregroundcolor gray
        write-host "`4.  corporate" -foregroundcolor gray
        write-host "`5.  employment" -foregroundcolor gray 
        write-host "`6.  family" -foregroundcolor gray
        write-host "`7.  ip" -foregroundcolor gray
        write-host "`8.  licensing" -foregroundcolor gray
        write-host "`9.  litigation" -foregroundcolor gray
        write-host "`10. real estate and development" -foregroundcolor gray
        write-host "`11. residential property" -foregroundcolor gray
        write-host "`12. tax and probate" -foregroundcolor gray
        write-host ""
        $departmentchoice = read-host
        sleep -m 500
        $ok = $departmentchoice -match '^[1,2,3,4,5,6,7,8,9,10,11,12]+$'
        
            if (-not $ok) 
            {
            write-host "`ninvalid selection" -foregroundcolor red 
            sleep -s 1
            }
        }
        until ($ok)
    
            if ($departmentchoice -eq "1")
            {
            $department = "banking and real estate finance"
            $adou = "ou=banking and real estate finance,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
            $secou = "ou=banking and real estate finance,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"
            }

            elseif ($departmentchoice -eq "2")
            {
            $department = "commercial and ip"
            $adou = "ou=commercial and ip,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
            $secou = "ou=commercial and ip,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"
            }
    
            elseif ($departmentchoice -eq "3")
            {
            $department = "commercial property"
            $adou = "ou=commercial property,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=commercial property,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
            }
    
            elseif ($departmentchoice -eq "4")
            {
            $department = "corporate"
            $adou = "ou=corporate,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=corporate,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"  
            }
        
            elseif ($departmentchoice -eq "5")
            {
            $department = "employment"
            $adou = "ou=employment,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=employment,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"  
            }
    
            elseif ($departmentchoice -eq "6")
            {
            $department = "family"
            $adou = "ou=family,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=family,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"         
            }
    
            elseif ($departmentchoice -eq "7")
            {
            $department = "intellectual property"
            $adou = "ou=ip,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=ip,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
            }
    
            elseif ($departmentchoice -eq "8")
            {
            $department = "licensing"
            $adou = "ou=licensing,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=licensing,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"   
            }
    
            elseif ($departmentchoice -eq "9")
            {
            $department = "litigation"
            $adou = "ou=litigation,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
            $secou = "ou=litigation,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"  
            }
    
            elseif ($departmentchoice -eq "10")
            {
            $department = "real estate and development"
            $adou = "ou=real estate and development,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=real estate and development,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
            }
    
            elseif ($departmentchoice -eq "11")
            {
            $department = "residential property"
            $adou = "ou=residential property,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=residentail property,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"   
            }
    
            elseif ($departmentchoice -eq "12")
            {
            $department = "tax & probate"
            $adou = "ou=tax & probate,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=tax & probate,ou=secretarial,ou=ksl staff,dc=kuits,dc=local" 
            }
    
    sleep -m 500
    $ou = "ou=" + "$department" + ",ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
    $namecheck = get-aduser -filter * | where {$_.name -like "*$name*"} -erroraction silentlycontinue
    
        if ($namecheck)
        {
        sleep -s 1
        write-host "fee a user called $name already exists in the $department department, $name's distinguished name will append a '2' at the end." -foregroundcolor red  
        write-host "this will not affect the way the users name is displayed." -foregroundcolor red
        sleep -m 500
        $dist = $name + "2"
        $distinguishedname = "cn=$dist," + "$ou"
        }

        else
        {
        $dist = $name
        }

    }
    
    
    ### if secretary
    elseif ($fss -eq "2")
    {
        do
        {
        write-host "`nwhat department will $name be joining?`n"
        write-host "`1.  banking and real estate finance" -foregroundcolor gray
        write-host "`2.  commercial and ip" -foregroundcolor gray 
        write-host "`3.  commercial property" -foregroundcolor gray
        write-host "`4.  corporate" -foregroundcolor gray
        write-host "`5.  employment" -foregroundcolor gray 
        write-host "`6.  family" -foregroundcolor gray
        write-host "`7.  ip" -foregroundcolor gray
        write-host "`8.  licensing" -foregroundcolor gray
        write-host "`9.  litigation" -foregroundcolor gray
        write-host "`10. real estate and development" -foregroundcolor gray
        write-host "`11. residential property" -foregroundcolor gray
        write-host "`12. tax and probate" -foregroundcolor gray
        write-host ""
        $departmentchoice = read-host
        sleep -m 500
        $ok = $departmentchoice -match '^[1,2,3,4,5,6,7,8,9,10,11,12]+$'
        
            if (-not $ok) 
            {
            write-host "`ninvalid selection" -foregroundcolor red 
            sleep -s 1
            }
        }
        until ($ok)
    
        if ($departmentchoice -eq "1")
        {
        $department = "banking and real estate finance"
        $adou = "ou=banking and real estate finance,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"
        $feeou = "ou=banking and real estate finance,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
		}

        elseif ($departmentchoice -eq "2")
        {
        $department = "commerical and ip"
        $adou = "ou=commercial and ip,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"
        $feeou = "ou=commercial and ip,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
		}
    
        elseif ($departmentchoice -eq "3")
        {
        $department = "commercial property"
        $adou = "ou=commercial property,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
        $feeou = "ou=commercial property,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"      
		}
    
        elseif ($departmentchoice -eq "4")
        {
        $department = "corporate"
        $adou = "ou=corporate,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
        $feeou = "ou=corporate,ou=feeearners,ou=ksl staff,dc=kuits,dc=local" 
		}
    
        elseif ($departmentchoice -eq "5")
        {
        $department = "employment"
        $adou = "ou=employment,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=employment,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"  
        }
    
        elseif ($departmentchoice -eq "6")
        {
        $department = "family"
        $adou = "ou=family,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=family,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
        }
    
        elseif ($departmentchoice -eq "7")
        {
        $department = "intellectual property"
        $adou = "ou=ip,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=ip,ou=feeearners,ou=ksl staff,dc=kuits,dc=local" 
        }
    
        elseif ($departmentchoice -eq "8")
        {
        $department = "licensing"
        $adou = "ou=licensing,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=licensing,ou=feeearners,ou=ksl staff,dc=kuits,dc=local" 
        }
    
        elseif ($departmentchoice -eq "9")
        {
        $department = "litigation"
        $adou = "ou=litigation,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=litigation,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
        }
    
        elseif ($departmentchoice -eq "10")
        {
        $department = "real estate and development"
        $adou = "ou=real estate and development,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=real estate and development,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"  
        }
    
        elseif ($departmentchoice -eq "11")
        {
        $department = "residential property"
        $adou = "ou=residentail property,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=residential property,ou=feeearners,ou=ksl staff,dc=kuits,dc=local" 
        }
    
        elseif ($departmentchoice -eq "12")
        {
        $department = "tax and probate"
        $adou = "ou=tax & probate,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"
		$feeou = "ou=tax & probate,ou=feeearners,ou=ksl staff,dc=kuits,dc=local" 
        }
   
    $ou = "ou=" + "$department" + ",ou=secretarial,ou=ksl staff,dc=kuits,dc=local"
    $namecheck = get-aduser -filter * | where {$_.name -like "*$name*"} -erroraction silentlycontinue
    
        if ($namecheck)
        {
        sleep -s 1
        write-host "sec a user called $name already exists in the $department department, their distinguished name will append a '2' at the end."  -foregroundcolor red
        write-host "this will not affect the way the users name is displayed." -foregroundcolor red
        sleep -m 500
        $dist = $name + "2"
        $distinguishedname = "cn=$dist," + "$ou"
        }

        else
        {
        $dist = $name
        }
    
    }

    ### if support
    elseif ($fss -eq "3")
    {
        do
        {
        write-host "`nwhat department will $name be joining?`n"
        write-host "`1.  accounts" -foregroundcolor gray
        write-host "`2.  hr" -foregroundcolor gray 
        write-host "`3.  marketing" -foregroundcolor gray
        write-host "`4.  money laundering / compliance" -foregroundcolor gray
        write-host "`5.  operations" -foregroundcolor gray 
        write-host "`6.  post" -foregroundcolor gray
        write-host "`7.  reception" -foregroundcolor gray
        write-host "`8.  records & files" -foregroundcolor gray
        write-host "`9.  training" -foregroundcolor gray
        write-host ""
        $departmentchoice = read-host
        sleep -m 500
        $ok = $departmentchoice -match '^[1,2,3,4,5,6,7,8,9]+$'
        
            if (-not $ok) 
            {
            write-host "`ninvalid selection" -foregroundcolor red 
            sleep -s 1
            }
        }
        until ($ok)
    
        if ($departmentchoice -eq "1")
        {
        $department = "accounts"
        $adou = "ou=accounts,ou=support,ou=ksl staff,dc=kuits,dc=local"        
        }

        elseif ($departmentchoice -eq "2")
        {
        $department = "hr"
        $adou = "ou=hr,ou=support,ou=ksl staff,dc=kuits,dc=local"        
        }
    
        elseif ($departmentchoice -eq "3")
        {
        $department = "marketing"
        $adou = "ou=marketing,ou=support,ou=ksl staff,dc=kuits,dc=local"
        }
    
        elseif ($departmentchoice -eq "4")
        {
        $department = "ml"
        $adou = "ou=ml,ou=support,ou=ksl staff,dc=kuits,dc=local"        
        }
    
        elseif ($departmentchoice -eq "5")
        {
        $department = "operations"
        $adou = "ou=operations,ou=support,ou=ksl staff,dc=kuits,dc=local"        
        }
    
        elseif ($departmentchoice -eq "6")
        {
        $department = "support"
        $adou = "ou=post,ou=support,ou=ksl staff,dc=kuits,dc=local"
        }
    
        elseif ($departmentchoice -eq "7")
        {
        $department = "support"
        $adou = "ou=receptionists,ou=support,ou=ksl staff,dc=kuits,dc=local"
        }
    
        elseif ($departmentchoice -eq "8")
        {
        $department = "records & files"
        $adou = "ou=records & files,ou=support,ou=ksl staff,dc=kuits,dc=local"
        }
    
        elseif ($departmentchoice -eq "9")
        {
        $department = "training"
        $adou = "ou=training,ou=support,ou=ksl staff,dc=kuits,dc=local"
        }
    
    $ou = "ou=" + "$department" + ",ou=support,ou=ksl staff,dc=kuits,dc=local"
    $namecheck = get-aduser -filter * | where {$_.name -like "*$name*"} -erroraction silentlycontinue
    
        if ($namecheck)
        {
        sleep -s 1
        write-host "sup a user called $name already exists in the $department department, their distinguished name will append a '2' at the end." -foregroundcolor red
        write-host "this will not affect the way the users name is displayed." -foregroundcolor red
        sleep -m 500
        $dist = $name + "2"
        $distinguishedname = "cn=$dist," + "$ou"
        }

        else
        {
        $dist = $name
        }

    }

    ### if it
    elseif ($fss -eq "4")
    {
    $department = "it"
    $adou = "ou=it,ou=ksl staff,dc=kuits,dc=local"    
    $ou = "ou=" + "$department" + ",ou=ksl staff,dc=kuits,dc=local"
    $namecheck = get-aduser -filter * | where {$_.name -like "*$name*"} -erroraction silentlycontinue
    
        if ($namecheck)
        {
        sleep -s 1
        write-host "it a user called $name already exists in the $department department, their distinguished name will append a '2' at the end." -foregroundcolor red
        write-host "this will not affect the way the users name is displayed." -foregroundcolor red
        sleep -m 500
        $dist = $name + "2"
        $distinguishedname = "cn=$dist," + "$ou"
        }

        else
        {
        $dist = $name
        }
    }

}
until ($namecont -ne "n")

$newname = $name.Split(' ')
$GivenName =  $newname[0]
$Surname = $newname[1]

### creating a username and checking for preexisting
$username = $name.split(' ')
$username = $username[0] + "." + $username[1]
write-host "`n$name's username will be set as " -nonewline
write-host "$username" -foregroundcolor cyan -nonewline
write-host ", is that ok? y/n"
$usernameconfirm = read-host

    if ($usernameconfirm -eq "n")
    {
    write-host "`nplease enter your preffered username"
    $username = read-host
    }

    else
    {
    }
    
do
{
$untest = get-aduser -filter * | where {$_.samaccountname -eq $username}

    if ($untest -eq $null)
    {
    sleep -s 1
    write-host "`nthis usename is unique in the domain and is ok to use`n" -foregroundcolor green
    sleep -s 1
    $conf = "1"
    }

    else
    {
    sleep -s 1
    write-host "`nthis username is already in use in the domain and is not ok to use, please enter another username : " -foregroundcolor red
    $username = read-host
    sleep -s 1
    $conf = "2"
    }
}
until ($conf -eq "1")

### job titles

    ### fee earner jobs
    if ($fss -eq "1")
    {
    write-host "`nplease select the appropriate job title for $name :"
    write-host  "`n`t1 - partner" -foregroundcolor gray
    write-host  "`t2 - senior associate" -foregroundcolor gray
    write-host  "`t3 - associate" -foregroundcolor gray
    write-host  "`t4 - solicitor" -foregroundcolor gray
    write-host  "`t5 - paralgeal" -foregroundcolor gray
    write-host  "`t6 - trainee solicitor" -foregroundcolor gray
    write-host  "`t7 - other (please specify)" -foregroundcolor gray
    write-host
    $jobtitle = read-host

        if ($jobtitle -eq "1")
        {
        $job = "partner"
        }
        
        elseif ($jobtitle -eq "2")
        {
        $job = "senior associate"
        }
        
        elseif ($jobtitle -eq "3")
        {
        $job = "associate"
        }
        
        elseif ($jobtitle -eq "4")
        {
        $job = "solicitor"
        }
        
        elseif ($jobtitle -eq "5")
        {
        $job = "paralegal"
        }
        
        elseif ($jobtitle -eq "6")
        {
        $job = "trainee solicitor"
        }
                
        elseif ($jobtitle -eq "7")
        {
        write-host "please enter the job title for $name"
        $job = read-host
        }
    }

    ### secretary jobs
    elseif ($fss -eq "2")
    {
    write-host "`nplease select the appropriate job title for $name :"
    write-host  "`n`t1 - team co-ordinator" -foregroundcolor gray
    write-host  "`t2 - secretary" -foregroundcolor gray
    write-host  "`t3 - admin assitant" -foregroundcolor gray
    write-host  "`t4 - other (please specify)" -foregroundcolor gray
    write-host
    $jobtitle = read-host
    
        if ($jobtitle -eq "1")
        {
        $job = "team co-ordinator"
        }

        elseif ($jobtitle -eq "2")
        {
        $job = "secretary"
        }
        
        elseif ($jobtitle -eq "3")
        {
        $job = "admin assistant"
        }

        elseif ($jobtitle -eq "4")
        {
        write-host "please enter the job title for $name"
        $job = read-host
        }
    }

    ### support jobs
    elseif ($fss -eq "3")
    {
        
        if ($department -eq "accounts")
        {
        write-host "`nplease select the appropriate job title for $name :"
        write-host  "`n`t1 - cashier" -foregroundcolor gray
        write-host  "`t2 - credit controller" -foregroundcolor gray
        write-host  "`t3 - other (please specify)" -foregroundcolor gray
        write-host
        $jobtitle = read-host
                
            if ($jobtitle -eq "2")
            {
            $job = "cashier"
            }
            
            elseif ($jobtitle -eq "2")
            {
            $job = "credit controller"
            }
                        
            elseif ($jobtitle -eq "3")
            {
            write-host "please enter the job title for $name"
            $job = read-host
            }
        }

        if ($department -eq "hr")
        {
        write-host "`nplease select the appropriate job title for $name :"
        write-host  "`n`t1 - hr assistant" -foregroundcolor gray
        write-host  "`t2 - other (please specify)" -foregroundcolor gray
        write-host
        $jobtitle = read-host
    
            if ($jobtitle -eq "1")
            {
            $job = "hr assistant"
            }

            elseif ($jobtitle -eq "2")
            {
            write-host "please enter the job title for $name"
            $jobtitle = read-host
            }
        }
        
        if ($department -eq "marketing")
        {
        write-host "`nplease select the appropriate job title for $name :"
        write-host  "`n`t1 - marketing executive" -foregroundcolor gray
        write-host  "`t2 - marketing assistant" -foregroundcolor gray
        write-host  "`t3 - marketing consultant" -foregroundcolor gray
        write-host  "`t4 - other (please specify)" -foregroundcolor gray
        write-host
        $jobtitle = read-host
            
            if ($jobtitle -eq "1")
            {
            $job = "marketing executive"
            }
            
            elseif ($jobtitle -eq "2")
            {
            $job = "marketing assistant"
            }
            
            elseif ($jobtitle -eq "3")
            {
            $job = "marketing consultant"
            }
            
            elseif ($jobtitle -eq "4")
            {
            write-host "please enter the job title for $name"
            $job = read-host
            }
        }

        if ($department -eq "ml")
        {
        write-host "`nplease select the appropriate job title for $name :"
        write-host  "`n`t1 - compliance administrator" -foregroundcolor gray
        write-host  "`t2 - money launderung & compliance administrator" -foregroundcolor gray
        write-host  "`t3 - other (please specify)" -foregroundcolor gray
        write-host
        $jobtitle = read-host
            
            if ($jobtitle -eq "1")
            {
            $job = "compliance administrator"
            }
            
            elseif ($jobtitle -eq "2")
            {
            $job = "money laundering & compliance administrator"
            }

            elseif ($jobtitle -eq "3")
            {
            write-host "please enter the job title for $name"
            $job = read-host
            }
        }

        if ($department -eq "operations")
        {
        write-host "please enter the job title for $name"
        $jobtitle = read-host
        }

        if ($department -eq "post")
        {
        write-host "`nplease select the appropriate job title for $name :"
        write-host  "`n`t1 - clerk" -foregroundcolor gray
        write-host  "`t2 - other (please specify)" -foregroundcolor gray
        write-host
        $jobtitle = read-host
    
            if ($jobtitle -eq "1")
            {
            $job = "clerk"
            }
            
            elseif ($jobtitle -eq "2")
            {
            write-host "please enter the job title for $name"
            $job = read-host
            }
        }

        if ($department -eq "receptionists")
        {
        write-host "`nplease select the appropriate job title for $name :"
        write-host  "`n`t1 - receptionist" -foregroundcolor gray
        write-host  "`t2 - other (please specify)" -foregroundcolor gray
        write-host
        $jobtitle = read-host
    
            if ($jobtitle -eq "1")
            {
            $job = "receptionist"
            }
            
            elseif ($jobtitle -eq "2")
            {
            write-host "please enter the job title for $name"
            $job = read-host
            }
        }

        if ($department -eq "records & files")
        {
        write-host "`nplease select the appropriate job title for $name :"
        write-host  "`n`t1 - archivist" -foregroundcolor gray
        write-host  "`t2 - other (please specify)" -foregroundcolor gray
        write-host
        $jobtitle = read-host
    
            if ($jobtitle -eq "1")
            {
            $job = "archivist"
            }
            
            elseif ($jobtitle -eq "2")
            {
            write-host "please enter the job title for $name"
            $job = read-host
            }
        }

        if ($department -eq "training")
        {
        write-host "`nplease select the appropriate job title for $name :"
        write-host  "`n`t1 - training officer" -foregroundcolor gray
        write-host  "`t2 - other (please specify)" -foregroundcolor gray
        write-host
        $jobtitle = read-host
    
            if ($jobtitle -eq "1")
            {
            $job = "training officer"
            }
            
            elseif ($jobtitle -eq "2")
            {
            write-host "please enter the job title for $name"
            $job = read-host
            }
        }
    }

    ### it jobs
    elseif ($fss -eq "4")
    {
    write-host "please enter the job title for $name"
    $job = read-host
    }

sleep -s 1

### office location
write-host "`nwill $name be based in 3 st mary's or reedham house? :"
write-host "`n`t1 - 3 st mary's" -foregroundcolor gray
write-host "`t2 - reedham house" -foregroundcolor gray
write-host "`t3 - blackfriars" -foregroundcolor gray
$office = read-host

    if ($office -eq "1")
    {
    $office = "3sm"
    }

    elseif ($office -eq "2")
    {
    $office = "reedham house"
    }
    
    elseif ($office -eq "3")
    {
    $office = "blackfriars"
    }

### email address check and creation
$split = $name.split(' ')
$email = $split[0] + $split[1] + "@kuits.com"
do
{
$emailtest = get-recipient -identity $email -erroraction silentlycontinue
    
    if ($emailtest)
    { 
    write-host "`nthe default email address for $name would be $email but this is already in use in the kuits domain, please choose a different email address" -foregroundcolor red
    sleep -m 500 
    write-host "`nemail address for $name : " -nonewline -foregroundcolor cyan
    $emailcont = "0"
    $email = read-host
    }

    else
    {
    write-host "`n$name's email will be set as " -nonewline
    write-host "$email" -foregroundcolor cyan -nonewline
    write-host ", is that ok? y/n"
    $emailconfirm = read-host

        if ($emailconfirm -eq "n")
        {
        write-host "`nplease enter the full email address wou would like to use for"
        $emailcont = "0"
        $email = read-host
        }

        elseif ($emailconfirm -eq "y")
        {
        $emailcont = "1"
        }
    }
}
until ($emailcont -eq "1")
$email2 = "$username" + "@kuits.com"
write-host "`n$name will also be given a mail alias of $email2" -foregroundcolor Gray
sleep -s 1
     
### homedrive
$homedirectory = "\\kslnas01\userfolders$\$username"
$homedrive = "H:"

### profile path
$profilepath = "\\kslnas01\profiles$\$username"

### phone number
$telbank = "+44 (0)161 838 7809"
$telcommip = "+44 (0)161 838 7806"
$telcommprop = "+44 (0)161 838 7875"
$telcorp = "+44 (0)161 838 7806"
$telempl = "+44 (0)161 838 7806"
$telfam = "+44 (0)161 838 7882"
$telip = "+44 (0)161 838 7816"
$tellic = "+44 (0)161 838 7888"
$tellit = "+44 (0)161 838 7807"
$telrealestdev = ""
$telresi = "+44 (0)161 838 7874"
$teltaxprob = "+44 (0)161 838 7882"

$telacc = "+44 (0)161 838 7894"
$telmark = "+44 (0)161 838 7808"

$teldefault = "+44 (0)161 832 3434"


    if ($department -eq "banking and real estate finance")
    {
    $ipphone = $telbank
    }

    elseif ($department -eq "commercial and ip")
    {
    $ipphone = $telcommip
    }
    
    elseif ($department -eq "commerical property")
    {
    $ipphone = $telcommprop
    }

    elseif ($department -eq "corporate")
    {
    $ipphone = $telcorp 
    }

    elseif ($department -eq "employment")
    {
    $ipphone = $telempl 
    }

    elseif ($department -eq "family")
    {
    $ipphone = $telfam 
    }

    elseif ($department -eq "ip")
    {
    $ipphone = $telip 
    }

    elseif ($department -eq "licensing")
    {
    $ipphone = $tellic 
    }
    
    elseif ($department -eq "litigation")
    {
    $ipphone = $tellit 
    }

    elseif ($department -eq "real estate and development")
    {
    $ipphone = $telrealestdev 
    }

    elseif ($department -eq "residential property")
    {
    $ipphone = $telresi 
    }

    elseif ($department -eq "tax and probate")
    {
    $ipphone = $teltaxprob 
    }

    elseif ($department -eq "accounts")
    {
    $ipphone = $telacc
    }

    elseif ($department -eq "marketing")
    {
    $ipphone = $telmark
    }

    else
    {
    $ipphone = $teldefault
    }

sleep -s 1
write-host "`n$name's departmental phone number will be set as $ipphone"
sleep -s 1

### fax number

$faxbank = "+44 (0)161 838 8103"
$faxcommip = "+44 (0)161 838 8110"
$faxcommprop = "+44 (0)161 838 8100"
$faxcorp = "+44 (0)161 838 8111"
$faxempl = "+44 (0)161 838 8107"
$faxfam = "+44 (0)161 838 8115"
$faxip = "+44 (0)161 838 8110"
$faxlic = "+44 (0)161 838 8109"
$faxlit = "+44 (0)161 838 8104"
$faxrealestdev = ""
$faxresi = "+44 (0)161 838 8102"
$faxtaxprob = "+44 (0)161 838 8108"

$faxacc = "+44 (0)161 838 8112"
$faxmark = "+44 (0)161 838 8105"
$faxhr = "+44 (0)161 838 8106"
$faxit = "+44 (0)161 838 8113"

$faxdefault = "+44 (0)161 838 8"

    if ($department -eq "banking and real estate finance")
    {
    $fax = $faxbank
    }

    elseif ($department -eq "commercial and ip")
    {
    $fax = $faxcommip
    }
    
    elseif ($department -eq "commerical property")
    {
    $fax = $faxcommprop
    }

    elseif ($department -eq "corporate")
    {
    $fax = $faxcorp 
    }

    elseif ($department -eq "employment")
    {
    $fax = $faxempl 
    }

    elseif ($department -eq "family")
    {
    $fax = $faxfam 
    }

    elseif ($department -eq "ip")
    {
    $fax = $faxip 
    }

    elseif ($department -eq "licensing")
    {
    $fax = $faxlic 
    }
    
    elseif ($department -eq "litigation")
    {
    $fax = $faxlit 
    }

    elseif ($department -eq "real estate and development")
    {
    $fax = $faxrealestdev 
    }

    elseif ($department -eq "residential property")
    {
    $fax = $faxresi 
    }

    elseif ($department -eq "tax and probate")
    {
    $fax = $faxtaxprob 
    }

    elseif ($department -eq "it")
    {
    $fax = $faxit
    }

### set final attributes
$company = "Kuit Steinart Levy LLP"
$displayname = $name
$userprinc = $username + "@kuits.local"

#### Password
$SecurePassword=ConvertTo-SecureString 'Kuits123' –asplaintext –force 

######  CREATE USER #####

New-ADUser -Company $company -Department $department -DisplayName $displayname -GivenName $givenname -HomeDirectory $homedirectory -HomeDrive $homedrive -Office $office -PassThru -ProfilePath $profilepath -SamAccountName $username -Surname $surname -Title $job -AccountPassword $SecurePassword -Name $name -UserPrincipalName $userprinc -Enabled $true -fax $fax -PasswordNeverExpires $false -CannotChangePassword $false


    if ($fss -eq "1")
    {
    Set-ADUser $username -add @{extensionattribute1 = "FE"}
    }

    elseif ($job -eq "trainee solicitor")
    {
    Set-ADUser $username -add @{extensionattribute2 = "Trainee"}
    }


set-aduser $username -add @{physicalDeliveryOfficeName = $office}
set-aduser $username -Add @{ipphone = $ipphone}


sleep -s 1
set-aduser $username -ChangePasswordAtLogon $true


######  CREATE MAILBOX #####
write-host "Creating Mailbox for $name`n`n" -ForegroundColor Cyan
sleep -s 5
Enable-Mailbox -Identity $username -Database "Mailbox Database Kuits 1"
write-host "Mailbox Created for $name" -ForegroundColor Cyan

### Initials check
Write-Host "What would you like the initials for $name to be? (no more than 3 characters)"
DO
{
$initials =Read-Host
write-host "`nPlease wait, this part may take a while......" -ForegroundColor Yellow

$initialscheck = Get-ADUser -filter * -Properties * | where {$_.initials -eq $initials} | select name

    if ($initialscheck)
    {
    Write-Host "`nThe initials you have selected are already in use, please select new initials" -ForegroundColor Red
    $initcont = "1"
    }

    else
    {
    write-host "`n$name's initials will be set as $initials`n"
    $initcont = "0"
    write-host "Please continue to wait" -ForegroundColor Yellow
    }

}
Until ($initcont -ne "1")

Set-ADUser $username -Initials $initials


### Move AD Object

$originalOU = "cn='$name',ou=users,dc=kuits,dc=local"
Get-ADUser -Identity $username |  Move-ADObject -TargetPath "$ou"


### fee earner - grant send on behalf to this mailbox to all secretaries in department

if ($fss -eq "1")
{
$delegates = get-aduser -SearchBase $secou -Filter * -Properties mail | select mail

    foreach ($delegate in $delegates)
    {
    $delegate = $delegate.mail
    set-mailbox $email -GrantSendOnBehalfTo @{add=$delegate}
    }

}

### secretary - get send on behalf to all fee earners in dept

if ($fss -eq "2")
{
$Permissions = get-aduser -SearchBase $feeou -Filter * -Properties mail | select mail

    foreach ($permission in $permissions)
    {
    $permission = $permission.mail
    set-mailbox $permission -GrantSendOnBehalfTo @{add=$email}
    }

}

### Create H Drive Folder
$ComputerName = "kslnas01"
$Path = "userfolders$"
$folder = "$username"
New-Item -Path "\\$ComputerName\$Path\$folder" -type directory -Force
$HSecGroup = "\\$ComputerName\$Path\$folder"


#region - Add to Groups

    #region - Accounts
    if ($department -eq "Accounts")
    {
    Add-ADGroupMember "AccountsDept" $username
    }
    #endregion

    #region - Banking
    if ($department -like "banking*")
    {
    Add-ADGroupMember "BankingDept" $username

        if ($fss -eq "1")
        {
        Add-ADGroupMember "Banking Fee Earners" $username
        }

        else
        {
        Add-ADGroupMember "Banking Secretaries" $username
        }
    }
    #endregion

    #region - Commercial and IP
    if ($department -eq "commercial and ip")
    {
    Add-ADGroupMember "CommercialIPDept" $username

        if ($fss -eq "1")
        {
        Add-ADGroupMember "Commercial and IP Fee Earners" $username
        }

        else
        {
        Add-ADGroupMember "Commercial and IP Secretaries" $username
        }
    }
    #endregion
        
    #region - Commercial Property
    if ($department -eq "commercial property")
    {
    Add-ADGroupMember "CommercialPropertyDept" $username

        if ($fss -eq "1")
        {
        Add-ADGroupMember "Commercial Property Fee Earners" $username
        }

        else
        {
        Add-ADGroupMember "Commercial Property Secretaries" $username
        }
    }
    #endregion

    #region - Corporate
    if ($department -eq "corporate")
    {
    Add-ADGroupMember "CorporateDept" $username

        if ($fss -eq "1")
        {
        Add-ADGroupMember "Corporate Fee Earners" $username
        }

        else
        {
        Add-ADGroupMember "Corporate Secretaries" $username
        }
    }
    #endregion

    #region - Employment
    if ($department -eq "employment")
    {
    Add-ADGroupMember "EmploymentDept" $username

        if ($fss -eq "1")
        {
        Add-ADGroupMember "Employment Fee Earners" $username
        }

        else
        {
        Add-ADGroupMember "Employment Secretaries" $username
        }
    }
    #endregion

    #region - Family
    if ($department -eq "Family")
    {
    Add-ADGroupMember "FamilyDept" $username

        if ($fss -eq "1")
        {
        Add-ADGroupMember "Family Fee Earners" $username
        }

        else
        {
        Add-ADGroupMember "Family Secretaries" $username
        }
    }
    #endregion

    #region - IP
    if ($department -eq "intellectual property" -and $fss -eq "1")
    {
    Add-ADGroupMember "IPDept" $username

        if ($fss -eq "1")
        {
        Add-ADGroupMember "IP Fee Earners" $username
        Add-ADGroupMember "IP Group" $username
        }

        else
        {
        Add-ADGroupMember "IP Secretaries" $username
        }
    }
    #endregion

    #region - Licensing
    if ($department -eq "licensing")
    {
    Add-ADGroupMember "LicensingDept" $username

        if ($fss -eq "1")
        {
        Add-ADGroupMember "Licensing Fee Earners" $username
        }

        else
        {
        Add-ADGroupMember "Licensing Secretaries" $username
        }
    }
    #endregion

    #region - Litigation
    if ($department -eq "litigation")
    {
    Add-ADGroupMember "LitigationDept" $username

        if ($fss -eq "1")
        {
        Add-ADGroupMember "Litigation Fee Earners" $username
        }

        else
        {
        Add-ADGroupMember "Litigation Secretaries" $username
        }
    }
    #endregion

    #region - Residential Property
    if ($department -eq "residential property")
    {
    Add-ADGroupMember "ResidentialPropertyDept" $username

        if ($fss -eq "1")
        {
        Add-ADGroupMember "Residential Property Fee Earners" $username
        }

        else
        {
        Add-ADGroupMember "Residential Property Secretaries" $username
        }
    }
    #endregion

    #region - Support
    if ($fss -eq "3")
    {
    Add-ADGroupMember "SupportDept" $username

        #region - Receptionists
        if ($job -eq "receptionist")
        {
        Add-ADGroupMember "GPOITS" $username
        Add-ADGroupMember "Remote Users" $username
        Add-ADGroupMember "Remote Workers" $username
        }
        #endregion

        #region - Archivists
        if ($job -eq "archivist")
        {
        Add-ADGroupMember "Archivists" $username
        }
        #endregion

    }
    #endregion

    #region - Tax
    if ($department -eq "tax & probate")
    {
    Add-ADGroupMember "TaxDept" $username
    Add-MailboxPermission -Identity "taxfax" -User "$username" -AccessRights fullaccess -InheritanceType all

        if ($fss -eq "1")
        {
        Add-ADGroupMember "Tax Fee Earners" $username
        }

        else
        {
        Add-ADGroupMember "Tax Property Secretaries" $username
        }
    }
    #endregion

    #region - KSL Partners Group
    if ($jobtitle -eq "1" -and $fss -eq "1")
    {
    Add-ADGroupMember -Identity "ksl partners" -Members $username
    }
    #endregion
    
    #region - H: Drives
    $HDRIVEGroup = $username + "_Full_Access"
    New-ADGroup -Name $HDRIVEGroup -SamAccountName $HDRIVEGroup -GroupCategory Security -GroupScope Global -Path "ou=H_Drives,ou=security groups,dc=kuits,dc=local" -Description "Members of this group have Full Access to the $username Folder"
    sleep -m 300
    Add-ADGroupMember $HDRIVEGroup $username
                            #Add-ADGroupMember "folder_redirection" $username

    $path = $hsecgroup
    $acl = get-acl $path
    $inherit = [system.security.accesscontrol.InheritanceFlags]"ContainerInherit, ObjectInherit"
    $propagation = [system.security.accesscontrol.PropagationFlags]"None"
    $Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("$HDRIVEGroup","FullControl",$inherit,$propagation,"Allow")
    
    
    sleep -s 2

    $acl.SetAccessRule($ar)
    set-acl $path $acl



    #endregion
    
    #region - Bighand
    if ($extensionattribute1 -eq "FE" -or $fss -eq "2")
    {
    Add-ADGroupMember "Bighand_users" $username
    }
    #endregion



#endregion
### Set AD Account Control

Set-ADAccountControl $username -PasswordNeverExpires $false -CannotChangePassword $false
set-aduser $username -ChangePasswordAtLogon $true

### Moving User
Get-ADUser -Identity $username |  Move-ADObject -TargetPath "$ou"

### Display user
sleep -s 1
Write-Host "`n---------------------------------------------------------------------"
write-host "`n$name has been created with the following attributes :`n" -ForegroundColor Cyan
get-aduser $username -Properties * | select Name, Samaccountname, Givenname, Surname, Title, Initials, department, Physicaldeliveryofficename, Company,  mail, Fax, Ipphone, Homedrive, Homedirectory, Profilepath, Userprincipalname
sleep -s 1

### EMAIL to spiceworks and IT Team

write-host "`n **** Please wait for process to complete ****" -ForegroundColor Yellow

set-acl $path $acl #######################################################################

sleep -s 1

if ($ticket -eq "1")
{
Send-MailMessage -From ITTeam@kuits.com -Subject "[Ticket #$ticketref]" -To ITDept@kuits.com -Body "`nA new user has been created with the following information : `n`n`tName : $name`n`tUsername : $username`nInitials : $initials`n`tJob Title : $job`n`tDepartment : $department`n`tOffice Location : $office`n`tEmail Address : $email`n`tHome Directory : $homedirectory`n`tHome Drive : $homedrive`n`nThe new user will need configuring in Bighand, Partner, PowWowNow and the Phone and Fax Systems" -SmtpServer EXCHSRV2.kuits.local
}

elseif ($ticket -eq "2")
{
Send-MailMessage -From ITTeam@kuits.com -Subject "New Starter - $name" -To ITDept@kuits.com -Body "`nA new user has been created with the following information : `n`n`tName : $name`n`tUsername : $username`n`tJob Title : $job`n`tDepartment : $department`n`tOffice Location : $office`n`tEmail Address : $email`n`tHome Directory : $homedirectory`n`tHome Drive : $homedrive`n`nThe new user will need configuring in Bighand, Partner, PowWowNow and the Phone and Fax Systems" -SmtpServer EXCHSRV2.kuits.local
}

#email to HR
Send-MailMessage -From ITTeam@kuits.com -Subject "New Starter - $name" -To AlisonPearse@kuits.com -Body "`nA new user has been created with the following information : `n`n`tName : $name`n`tUsername : $username`n`tJob Title : $job`n`tDepartment : $department`n`tOffice Location : $office`n`tEmail Address : $email`n`nPlease can you ensure that they are set up in HR Net.`n`nThanks,`nIT" -SmtpServer EXCHSRV2.kuits.local

### repeat
write-host "`nwould you like to create another new user? type n to exit" -foregroundcolor yellow
$continue = read-host

}
until ($continue -eq "n")

