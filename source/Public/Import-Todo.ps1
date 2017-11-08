function Import-Todo
{
<#
.SYNOPSIS
    Imports todos from the todo file.
.DESCRIPTION
    Imports the todos from the todo file and then adds a line number to the todo object..
.PARAMETER Path
    Path to the todo file. Default is TodoTaskFile from the mofule configuration.
.OUTPUTS
    System.ArrayList
.EXAMPLE
    Import-Todo c:\todo.txt

    Read and outputs the todos from c:\todo.txt
.LINK
    https://www.guthub.com/pauby/PSTodoWarrior
.NOTES
    Author: Paul Broadwith (https://pauby.com)
#>
    Param (
        [Parameter(Mandatory = $true, Position = 0,
            ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateScript( { Test-Path $_ } )]
        [ValidateNotNullOrEmpty()]
        [string]$Path = $script:twSettings.TodoTaskFile
    )

    Write-Verbose "Importing todos and adding the line number property."
    Import-TodoTxt -Path $Path | ForEach-Object `
        -Begin {
            $count = 1
        } `
        -Process {
            $_ | Add-Member -MemberType NoteProperty -Name 'Line' -Value $count -Passthru
            $count++
        }
}