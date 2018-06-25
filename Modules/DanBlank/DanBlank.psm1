##############################################################################
#.SYNOPSIS
# Creates a new PS module
# 
#.DESCRIPTION
# Created the fodler structure and basic files for a module as per GitHub standard in C:\Stuff\git\Powershell\Modules
#
#.PARAMETER User
# ModuleName - Name to give the module ***MANDATORY***
# Description - Description of the module
#
#.EXAMPLE
# New-Module2 -ModuleName "DanBlank" -Description "My PS Module"
##############################################################################

Function New-Module2
{

    [cmdletbinding()]
    param(
    [Parameter(Mandatory=$true, Position=0)] 
    [string]$ModuleName,
      
    [Parameter(Position=1)] 
    [string]$Description
    )
    
        # We cloned our project to C:\sc\PSStackExchange
        $Path = 'C:\Stuff\git\Powershell\Modules'
        $Author = 'Dan Blank'
            
        # Create the module and private function directories
        mkdir $Path\$ModuleName
        mkdir $Path\$ModuleName\Private
        mkdir $Path\$ModuleName\Public
        mkdir $Path\$ModuleName\en-GB # For about_Help files
            
        #Create the module and related files
        New-Item "$Path\$ModuleName\$ModuleName.psm1" -ItemType File
        New-Item "$Path\$ModuleName\$ModuleName.Format.ps1xml" -ItemType File
        New-Item "$Path\$ModuleName\en-GB\about_$ModuleName.help.txt" -ItemType File
        $PSVersion = [string]$PSVersionTable.PSVersion.Major + "." + [string]$PSVersionTable.PSVersion.Minor
        New-ModuleManifest -Path $Path\$ModuleName\$ModuleName.psd1 `
                            -RootModule $ModuleName.psm1 `
                            -Description $Description `
                            -PowerShellVersion $PSVersion `
                            -Author $Author `
                            -FormatsToProcess "$ModuleName.Format.ps1xml"

        # Copy the public/exported functions into the public folder, private functions into private folder
}

function Connect-Exchange
{
    #implicitly connect to exchange
    $usercredential = get-credential -credential ksl\daniel.blank
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://exchsrv2/PowerShell/ -Credential $UserCredential
    Import-PSSession $Session
}