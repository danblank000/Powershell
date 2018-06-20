#getting names and usernames of disbaled users with active mailboxes on Exchange 2010
get-Mailbox -resultsize unlimited | where { $_.ExchangeUserAccountControl -match “AccountDisabled”} | select name, samaccountname | sort-object name | Export-Csv 'C:\Stuff\Mailboxes.csv' -NoTypeInformation

#adding additional column headers
$file = gc 'C:\Stuff\Disabled Users Active Mailboxes\mailboxes.csv'
$existingheaders = $file[0]
$newheaders = $existingheaders + ",Email_Address" + ",Total_Item_Size" + ",Manager" + ",Last_Logon_Time" + ",Last_Logged_On_User"
$file = $file -replace "$existingheaders","$newheaders"
$file | Set-Content 'C:\Stuff\mailboxes.csv'

#clearing the variable $file
$file = ""

#Filling in additional column info
$file = Import-Csv -path "C:\Stuff\mailboxes.csv"

foreach ($line in $file)
    {
    #######################
    #### email address ####
    #######################
    
    #get email address
    $email = get-aduser $line.SAMAccountName -properties emailaddress | select emailaddress
    
    #add it to the file
    $line.email_address = $email.emailaddress
    
    #######################
    ##### Mailbox Size ####
    #######################

    #getting mailbox size and stripping to a number
    $mailsize = Get-MailboxStatistics $line.samaccountname | select totalitemsize
    
    #if there is a mailsize
    if ($mailsize -ne $NULL)
    {    
    $mailsize = $mailsize.totalitemsize
    $mailsize = $mailsize.Split('(')[-1]
    $mailsize = $mailsize -replace "\ .*" , ""
    $truemailsize = $mailsize -as [int]
    }

    #if there is not a mailsize
    else
    {
    $mailsize = "0"
    } 
    
            
    ########################
    # Last Loggedn on User #
    ########################
        
    #getting last logged on user and reducing it to a real name
    $lastloggedonuseraccount = Get-MailboxStatistics $line.Email_Address | select lastloggedonuseraccount
    $lastloggedonuseraccount = $lastloggedonuseraccount.LastLoggedOnUserAccount

    #if there is a last logged on user account
    if ($lastloggedonuseraccount.length -ne 0)
    {
    $lastloggedonuseraccount = $lastloggedonuseraccount.substring(4)
    $lastloggedonuser = Get-ADUser $lastloggedonuseraccount | select name
    $lastloggedonuser = $lastloggedonuser.name
    }

    #if there is not a last logged on user account
    else
    {
    $lastloggedonuser = ""
    }

    ###############################  
    ####### Last Logon Time #######             
    ###############################
           
    $lastlogontime = Get-MailboxStatistics $line.Email_Address | select lastlogontime
    
    ###############################  
    ##### Adding info to $file ####
    ###############################  
        
    $line.email_address = $email.emailaddress
    $line.Total_Item_Size = $truemailsize
    $line.manager = $manager
    $line.last_logon_time = $lastlogontime.lastlogontime
    $line.Last_logged_on_user = $lastloggedonuser
    }

#displaying result
$File | ft

#exporting result
$file | export-csv 'C:\Stuff\mailboxes_Final.csv' -NoTypeInformation