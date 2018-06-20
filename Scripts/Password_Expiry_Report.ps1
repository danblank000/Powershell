<#
.SYNOPSIS
	Create a CSV and HTML Report on Expiring Passwords
.DESCRIPTION
	This script will create a report of passwords that are expiring within
	the specified time.  It will also list users who's passwords have already
	expired.  The script will create reports in 2 formats, CSV and HTML.  
	Both are then emailed to the specified user.
	
	Make sure to edit and change the PARAM section to match your environment
.PARAMETER Path
	Specify the path where you want to save the CSV report.  The script does not save
	the HTML report, but emails it as the body of the email.
.PARAMTER SearchBase
	Specify the full FQDN of the OU you wish to begin your search at.  If you need
	help getting the FQDN you can use this script:
	
	http://community.spiceworks.com/scripts/show/1635-copy-a-ou-s-fqdn-to-clipboard
.PARAMETER Age
	Specify the number of days the script will report on expiring passwords.  An
	entry of 2 will report all passwords that have already expired, or are going to
	expire in the next 2 days.
.PARAMETER From
	When emailing the reports, this parameter will specify who the report is 
	coming from.  
.PARAMETER To
	Tell the script where to send the email
.PARAMETER SMTPServer
	This needs to be the IP address or name of your SMTP relay server.
.OUTPUTS
	CSV:	ExpiringReport.csv in the $Path location
	Email:	HTML version of the same report in the body of the email.  Also attaches
			the CSV to the email.
.EXAMPLE
	.\Report-PasswordExpiring.ps1
	Accepts all defaults as defined in the PARAM section
.EXAMPLE
	.\Report-PasswordExpiring.ps1 -Path d:\myreports -Age 5 -From script@yourdomain.com -To Administrator@yourdomain.com -SMTPServer 192.168.1.25
	Runs the report using D:\myreports as the path to save the CSV report.  Email will be sent
	from "script@yourdomain.com" and sent to "Administrator@yourdomain.com" using 192.168.1.25
	as the SMTP relay server.  All user accounts with expired passwords or password that will
	be expiring in 5 days will be reported.
.NOTES
	Script:				Report-PasswordExpiring.ps1
	Author:				Martin Pugh
	Blog:				www.thesurlyadmin.com
	Twitter:			@thesurlyadm1n
	Spiceworks:			Martin9700
	
	Changelog
		1.5				Rewrite of Report-PasswordExpiration.ps1.  Added ability to specify
		                SearchBase, save report with dates and specify time range for 
						reporting expired passwords.  Also completely re-worked the max
						password age function to be much more efficient. Also added a little
						color to the HTML report.
		1.0				Initial Version
.LINK
        http://community.spiceworks.com/scripts/show/1733-report-passwordexpiring
.LINK
	http://community.spiceworks.com/scripts/show/1635-copy-a-ou-s-fqdn-to-clipboard
#>
Param (
	[string]$Path = "c:\Reports",
	[string]$SearchBase = "OU=KSL Staff,DC=Kuits,DC=local",
	[int]$Age = 3,
	[string]$From = "ITTeam@Kuits.com",
	[string]$To = "ITDept@Kuits.com",
	[string]$SMTPServer = "exchsrv2.kuits.local"
)

cls
$Result = @()

#region Determine MaxPasswordAge
#Determine MaxPasswordAge
$maxPasswordAgeTimeSpan = $null
$dfl = (get-addomain).DomainMode
$maxPasswordAgeTimeSpan = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge
If ($maxPasswordAgeTimeSpan -eq $null -or $maxPasswordAgeTimeSpan.TotalMilliseconds -eq 0) 
{	Write-Host "MaxPasswordAge is not set for the domain or is set to zero!"
	Write-Host "So no password expiration's possible."
	Exit
}
#endregion

$Users = Get-ADUser -Filter * -SearchBase $SearchBase -SearchScope Subtree -Properties GivenName,sn,PasswordExpired,PasswordLastSet,PasswordneverExpires,LastLogonDate
ForEach ($User in $Users)
{	If ($User.PasswordNeverExpires -or $User.PasswordLastSet -eq $null)
	{	Continue
	}
	If ($dfl -ge 3) 
	{	## Greater than Windows2008 domain functional level
		$accountFGPP = $null
		$accountFGPP = Get-ADUserResultantPasswordPolicy $User
    	If ($accountFGPP -ne $null) 
		{	$ResultPasswordAgeTimeSpan = $accountFGPP.MaxPasswordAge
    	} 
		Else 
		{	$ResultPasswordAgeTimeSpan = $maxPasswordAgeTimeSpan
    	}
	}
	Else
	{	$ResultPasswordAgeTimeSpan = $maxPasswordAgeTimeSpan
	}
	$Expiration = $User.PasswordLastSet + $ResultPasswordAgeTimeSpan
	If ((New-TimeSpan -Start (Get-Date) -End $Expiration).Days -le $Age)
	{	$Result += New-Object PSObject -Property @{
			'Last Name' = $User.sn
			'First Name' = $User.GivenName
			UserName = $User.SamAccountName
			'Expiration Date' = $Expiration
			'Last Logon Date' = $User.LastLogonDate
			State = If ($User.Enabled) { "" } Else { "Disabled" }
		}
	}
}
$Result = $Result | Select 'Last Name','First Name',UserName,'Expiration Date','Last Logon Date',State | Sort 'Expiration Date','Last Name'

#Produce a CSV
$ExportDate = Get-Date -f "yyyy-MM-dd"
$Result | Export-Csv $path\ExpiringReport-$ExportDate.csv -NoTypeInformation

#Send HTML Email
$Header = @"
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>
"@
$splat = @{
	From = $From
	To = $To
	SMTPServer = $SMTPServer
	Subject = "Password Expiration Report"
}
$Body = $Result | ConvertTo-Html -Head $Header | Out-String
Send-MailMessage @splat -Body $Body -BodyAsHTML -Attachments $Path\ExpiringReport-$ExportDate.csv