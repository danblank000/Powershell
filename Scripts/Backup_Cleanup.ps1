$limit = (Get-Date).AddDays(-15)
$paths = @("\\kslnas01\backups\Partner Backups","\\kslnas01\backups\Bighand Backups","\\kslnas01\backups\CarpeDiem Backups","\\kslnas01\backups\TimeFinder Backups")

# Delete files older than the $limit.
Foreach ($path in $paths)
{
$path
# Delete files older than the $limit.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force

# Delete any empty directories left behind after deleting the old files.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

}

