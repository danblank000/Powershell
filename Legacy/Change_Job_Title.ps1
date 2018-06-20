$fss = ""
$fee = ""
   
cls

Write-host "`nPlease enter the name of the person to change"
$name = read-host

$user = get-aduser -filter * -Properties * | where {$_.name -like "$name"} | select samaccountname
$user = $user.samaccountname
$details = get-aduser $user -Properties *
$department = $details.department
$job = $details.title
$fss = $details.extensionattribute1


    write-host "`n*** Changing $name's Job Title ***" -ForegroundColor Yellow
    sleep -m 500
    write-host "`n`n$name's current job title is $job" -ForegroundColor Gray
    sleep -m 500
    write-host "`nWill $name be a fee-earner in their new role? y/n"
    $fee = read-host

#region Adding / removing Fee Earner Extension Attribute
        if ($fee -eq "y")
        {
        Set-ADUser $user -add @{extensionattribute1 = "FE"}
        }

        else
        {
        Set-ADUser $user -Clear "extensionattribute1"
        }
        #endregion

#region - Get New Job Title
    write-host "`nPlease enter $name's new job title?"
    $newtitle = read-host
    write-host "`nAre you sure you want to change $name's job title from $job to $newtitle ? y/n"
    $jobsure = read-host
    #endregion

#region - Changing Job Title
        if ($jobsure -eq "y")
        {
        $newtitle = $newtitle.ToLower()
        set-aduser $user -Title $newtitle
        write-host "`n`n$name's job title has now been changed to $newtitle" -ForegroundColor Cyan
        #endregion
        
#region Adding /Removing from Fee Earner / Secretary groups
        $groups = (get-aduser $user -Properties memberof).memberof
            
            foreach ($group in $groups)
            {
            
                # Fee Earners
                if ($fee -eq "y")
                {
                
                    if ($group.ToString() -like "*secretaries*")
                    {
                    $gro = $group.Split(",")
                    $gro = $gro[0]
                    $gro = ($gro.ToString()).split("=")
                    $gro = $gro[1]
                    Remove-ADGroupMember -Identity $gro -Members $user -Confirm:$false
                    }

                }

                # Secretaries
                if ($fee -eq "n")
                {
                
                    if ($group.ToString() -like "*fee earner*")
                    {
                    $gro = $group.Split(",")
                    $gro = $gro[0]
                    $gro = ($gro.ToString()).split("=")
                    $gro = $gro[1]
                    Remove-ADGroupMember -Identity $gro -Members $user -Confirm:$false
                    }
                }
            }
            
#region - Adding to new dist groups

            #region - Banking
            if ($department -like "banking*")
            {
    
                if ($fee -eq "y")
                {
                Add-ADGroupMember "Banking Fee Earners" $user
                }

                else
                {
                Add-ADGroupMember "Banking Secretaries" $user
                }
            }
            #endregion

            #region - Commercial and IP
            if ($department -eq "commercial and ip")
            {

                if ($fee -eq "y")
                {
                Add-ADGroupMember "Commercial and IP Fee Earners" $user
                }

                else
                {
                Add-ADGroupMember "Commercial and IP Secretaries" $user
                }
            }
            #endregion
        
            #region - Commercial Property
            if ($department -eq "commercial property")
            {
    
                if ($fee -eq "y")
                {
                Add-ADGroupMember "Commercial Property Fee Earners" $user
                }

                else
                {
                Add-ADGroupMember "Commercial Property Secretaries" $user
                }
            }
            #endregion

            #region - Corporate
            if ($department -eq "corporate")
            {
    
                if ($fee -eq "y")
                {
                Add-ADGroupMember "Corporate Fee Earners" $user
                }

                else
                {
                Add-ADGroupMember "Corporate Secretaries" $user
                }
            }
            #endregion

            #region - Employment
            if ($department -eq "employment")
            {
    
                if ($fee -eq "y")
                {
                Add-ADGroupMember "Employment Fee Earners" $user
                }

                else
                {
                Add-ADGroupMember "Employment Secretaries" $user
                }
            }
            #endregion

            #region - Family
            if ($department -eq "Family")
            {

                if ($fee -eq "y")
                {
                Add-ADGroupMember "Family Fee Earners" $user
                }

                else
                {
                Add-ADGroupMember "Family Secretaries" $user
                }
            }
            #endregion

            #region - IP
            if ($department -eq "intellectual property" -and $fee -eq "y")
            {
 
                if ($fee -eq "y")
                {
                Add-ADGroupMember "IP Fee Earners" $user
                Add-ADGroupMember "IP Group" $user
                }

                else
                {
                Add-ADGroupMember "IP Secretaries" $user
                }
            }
            #endregion

            #region - Licensing
            if ($department -eq "licensing")
            {
    
                if ($fee -eq "y")
                {
                Add-ADGroupMember "Licensing Fee Earners" $user
                }

                else
                {
                Add-ADGroupMember "Licensing Secretaries" $user
                }
            }
            #endregion

            #region - Litigation
            if ($department -eq "litigation")
            {
    
                if ($fee -eq "y")
                {
                Add-ADGroupMember "Litigation Fee Earners" $user
                }

                else
                {
                Add-ADGroupMember "Litigation Secretaries" $user
                }
            }
            #endregion

            #region - Residential Property
            if ($department -eq "residential property")
            {
    
                if ($fee -eq "y")
                {
                Add-ADGroupMember "Residential Property Fee Earners" $user
                }

                else
                {
                Add-ADGroupMember "Residential Property Secretaries" $user
                }
            }
            #endregion

            #region - Tax
            if ($department -eq "tax & probate")
            {
    
                if ($fee -eq "y")
                {
                Add-ADGroupMember "Tax Fee Earners" $user
                }

                else
                {
                Add-ADGroupMember "Tax Property Secretaries" $user
                }
            }
            #endregion
            #endregion
        
        }
        #endregion
    
