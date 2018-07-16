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
        [string]
        $ID,

        # Returns the TWTodo object created
        [switch]
        $PassThru
    )

    #TODO Look at adding parameters for each component of the Todo - priority, createddate, donedate etc.

    # remember the array is zero based but the user sees the ID's starting from
    # 1 so -1 from what the user sees.
    $script:TWTodo.RemoveAt($ID - 1)

    # we have made a change so export the list again
    Export-TWTodo

    if ($PassThru.IsPresent) {
        $script:TWTodo
    }
}