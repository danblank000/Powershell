$user = Get-Credential -username dwf\blad-adm -message "Enter UN & Password for Authentification"
Start-Process cmd.exe –credential $user “/c c:\FancyAD.MSC”
Start-process cmd.exe -credential $user "/c C:\Stuff\conf.lnk"
start-process powershell.exe -Credential $user
Start-Process powershell_ise.exe -Credential $user
sleep -Seconds 2
Stop-Process -processname iexplore
stop-process -processname cmd -force
