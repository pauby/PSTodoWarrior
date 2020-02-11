function Remove-TWTodo
{
    <#
    .SYNOPSIS
        Removes a todo from the list.
    .DESCRIPTION
        Removes a todo from the list specified by it's ID number.
    .OUTPUTS
        System.Collections.ArrayList
    .EXAMPLE
        Remove-TWTodo -ID 15

        Removes the todo with ID 15 from the list.
    .NOTES
        Author:  Paul Broadwith (https://pauby.com)
        Project: PSTodoWarrior (https://github.com/pauby/pstodowarrior)
        History: 1.0 - 16/07/18 - Initial
    .LINK
        https://www.github.com/pauby/pstodowarrior/tree/master/docs/add-twtodo.md
    #>
    [OutputType([System.Collections.ArrayList])]
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, Position = 0)]
        [System.Collections.ArrayList]
        $Todo,

        # The todo ID number to remove.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [int32[]]
        $ID
    )

    Begin { }

    Process { }

    End {
        $list = $ID | Select-Object -Unique
        Write-Verbose ("Created unique list of ID''s to remove: {0}" -f ($list -join ','))

        # if we delete the higher items first it doesn't affect the numbering below so always sort the numbers first
        $list = $list | Sort-Object -Descending
        ForEach ($item in $list) {
            #TODO Look at adding parameters for each component of the Todo - priority, createddate, donedate etc.

            # remember the array is zero based but the user sees the ID's starting from
            # 1 so -1 from what the user sees.
            $Todo.RemoveAt($item - 1)
        }

        # we only output the todo(s) removed
        Export-TWTodo -Todo $Todo
    }
}