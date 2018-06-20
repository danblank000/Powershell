Function Get_Password_Expiration
{

    param
    (
    [Parameter(Mandatory=$True,Position=0)]
    [string]$User
    )
        
    Get-ADUser $user –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

} 