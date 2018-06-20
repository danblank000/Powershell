$PhotoPath = "\\kslsrv04\Intranet\photos\Outlook\*.*" 
ForEach ($PhotoFile in gci $PhotoPath)
{

$User = '' + $PhotoFile.Name.substring(0, $PhotoFile.Name.Length - 4) + ''
#Set-Mailbox "$user" -RemovePicture
#sleep -Seconds 1

Import-RecipientDataProperty -Identity $User -Picture -FileData ([Byte[]]$(Get-Content -Path $PhotoFile.Fullname -Encoding Byte -ReadCount 0))

}



Import-RecipientDataProperty -Identity "Jackie Minzie" -Picture -FileData ([Byte[]]$(Get-Content -Path "\\kslsrv04\intranet\photos\Outlook\Jackie Minzie.jpg" -Encoding Byte -ReadCount 0))



Get-ADUser -Filter * -SearchBase "ou=ksl staff,dc=kuits,dc=local" -Properties thumbnailPhoto | Where-Object {$_.thumbnailPhoto -eq $Null -and $_.distinguishedname -notlike "*generic*" -and $_.name -notlike "test*" -and $_.name -notlike "laptop*"} | select name |  sort name | out-gridview