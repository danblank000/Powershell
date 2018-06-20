$Now = Get-Date

function Get-FirstFridayOfMonth ([DateTime] $Date) {
    # Get an object representing the first day of the specified month
    $Year = $Date.Year
    $Month = $Date.Month
    [DateTime] $TestDate = "$Year-$Month-01 13:00:00"

    # Increment through the month until the first Friday is found
    while ($TestDate.DayOfWeek -ne 'Friday') {
        $TestDate = $TestDate.AddDays(1)
    }

    # And spit out the Friday we found
    $TestDate
}

# Call the previously defined function
$PotentialFriday = Get-FirstFridayOfMonth -Date $Now

# It's no good to us if it's in the past though
if (($PotentialFriday - $Now) -lt 0) {
    # So try find next month's PSTweetChat
    $PotentialFriday = Get-FirstFridayOfMonth -Date $Now.AddMonths(1)
}

# Get that time in your local timezone
[System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId($PotentialFriday, 'US Eastern Standard Time', [System.TimeZoneInfo]::Local.Id)