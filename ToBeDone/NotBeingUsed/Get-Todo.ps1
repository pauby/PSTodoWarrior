<# 
.SYNOPSIS
    Gets the todos.
.DESCRIPTION
    Gets the todos from the todo file.
.NOTES 
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 13/10/15 - Initial version
.LINK 
    http://www.github.com/pauby
.PARAMETER Path
    The path of the todo file. By default this is the TodoTaskFile from the confguration.
.OUTPUTS
	None
.EXAMPLE
    Get-Todo
		
	Gets the todos from the todo task file in the configuration.
#>

function Get-Todo
{
    [CmdletBinding()]
    Param (
        [string]$Path= (Get-TodoConfig)['TodoTaskFile']
    )
    
    $todos = import-todo $Path -Verbose:$VerbosePreference

    ,$todos
}