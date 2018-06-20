﻿<# 
.Synopsis 
   Script to Automated Email Reminders when Users Passwords due to Expire. 
.DESCRIPTION 
   Script to Automated Email Reminders when Users Passwords due to Expire. 
   Robert Pearman (Cloud & Data Center MVP) 
   WindowsServerEssentials.com 
   Version 2.2 February 2017 
   Requires: Windows PowerShell Module for Active Directory 
   For assistance and ideas, visit the TechNet Gallery Q&A Page. http://gallery.technet.microsoft.com/Password-Expiry-Email-177c3e27/view/Discussions#content 
.EXAMPLE 
  PasswordChangeNotification.ps1 -smtpServer mail.domain.com -expireInDays 21 -from "IT Support <support@domain.com>" -Logging -LogPath "c:\logFiles" -testing -testRecipient support@domain.com 
.EXAMPLE 
  PasswordChangeNotification.ps1 -smtpServer mail.domain.com -expireInDays 21 -from "IT Support <support@domain.com>"  
#> 

param( 
    # $smtpServer Enter Your SMTP Server Hostname or IP Address 
    [Parameter(Mandatory=$True,Position=0)] 
    [ValidateNotNull()] 
    [string]$smtpServer, 
    # Notify Users if Expiry Less than X Days 
    [Parameter(Mandatory=$True,Position=1)] 
    [ValidateNotNull()] 
    [int]$expireInDays, 
    # From Address, eg "IT Support <support@domain.com>" 
    [Parameter(Mandatory=$True,Position=2)] 
    [ValidateNotNull()] 
    [string]$from, 
    [Parameter(Position=3)] 
    [switch]$logging, 
    # Log File Path 
    [Parameter(Position=4)] 
    [string]$logPath, 
    # Testing Enabled 
    [Parameter(Position=5)] 
    [switch]$testing, 
    # Test Recipient, eg recipient@domain.com 
    [Parameter(Position=6)] 
    [string]$testRecipient, 
    [Parameter(Position=7)] 
    [switch]$status 
) 
################################################################################################################### 
$start = [datetime]::Now 
# System Settings 
$textEncoding = [System.Text.Encoding]::UTF8 
$today = [datetime]::Now 
# End System Settings 
 
