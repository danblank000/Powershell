write-host "-----------------------------------------------"
Write-host "            Test for p4w.dot                   " -ForegroundColor Yellow -BackgroundColor Black
write-host "-----------------------------------------------"
$pcs = @()
$truedot = @()
$truedotm = @()
$falsedotm = @()
$offline = @()
$OUs = "ou=ksl computers,dc=kuits,dc=local","ou=pcs,dc=kuits,dc=local","ou=laptops,dc=kuits,dc=local"

    foreach ($ou in $OUs)
    {
    
    $PCs += (Get-ADComputer -SearchBase "$ou" -filter * |select name).name
    
        foreach ($pc in $pcs)
        {
        write-host "$pc"
        $pingtest = Test-Connection $pc -Count 1 -Quiet

            if ($pingtest -eq $true)
            {
            write-host "ONLINE" -ForegroundColor Green
            $testdot = test-path "\\$pc\c$\printing\p4w.dot"
        
                if ($testdot -eq $true)
                {
                write-host "Has p4w.dot" -ForegroundColor Green
                $truedot += "$pc`n"
                Remove-Item \\$pc\c$\printing\p4w.dot -Force
                }

                else
                {
                write-host "Does not have p4w.dot" -ForegroundColor Red
                }
            
            $testdotm = test-path "\\$pc\c$\printing\p4w.dotm"

                if ($testdotm -eq $true)
                {
                write-host "Has p4w.dotm" -ForegroundColor Green
                $truedotm += "$pc`n"
                }

                else
                {
                write-host "Does not have p4w.dotm" -ForegroundColor Red
                $falsedotm += "$pc`n"
                }

            write-host "-----------------------------------------------`n" -ForegroundColor DarkGray            
            }

            else
            {
            write-host "OFFLINE" -ForegroundColor Red
            write-host "-----------------------------------------------`n" -ForegroundColor DarkGray 
            $offline += "$pc`n"
            }

        }
    
    }

write-host "`n These PCs were offline : `n$offline"
write-host  "-----------------------------------------"
write-host "`n These PCs have the .dot file : `n$truedot"
write-host  "-----------------------------------------"
write-host "`n These PCs have the dotm file : `n$truedotm"
write-host  "-----------------------------------------"
write-host "`n These PCs need the .dotm file : `n$falsedotm"

