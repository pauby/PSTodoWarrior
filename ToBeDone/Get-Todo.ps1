<# 
.SYNOPSIS
    Gets the todos.
.DESCRIPTION
    Gets the todos from the todo file. This is just a wrapper functions for the Import-Todotxt cmdlet
    from the PSTodoTxt module. Here however we use the config to pass the todo filename.
.NOTES 
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 03/05/17 - Initial version
.LINK 
    http://www.github.com/pauby/PSTodoWarrior
.PARAMETER Path
    The path of the todo file. By default this is the taken from the modules configuration.
.OUTPUTS
	[psobject] The todos read.
.EXAMPLE
    Get-Todo
		
	Gets the todos from the todo task file in the configuration.
#>

function Get-Todo
{
    [CmdletBinding()]
    Param (
        [string]$Path= $odoConfig.TodoTaskFile
    )
    
    Import-TodoTxt -Path $Path
}