# Get Users From AD who are Enabled, Passwords Expire and are Not Currently Expired 
Import-Module ActiveDirectory 
$padVal = "20" 
Write-Output "Script Loaded" 
Write-Output "*** Settings Summary ***" 
$smtpServerLabel = "SMTP Server".PadRight($padVal," ") 
$expireInDaysLabel = "Expire in Days".PadRight($padVal," ") 
$fromLabel = "From".PadRight($padVal," ") 
$testLabel = "Testing".PadRight($padVal," ") 
$testRecipientLabel = "Test Recipient".PadRight($padVal," ") 
$logLabel = "Logging".PadRight($padVal," ") 
$logPathLabel = "Log Path".PadRight($padVal," ") 
if($testing) 
{ 
    if(($testRecipient) -eq $null) 
    { 
        Write-Output "No Test Recipient Specified" 
        Exit 
    } 
} 
if($logging) 
{ 
    if(($logPath) -eq $null) 
    { 
        $logPath = $PSScriptRoot 
    } 
} 
Write-Output "$smtpServerLabel : $smtpServer" 
Write-Output "$expireInDaysLabel : $expireInDays" 
Write-Output "$fromLabel : $from" 
Write-Output "$logLabel : $logging" 
Write-Output "$logPathLabel : $logPath" 
Write-Output "$testLabel : $testing" 
Write-Output "$testRecipientLabel : $testRecipient" 
Write-Output "*".PadRight(25,"*") 
$users = get-aduser -filter {(Enabled -eq $true) -and (PasswordNeverExpires -eq $false)} -properties Name, PasswordNeverExpires, PasswordExpired, PasswordLastSet, EmailAddress | where { $_.passwordexpired -eq $false } 
# Count Users 
$usersCount = ($users | Measure-Object).Count 
Write-Output "Found $usersCount User Objects" 
# Collect Domain Password Policy Information 
$defaultMaxPasswordAge = (Get-ADDefaultDomainPasswordPolicy -ErrorAction Stop).MaxPasswordAge.Days  
Write-Output "Domain Default Password Age: $defaultMaxPasswordAge" 
# Collect Users 
$colUsers = @() 
# Process Each User for Password Expiry 
Write-Output "Process User Objects" 
foreach ($user in $users) 
{ 
    $Name = $user.Name 
    $emailaddress = $user.emailaddress 
    $passwordSetDate = $user.PasswordLastSet 
    $samAccountName = $user.SamAccountName 
    $pwdLastSet = $user.PasswordLastSet 
    # Check for Fine Grained Password 
    $maxPasswordAge = $defaultMaxPasswordAge 
    $PasswordPol = (Get-AduserResultantPasswordPolicy $user)  
    if (($PasswordPol) -ne $null) 
    { 
        $maxPasswordAge = ($PasswordPol).MaxPasswordAge.Days 
    } 
    $expireson = $pwdLastSet.AddDays($maxPasswordAge) 
    $daysToExpire = New-TimeSpan -Start $today -End $Expireson 
    # Round Up or Down 
    if(($daysToExpire.Days -eq "1") -and ($daysToExpire.Hours -ge "12")) 
    { 
        # If password expires in 1 day and more than 12 hours, ie 1 day 23 hours, we round up to two days for notification purposes. 
        $daysToExpire = 2 
    } 
    else 
    { 
        # Use total number of days from from 'Time Span' 
        $daysToExpire = $daysToExpire.Days 
        if(($daysToExpire) -le "0") 
        { 
            # if $daystoExpire is negative value reset to 0 
            $daysToExpire = 0 
        } 
         
    } 
    # Create User Object 
    $userObj = New-Object System.Object 
    $userObj | Add-Member -Type NoteProperty -Name UserName -Value $samAccountName 
    $userObj | Add-Member -Type NoteProperty -Name Name -Value $Name 
    $userObj | Add-Member -Type NoteProperty -Name EmailAddress -Value $emailAddress 
    $userObj | Add-Member -Type NoteProperty -Name PasswordSet -Value $pwdLastSet 
    $userObj | Add-Member -Type NoteProperty -Name DaysToExpire -Value $daysToExpire 
    $userObj | Add-Member -Type NoteProperty -Name ExpiresOn -Value $expiresOn 
    $colUsers += $userObj 
} 
$colUsersCount = ($colUsers | Measure-Object).Count 
Write-Output "$colusersCount Users processed" 
$notifyUsers = $colUsers | where { $_.DaysToExpire -le $expireInDays} 
$notifiedUsers = @() 
$notifyCount = ($notifyUsers | Measure-Object).Count 
Write-Output "$notifyCount Users to notify" 
foreach ($user in $notifyUsers) 
{ 
    # Email Address 
    $samAccountName = $user.UserName 
    $emailAddress = $user.EmailAddress 
    # Set Greeting Message 
    $name = $user.Name 
    $daysToExpire = $user.DaysToExpire 
    $messageDays = "today." 
    if (($daysToExpire) -gt "1") 
    { 
        $messageDays = "in " + "$daystoexpire" + " days." 
    } 
    # Subject Setting 
    $subject="Your password will expire $messageDays" 
    # Email Body Set Here, Note You can use HTML, including Images. 
    $body =" 
    <font face=""verdana""> 
    Dear $name, 
    <p> Your Password will expire $messageDays<br> 
    To change your password on a PC press CTRL ALT Delete and choose Change Password <br> 
    <p> If you are intending to work away from the office, you will not be able to access the system if your password expires. 
    <p> If uyou get you Kuits emails to your phone, don't forget to Update the password on there as well! 
    <p>Thanks, <br>  
    </P> 
    IT Support 
    <a href=""mailto:ITDept@kuits.com""?Subject=Password Expiry Assistance"">ITDept@Kuits.com</a> | EXT: 1320 
    </font>" 
        
    # If Testing Is Enabled - Email Administrator 
    if($testing) 
    { 
        $emailaddress = $testRecipient 
    } # End Testing 
 
    # If a user has no email address listed 
    if(($emailaddress) -eq $null) 
    { 
        $emailaddress = $testRecipient     
    }# End No Valid Email 
    $samLabel = $samAccountName.PadRight($padVal," ") 
    if($status) 
    { 
        Write-Output "Sending Email : $samLabel : $emailAddress" 
    } 
    try 
    { 
        Send-Mailmessage -smtpServer $smtpServer -from $from -to $emailaddress -subject $subject -body $body -bodyasHTML -priority High -Encoding $textEncoding -ErrorAction Stop 
        $user | Add-Member -MemberType NoteProperty -Name SendMail -Value "OK" 
    } 
    catch 
    { 
        $errorMessage = $_.exception.Message 
        if($status) 
        { 
           $errorMessage 
        } 
        $user | Add-Member -MemberType NoteProperty -Name SendMail -Value $errorMessage     
    } 
    $notifiedUsers += $user 
} 
if($logging) 
{ 
    # Create Log File 
    Write-Output "Creating Log File" 
    $day = $today.Day 
    $month = $today.Month 
    $year = $today.Year 
    $date = "$day-$month-$year" 
    $logFileName = "$date-PasswordLog.csv" 
    if(!($logPath.EndsWith("\"))) 
    { 
       $logFile = $logPath + "\" 
    } 
    $logFile = $logFile + $logFileName 
    Write-Output "Log Output: $logfile" 
    $notifiedUsers | Export-CSV $logFile 
} 
$notifiedUsers | sort DaystoExpire | FT -autoSize 
 
 
$stop = [datetime]::Now 
$runTime = New-TimeSpan $start $stop 
Write-Output "Script Runtime: $runtime" 
# End 