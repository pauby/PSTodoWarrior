<# .SYNOPSIS    Removes a todo.
.DESCRIPTION    Removes a todo from the todo file.
.NOTES 
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 24/09/15 - Initial version
                : 1.1 - 09/10/15 - Tidied up some code.

    TODO        : This function needs to work with the todo objects and return the new todo object list.
                  Remove Export-Todo from it and the Froce switch as a consequence of that.
.LINK 
    https://www.github.com/pauby
.PARAMETER LineNum    Line number(s) to remove.
.PARAMETER Path    Path of the todo file.
.PARAMETER Force
    Forces overwriting of read only todo file.
.OUTPUTS
	Number of todos removed. Output type is [int]
.EXAMPLE    Remove-Todo -LineNum 14,17 -Path c:\todo.txt -Force

    Removes the todos on lines 14 and 17, exports them to the todo file at c:\todo.txt and overwrites
    the todo file if it is read only.
#>

function Remove-Todo
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateRange(1,65535)]
        [int[]]$LineNum,

        [Parameter(Mandatory)]
        [ValidateScript( { Test_Path -Path $_ } )]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [switch]$Force
    )

    $config = Get-TodoConfig

    Write-Verbose "Importing all todos from $Path"
    $sourceTodos = Import-Todo -Path $Path
    if ($sourceTodos.Count -eq 0)
    {
        Write-Warning "Could not read todos from $Path or there were no todos to read."
        return 0 # using the return keyword to make it clear we are returning 0
    }
    else 
    {    
        Write-Verbose "Read $($sourceTodos.Count) todos.`nCreating a new todo list skipping over the one to be removed."
        $destTodos = @($sourceTodos | where-object { $LineNum -notcontains $_.Line })
        Write-Verbose "New todo list is now $($destTodos.Count) lines long (original list was $($sourceTodos.Count) lines long)."
        Export-Todo -TodoObject $destTodos -Path $Path -Force:$($Force.IsPresent) -BackupPath $config['BackupPath'] -DaysToKeep $config['BackupDaysToKeep'] -Verbose:$VerbosePreference
        return ($sourceTodos.Count - $destTodos.Count)
    }
}