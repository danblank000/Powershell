#region <Script Synopsis>
<# 
.Synopsis 
   Script to create new starters
.Description
   Daniel Blank
   Creates new users, adds to relevant groups, and creates mailbox
   Version 1.0 April 2017 
   Requires: Windows PowerShell Module for Active Directory and Exchange
.EXAMPLE 
  New_Starter -Name "Joe Bloggs" -Title "Solicitor" -Department "Litigation" -Fee -Ticket "10458"
.EXAMPLE
  New_Starter -Name "Phillip Dick" -Title "Admin Assistant" -Department "Tax" -Initials "PAD"
#>
#endregion 

Function New_Starter
{

    #region <Set parameters>
    param( 
        #Enter Full name of user
        [Parameter(Mandatory=$True,Position=0)] 
        [ValidateNotNull()] 
        [string]$Name, 
    
        # Enter the job title
        [Parameter(Mandatory=$True,Position=1)] 
        [string]$Title, 
    
        # Enter the department
        [Parameter(Mandatory=$True, Position=2)] 
        [string]$Department,
    
        # Is the user a fee-earner?
        [Parameter(Position=3)] 
        [switch]$Fee,

        # Are there initials that need setting
        [Parameter(Position=4)] 
        [string]$Initials,
        
        # Is there a ticket logged? Enter the ticket number
        [Parameter(Position=5)] 
        [int]$Ticket
    
    )
    #endregion
    
    #region <generic variables>
       
    $HomeDrive = "H:"
    $Company = "Kuit Steinart Levy LLP"
    $Groups = @()
    $SecurePassword = ConvertTo-SecureString 'Kuits123' –asplaintext –force 
    $FromEmail = "ITTeam@kuits.com"
    $ToITEmail = "ITDept@Kuits.com"
    $FromHREmail = "ITDept@kuits.com"
    $ToHREmail = "HRDept@Kuits.com"
    $SMTPServer = "EXCHSRV2.kuits.local"
    $textEncoding = [System.Text.Encoding]::UTF8 

    $plc = 0

    #endregion

    #region <$name>

    $DisplayName = $Name
    $GivenName = ($name.Split(" "))[0]
    $Surname = ($name.Split(" "))[1]
    $UserName = "$GivenName" + "." + "$Surname"
    $UserPrincipalName = "$UserName" + "@kuits.local"
    $HomeDirectory = "\\KSLNAS01\UserFolders$\$UserName"
    $ProfilePath = "\\KSLNAS01\Profiles$\$UserName"

    #endregion
    
    #region <create H Drive Sec Group>

    New-Item -Path "\\KSLNAS01\UserFolders$\$UserName" -type directory -Force
    $HSecGroup = "\\KSLNAS01\UserFolders$\$UserName"
        
    $HDRIVEGroup = "$username" + "_Full_Access"
    New-ADGroup -Name $HDRIVEGroup -SamAccountName $HDRIVEGroup -GroupCategory Security -GroupScope Global -Path "ou=H_Drives,ou=security groups,dc=kuits,dc=local" -Description "Members of this group have Full Access to the $username Folder"
    sleep -m 300
    
    
sleep -Seconds 1    

    #endregion

    #region <Switch Department>

    switch -wildcard ($department)
        {
        "*Banking*" {
                    $Department = "Banking and Real Estate Finance"
                    $office = "Reedham House"
                    $depou = "banking"
                    $ipphone = "+44 (0)161 838 7809"
                    $fax = "+44 (0)161 838 8103"
                    $Groups += "BankingDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Banking "
                    $Manager = $NULL

                    }
        
        "*Comm IP*" {
                    $Department = "Commercial and IP"
                    $office = "3SM"
                    $depou = "Commercial_IP"
                    $ipphone = "+44 (0)161 838 7816"
                    $fax = "+44 (0)161 838 8110"
                    $Groups += "CommercialIPDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Commercial and IP "
                    $plc ++
                    $Manager = $NULL
                    }
        
        "*Commercial IP*" {
                    $Department = "Commercial and IP"
                    $office = "3SM"
                    $depou = "Commercial_IP"
                    $ipphone = "+44 (0)161 838 7816"
                    $fax = "+44 (0)161 838 8110"
                    $Groups += "CommercialIPDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Commercial and IP "
                    $plc ++
                    $Manager = $NULL
                    }
        
        "*Comm Prop*" {
                    $Department = "Commercial Property"
                    $office = "Reedham House"
                    $depou = "commercial_property"
                    $ipphone = "+44 (0)161 838 7875"
                    $fax = "+44 (0)161 838 8100"                    
                    $Groups += "CommercialPropertyDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Commercial Property "
                    $plc ++
                    $Manager = $NULL
                    }
        
        "*Commerical Property*" {
                    $Department = "Commercial Property"
                    $office = "Reedham House"
                    $depou = "commercial_property"
                    $ipphone = "+44 (0)161 838 7875"
                    $fax = "+44 (0)161 838 8100"
                    $Groups += "CommercialPropertyDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Commercial Property "
                    $plc ++
                    $Manager = $NULL
                    }
        
        "*Corporate*" {
                    $Department = "Corporate"
                    $office = "3SM"
                    $depou = "corporate"
                    $ipphone = "+44 (0)161 838 7806"
                    $fax = "+44 (0)161 838 8111"
                    $Groups += "CorporateDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Corporate "
                    $plc ++
                    $Manager = $NULL
                    }
        
        "*Employment*" {
                    $Department = "Employment"
                    $office = "3SM"
                    $depou = "employment"
                    $ipphone = "+44 (0)161 838 7806"
                    $fax = "+44 (0)161 838 8107"
                    $Groups += "EmploymentDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Employment "
                    $plc ++
                    $Manager= $NULL
                    }
        
        "*Family*" {
                    $Department = "Family"
                    $office = "3SM"
                    $depou = "family"
                    $ipphone = "+44 (0)161 838 8146"
                    $fax = "+44 (0)161 838 8115"
                    $Groups += "FamilyDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Family "
                    $Manager = $NULL
                    }
        
        "IP*" {
                    $Department = "Intellectual Property"
                    $office = "3m"
                    $depou = "ip"
                    $ipphone = "+44 (0)161 838 7816"
                    $fax = "+44 (0)161 838 8110"
                    $Groups += "IPDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "IP "
                    $plc ++
                    $Manager = "Ian.Morris"
                    }
        
        "*Intellectual Property*" {
                    $Department = "Intellectual Property"
                    $office = "3SM"
                    $depou = "ip"
                    $ipphone = "+44 (0)161 838 7816"
                    $fax = "+44 (0)161 838 8110"
                    $Groups += "IPDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "IP "
                    $plc ++
                    $Manager = "ian.morris"
                    }
        
        "*Licensing*" {
                    $Department = "Licensing"
                    $office = "3SM"
                    $depou = "licensing"
                    $ipphone = "+44 (0)161 838 7888"
                    $fax = "+44 (0)161 838 8109"
                    $Groups += "LicensingDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Licensing "
                    $Manager = "anthony.lyons"
                    }
        
        "*Litigation*" {
                    $Department = "Litigation"
                    $office = "3SM"
                    $depou = "litigation"
                    $ipphone = "+44 (0)161 838 7807"
                    $fax = "+44 (0)161 838 8104"
                    $Groups += "LitigationDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Litigation "
                    $plc ++
                    $Manager = $NULL
                    }
        
        "*Resi*" {
                    $Department = "Residential Property"
                    $office = "Reedham House"
                    $depou = "residential_property"
                    $ipphone = "+44 (0)161 838 7874"
                    $fax = "+44 (0)161 838 8102"
                    $Groups += "ResidentialPropertyDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Residential Property "
                    $plc ++
                    $Manager = $NULL
                    }
        
        "*Residential Property*" {
                    $Department = "Residential Property"
                    $office = "Reedham House"
                    $depou = "residential_property"
                    $ipphone = "+44 (0)161 838 7874"
                    $fax = "+44 (0)161 838 8102"
                    $Groups += "ResidentialPropertyDept"
                    $Groups += "Bighand_Users"
                    $DeptList = "Residential Property "
                    $plc ++
                    $Manager = $NULL
                    }
        
        "*Tax*" {
                    $Department = "Tax and Probate"
                    $office = "3SM"
                    $depou = "tax"
                    $ipphone = "+44 (0)161 838 7882"
                    $fax = "+44 (0)161 838 8108"
                    $Groups += "TaxDept"
                    $Groups += "Sensitive Tax Files Lock"
                    $Groups += "Bighand_Users"
                    $DeptList = "Tax "
                    $Manager = $NULL
                    }

        "*Accounts*" {
                    $support = $true
                    $Department = "Accounts"
                    $office = "Reedham House"
                    $depou = "accounts,ou=support"
                    $ipphone = "+44 (0)161 838 7894"
                    $fax = "+44 (0)161 838 8112"
                    $Groups += "AccountsDept"
                    $DeptList = " "
                    $Manager = "janie.walters"
                    }

        "*reception*" {
                    $support = $true
                    $Department = "Support"
                    $office = "3SM"
                    $depou = "reception,ou=support"
                    $ipphone = "+44 (0)161 832 3434"
                    $fax = "+44 (0)161 832 6650"
                    $Groups += "SupportDept"
                    $Manager = "jackie.wright"
                    }

        "*basement*" {
                    $support = $true
                    $Department = "Support"
                    $office = "3SM"
                    $depou = "operations,ou=support"
                    $ipphone = "+44 (0)161 832 3434"
                    $fax = "+44 (0)161 832 6650"
                    $Groups += "SupportDept"
                    $Groups += "Archivists"
                    $Groups += "KSL Postroom"
                    $Groups += "OperationsDept"
                    $Manager = "jackie.wright"
                    }

        "*operations*" {
                    $support = $true
                    $Department = "Operations"
                    $office = "3SM"
                    $depou = "operations,ou=support"
                    $ipphone = "+44 (0)161 832 3434"
                    $fax = "+44 (0)161 832 6650"
                    $Groups += "SupportDept"
                    $Groups += "OperationsDept"
                    $Manager = "jackie.wright"
                    }
        
        "*marketing*" {
                    $support = $true
                    $Department = "Marketing"
                    $office = "3SM"
                    $depou = "marketing,ou=support"
                    $ipphone = "+44 (0)161 838 7808"
                    $fax = "+44 (0)161 838 8105"
                    $Groups += "SupportDept"
                    $Groups += "MarketingDept"
                    $Manager = "sarah.evans"
                    }
        
        "*hr*" {
                    $support = $true
                    $Department = "HR"
                    $office = "3SM"
                    $depou = "hr,ou=support"
                    $ipphone = "+44 (0)161 832 3434"
                    $fax = "+44 (0)161 838 8106"
                    $Groups += "HRDept"
                    $Manager = "alison.pearse"
                    }

        "*risk*" {
                    $support = $true
                    $Department = "Risk"
                    $office = "3SM"
                    $depou = "risk,ou=support"
                    $ipphone = "+44 (0)161 832 3434"
                    $fax = "+44 (0)161 832 6650"
                    $Groups += "SupportDept"
                    $Groups += "ComplianceDept"
                    $Groups += "MLAdmins"
                    $URUUsername = "$GivenName" + "$Surname"
                    $URUPassword = "Kuits123"
                    $Manager = "Joanne.Smith"
                    }

        "*training*" {
                    $support = $true
                    $Department = "Training"
                    $office = "3SM"
                    $depou = "training,ou=support"
                    $ipphone = "+44 (0)161 832 3434"
                    $fax = "+44 (0)161 832 6650"
                    $Groups += "SupportDept"
                    $Manager = "PearseA"
                    }
        
        default {
                    "This department can not be recognised"
                    }
        }
        #>
    #endregion 
    
    #region <$Fee>
    switch($fee)
        {

        "true"      { 
                    $path = "ou=$depou,ou=feeearners,ou=ksl staff,dc=kuits,dc=local"
                    $DeptList = "$DeptList" + "Fee Earners"
                    $Groups += $DeptList
                    $Groups += "CarpeDiemUsers"
                    $ExtensionAttribute1 = $True
                    #$FeeMailboxUsers = (get-aduser -filter * -SearchBase "ou=$depou,ou=secretarial,ou=ksl staff,dc=kuits,dc=local" | select name).name
                    $plc ++
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
                        $Groups += "CarpeDiemUsers"
                        #$SecMailboxUsers = (get-aduser -filter * -SearchBase "ou=$depou,ou=feeearners,ou=ksl staff,dc=kuits,dc=local" | select name).name
                        }

                    }     
                    
        }

    #endregion

    #region <$Initials>
        
    if ($Initials)
    {
    $Init = $Initials.ToCharArray()
    $FirstInit = $Init[0]
    $MiddleInit = $Init[1]
    $LastInit = $Init[2]
    $initialslist = Invoke-Sqlcmd -ServerInstance "kslsql01" -Database "partner" -Query "select code from users"
    
        do
        {
        $initialscheck = $initialslist.code.Contains("$initials")
        
            if ($initialscheck -eq $true)
            {
            $MiddleInit = [byte]$MiddleInit
            $MiddleInit = $MiddleInit + 1
            $MiddleInit = [char]$MiddleInit
            $Initials = $FirstInit + $MiddleInit + $LastInit
            }

        }

        until ($initialscheck -eq $false)

    }

    else
    {
    $Initials = ($GivenName.ToCharArray())[0] + "A" + ($Surname.ToCharArray())[0]
    $FirstInit = $Initials[0]
    $MiddleInit = $Initials[1]
    $LastInit = $Initials[2]
    $initialslist = Invoke-Sqlcmd -ServerInstance "kslsql01" -Database "partner" -Query "select code from users"
    
        do
        {
        $initialscheck = $initialslist.code.Contains("$initials")
        
            if ($initialscheck -eq $true)
            {
            $MiddleInit = [byte]$MiddleInit
            $MiddleInit = $MiddleInit + 1
            $MiddleInit = [char]$MiddleInit
            $Initials = $FirstInit + $MiddleInit + $LastInit
            }
        
        }

        until ($initialscheck -eq $false)

    }

    #endregion
    
    #region <$Ticket>

    if ($ticket -gt "0")
    {
    $Subject = "[Ticket #$ticket]"
    }

    else
    {
    $Subject = "New Starter - $name"
    }
         
    #endregion
 
    #region <Create New user>
            
        New-ADuser -Path $path -SamAccountName $UserName -Name $name -DisplayName $displayname -GivenName $givenname -Surname $surname -UserPrincipalName $userprincipalname -ProfilePath $profilepath -HomeDirectory $homedirectory -HomeDrive $homedrive -Company $company -Department $department -Title $title -fax $fax -PassThru -AccountPassword $SecurePassword -PasswordNeverExpires $false -CannotChangePassword $false -Initials $Initials -Manager $Manager
        set-aduser $username -add @{physicalDeliveryOfficeName = $office}
        set-aduser $username -Add @{ipphone = $ipphone}
        set-aduser $UserName -ChangePasswordAtLogon $true
        set-aduser $UserName -Enabled $true

            if ($extensionattribute1)
            {
            Set-ADUser $username -add @{extensionattribute1 = "FE"}
            }
        
            if ($title -like "*trainee*")
            {
            $ExtensionAttribute2 = $true
            Set-ADUser $username -add @{extensionattribute2 = "Trainee"}
            }
        
    #endregion

