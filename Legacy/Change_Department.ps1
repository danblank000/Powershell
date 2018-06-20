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





    write-host "`n*** Changing $name's Department***" -ForegroundColor Yellow
    sleep -m 500
    write-host "`n`n$name's current Department is $department" -ForegroundColor Gray
    sleep -m 500
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
        write-host "`10. residential property" -foregroundcolor gray
        write-host "`11. tax and probate" -foregroundcolor gray
        write-host ""
    $newdept = read-host

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


    if ($newdept -eq "1")
    {
    $ipphone = $telbank
    }

    elseif ($newdept -eq "2")
    {
    $ipphone = $telcommip
    }
    
    elseif ($newdept -eq "3")
    {
    $ipphone = $telcommprop
    }

    elseif ($newdept -eq "4")
    {
    $ipphone = $telcorp 
    }

    elseif ($newdept -eq "5")
    {
    $ipphone = $telempl 
    }

    elseif ($newdept -eq "6")
    {
    $ipphone = $telfam 
    }

    elseif ($newdept -eq "7")
    {
    $ipphone = $telip 
    }

    elseif ($newdept -eq "8")
    {
    $ipphone = $tellic 
    }
    
    elseif ($newdept -eq "9")
    {
    $ipphone = $tellit 
    }

    elseif ($newdept -eq "10")
    {
    $ipphone = $telresi 
    }

    elseif ($newdept -eq "11")
    {
    $ipphone = $teltaxprob 
    }

    else
    {
    $ipphone = $teldefault
    }
    
    Set-ADUser $user -Clear "ipphone"
    set-aduser $user -Add @{ipphone = $ipphone}
        
        #removing from existing groups
        $groups = (get-aduser $user -Properties memberof).memberof
            
            foreach ($group in $groups)
            {
            
                # Fee Earners
                if ($fee -eq "FE")
                {
                
                    if ($group.ToString() -like "*fee earner*" -or $group.ToString() -like "*dept*")
                    {
                    $gro = $group.Split(",")
                    $gro = $gro[0]
                    $gro = ($gro.ToString()).split("=")
                    $gro = $gro[1]
                   
                    Remove-ADGroupMember -Identity $gro -Members $user -Confirm:$false
                    }

                }

                # Secretaries
                else
                {
                
                    if ($group.ToString() -like "*secretar*" -or $group.ToString() -like "*dept*")
                    {
                    $gro = $group.Split(",")
                    $gro = $gro[0]
                    $gro = ($gro.ToString()).split("=")
                    $gro = $gro[1]
                    Remove-ADGroupMember -Identity $gro -Members $user -Confirm:$false
                    }
                }
            
            }
            
        
        #adding to the new departments groups 
        if ($fee -eq "FE")
        {
        
        #region - Add to Groups
                    
            #region - Banking
            if ($newdept -eq "1")
            {
            Add-ADGroupMember "BankingDept" $user
            Add-ADGroupMember "Banking Fee Earners" $user
            $ADDept = "banking and real estate finance"
            }
            #endregion

            #region - Commercial and IP
            if ($newdept -eq "2")
            {
            Add-ADGroupMember "CommercialIPDept" $user
            Add-ADGroupMember "Commercial and IP Fee Earners" $user
            $ADDept = "commercial and ip"
            }
            #endregion
        
            #region - Commercial Property
            if ($newdept -eq "3")
            {
            Add-ADGroupMember "CommercialPropertyDept" $user
            Add-ADGroupMember "Commercial Property Fee Earners" $user
            $ADDept = "commercial property"
            }
            #endregion

            #region - Corporate
            if ($newdept -eq "4")
            {
            Add-ADGroupMember "CorporateDept" $user
            Add-ADGroupMember "Corporate Fee Earners" $user
            $ADDept = "c"
            }
            #endregion

            #region - Employment
           if ($newdept -eq "5")
            {
            Add-ADGroupMember "EmploymentDept" $user
            Add-ADGroupMember "Employment Fee Earners" $user
            $ADDept = "corporate"
            }
            #endregion

            #region - Family
            if ($newdept -eq "6")
            {
            Add-ADGroupMember "FamilyDept" $user
            Add-ADGroupMember "Family Fee Earners" $user
            $ADDept = "family"
            }
            #endregion

            #region - IP
           if ($newdept -eq "7")
            {
            Add-ADGroupMember "IPDept" $user
            Add-ADGroupMember "IP Fee Earners" $user
            Add-ADGroupMember "IP Group" $user
            $ADDept = "intellectual property"
            }
            #endregion

            #region - Licensing
            if ($newdept -eq "8")
            {
            Add-ADGroupMember "LicensingDept" $user
            Add-ADGroupMember "Licensing Fee Earners" $user
            $ADDept = "licensing"
            }
            #endregion

            #region - Litigation
            if ($newdept -eq "9")
            {
            Add-ADGroupMember "LitigationDept" $user
            Add-ADGroupMember "Litigation Fee Earners" $user
            $ADDept = "litigation"
            }
            #endregion

            #region - Residential Property
            if ($newdept -eq "10")
            {
            Add-ADGroupMember "ResidentialPropertyDept" $user
            Add-ADGroupMember "Residential Property Fee Earners" $user
            $ADDept = "residential property"
            }
            #endregion
        
            #region - Tax
            if ($newdept -eq "11")
            {
            Add-ADGroupMember "TaxDept" $user
            Add-ADGroupMember "Tax Fee Earners" $user
            $ADDept = "tax and probate"
            }
            #endregion


        }

        else
        {
            #region - Banking
            if ($newdept -eq "1")
            {
            Add-ADGroupMember "BankingDept" $user
            Add-ADGroupMember "Banking Secretaries" $user
            $ADDept = "banking and real estate finance"
            }
            #endregion

            #region - Commercial and IP
            if ($newdept -eq "2")
            {
            Add-ADGroupMember "CommercialIPDept" $user
            Add-ADGroupMember "Commercial and IP Secretaries" $user
            $ADDept = "commercial and ip"
            }
            #endregion
        
            #region - Commercial Property
            if ($newdept -eq "3")
            {
            Add-ADGroupMember "CommercialPropertyDept" $user
            Add-ADGroupMember "Commercial Property Secretaries" $user
            $ADDept = "commercial property"
            }
            #endregion

            #region - Corporate
            if ($newdept -eq "4")
            {
            Add-ADGroupMember "CorporateDept" $user
            Add-ADGroupMember "Corporate Secretaries" $user
            $ADDept = "corporate"
            }
            #endregion

            #region - Employment
            if ($newdept -eq "5")
            {
            Add-ADGroupMember "EmploymentDept" $user
            Add-ADGroupMember "Employment Secretaries" $user
            $ADDept = "employment"
            }
            #endregion

            #region - Family
            if ($newdept -eq "6")
            {
            Add-ADGroupMember "FamilyDept" $user
            Add-ADGroupMember "Family Secretaries" $user
            $ADDept = "family"
            }
            #endregion

            #region - IP
            if ($newdept -eq "7")
            {
            Add-ADGroupMember "IPDept" $user
            Add-ADGroupMember "IP Secretaries" $user
            Add-ADGroupMember "IP Group" $user
            $ADDept = "intellectual property"
            }
            #endregion

            #region - Licensing
            if ($newdept -eq "8")
            {
            Add-ADGroupMember "LicensingDept" $user
            Add-ADGroupMember "Licensing Secretaries" $user
            $ADDept = "licensing"
            }
            #endregion

            #region - Litigation
            if ($newdept -eq "9")
            {
            Add-ADGroupMember "LitigationDept" $user
            Add-ADGroupMember "Litigation Secretaries" $user
            $ADDept = "litigation"
            }
            #endregion

            #region - Residential Property
            if ($newdept -eq "10")
            {
            Add-ADGroupMember "ResidentialPropertyDept" $user
            Add-ADGroupMember "Residential Property Secretaries" $user
            $ADDept = "residential property"
            }
            #endregion
        
            #region - Tax
            if ($newdept -eq "11")
            {
            Add-ADGroupMember "TaxDept" $user
            Add-ADGroupMember "Tax Secretaries" $user
            $ADDept = "tax and probate"
            }
            #endregion
        }
        
    
    #endregion


