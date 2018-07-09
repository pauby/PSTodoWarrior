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
        Import-Todo c:\todo.txt

        Read and outputs the todos from c:\todo.txt
    .NOTES
        Author:  Paul Broadwith (https://pauby.com)
        History: 1.0 - unknown - initial release
                 1.1 - 09/07/18 - Renamed function; Updated comments
    .LINK
        https://www.github.com/pauby/pstodowarrior/tree/master/docs/import-twtodo.md
    #>
    [OutputType([System.ArrayList])]
    [CmdletBinding()]
    Param (
        # Path to the todo file.
        # Default is TodoTaskFile from the module configuration.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript( { Test-Path $_ } )]
        [string]
        $Path = $script:TWSettings.TodoTaskPath
    )

    Write-Verbose "Importing todos and adding a line number to each."
    Import-TodoTxt -Path $Path | ForEach-Object `
        -Begin {
            $count = 1
        } `
        -Process {
            $_.PSObject.TypeNames.Insert(0, 'TWTodo')
            $_ | Add-Member -MemberType NoteProperty -Name 'Line' -Value $count -Passthru
            $count++
        }
}