sleep -Seconds 3
    
    #region <Create Mailbox>
        
    Enable-Mailbox -Identity $username -Database "Mailbox Database Kuits 1"

        foreach ($Group in $Groups)
        {
        Add-ADGroupMember $Group -Members $UserName
        }

    #endregion

sleep -Seconds 1

    #region <Mailbox permissions>

    if ($Fee -ne $true -and $support -ne $true)
    {
    
        foreach ($person in $SecMailboxUsers)
        {
        #$person = $person.tostring()
        #Add-MailboxPermission -Identity "$person" -user $name -AccessRights fullaccess -InheritanceType All
        #Set-Mailbox "$person" -GrantSendOnBehalfTo @{add="$name"}
        }

    }

    if ($fee -eq $True)
    {

        foreach ($person in $FeeMailboxUsers)
        {
        #$person = $person.tostring()
        #Add-MailboxPermission -Identity $name -user "$person" -AccessRights fullaccess -InheritanceType All
        #Set-Mailbox $name -GrantSendOnBehalfTo @{add="$person"}
        }

    }

    if ($depou -eq "reception,ou=support")
    {
    sleep -s 1
    Add-MailboxFolderPermission -identity "3SM mr 1:\Calendar" -user "$Name" -AccessRights editor
    Add-MailboxFolderPermission -identity "3SM mr 2:\Calendar" -user "$Name" -AccessRights editor
    Add-MailboxFolderPermission -identity "3SM Boardroom:\Calendar" -user "$Name" -AccessRights editor
    Add-MailboxFolderPermission -identity "3SM training room:\Calendar" -user "$Name" -AccessRights editor
    Add-MailboxFolderPermission -identity "RH Accounts Meeting Room:\Calendar" -user "$Name" -AccessRights editor
    Add-MailboxFolderPermission -Identity "blackfriars MR1:\calendar"  -AccessRights Editor -User $Name
    Add-MailboxFolderPermission -Identity "blackfriars MR2:\calendar"  -AccessRights Editor -User $Name
    Add-MailboxFolderPermission -Identity "blackfriars MR3:\calendar"  -AccessRights Editor -User $Name
    Add-MailboxFolderPermission -Identity "blackfriars MR4:\calendar"  -AccessRights Editor -User $Name
    Add-MailboxFolderPermission -Identity "blackfriars MR5:\calendar"  -AccessRights Editor -User $Name
    Add-MailboxFolderPermission -Identity "blackfriars MR6:\calendar"  -AccessRights Editor -User $Name
    Add-MailboxFolderPermission -Identity "blackfriars MR7:\calendar"  -AccessRights Editor -User $Name
    Add-MailboxPermission -Identity "reception" -User "$Name" -AccessRights fullaccess
    }

    $calendar = "$name" + ":\calendar"
    set-MailboxFolderPermission "$calendar" -User "default" -AccessRights reviewer
    Add-ADPermission "CN=Reception,OU=Generic,OU=KSL Staff,DC=kuits,DC=local" -user "$name" -ExtendedRights "send as"

    #endregion
    
    #region <apply permisssions to H: drive folder>
    Add-ADGroupMember $HDRIVEGroup $username
    $acl = get-acl $HSecGroup
    $inherit = [system.security.accesscontrol.InheritanceFlags]"ContainerInherit, ObjectInherit"
    $propagation = [system.security.accesscontrol.PropagationFlags]"None"
