$trainees = (get-aduser -Filter {title -like "*trainee*"} -Properties title | select samaccountname).samaccountname | sort name

write-host "`nCurrent Trainees" -BackgroundColor black -ForegroundColor Yellow
foreach ($trainee in $trainees)
{
$trainee = $trainee.ToString()
set-aduser $trainee -Clear "extensionattribute2"
set-aduser $trainee -add @{"extensionattribute2"="trainee"}
get-aduser $trainee -Properties title, extensionattribute2 | select name, title, extensionattribute2
}

$formertrainees = (get-aduser -Filter {(title -notlike "*trainee*") -and (extensionattribute2 -like "*trainee*")}).samaccountname | sort name

write-host "`nFormer Trainees" -BackgroundColor black -ForegroundColor Yellow
foreach ($formertrainee in $formertrainees)
{
set-aduser $formertrainee -Clear "extensionattribute2"
get-aduser $formertrainee -Properties title, extensionattribute2 | select name, title
}