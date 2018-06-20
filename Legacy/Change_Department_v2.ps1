$nameok = $null
$currentdept = $null
$currentgroups = $null
$currentgroup = $null

write-host "*** Change Department Script ***" -ForegroundColor Yellow -BackgroundColor Black

#region <Checking User Exisits>
 DO
    {
    write-host "`n`nEnter the name of the user moving department" -ForegroundColor Yellow
    $name = read-host
    $nametest = get-aduser -filter * | where {$_.name -like "*$name*"}
    
        if ($nametest)
        {
        write-host "`nUser $name exists" -ForegroundColor Green
        $user = get-aduser -filter * | where {$_.name -like "$name"} | select samaccountname
        $user = $user.samaccountname
        $nameok = "ok"
        }

        else
        {
        write-host "`n`nNo user called $name exists" -ForegroundColor Red
        sleep -m 500
        }
    }
    Until ($nameok -eq "OK")
    
#endregion

#region <getting info for variables>
#get current department
$currentdept = ((get-aduser $user -Properties department | select department).department).tostring()
write-host "`n$name is currently in the $currentdept department" -ForegroundColor Gray
sleep -m 500
                    
#get current groups
$currentgroups = (Get-ADPrincipalGroupMembership $user | select name | sort name).name

#check if fee earner
$FeeEarner = ((get-aduser $user -Properties extensionattribute1 | select extensionattribute1).extensionattribute1).tostring()

#get new department
write-host "`nWhat department will $name be joining?`n"
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

    if ($departmentchoice -eq "1")
            {
            $department = "banking and real estate finance"
            $adou = "ou=banking and real estate finance,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
            $secou = "ou=banking and real estate finance,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"
            $feegroup = "Banking Fee Earners"
            $secgroup = "Banking Secretaries"
            $deptgroup = "BankingDept"
            }

            elseif ($departmentchoice -eq "2")
            {
            $department = "commercial and ip"
            $adou = "ou=commercial and ip,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
            $secou = "ou=commercial and ip,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"
            $feegroup = ""
            $secgroup = ""
            $deptgroup = ""
            }
    
            elseif ($departmentchoice -eq "3")
            {
            $department = "commercial property"
            $adou = "ou=corporate,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=commercial property,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
            $feegroup = ""
            $secgroup = ""
            $deptgroup = ""
            }
    
            elseif ($departmentchoice -eq "4")
            {
            $department = "corporate"
            $adou = "ou=corporate,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=corporate,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"  
            $feegroup = ""
            $secgroup = ""
            $deptgroup = ""
            }
        
            elseif ($departmentchoice -eq "5")
            {
            $department = "employment"
            $adou = "ou=employment,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=employment,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"  
            $feegroup = ""
            $secgroup = ""
            $deptgroup = ""
            }
    
            elseif ($departmentchoice -eq "6")
            {
            $department = "family"
            $adou = "ou=family,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=family,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"         
            $feegroup = ""
            $secgroup = ""
            $deptgroup = ""
            }
    
            elseif ($departmentchoice -eq "7")
            {
            $department = "intellectual property"
            $adou = "ou=ip,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=ip,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
            $feegroup = ""
            $secgroup = ""
            $deptgroup = ""
            }
    
            elseif ($departmentchoice -eq "8")
            {
            $department = "licensing"
            $adou = "ou=licensing,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=licensing,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"   
            $feegroup = ""
            $secgroup = ""
            $deptgroup = ""
            }
    
            elseif ($departmentchoice -eq "9")
            {
            $department = "litigation"
            $adou = "ou=litigation,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
            $secou = "ou=litigation,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"  
            $feegroup = ""
            $secgroup = ""
            $deptgroup = ""
            }
    
            elseif ($departmentchoice -eq "10")
            {
            $department = "real estate and development"
            $adou = "ou=real estate and development,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=real estate and development,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
            $feegroup = ""
            $secgroup = ""
            $deptgroup = ""
            }
    
            elseif ($departmentchoice -eq "11")
            {
            $department = "residential property"
            $adou = "ou=residential property,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=residentail property,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"   
            $feegroup = ""
            $secgroup = ""
            $deptgroup = ""
            }
    
            elseif ($departmentchoice -eq "12")
            {
            $department = "tax & probate"
            $adou = "ou=tax & probate,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"        
            $secou = "ou=tax & probate,ou=secretarial,ou=ksl staff,dc=kuits,dc=local" 
            $feegroup = ""
            $secgroup = ""
            $deptgroup = ""
            }

#endregion



#region <delete from departmental groups>

foreach ($currentgroup in $currentgroups)

    {
        if ($currentgroup -like "*$currentdept*")
        {
        $currentgroup
        #Remove-ADGroupMember -Identity $currentgroup -Members $user
        }


    }


#endregion




#region <add to new departmental groups>



    if ($FeeEarner = "FE")
    {
    $newgroupfee = (get-adgroup -Filter {name -like "*fee*" -and name -like "*$newdept*"}).name
    }

    else
    {

    }


#endregion

    