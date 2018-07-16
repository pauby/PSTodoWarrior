function Use-TWTodo
{
<#
.SYNOPSIS
    One overall function to work with todos.
.DESCRIPTION
    This cmdlet is a wrapper for the other cmdlets and allows you to work with todos..

.PARAMETER List
    List / show the todos on the host. This is also the default when no other command switch is provided.
.EXAMPLE
    Use-TWTodo -Add 'Take car to the garage' -project 'care-maintenance' -context 'car'

    Adds a new todo.
.EXAMPLE
    Use-TWTodo remove 15

    Removes the todo at line 15.
.LINK
    http://www.github.com/pauby/pstodowarrior/tree/master/docs/use-twtodo.md
.NOTES
    Author: Paul Broadwith (https://pauby.com)
    Project: PSTodoWarrior (https://github.com/pauby/pstodowarrior)
    History: 1.0 - unknown  - Initial release
             1.1 - 09/07/18 - Renamed function
             1.2 - 16/07/18 - Added Add functionality; Refactored code
#>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    Param (
        [Parameter(ParameterSetName = 'List')]
        [switch]
        $List,

        [Parameter(ParameterSetName = 'Add')]
        [string]
        $Add,

        [Parameter(ParameterSetName = 'Remove')]
        [int32]     #TODO allow an array or raneg to be used here
        $Remove,

        [Parameter(ParameterSetName = 'Complete')]
        [Int32]
        $Complete
    )

    # using round brackets around switch scriptblocks to make it easier to read
    # and break up the curly brackets a bit
    if ($PSBoundParameters.Keys.Contains('Add')) {
        # import the todos again in case anything has changed, add the new todo
        # and then export them (as we have made a change)
        Import-TWTodo
        $Add | Add-TWTodo
        Export-TWTodo
    }
    elseif ($PSBoundParameters.Keys.Contains('Remove')) {
        # the user is basing their removal on what they last saw so don't re-read the todolist in case it has changed

        #TODO we need to put some mechanism in here for alerting the user if
        #TODO things have changed since the last import - for example a hash of the
        #TODO todo file
        Remove-TWTodo -ID $Remove
        Export-TWTodo
    }
    elseif ($PSBoundParameters.Keys.Contains('Complete')) {
        # complete a todo by setting the DoneDate
        $doneDate = Get-Date -Format "yyyy-MM-dd"       #TODO this was taken straight Get-TodoTxtTodaysDate - consider making that function public and use it instead
        $script:TWTodo[$Complete - 1] | Set-TodoTxt -DoneDate $doneDate
        Export-TWTodo
    }
    else {
        # if we get here we have either not passed any of the 'command'
        # parameters OR have passed List
        if ($List.IsPresent) {
            Write-Verbose "Listing todos."
        }
        else {
            Write-Verbose "No parameter was passed. Defaulting to listing todos."
        }

        # import the todos and then show them - simples!
        Import-TWTodo
        $script:TWTodo | Where { [string]::IsNullOrEmpty($_.DoneDate) -eq $true }
        $stats = Get-TWStats
        Write-Host "`nCompleted: $($stats.Completed)"
    }
}

Set-Alias t Use-TWTodo