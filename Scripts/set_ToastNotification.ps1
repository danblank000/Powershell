# This needs to be run in an elevated PowerShell session.

# Setup a 'scratch' location in the registry, to prevent re-alerting on the same tweet.
New-Item -Path 'HKCU:\SOFTWARE\PowerShellSQL-Scratch'
Set-ItemProperty -Path 'HKCU:\SOFTWARE\PowerShellSQL-Scratch' -Name 'SQLHelp-LastId' –Value 'FirstRun'

# Define the job block whick will be run on a schedule via a Scheduled Job
$JobBlock = {
    $URL = 'https://queryfeed.net/twitter?q=%23sqlhelp&title-type=user-name-both&geocode=&omit-retweets=on'
    $RSS = Invoke-RestMethod -Uri $URL
    
    # The Tweet URL acts as the Id, the Id from the feed and the Id in the registry are compared to see if
    # the latest Tweet has been toasted or not.
    $LastNotifyId = Get-ItemPropertyValue -Path 'HKCU:\SOFTWARE\PowerShellSQL-Scratch' -Name 'SQLHelp-LastId'
    $LatestId = $RSS[0].link

    if ($LastNotifyId -ne $LatestId) {
        Import-Module -Name BurntToast -Force

        $Title = $RSS[0].title.'#cdata-section'

        # Display a Toast Notification, with a button to open the Tweet.
        $Button = New-BTButton -Content 'Open' -Arguments $LatestId    
        New-BurntToastNotification -Text 'New SQLHelp Question on Twitter', "From: $Title" -Button $Button

        Set-ItemProperty -Path 'HKCU:\SOFTWARE\PowerShellSQL-Scratch' -Name 'SQLHelp-LastId' -Value $LatestId
    }
}

# Register the scheduled job, it will repeat until the end of time and check Twitter every five minutes.
$Trigger = New-JobTrigger -Once -At "12:00" -RepetitionInterval (New-TimeSpan -Minutes 5) -RepeatIndefinitely
Register-ScheduledJob -Name StackWatch-PowerShellSQL -Trigger $Trigger -ScriptBlock $JobBlock -Credential domain\user