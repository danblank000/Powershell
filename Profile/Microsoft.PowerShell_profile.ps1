Import-Module ActiveDirectory

$UserCredential = get-credential dwf\blad-adm


$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mascoexch04.dwf.local/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session

Cd C:/powershell

cls

"You are now entering Powershell : " + $env:username

