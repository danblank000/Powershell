foreach ($per in staff)
{
$per = ($per.samaccountname).ToString()
Set-ADAccountControl $per -PasswordNeverExpires $false -CannotChangePassword $false
set-aduser $per -ChangePasswordAtLogon $true
}