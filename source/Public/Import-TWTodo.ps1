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
        [ValidateScript( { Test-Path $_ } )]
        [string]
        $Path = ((Get-TWSettings).TodoTaskPath)
    )

    Write-Verbose "Checking that todo file '$($Path)' exists."
    If (Test-Path -Path $Path) {
        Write-Verbose "Importing todos and adding an ID number to each."
        [System.Collections.ArrayList]$script:TWTodo = Import-TodoTxt -Path $Path | ForEach-Object `
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
        Write-Error "Todo file '$($Path) does not exist!"
    }

    $script:TWTodo
}