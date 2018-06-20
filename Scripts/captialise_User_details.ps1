$users = get-aduser -Filter * -SearchBase "ou=ksl staff,dc=kuits,dc=local"

    foreach ($user in $users)
    {
    $person = get-aduser $user -Properties title, department, givenname, surname, displayname | select displayname, title, department, givenname, surname
    
    $displayname = ($person.displayname).ToString()
    $title = ($person.title).ToString()
    $department = ($person.department).ToString()
    $givenname = ($person.givenname).ToString()
    $surname = ($person.surname).ToString()
    
    $newdisplayname = ((get-culture).TextInfo.ToTitleCase($displayname)).ToString()
    $newtitle = ((get-culture).TextInfo.ToTitleCase($title)).ToString()
    $newdepartment = ((get-culture).TextInfo.ToTitleCase($department)).ToString()
    $newgivenname = ((get-culture).TextInfo.ToTitleCase($givenname)).ToString()
    $newsurname = ((get-culture).TextInfo.ToTitleCase($surname)).ToString()
    
    set-aduser $user -Title $newtitle -Department $newdepartment
    }