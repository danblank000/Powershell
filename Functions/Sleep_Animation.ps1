function sleepanim {
<#

EXAMPLE

sleepanim
Will display a small animation for 1 second
 
sleepanim 5
Will display a small animation for 5 seconds
 
sleepanim 10 "Waiting for domain sync"
Will display "Waiting for domain sync " and a small animation for 10 seconds

#>

[CmdletBinding()]
param
(
        [Parameter(Position=1)][int]$seconds=1,
        [Parameter(Position=2)][string]$title="Sleeping"
)
        $blank = "`b" * ($title.length+11)
        $clear = " " * ($title.length+11)
        $anim=@("0o.......o","o0o.......",".o0o......","..o0o.....","...o0o....","....o0o...",".....o0o..","......o0o.",".......o0o","o.......o0") # Animation sequence characters
        while ($seconds -gt 0) {
                $anim | % {
                        Write-Host "$blank$title $_" -NoNewline -ForegroundColor Yellow
                        Start-Sleep -m 100
                }
                $seconds --
          }
        Write-Host "$blank$clear$blank" -NoNewline
}