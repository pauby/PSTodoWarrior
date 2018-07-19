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
        # The todo ID number to remove.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [int32[]]
        $ID,

        # Returns the TWTodo object created
        [switch]
        $PassThru
    )

    Begin {
        # initiaoise the list we will use to capture the ID's
        $list = @()
    }

    Process {
        # in order top sort the list BEFORE we do anything with it we need to
        # capture all the ID's
        ForEach ($i in $ID) {
            # check we don't already have the ID - removes duplicates
            if ($list -notcontains $i) {
                $list += $i
            }
        }
    }

    end {
        # if we delete the higher items first it doesn't affect the numbering below so always sort the numbers first
        $list = $list | Sort-Object -Descending
        ForEach ($item in $list) {
            #TODO Look at adding parameters for each component of the Todo - priority, createddate, donedate etc.

            # remember the array is zero based but the user sees the ID's starting from
            # 1 so -1 from what the user sees.
            $script:TWTodo[$item -1]    # display what you're about to delete
            $script:TWTodo.RemoveAt($item - 1)
        }

        Export-TWTodo

        if ($PassThru.IsPresent) {
            $script:TWTodo
        }
    }
}