cls
Write-Host "*** Find Fee Earners ***" -ForegroundColor Yellow
sleep -s 1
write-host "`nWhich department's Fee Earners do you need to find?`n"
write-host "`1.  banking and real estate finance" -foregroundcolor gray
write-host "`2.  commercial and ip" -foregroundcolor gray 
write-host "`3.  commercial property" -foregroundcolor gray
write-host "`4.  corporate" -foregroundcolor gray
write-host "`5.  employment" -foregroundcolor gray 
write-host "`6.  family" -foregroundcolor gray
write-host "`7.  ip" -foregroundcolor gray
write-host "`8.  licensing" -foregroundcolor gray
write-host "`9.  litigation" -foregroundcolor gray
write-host "`10. real estate and development" -foregroundcolor gray
write-host "`11. residential property" -foregroundcolor gray
write-host "`12. tax and probate`n" -foregroundcolor gray

$departmentchoice = Read-Host

if ($departmentchoice -eq "1")
            {
            $department = "banking and real estate finance"
            }

            elseif ($departmentchoice -eq "2")
            {
            $department = "commercial and ip"
            }
    
            elseif ($departmentchoice -eq "3")
            {
            $department = "commercial property"
            }
    
            elseif ($departmentchoice -eq "4")
            {
            $department = "corporate"
            }
        
            elseif ($departmentchoice -eq "5")
            {
            $department = "employment"
            }
    
            elseif ($departmentchoice -eq "6")
            {
            $department = "family"
            }
    
            elseif ($departmentchoice -eq "7")
            {
            $department = "intellectual property"
            }
    
            elseif ($departmentchoice -eq "8")
            {
            $department = "licensing"
            }
    
            elseif ($departmentchoice -eq "9")
            {
            $department = "litigation"
            }
    
            elseif ($departmentchoice -eq "10")
            {
            $department = "real estate and development"
            }
    
            elseif ($departmentchoice -eq "11")
            {
            $department = "residential property"
            }
    
            elseif ($departmentchoice -eq "12")
            {
            $department = "tax & probate"
            }


get-aduser -filter {extensionattribute1 -eq "FE"} -Properties * | where {$_.department -eq "$department"} | select name | sort name