function Use-Todo
{
<#
.SYNOPSIS
    One overall function to work with todos.
.DESCRIPTION
    This cmdlet is a wrapper for the other cmdlets and allows you to work with todos..

.PARAMETER List
    List / show the todos on the host. This is also the default when no other command switch is provided.
.EXAMPLE
    Use-Todo -command add -priority A -task 'Take car to the garage' -project 'care-maintenance' -context 'car'

    Adds a new todo.
.EXAMPLE
    Use-Todo remove 15

    Removes the todo at line 15.
.LINK
    http://www.github.com/pauby/pstodowarrior
.NOTES
    Author: Paul Broadwith (https://pauby.com)
#>
    [CmdletBinding()]
    Param (
        [Parameter(ParameterSetName='list')]
        [switch]$List
    )

    if ($List.IsPresent) {
        $script:twTodo = Import-Todo -Path $script:twSettings.TodoTaskPath
        $script:twTodo
    }
}

Set-Alias t Use-Todo