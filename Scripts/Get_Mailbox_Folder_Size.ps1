write-host "`nEnter the users name : " -ForegroundColor Yellow
$mailbox = read-host 

Get-MailboxFolderStatistics $mailbox | Select-Object name, @{
    Name="FolderSize in MB";
    Expression={
        [math]::Round(([regex]::matches($_.FolderSize,'\(([^\}]+)\)').value -replace 'bytes', '' -replace '\(', '' -replace '\)', '' -replace ',', '') / 1MB, 2)
    }    
} | Sort-Object "FolderSize in MB"-Descending