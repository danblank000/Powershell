$user = read-host "What is the name of the receptionist?"

#region - Meeting Room Calendars

Add-MailboxFolderPermission -identity "3sm mr 1:\Calendar" -user "$user" -AccessRights editor
Add-MailboxFolderPermission -identity "3sm mr 2:\Calendar" -user "$user" -AccessRights editor
Add-MailboxFolderPermission -identity "3sm Boardroom:\Calendar" -user "$user" -AccessRights editor
Add-MailboxFolderPermission -identity "3sm training room:\Calendar" -user "$user" -AccessRights editor
Add-MailboxFolderPermission -identity "RH Accounts Meeting Room:\Calendar" -user "$user" -AccessRights editor
Add-MailboxFolderPermission -Identity "blackfriars MR1:\calendar"  -AccessRights Editor -User $User
Add-MailboxFolderPermission -Identity "blackfriars MR2:\calendar"  -AccessRights Editor -User $User
Add-MailboxFolderPermission -Identity "blackfriars MR3:\calendar"  -AccessRights Editor -User $User
Add-MailboxFolderPermission -Identity "blackfriars MR4:\calendar"  -AccessRights Editor -User $User
Add-MailboxFolderPermission -Identity "blackfriars MR5:\calendar"  -AccessRights Editor -User $User
Add-MailboxFolderPermission -Identity "blackfriars MR6:\calendar"  -AccessRights Editor -User $User
Add-MailboxFolderPermission -Identity "blackfriars MR7:\calendar"  -AccessRights Editor -User $User
#endregion

#reception mailbox full access permissions
Add-MailboxPermission -Identity "reception" -User "$user" -AccessRights fullaccess