sleep -s 1
    $Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("$HDRIVEGroup","modify",$inherit,$propagation,"Allow")
sleep -s 2

    $acl.SetAccessRule($ar)
    set-acl $HSecGroup $acl                    
        
    #endregion
    
    #region <Email to IT>

    $Body =" 
    <font face=""verdana""> 
    A new starter with the following details has been created :  
    <p> <b>Name</b>           : $Name
    <br> <b>User Name</b>     : $Username
    <br> <b>Initials</b>      : $Initials
    <br> <b>Job Title</b>     : $Title
    <br> <b>Department</b>    : $Department
    <br> 
    <p> Please make sure that you add $name to Partner, Bighand, Phone and Fax systems where appropriate.
    "
    Send-MailMessage -SmtpServer $SMTPServer -From $FromEmail -Subject $Subject -To $ToITEmail -Body $Body -bodyasHTML -priority High -Encoding $textEncoding 

    #endregion

    #region <Email to HR>

    $Body =" 
    <font face=""verdana""> 
    A new starter with the following details has been created :  
    <p> <b>Name</b>           : $Name
    <br> <b>User Name</b>     : $Username
    <br> <b>Initials</b>      : $Initials
    <br> <b>Job Title</b>     : $Title
    <br> <b>Department</b>    : $Department
    <br> 
    <p> Thanks,
    <br> IT
    "

    Send-MailMessage -SmtpServer $SMTPServer -From $FromHREmail -Subject $Subject -To $ToHREmail -Cc "ConniePearson@Kuits.com" -Body $Body -bodyasHTML -priority High -Encoding $textEncoding 
    
    #endregion
    
}