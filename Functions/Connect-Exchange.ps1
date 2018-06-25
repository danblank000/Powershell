function Connect-Exchange
{
    #implicitly connect to exchange
    $usercredential = get-credential -credential ksl\daniel.blank
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://exchsrv2/PowerShell/ -Credential $UserCredential
    Import-PSSession $Session
}