#region - Move AD Object

        if ($newdept -eq "1")
        {
        $secou = "ou=banking and real estate finance,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"
        $feeou = "ou=banking and real estate finance,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
		}

        if ($newdept -eq "2")
        {
        $secou = "ou=commercial and ip,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"
        $feeou = "ou=commercial and ip,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
		}
    
        if ($newdept -eq "3")
        {
        $secou = "ou=commercial property,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
        $feeou = "ou=commercial property,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"      
		}
    
        if ($newdept -eq "4")
        {
        $secou = "ou=corporate,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
        $feeou = "ou=corporate,ou=feeearners,ou=ksl staff,dc=kuits,dc=local" 
		}
    
        if ($newdept -eq "5")
        {
        $secou = "ou=employment,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=employment,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"  
        }
    
        if ($newdept -eq "6")
        {
        $secou = "ou=family,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=family,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
        }
    
        if ($newdept -eq "7")
        {
        $secou = "ou=ip,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=ip,ou=feeearners,ou=ksl staff,dc=kuits,dc=local" 
        }
    
       if ($newdept -eq "8")
        {
        $secou = "ou=licensing,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=licensing,ou=feeearners,ou=ksl staff,dc=kuits,dc=local" 
        }
    
        if ($newdept -eq "9")
        {
        $secou = "ou=litigation,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=litigation,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
        }
        
        if ($newdept -eq "10")
        {
        $secou = "ou=residentail property,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"        
		$feeou = "ou=residential property,ou=feeearners,ou=ksl staff,dc=kuits,dc=local" 
        }
    
        if ($newdept -eq "11")
        {
        $secou = "ou=tax & probate,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"
		$feeou = "ou=tax & probate,ou=feeearners,ou=ksl staff,dc=kuits,dc=local" 
        }



    if ($fss -eq "FE")
    {
    Get-ADUser -Identity $user |  Move-ADObject -TargetPath "$feeou"
    }

    else
    {
    Get-ADUser -Identity $user |  Move-ADObject -TargetPath "$secou"
    }

    set-aduser $user -Department $ADDept

#endregion
    
    #endregion