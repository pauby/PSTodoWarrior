function Import-Todo
{
    <# 
    .SYNOPSIS
        Imports todos from the todo file.
    .DESCRIPTION
        Imports the todos from the todo file and then adds a line number to the todo object..
    .LINK 
        https://www.guthub.com/pauby/PSTodoWarrior            
    .PARAMETER Path
        Path to the todo file. Default is TodoTaskFile from the mofule configuration.
    .OUTPUTS
        Output is [array]
    .EXAMPLE
        Import-Todo c:\todo.txt

        Read and outputs the todos from c:\todo.txt
    #>
    Param (
        [ValidateScript( { Test-Path $_ } )]
        [ValidateNotNullOrEmpty()]
        [string]$Path = $todoConfig.TodoTaskFile
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