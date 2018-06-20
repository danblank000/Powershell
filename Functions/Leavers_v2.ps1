#region <Script Synopsis>
<# 
.Synopsis 
   Script to process leavers
.Description
   Daniel Blank
   Disables user, clears fields, mailbox access and permissions etc.
   Version 1.0 April 2017 
   Requires: Windows PowerShell Module for Active Directory and Exchange
.EXAMPLE 
  
.EXAMPLE
  
#>
#endregion 

Function Leaver
{

    #region <Set parameters>
    
    param( 
        #Enter Full name of user
        [Parameter(Mandatory=$True,Position=0)] 
        [ValidateNotNull()] 
        [string]$Name, 
            
        #Who will be responsible for their matters?
        [Parameter(Position=1)]
        [string]$Responsible,
        
        #Is there a ticket logged? Enter the ticket number
        [Parameter(Position=2 )] 
        [int]$Ticket
    
    )

    #endregion

    #region <Name>

    $leaver = get-aduser -filter {name -like $name} -Properties extensionattribute1, department, samaccountname, initials, homedirectory, profilepath
    Try{
    $FE = ($leaver.extensionattribute1).ToString() 
    }Catch{}
    $User = ($leaver.SamAccountName).ToString()
    $Initials = ($leaver.Initials).ToString()
    $Department = ($leaver.Department).ToString()
    $HomeDirectory = ($leaver.homedirectory).ToString()
    $FolderRedirection = "\\kslnas01\FolderRedirection$\$user"
    
    #endregion

    #Disable AD Account
    Disable-ADAccount -Identity $user 
    $date = get-date -DisplayHint Date
    set-aduser $user -Description "Disabled on $date - $department - $title"
    write-host "`nAD Account for $Name disabled" -ForegroundColor Gray
        
    #Hide from address book
    Set-Mailbox -identity $user -HiddenFromAddressListsEnabled $true
    write-host "Mailbox hidden from Address Book" -ForegroundColor Gray
        
    #Clear AD fields
    set-aduser $user -Clear company, department, homedirectory, ipphone, homedrive, physicalDeliveryOfficeName, company, profilepath, title, Userprincipalname, facsimileTelephoneNumber, pager, telephonenumber, manager
    write-host "AD fields cleared" -ForegroundColor Gray

    #Add to leavers group
    Add-ADGroupMember "Leavers" –Members $user
    write-host "AD Account added to leavers group" -ForegroundColor Gray

    sleep -s 1

    #Make leavers primary group
    $LeaversGroup = get-adgroup "Leavers"
    $LeaversGroupSID = $LeaversGroup.sid
    $LeaversGroupSID
    [int]$LeaversGroupID = $LeaversGroupSID.Value.Substring($LeaversGroupSID.Value.LastIndexOf("-")+1)
    Get-ADUser $user | Set-ADObject -Replace @{primaryGroupID="$LeaversGroupID"}
    write-host "Leavers Group has been set as primary group" -ForegroundColor Gray
    sleep -s 1

    #Remove from all other groups
    $Groups = (get-aduser $user -Properties memberof).memberof

        foreach ($Group in $Groups)
        {
        Remove-ADGroupMember $Group -Member $User -Confirm:$false
        }
    write-host "All AD group memberships cleared" -ForegroundColor Gray
            
    #Move to leavers OU
        if ($FE -eq "FE")
        {
        get-aduser $user | Move-ADObject -TargetPath "OU=FEs,OU=Ex KSL Staff,DC=kuits,DC=local"
        }

        else
        {
        get-aduser $user | Move-ADObject -TargetPath "OU=Ex KSL Staff,DC=kuits,DC=local"
        }
    write-host "Moved to Leavers OU" -ForegroundColor Gray        

    #region <Responsible>

            if ($Responsible)
            {
            $resp = get-aduser -Filter {name -like $Responsible} -Properties emailaddress, ipphone
            $respname = ($resp.Name).ToString()
            $respuser = ($resp.samaccountname).ToString()
            $respemail = ($resp.emailaddress).ToString()
            $respDeptPhone = ($resp.ipphone).ToString()
            }

        #Name - split
        $respfirst = ($respname.Split(" "))[0]
        
    #endregion
        
    #Remove Mailbox Permissions
    try{
        $perms = (Get-MailboxPermission "$name" | Where-Object {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.user.tostring() -notlike "S-1-5-21*" -and $_.IsInherited -eq $false -and $_.user.tostring() -notlike "*administrator*"} | select user -ErrorAction SilentlyContinue).user
        
            foreach ($perm in $perms)
            {

            $perm = ($perm.Split('\'))[1]
            Remove-MailboxPermission -Identity "$name" -User "$perm" -AccessRights fullaccess -InheritanceType all -Confirm:$false
            }
        }catch{}
    
    #Give $Responsible mailbox permission
    Add-MailboxPermission -Identity "$Name" -User "$respname" -AccessRights fullaccess -InheritanceType all
    write-host "$respname has been given full mailbox access" -ForegroundColor Gray

    #Give $Responsible claendar permissions
    $cal = "$name" + ":\Calendar"
    Add-MailboxFolderPermission -identity "$cal" -user "$respname" -AccessRights editor
    write-host "$respname has been given full calendar permissions" -ForegroundColor Gray
        
    #Set OOO reply
        if ($Department -like "*accounts*" -or $Department -like "*banking*" -or $Department -like "*commercial*" -or $Department -like "*corpo*" -or $Department -like "*emplo*" -or $Department -like "*family*" -or $Department -like "*Intel*" -or $Department -like "*Licensing*" -or $Department -like "*Litiagtion*" -or $Department -like "*Marketing*" -or $Department -like "*Resi*" -or $Department -like "*Tax*")
        {
        Set-MailboxAutoReplyConfiguration $name –AutoReplyState Enabled –ExternalMessage "Thank you for contacting the $department department at Kuits. $name is no longer with the firm, however their matters are being dealt with by $respname and your email has automatically been forwarded to them. If you have an urgent query, you can contact $respfirst on $respDeptPhone or alternatively email $respemail." -InternalMessage "Thank you for contacting the $department department at Kuits. $name is no longer with the firm, however their matters are being dealt with by $respname and your email has automatically been forwarded to them. If you have an urgent query, you can contact $respfirst on $respDeptPhone or alternatively email $respemail."
        }

        else
        {
        Set-MailboxAutoReplyConfiguration $name –AutoReplyState Enabled –ExternalMessage "Thank you for contacting Kuits Solicitors. $name is no longer with the firm.  If you have an urgent query, you can contact our main reception on 0161 832 3434." -InternalMessage "Thank you for contacting Kuits Solicitors. $name is no longer with the firm.  If you have an urgent query, you can contact our main reception on 0161 832 3434."
        }
    write-host "Out of Office has been set" -ForegroundColor Gray
            
    #Remove active sync
    Get-ActiveSyncDevice -Result Unlimited -mailbox $user | Remove-ActiveSyncDevice -Confirm:$false
    write-host "Active Sync entries have een deleted" -ForegroundColor Gray

    #region <SQL Stuff>

    $SQLName = "Z" + "$Name"
    $UserTypeRef = "10"
    $UserStatus = "1"

    Invoke-Sqlcmd -ServerInstance "kslsql01" -Database "partner" -Query "UPDATE users set FullName = '$SQLName', UserTypeRef = '$UserTypeRef', UserStatus = '$UserStatus' WHERE code like '$Initials'"
    write-host "Partner account has been updated and disabled" -ForegroundColor Gray
    

$GUID = ((Invoke-Sqlcmd -ServerInstance kslsql01 -Database partner -Query @"
SELECT AD_UserObjectGUID
FROM ADLicencedUsers
WHERE AD_CommonName = '$name'
"@).AD_UserObjectGUID).tostring()

Invoke-Sqlcmd -ServerInstance kslsql01 -Database partner -Query @"
DELETE FROM ADUserLicence
WHERE AD_UserObjectGUID = '$GUID'
"@

sleep -m 500

Invoke-Sqlcmd -ServerInstance kslsql01 -Database partner -Query @"
DELETE FROM ADLicencedUsers
WHERE AD_CommonName = '$name'
"@
    write-host "Partner license has been removed" -ForegroundColor Gray

if ($FE)
{
$date = Invoke-Sqlcmd -ServerInstance kslsql01 -Database partner -Query @"
SELECT 
P_Period =
	CASE MONTH(SYSDATETIME())
		WHEN '1' THEN '9'
		WHEN '2' THEN '10'
		WHEN '3' THEN '11'
		WHEN '4' THEN '12'
		WHEN '5' THEN '1'
		WHEN '6' THEN '2'
		WHEN '7' THEN '3'
		WHEN '8' THEN '4'
		WHEN '9' THEN '5'
		WHEN '10' THEN '6'
		WHEN '11' THEN '7'
		WHEN '12' THEN '8'
		END,
P_Year =
	CASE YEAR(SYSDATETIME())
		WHEN '1' THEN YEAR(DATEADD(yy, -1, GETDATE()))
		WHEN '2' THEN YEAR(DATEADD(yy, -1, GETDATE()))
		WHEN '3' THEN YEAR(DATEADD(yy, -1, GETDATE()))
		WHEN '4' THEN YEAR(DATEADD(yy, -1, GETDATE()))
		ELSE YEAR(SYSDATETIME())
		END
"@

[int]$period = $date.P_Period
[int]$year = $date.P_Year 
    
for ($period; $period -lt "13"; $period++)
{
Invoke-Sqlcmd -ServerInstance kslsql01 -Database partner -Query @"
UPDATE Targets 
SET FeesBilled = 0.0000
	, ChargeableTime = 0
	, NonChargeableTime = 0 
WHERE FeeEarnerRef = '$initials'
    AND YEAR = $year
    AND Period = $period
"@
}

    Write-Host "Targets have been zeroed" -ForegroundColor Gray

}


    #endregion

    #region <$Ticket>

    if ($ticket -gt "0")
    {
    $Subject = "[Ticket #$ticket]"
    }

    else
    {
    $Subject = "Leaver - $name"
    }
         
    #endregion

    #region <Email to IT>

    $FromEmail = "ITTeam@kuits.com"
    $ToITEmail = "ITDept@Kuits.com"
    $SMTPServer = "EXCHSRV2.kuits.local"
    $textEncoding = [System.Text.Encoding]::UTF8 

    $Body =" 
    <font face=""verdana""> 
    A leaver has been processed with the following details :  
    <p> <b>Name</b>           : $Name
    <br> <b>Old Department</b>: $Department
    "
    Send-MailMessage -SmtpServer $SMTPServer -From $FromEmail -Subject $Subject -To $ToITEmail -Body $Body -bodyasHTML -priority High -Encoding $textEncoding 

    #endregion

    $Year = (get-date -Format yyyy).ToString()
    $Month = ((get-date -Format y).ToString()).Split(" ")[0]
    
    #Archive and Delete users Home Drive
    $HomeDriveSize = "{0:N2}" -f ( ( Get-ChildItem $HomeDirectory -Recurse -Force | Measure-Object -Property Length -Sum ).Sum / 1MB )
    Write-Host "`nArchiving $HomeDriveSize MB Home Drive, please wait... "
    $pathtest = Test-Path "\\kslnas01\LeaversuserFolders$\$Year\$Month"
        
        if ($pathtest -ne "true")
        {
        New-Item \\kslnas01\LeaversuserFolders$\$Year\$Month -ItemType directory
        }

    Copy-Item -Path "$HomeDirectory" -Destination "\\KSLNAS01\leaversuserfolders$\$Year\$Month\$User\" -recurse
    Remove-Item -Recurse -Force $homeDirectory
    
    #Archive and delete Folder Redirection
    $FolderRedSize = "{0:N2}" -f ( ( Get-ChildItem $FolderRedirection -Recurse -Force | Measure-Object -Property Length -Sum ).Sum / 1MB )
    Write-Host "`nArchiving $FolderRedSize MB Folder Redirection, please wait... "
    $pathtest = Test-Path "\\kslnas01\Leaversredirection$\$year\$month"
        
        if ($pathtest -ne "true")
        {
        New-Item \\kslnas01\Leaversredirection$\$year\$month -ItemType directory
        }

    Copy-Item -Path "$FolderRedirection" -Destination "\\KSLNAS01\leaversredirection$\$Year\$Month\$User\" -recurse
    Remove-Item -Recurse -Force $FolderRedirection
    Write-Host "Leaver process finished for $Name" -ForegroundColor Gray

}