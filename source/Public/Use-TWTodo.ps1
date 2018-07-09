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
    Use-TWTodo -command add -priority A -task 'Take car to the garage' -project 'care-maintenance' -context 'car'

    Adds a new todo.
.EXAMPLE
    Use-TWTodo remove 15

    Removes the todo at line 15.
.LINK
    http://www.github.com/pauby/pstodowarrior/tree/master/docs/use-twtodo.md
.NOTES
    Author: Paul Broadwith (https://pauby.com)
    History: 1.0 - unknown - Initial release
             1.1 - 09/07/18 - Renamed function
#>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    Param (
        [Parameter(ParameterSetName = 'List')]
        [switch]$List
    )

    if ($List.IsPresent) {
        $script:TWTodo = Import-TWTodo -Path $script:TWSettings.TodoTaskPath
        $script:TWTodo
    }
}

Set-Alias t Use-Todo