Function Rest_Password
{

    Param
    (
    [Parameter(Mandatory=$True,Position=0)]
    [string]$user,
    
    [Parameter(Position=1)]
    [string]$Paswd
        
    )

    if (!$Paswd)
    {
    $Paswd = ConvertTo-SecureString –String ‘Kuits123’ –AsPlainText –Force
    }

    else
    {
    $Paswd = ConvertTo-SecureString –String ‘Kuits123’ –AsPlainText –Force
    }

    Set-ADAccountPassword -Identity $user -NewPassword $Paswd
    Set-ADAccountControl $user -PasswordNeverExpires $false -CannotChangePassword $false
    set-aduser $user -ChangePasswordAtLogon $true

}