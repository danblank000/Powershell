$excluded = @("admin*", "*desktop*", "*fifosys*", "*librarian*", "*rdp*", "*svc*", "test*", "*train**", "*wisdom", "*~*", "*tr1*", "*tmobile*", "*support*", "*temp*", "*tax*", "*recept*", "project*", "print*", "*rbs*", "*prec*", "*post*", "*persman*", "*p4w*", "*oyez*", "*office*", "*my web*", "*mltemp*", "*meeting*", "*maternity*", "*litigation*", "*licensing*", "*ksl*", "*Job Des*", "*Intranet*", "*hr*", "*hpds*", "*hays*", "*client*", "*cd bible*", "bytes*", "*archive*" )
$folders = Get-ChildItem "\\kslnas01\userfolders$" -Directory -Exclude $excluded -Name "jenkinsm"

    foreach ($folder in $folders)
    {
    $oldfolder = ($folder<#.Name#>).ToString()
    $oldfolder
    $firstname = (get-aduser $oldfolder | select givenname).givenname
    $surname = (get-aduser $oldfolder | select surname).surname
    $firstname = $firstname.tostring()
    $surname = $surname.tostring()
    $newname = "$firstname" + "." + "$surname"
    Rename-Item "\\kslnas01\userfolders$\$oldfolder" -NewName "$newname"
    }
    cc
$profolders = Get-ChildItem "\\kslnas01\profiles$" -Directory -Exclude $excluded  -Name "jenkinsm*"
 
    foreach ($profolder in $profolders)
    {
    $prooldfolder = ($profolder<#.Name#>).ToString()
    $prooldfolder
    $proname = ($prooldfolder.Split("."))[0]
    $profirstname = (get-aduser $proname | select givenname).givenname
    $prosurname = (get-aduser $proname | select surname).surname
    $profirstname = $profirstname.tostring()
    $prosurname = $prosurname.tostring()
    $pronewname = "$profirstname" + "." + "$prosurname" + ".v2"
    Rename-Item "\\kslnas01\profiles$\$prooldfolder" -NewName "$pronewname"
    }
    