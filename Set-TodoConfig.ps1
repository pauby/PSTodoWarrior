<# 
.SYNOPSIS
    Sets the todo configuration.
.DESCRIPTION
    Sets the todo configuration using the hashtable passed to it.
.NOTES 
    File Name	: Set-TodoConfig.ps1  
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 11/09/15 - Initial version
.PARAMETER Config
    The first month to display.
.EXAMPLE
    .\Set-TodoConfig -Config $Config

    Sets the todo configuration based on $config hashtable.
#>

function Set-TodoConfig
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,Position=0)]
        [ValidateScript({ Confirm-TodoConfig -Config $_ -Verbose:$VerbosePreference})]
        [hashtable]$Config
        )

    $script:poshTodoConfig = Merge-Hashtable $Config $(Get-TodoDefaultConfig)
}