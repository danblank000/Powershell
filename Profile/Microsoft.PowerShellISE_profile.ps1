#implicitly connect to exchange
$usercredential = get-credential -credential ksl\admin_db
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://exchsrv2/PowerShell/ -Credential $UserCredential
Import-PSSession $Session

#add excahnge snapin
add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010

import-module dbatools

set-location C:\Users\daniel.blank\Dropbox\Powershell

Add-PSSnapin Quest.ActiveRoles.ADManagement

cls

dir | ft
