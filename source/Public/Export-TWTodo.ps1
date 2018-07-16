function Export-TWTodo
{
    <#
    .SYNOPSIS
        Imports todos from the todo file.
    .DESCRIPTION
        Imports the todos from the todo file and then adds a line number to the todo object.
    .OUTPUTS
        System.ArrayList
    .EXAMPLE
        Export-TWTodo c:\todo.txt

        Read and outputs the todos from c:\todo.txt
    .NOTES
        Author:  Paul Broadwith (https://pauby.com)
        Project: PSTodoWarrior (https://github.com/pauby/pstodowarrior)
        History: 1.0 - 16/07/18 - Initial
    .LINK
        https://www.github.com/pauby/pstodowarrior/tree/master/docs/import-twtodo.md
    #>
    [OutputType([System.Collections.ArrayList])]
    [CmdletBinding()]
    Param ()

    Write-Verbose "Exporting todos."

    # first we need to strip off all of the TodoWarrior bits and export it using
    # the Export-TodoTxt function
    $script:TwTodo | Select-Object -ExcludeProperty Line |
        Export-TodoTxt -Path $global:TWSettings.TodoTaskPath
}