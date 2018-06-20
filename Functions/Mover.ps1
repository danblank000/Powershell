#region <Script Synopsis>
<# 
.Synopsis 
   Script to move users
.Description
   Daniel Blank
   moves users updates / removes memberships to relevant groups
   Version 1.0 June 2017 
   Requires: Windows PowerShell Module for Active Directory and Exchange
.EXAMPLE 
  Mover -Name "Joe Bloggs" -NewDepartment "Tax" -Fee -Ticket "5017"
  
#>
#endregion 

Function Mover
{

    #region <Set parameters>
    param( 
        #Enter Full name of user
        [Parameter(Mandatory=$True,Position=0)] 
        [ValidateNotNull()] 
        [string]$Name, 
        
        # Enter the department user is moving to
        [Parameter(Mandatory=$True, Position=1)] 
        [string]$NewDepartment,
            
        # Did the Job title change?
        [Parameter(Position=2)]
        [string]$Title,
        
        # Will the user be a fee-earner?
        [Parameter(Position=3)] 
        [switch]$Fee,
                
        # Is there a ticket logged? Enter the ticket number
        [Parameter(Position=4)] 
        [int]$Ticket
    )
    #endregion

    #region <Generic Variables>

    $Leave = @()
    $Groups = @()

    #endregion
    
    #region <Name>
    
        
        $mover = get-aduser -filter {name -like $name} -Properties extensionattribute1, department, samaccountname, initials, givenname, surname
        $Department = ($mover.department).ToString()
        $User = ($mover.samaccountname).ToString()
        $Initials = ($mover.initials).ToString()
        $GivenName = ($mover.givenname).ToString() 
        $Surname = ($mover.surname).ToString()
        
            if ($mover.extensionattribute1 -eq "FE")
            {
            $CurrentFE = $True
            }
               
    #endregion

    #region <Remove Groups>

    switch -wildcard ($Department)
    {
    "Banking and Real Estate Finance"       {
                                            $Leave += "BankingDept"
                                            $LeaveDeptList = "Banking "
                                            }

    "Commercial And Intellectual Property"  {
                                            $Leave += "CommercialIPDept"
                                            $LeaveDeptList = "Commercial and IP "                                            
                                            }

    "Commercial Property"                   {
                                            $Leave += "CommercialPropertyDept"
                                            $LeaveDeptList = "Commercial Property "                                            
                                            }
    
    "Corporate"                             {
                                            $Leave += "CorporateDept"
                                            $LeaveDeptList = "Corporate "                                            
                                            }

    "Corporate And Commercial"              {
                                            $Leave += "CorporateDept"
                                            $LeaveDeptList = "Corporate "                                            
                                            }


    "Employment"                            {
                                            $Leave += "EmploymentDept"
                                            $LeaveDeptList = "Employment "                                            
                                            }
    
    "Family"                                {
                                            $Leave += "FamilyDept"
                                            $LeaveDeptList = "Family "                                            
                                            }
    
    "Intellectual Property"                 {
                                            $Leave += "IPDept" 
                                            $LeaveDeptList = "IP "                                            
                                            }    

    "Licensing"                             {
                                            $Leave += "LicensingDept"
                                            $LeaveDeptList = "Licensing "                                            
                                            }

    "Litigation"                            {
                                            $Leave += "LitigationDept"
                                            $LeaveDeptList = "Litigation "                                            
                                            }

    "Residential Property"                  {
                                            $Leave += "ResidentialPropertyDept"
                                            $LeaveDeptList = "Residential Property "                                            
                                            }

    "Tax And Probate"                       {
                                            $Leave += "TaxDept"
                                            $Leave += "Sensitive Tax Files Lock"
                                            $LeaveDeptList = "Tax "                                            
                                            }
    
    "Support"                               {
                                            $Support = $true
                                            $Leave += "SupportDept"                                            
                                            }

    "Accounts"                              {
                                            $Support = $true
                                            $Leave += "AccountsDept"
                                            }

    "Operations"                            {
                                            $Support = $true
                                            $Leave += "SupportDept"   
                                            $Leave += "OperationsDept"                                         
                                            }

    "Marketing"                             {
                                            $Support = $true
                                            $Leave += "SupportDept"                                            
                                            $Leave += "MarketingDept"
                                            }

    "Risk"                                  {
                                            $Support = $true
                                            $Leave += "SupportDept"
                                            $Leave += "ComplianceDept"
                                            $Leave += "MLAdmins"
                                            }

    "HR"                                    {
                                            $Support = $true
                                            $Leave += "HRDept"                                            
                                            } 
    }

    if ($CurrentFE -eq $true)
    {
    $Leave += "$LeaveDeptList" + "Fee Earners"
    }

    elseif ($CurrentFE -ne $true -and $Support -ne $true)
    {
    $Leave += "$LeaveDeptList" + "Secretaries"
    }

    foreach ($LGroup in $Leave)
    {
    Remove-ADGroupMember -Identity "$LGroup" -Members "$User" -Confirm:$false
    }

    
    #endregion

    #region <Remove Mailbox Acess>

    #fee-earner
    

        if ($CurrentFE -eq $True)
        {
    
        try{
        $perms = (Get-MailboxPermission "$name" | Where-Object {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.user.tostring() -notlike "S-1-5-21*" -and $_.IsInherited -eq $false -and $_.user.tostring() -notlike "*administrator*"} | select user -ErrorAction SilentlyContinue).user
        
            foreach ($perm in $perms)
            {

            $perm = ($perm.Split('\'))[1]
            Remove-MailboxPermission -Identity "$name" -User "$perm" -AccessRights fullaccess -InheritanceType all -Confirm:$false
            }
        }catch{}
        
        }
    
    #secreatry
    
        elseif ($CurrentFE -ne $True -and $Support -ne $True)
        {

        try{
        $mailboxes = Get-Mailbox -Server "exchsrv2.kuits.local" | Get-MailboxPermission -user "$User" | select identity -ErrorAction SilentlyContinue

            foreach ($mailbox in $mailboxes)
            {
            $can = ($mailbox.Identity).tostring()
            $leaveMail = ((get-aduser -SearchBase "ou=ksl staff,dc=kuits,dc=local" -Filter * -Properties canonicalname | where {$_.canonicalname -like "$can"} | select name).name).tostring()
            Remove-MailboxPermission -identity "$leaveMail" -user $Name -AccessRights fullaccess -InheritanceType all -Confirm:$false -ErrorAction silentlycontinue
            }

        }catch{}
        }

    #endregion

    #region <New Department>

     switch -wildcard ($NewDepartment)
        {
        "*Banking*" {
                    $NewDepartment = "Banking and Real Estate Finance"
                    $office = "reedham house"
                    $depou = "banking"
                    $ipphone = "+44 (0)161 838 7809"
                    $SQLDeptPhone = "0161 838 7809"
                    $fax = "+44 (0)161 838 8103"
                    $Groups += "BankingDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Banking "
                    $Workgroup = "9"
                    $SQLDept = "SL"
                    $Manager = $NULL
                    $CarpeAD = "Banking"
                    $CarpeTK = "Banking"
                    }
        
        "*Comm IP*" {
                    $NewDepartment = "Commercial and Intellectual Property"
                    $office = "3sm"
                    $depou = "commercial_ip"
                    $ipphone = "+44 (0)161 838 7816"
                    $SQLDeptPhone = "0161 838 7816"
                    $fax = "+44 (0)161 838 8110"
                    $Groups += "CommercialIPDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Commercial and IP "
                    $plc ++
                    $Workgroup = "14"
                    $SQLDept = "CIP"
                    $Manager = $NULL
                    $CarpeAD = "Commercial and I.P"
                    $CarpeTK = "Commercial"
                    }
        
        "*Commercial IP*" {
                    $NewDepartment = "Commercial and Intellectual Property"
                    $office = "3sm"
                    $depou = "commercial_ip"
                    $ipphone = "+44 (0)161 838 7816"
                    $SQLDeptPhone = "0161 838 7816"
                    $fax = "+44 (0)161 838 8110"
                    $Groups += "CommercialIPDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Commercial and IP "
                    $plc ++
                    $Workgroup = "14"
                    $SQLDept = "CIP"
                    $Manager = $NULL
                    $CarpeAD = "Commercial and I.P"
                    $CarpeTK = "Commercial"
                    }
        
        "*Comm Prop*" {
                    $NewDepartment = "Commercial Property"
                    $office = "reedham house"
                    $depou = "commercial_property"
                    $ipphone = "+44 (0)161 838 7875"
                    $SQLDeptPhone = "0161 838 7875"
                    $fax = "+44 (0)161 838 8100"                    
                    $Groups += "CommercialPropertyDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Commercial Property "
                    $plc ++
                    $Workgroup = "4"
                    $SQLDept = "CM"
                    $Manager = $NULL
                    $CarpeAD = "Commercial Property"
                    $CarpeTK = "Commercial Property"
                    }
        
        "*Commerical Property*" {
                    $NewDepartment = "Commercial Property"
                    $office = "reedham house"
                    $depou = "commercial_property"
                    $ipphone = "+44 (0)161 838 7875"
                    $SQLDeptPhone = "0161 838 7875"
                    $fax = "+44 (0)161 838 8100"
                    $Groups += "CommercialPropertyDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Commercial Property "
                    $plc ++
                    $Workgroup = "4"
                    $SQLDept = "CM"
                    $Manager = $NULL
                    $CarpeAD = "Commercial Property"
                    $CarpeTK = "Commercial Property"
                    }
        
        "*Corporate*" {
                    $NewDepartment = "Corporate"
                    $office = "3sm"
                    $depou = "corporate"
                    $ipphone = "+44 (0)161 838 7806"
                    $SQLDeptPhone = "0161 838 7806"
                    $fax = "+44 (0)161 838 8111"
                    $Groups += "CorporateDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Corporate "
                    $plc ++
                    $Workgroup = "2"
                    $SQLDept = "COR"
                    $Manager = $NULL
                    $CarpeAD = "Corporate"                    
                    $CarpeTK = "Corporate"
                    }
        
        "*Employment*" {
                    $NewDepartment = "Employment"
                    $office = "3sm"
                    $depou = "employment"
                    $ipphone = "+44 (0)161 838 7806"
                    $SQLDeptPhone = "0161 838 7806"
                    $fax = "+44 (0)161 838 8107"
                    $Groups += "EmploymentDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Employment "
                    $plc ++
                    $Workgroup = "5"
                    $SQLDept = "EMP"
                    $Manager = $NULL
                    $CarpeAD = "Employment"                    
                    $CarpeTK = "Employment"
                    }
        
        "*Family*" {
                    $NewDepartment = "Family"
                    $office = "3sm"
                    $depou = "family"
                    $ipphone = "+44 (0)161 838 8146"
                    $SQLDeptPhone = "0161 838 8146"
                    $fax = "+44 (0)161 838 8115"
                    $Groups += "FamilyDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Family "
                    $Workgroup = "12"
                    $SQLDept = "FAM"
                    $Manager = $NULL
                    $CarpeAD = "Family"
                    $CarpeTK = "Family"
                    }
        
        "IP*" {
                    $NewDepartment = "Intellectual Property"
                    $office = "3m"
                    $depou = "ip"
                    $ipphone = "+44 (0)161 838 7816"
                    $SQLDeptPhone = "0161 838 7816"
                    $fax = "+44 (0)161 838 8110"
                    $Groups += "IPDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "IP "
                    $plc ++
                    $Workgroup = "6"
                    $SQLDept = "IP"
                    $Manager = "ian.morris"
                    $CarpeAD = "Intellectual Property"
                    $CarpeTK = "Intellectual Property"
                    }
        
        "*Intellectual Property*" {
                    $NewDepartment = "Intellectual Property"
                    $office = "3sm"
                    $depou = "ip"
                    $ipphone = "+44 (0)161 838 7816"
                    $SQLDeptPhone = "0161 838 7816"
                    $fax = "+44 (0)161 838 8110"
                    $Groups += "IPDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "IP "
                    $plc ++
                    $Workgroup = "6"
                    $SQLDept = "IP"
                    $Manager = "ian.morris"
                    $CarpeAD = "Intellectual Property"
                    $CarpeTK = "Intellectual Property"
                    }
        
        "*Licensing*" {
                    $NewDepartment = "Licensing"
                    $office = "3sm"
                    $depou = "licensing"
                    $ipphone = "+44 (0)161 838 7888"
                    $SQLDeptPhone = "0161 838 7888"
                    $fax = "+44 (0)161 838 8109"
                    $Groups += "LicensingDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Licensing "
                    $Workgroup = "3"
                    $SQLDept = "LIC"
                    $Manager = "anthony.lyons"
                    $CarpeAD = "Licensing"
                    $CarpeTK = "Licensing"
                    }
        
        "*Litigation*" {
                    $NewDepartment = "Litigation"
                    $office = "3sm"
                    $depou = "litigation"
                    $ipphone = "+44 (0)161 838 7807"
                    $SQLDeptPhone = "0161 838 7807"
                    $fax = "+44 (0)161 838 8104"
                    $Groups += "LitigationDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Litigation "
                    $plc ++
                    $Workgroup = "8"
                    $SQLDept = "LIT"
                    $Manager = $NULL
                    $CarpeAD = "Litigation"
                    $CarpeTK = "Litigation"
                    }
        
        "*Resi*" {
                    $NewDepartment = "Residential Property"
                    $office = "reedham house"
                    $depou = "residential_property"
                    $ipphone = "+44 (0)161 838 7874"
                    $SQLDeptPhone = "0161 838 7874"
                    $fax = "+44 (0)161 838 8102"
                    $Groups += "ResidentialPropertyDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Residential Property "
                    $plc ++
                    $Workgroup = "11"
                    $SQLDept = "DM"
                    $Manager = $NULL
                    $CarpeAD = "Residential Property"
                    $CarpeTK = "Residential Property"
                    }
        
        "*Residential Property*" {
                    $NewDepartment = "Residential Property"
                    $office = "reedham house"
                    $depou = "residential_property"
                    $ipphone = "+44 (0)161 838 7874"
                    $SQLDeptPhone = "0161 838 7874"
                    $fax = "+44 (0)161 838 8102"
                    $Groups += "ResidentialPropertyDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Residential Property "
                    $plc ++
                    $Workgroup = "11"
                    $SQLDept = "DM"
                    $Manager = $NULL
                    $CarpeAD = "Residential Property"
                    $CarpeTK = "Intellectual Property"
                    }
        
        "*Tax*" {
                    $NewDepartment = "Tax And Probate"
                    $office = "3sm"
                    $depou = "tax"
                    $ipphone = "+44 (0)161 838 7882"
                    $SQLDeptPhone = "0161 838 7882"
                    $fax = "+44 (0)161 838 8108"
                    $Groups += "TaxDept"
                    $Groups += "Sensitive Tax Files Lock"
                    $Groups += "Bighand_Users"
                    $DeptList = "Tax "
                    $Workgroup = "10"
                    $SQLDept = "TAX"
                    $Manager = $NULL
                    $CarpeAD = "Tax and Probate"
                    $CarpeTK = "Tax"
                    }

        "*Accounts*" {
                    $support = $true
                    $NewDepartment = "Accounts"
                    $office = "reedham house"
                    $depou = "accounts,ou=support"
                    $ipphone = "+44 (0)161 838 7894"
                    $SQLDeptPhone = "0161 838 7894"
                    $fax = "+44 (0)161 838 8112"
                    $Groups += "AccountsDept"
                    $DeptList = " "
                    $Workgroup = "1"
                    $SQLDept = "ACC"
                    $Manager = "janie.walters"
                    }

        "*reception*" {
                    $support = $true
                    $NewDepartment = "Support"
                    $office = "3sm"
                    $depou = "reception,ou=support"
                    $ipphone = "+44 (0)161 832 3434"
                    $SQLDeptPhone = "0161 832 3434"
                    $fax = "+44 (0)161 832 6650"
                    $Groups += "SupportDept"
                    $Workgroup = "1"
                    $SQLDept = "SUP"
                    $Manager = "jackie.wright"
                    }

        "*basement*" {
                    $support = $true
                    $NewDepartment = "Support"
                    $office = "3sm"
                    $depou = "operations,ou=support"
                    $ipphone = "+44 (0)161 832 3434"
                    $SQLDeptPhone = "0161 832 3434"
                    $fax = "+44 (0)161 832 6650"
                    $Groups += "SupportDept"
                    $Groups += "Archivists"
                    $Groups += "KSL Postroom"
                    $Groups += "OperationsDept"
                    $Workgroup = "1"
                    $SQLDept = "SUP"
                    $Manager = "jackie.wright"
                    }

        "*operations*" {
                    $support = $true
                    $NewDepartment = "Operations"
                    $office = "3sm"
                    $depou = "operations,ou=support"
                    $ipphone = "+44 (0)161 832 3434"
                    $SQLDeptPhone = "0161 832 3434"
                    $fax = "+44 (0)161 832 6650"
                    $Groups += "SupportDept"
                    $Groups += "OperationsDept"
                    $Workgroup = "1"
                    $SQLDept = "SUP"
                    $Manager = "jackie.wright"
                    }
        
        "*marketing*" {
                    $support = $true
                    $NewDepartment = "Marketing"
                    $office = "3sm"
                    $depou = "marketing,ou=support"
                    $ipphone = "+44 (0)161 838 7808"
                    $SQLDeptPhone = "0161 838 7808"
                    $fax = "+44 (0)161 838 8105"
                    $Groups += "SupportDept"
                    $Groups += "MarketingDept"
                    $Workgroup = "1"
                    $SQLDept = "SUP"
                    $Manager = "sarah.evans"
                    }
        
        "*hr*" {
                    $support = $true
                    $NewDepartment = "HR"
                    $office = "3sm"
                    $depou = "hr,ou=support"
                    $ipphone = "+44 (0)161 832 3434"
                    $SQLDeptPhone = "0161 832 3434"
                    $fax = "+44 (0)161 838 8106"
                    $Groups += "HRDept"
                    $Workgroup = "1"
                    $SQLDept = "SUP"
                    $Manager = "alison.pearse"
                    }

        "*risk*" {
                    $support = $true
                    $NewDepartment = "Risk"
                    $office = "3sm"
                    $depou = "risk,ou=support"
                    $ipphone = "+44 (0)161 832 3434"
                    $SQLDeptPhone = "0161 832 3434"
                    $fax = "+44 (0)161 832 6650"
                    $Groups += "SupportDept"
                    $Groups += "ComplianceDept"
                    $Groups += "MLAdmins"
                    $Workgroup = "1"
                    $SQLDept = "SUP"
                    $URUUsername = "$GivenName" + "$Surname"
                    $URUPassword = "Kuits123"
                    $Manager = "joanne.smith"
                    }

        "*training*" {
                    $support = $true
                    $NewDepartment = "Training"
                    $office = "3sm"
                    $depou = "training,ou=support"
                    $ipphone = "+44 (0)161 832 3434"
                    $SQLDeptPhone = "0161 832 3434"
                    $fax = "+44 (0)161 832 6650"
                    $Groups += "SupportDept"
                    $Workgroup = "1"
                    $SQLDept = "SUP"
                    $Manager = "alison.pearse"
                    }
        
        default {
                    "This department can not be recognised"
                    }
        }
        
        #endregion
    
    #region <Fee>

        switch ($Fee)
        {

        "true"      { 
                    $path = "ou=$depou,ou=feeearners,OU=KSL Staff,DC=kuits,DC=local"
                    $DeptList = "$DeptList" + "Fee Earners"
                    $Groups += $DeptList
                    $ExtensionAttribute1 = $True
                    }        
                    
        default     { 
                        
                        if ($support -eq $true)
                        {
                        $path = "ou=$depou,ou=ksl staff,dc=kuits,dc=local"
                        }

                        else
                        {
                        $path = "ou=$depou,ou=secretarial,ou=ksl staff,dc=kuits,dc=local"
                        $DeptList = "$DeptList" + "Secretaries"
                        $Groups += $DeptList
                        }

                    }     
                   
        }

    #endregion

    #region <Update AD>
    
    if($title)
    {
    set-aduser $User -Department $NewDepartment -Fax $fax 
    set-aduser $User -Replace @{physicalDeliveryOfficeName = $office}
    set-aduser $User -Replace @{ipphone = $ipphone} 
    set-aduser $user -Title $title
    }

    else
    {
    set-aduser $User -Department $NewDepartment -Fax $fax 
    set-aduser $User -Replace @{physicalDeliveryOfficeName = $office}
    set-aduser $User -Replace @{ipphone = $ipphone} 
    }

    set-aduser $user -Manager $Manager

    #add to groups
    foreach ($Group in $Groups)
        {
        
        $GroupMembers = (Get-ADGroupMember "$group" | sort name -ErrorAction silentlycontinue).name
    
            if ($GroupMembers -notcontains $name)
            {
            Add-ADGroupMember -Identity $group -Members $user
            }

        }

    if ($Title -like "trainee*")
    {
    Set-ADUser "$user" -add @{extensionattribute2 = "trainee"}
    }

    #move user
    get-aduser $user | Move-ADObject -TargetPath $path

    #endregion

    #region <Mailbox Access>

    if ($Fee -eq $True)
    {
    Add-ADGroupMember "carpediemusers" -Members $User
    }
    
    elseif ($Fee -ne $True -and $Support -ne $True)
    {
    Add-ADGroupMember "carpediemusers" -Members $User
    }

    #endregion

    #region <PLC>

    <#if ($CurrentFE -ne $true -and $FE -eq $True)
    {
    DO PLC STUFF!
    }#>

    #endregion

    #region <SQL Stuff>

    Invoke-Sqlcmd -ServerInstance "kslsql01" -Database "partner" -Query "
    UPDATE users 
    SET NOK_Address3 = '$fax'
        , FaxNo = '$fax'
        , Department = '$SQLDept'
        , Manager = ''
        , Tel_Secretary = ''
        , ExpensesCostCentre = '$Workgroup'
        , ProfitCostsCostCentre = '$Workgroup' 
    WHERE code = '$Initials';"

    Invoke-Sqlcmd -ServerInstance "kslsql01" -Database "partner" -Query "
    UPDATE Usr_Fee_Earner 
    SET Dept_Direct_Dial = '$SQLDeptPhone' 
    WHERE usercode = '$Initials'"
    
    # User Access
    Invoke-Sqlcmd2 -ServerInstance kslsql01 -Database carpediem -Query "
    DELETE CDU2TK
    WHERE USERID = '$User'
        AND TKPRID <> '$Initials'
    "

    # Remove From Department
    Invoke-Sqlcmd2 -ServerInstance kslsql01 -Database carpediem -Query "
    DELETE CDULINK
    WHERE USERGRPID NOT IN ('Everyone', 'CDADSynch')
	    AND USERID = '$User'
    "

    # Add To Department
    Invoke-Sqlcmd2 -ServerInstance kslsql01 -Database carpediem -Query "
    INSERT INTO CDULINK (USERID, USERGRPID)
    VALUES ('$User', '$CarpeAD')
    "

    # Remove from TimeKeeper Department
    Invoke-Sqlcmd2 -ServerInstance kslsql01 -Database carpediem -Query "
    DELETE CDTLINK
    WHERE USERGRPID <> 'All Fee-Earners'
	    AND USERID = '$User'
    "

    # Add to TimeKeeper Department
    Invoke-Sqlcmd2 -ServerInstance kslsql01 -Database carpediem -Query "
    INSERT INTO CDTLINK (TGROUPID, TKPRID)
    VALUES ('$CarpeTK', '$Initials')
    "

    if ($fee -eq $True)
    {
    Invoke-Sqlcmd -ServerInstance "kslsql01" -Database "partner" -Query "UPDATE Users set Address1 = 'Secretary' where code like '$initials'"
    }
    
    #endregion

    #region <$Ticket>

    if ($ticket -gt "0")
    {
    $Subject = "[Ticket #$ticket]"
    }

    else
    {
    $Subject = "Mover - $name"
    }
         
    #endregion

    #region <Email to IT>

    $FromEmail = "ITTeam@kuits.com"
    $ToITEmail = "ITDept@Kuits.com"
    $SMTPServer = "EXCHSRV2.kuits.local"
    $textEncoding = [System.Text.Encoding]::UTF8 

    $Body =" 
    <font face=""verdana""> 
    A mover has been processed with the following details :  
    <p> <b>Name</b>           : $Name
    <br> <b>User Name</b>     : $User
    <br> <b>Initials</b>      : $Initials
    <br> <b>Old Department</b>: $Department
    <br> <b>New Department</b>: $NewDepartment
    "
    Send-MailMessage -SmtpServer $SMTPServer -From $FromEmail -Subject $Subject -To $ToITEmail -Body $Body -bodyasHTML -priority High -Encoding $textEncoding 

    #endregion

    Write-Output "`n$name has been moved from $Department to $NewDepartment`n"

}