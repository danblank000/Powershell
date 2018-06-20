Function Add_Photo
{

    param
    (
    #Enter Full name of user
    [Parameter(Mandatory=$True,Position=0)] 
    [ValidateNotNull()] 
    [string]$Name
    )

Import-RecipientDataProperty -Identity "$name" -Picture -FileData ([Byte[]]$(Get-Content -Path "\\kslsrv04\intranet\photos\Outlook\$name.jpg" -Encoding Byte -ReadCount 0))

}