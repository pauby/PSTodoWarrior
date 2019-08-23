function Import-TWTodo
{
    <#
    .SYNOPSIS
        Imports todos from the todo file.
    .DESCRIPTION
        Imports the todos from the todo file and then adds a line number to the todo object.
    .OUTPUTS
        System.ArrayList
    .EXAMPLE
        Import-TWTodo c:\todo.txt

        Read and outputs the todos from c:\todo.txt
    .NOTES
        Author:  Paul Broadwith (https://pauby.com)
    .LINK
        https://www.github.com/pauby/pstodowarrior/tree/master/docs/import-twtodo.md
    #>
    [OutputType([System.Collections.ArrayList])]
    [CmdletBinding()]
    Param (
        # Path to the todo file.
        # Default is TodoTaskFile from the module configuration.
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $Path = ((Get-TWConfiguration).TodoTaskPath)
    )

    If (Test-Path -Path $Path) {
        Write-Verbose "Found Todo file at '$Path'."
        Write-Verbose "Importing todos, adding the 'TWTodo' type and adding an ID number to each."
        [System.Collections.ArrayList]$todo = Import-TodoTxt -Path $Path | ForEach-Object `
        -Begin {
            $count = 1
        } `
        -Process {
            $_.PSObject.TypeNames.Insert(0, 'TWTodo')
            $_ | Add-Member -MemberType NoteProperty -Name 'ID' -Value $count -PassThru
            $count++
        }
    }
    else {
        Write-Error "Could not find '$($Path)'."
    }

    $todo
}