#region - Move AD Object    
    
        #region - Setting AD Path
        if ($department -eq "banking and real estate finance")
        {
        $secou = "ou=banking and real estate finance,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"
        $feeou = "ou=banking and real estate finance,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
		}

        elseif ($department -eq "commercial and intellectual property")
        {
        $secou = "ou=commercial and ip,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"
        $feeou = "ou=commercial and ip,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
		}
    
        elseif ($department -eq "commercial property")
        {
        $secou = "ou=commercial property,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
        $feeou = "ou=commercial property,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"      
		}
    
        elseif ($department -like "corpo*")
        {
        $secou = "ou=corporate,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
        $feeou = "ou=corporate,ou=feeearners,ou=ksl staff,dc=kuits,dc=local" 
		}
    
        elseif ($department -eq "employment")
        {
        $secou = "ou=employment,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=employment,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"  
        }
    
        elseif ($department -eq "family")
        {
        $secou = "ou=family,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=family,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
        }
    
        elseif ($department -eq "intellectual property")
        {
        $secou = "ou=ip,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=ip,ou=feeearners,ou=ksl staff,dc=kuits,dc=local" 
        }
    
        elseif ($department -eq "licensing")
        {
        $secou = "ou=licensing,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=licensing,ou=feeearners,ou=ksl staff,dc=kuits,dc=local" 
        }
    
        elseif ($department -eq "litigation")
        {
        $secou = "ou=litigation,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=litigation,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
        }
    
        elseif ($department -eq "real estate and development")
        {
        $secou = "ou=real estate and development,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=real estate and development,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"  
        }
    
        elseif ($department -eq "residential property")
        {
        $secou = "ou=residentail property,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=residential property,ou=feeearners,ou=ksl staff,dc=kuits,dc=local" 
        }
    
        elseif ($department -eq "tax and probate")
        {
        $secou = "ou=tax & probate,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"
		$feeou = "ou=tax & probate,ou=feeearners,ou=ksl staff,dc=kuits,dc=local" 
        }
        #endregion


        #region - The Actual Move
        if ($fee -eq "y")
        {
        write-host "I am trying to move!" -ForegroundColor DarkRed
        Get-ADUser -Identity $user | Move-ADObject -TargetPath $feeou
        write-host "I am trying to move!" -ForegroundColor DarkRed
        }

        else
        {
        write-host "I am trying to move!" -ForegroundColor  DarkYellow
        Get-ADUser -Identity $user |  Move-ADObject -TargetPath $secou
        write-host "I am trying to move!" -ForegroundColor  DarkYellow
        }
        #endregion

#endregion



    #endregion