$users = ""

$users = Get-ADUser -Filter {(samaccountname -notlike "*test*") -and (samaccountname -notlike "*account*") -and (samaccountname -notlike "*training*") -and (samaccountname -notlike "*temp*")} -SearchBase "OU=ex ksl staff,DC=kuits,DC=local" -Properties mail | select mail | sort mail

    foreach ($user in $users)
    {
    $mailbox = $user.mail
    $alias = "{" + $mailbox + "}" + ".1" + ".pst"
    New-MailboxExportRequest -FilePath "\\kslnas01\pstfiles$\Mimecast_Ingestion\$alias" -Mailbox $mailbox -ContentFilter "(Received -lt '05/15/2014')"
    }