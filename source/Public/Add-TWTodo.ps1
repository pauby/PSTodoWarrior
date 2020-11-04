function Add-TWTodo
{
    <#
    .SYNOPSIS
        Adds a new todo to the list.
    .DESCRIPTION
        Adds a new todo to the list and then adds a line number to the todo object.
    .EXAMPLE
        Add-TWTodo -Todo "A new todo"

        Adds "A new todo" to the todo list and gives it the next line number
    .NOTES
        Author:  Paul Broadwith (https://pauby.com)
        Project: PSTodoWarrior (https://github.com/pauby/pstodowarrior)
    .LINK
        https://www.github.com/pauby/pstodowarrior/tree/master/docs/add-twtodo.md
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    Param (
        # The todo to add
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $Todo,

        # Path to the todo file.
        # Default is TodoTaskFile from the module configuration.
        [Parameter(Mandatory, Position = 1)]
        [AllowEmptyCollection()]
        [System.Collections.ArrayList]
        $TodoList
    )

    Begin {}

    Process {
        #TODO Look at adding parameters for each component of the Todo - priority, createddate, donedate etc.

        # convert the todo text into a TodoTxt object
        $obj = $Todo | ConvertTo-TodoTxt

        # change the object type and add a line number for the todo
        $obj.PSObject.TypeNames.Insert(0, 'TWTodo')
        $id = @($TodoList).count + 1
        $obj | Add-Member -MemberType NoteProperty -Name 'ID' -Value $id

        # add the UUID to the object
        if ($obj.addon.keys -notcontains 'uuid') {
            $guid = ([GUID]::NewGuid()).ToString()

            # if the addons hashtable doesn't exist, then create it
            if ($obj.PSObject.Properties.name -notcontains 'addon') {
                $obj | Add-Member -MemberType NoteProperty -Name 'addon' -Value @{ 'uuid' = $guid }
            } else {
                $obj.addon += @{ 'uuid' = $guid }
            }
        }

        # add the new TWTodo object to the todo list and export the todos
        $null = $TodoList.Add($obj)

        # output the new todo
        $obj
    }

    End {
        Export-TWTodo -Todo $TodoList
    }
}