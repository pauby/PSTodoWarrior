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
        Project: PSTodoWarrior (https://github.com/pauby/pstodowarrior)
        History: 1.0 - unknown - initial release
                 1.1 - 09/07/18 - Renamed function; Updated comments
    .LINK
        https://www.github.com/pauby/pstodowarrior/tree/master/docs/import-twtodo.md
    #>
    [OutputType([System.Collections.ArrayList])]
    [CmdletBinding()]
    Param (
        # Path to the todo file.
        # Default is TodoTaskFile from the module configuration.
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript( { Test-Path $_ } )]
        [string]
        $Path = $global:TWSettings.TodoTaskPath,

        # Returns the TWTodo object list created
        [switch]
        $PassThru
    )

    Write-Verbose "Checking that todo file '$($global:TWSettings.TodoTaskPath)' exists."
    If (Test-Path -Path $global:TWSettings.TodoTaskPath) {
        Write-Verbose "Importing todos and adding an ID number to each."
        [System.Collections.ArrayList]$script:TWTodo = Import-TodoTxt -Path $global:TWSettings.TodoTaskPath | ForEach-Object `
            -Begin {
                $count = 1
            } `
            -Process {
                $_.PSObject.TypeNames.Insert(0, 'TWTodo')
                $_ | Add-Member -MemberType NoteProperty -Name 'ID' -Value $count -PassThru
                $count++
            }

        if ($PassThru.IsPresent) {
            $script:TWTodo
        }
    }
    else {
        Write-Error "Todo file '$($global:TWSettings.TodoTaskPath) does not exist!"
    }
}