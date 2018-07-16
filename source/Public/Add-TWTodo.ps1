function Add-TWTodo
{
    <#
    .SYNOPSIS
        Adds a new todo to the list.
    .DESCRIPTION
        Adds a new todo to the list and then adds a line number to the todo object.
    .OUTPUTS
        System.Collections.ArrayList
    .EXAMPLE
        Add-TWTodo -Todo "A new todo"

        Adds "A new todo" to the todo list and gives it the next line number
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
        # Path to the todo file.
        # Default is TodoTaskFile from the module configuration.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $Todo,

        # Returns the TWTodo object created
        [switch]
        $PassThru
    )

    #TODO Look at adding parameters for each component of the Todo - priority, createddate, donedate etc.

    # convert the todo text into a TodoTxt object
    $obj = $Todo | ConvertTo-TodoTxt

    # change the object type and add a line number for the todo
    $obj.PSObject.TypeNames.Insert(0, 'TWTodo')
    $id = @($script:TWTodo).count + 1
    $obj | Add-Member -MemberType NoteProperty -Name 'ID' -Value $id

    # add the new TWTodo object to the todo list
    $null = $script:TWTodo.Add($obj)

    if ($PassThru.IsPresent) {
        $obj
    }
}