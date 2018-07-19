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

    # check if we have completed todos and autoarchiving is enabled
    $toBeExported = $script:TWTodo      # by default ALL todos are exported to the task file
    if ($global:TWSettings.AutoArchive -eq $true -and $global:TWSettings.TodoDonePath) {
        Write-Verbose "Autoarchiving of completed todo(s) is enabled."
        $completed = $script:TWTodo | Where-Object { [string]::IsNullOrEmpty($_.DoneDate) -eq $false }
        Write-Verbose "Found $(@($completed).count) completed todo(s)."
        if ($completed) {
            Write-Verbose "Exporting $(@($completed).count) completed todo(s) to '$($global:TWSettings.TodoDonePath)'."
            $completed | Export-TodoTxt -Path $global:TWSettings.TodoDonePath -Append
        }

        # remove the completed todos from our current list
        $toBeExported = $script:TWTodo | Where-Object { [string]::IsNullOrEmpty($_.DoneDate) -eq $true }
    }

    # we dont' need to striup off any of the TodoWarrior extra fields as they
    # will simply be ignored when exporting
    $toBeExported | Export-TodoTxt -Path $global:TWSettings.TodoTaskPath
}