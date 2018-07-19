function Get-TWTodo
{
    <#
    .SYNOPSIS
        Imports todos from the todo file.
    .DESCRIPTION
        Imports the todos from the todo file and then adds a line number to the todo object.
    .OUTPUTS
        System.ArrayList
    .EXAMPLE
        Export-TWTodo c:\todo.txt

        Read and outputs the todos from c:\todo.txt
    .NOTES
        Author:  Paul Broadwith (https://pauby.com)
        Project: PSTodoWarrior (https://github.com/pauby/pstodowarrior)
        History: 1.0 - 16/07/18 - Initial
    .LINK
        https://www.github.com/pauby/pstodowarrior/tree/master/docs/import-twtodo.md
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    Param (
        [int32]
        $ID
    )

    # check we have some todos in the list - do this here rather than as a param
    # validation as we need to return different messages depending on what the
    # error was.
    if ($PSBoundParameters.Keys.Contains('ID')) {
        if (@($script:TWTodo).count -eq 0) {
            Write-Error "Todo list is empty."
        }
        elseif ($ID -lt 1 -or $ID -gt $script:TWTodo.count) {
            Write-Error "ID $ID does not exist in the list. ID must be between 1 and $($script:TWTodo.Count)."
        }

        # if we don't have an ID passed then return all
        Write-Verbose "Getting todo with ID $ID from list."
        $script:TWTodo[$ID - 1]
    }
    else {
        Write-Verbose 'Getting all todos.'
        $script:TWTodo
    }
}