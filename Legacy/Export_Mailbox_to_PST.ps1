Do{
    $alias = read-host "Enter Exchange Alias of mailbox to export"

    Try
    {
    [void](Get-Mailbox $alias -ErrorAction Stop)
    $Continue = $true
    } 
    
    Catch 
    {
    $Continue = $false
    }

        if($Continue)
            {
            write-host "Alias $alias exists" -ForegroundColor Green
            $path = "\\masparch001\pstarchive\"
            $location = "$path" + "$alias" + ".pst"
            New-MailboxExportRequest -mailbox $alias -filepath $location -name ServiceDesk
            sleep -s 1
            Get-MailboxExportRequest -Mailbox "$alias" | select status, mailbox, filepath | format-table -autosize
            } 
            
            else 
            {
            write-host "No mailbox with that alias exists" -ForegroundColor Red
            $repeat = read-host "Would you like to enter another alias? Press 'Y' to try again or 'N' to exit"
            }
}
Until ($repeat -eq "N")