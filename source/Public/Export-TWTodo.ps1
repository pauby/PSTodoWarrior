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
    Param (
        [System.Collections.ArrayList]
        $Todo
    )

    # get the config
    $config = Get-TWConfiguration

    Write-Verbose "Exporting todos."

    # check if we have completed todos and autoarchiving is enabled
    $toBeExported = $Todo      # by default ALL todos are exported to the task file
    if ($config.AutoArchive -eq $true -and $config.TodoDonePath) {
        Write-Verbose "Autoarchiving of completed todo(s) is enabled."
        $completed = $Todo | Where-Object { [string]::IsNullOrEmpty($_.DoneDate) -eq $false }
        Write-Verbose "Found $(@($completed).count) completed todo(s)."

        # if we have todos that have a completed value then export them to the done file
        if ($completed) {
            Write-Verbose "Exporting $(@($completed).count) completed todo(s) to '$($config.TodoDonePath)'."
            $completed | Export-TodoTxt -Path $config.TodoDonePath -Append
        }

        # remove the completed todos from our current list
        $toBeExported = $Todo | Where-Object { [string]::IsNullOrEmpty($_.DoneDate) -eq $true }
    }

    # we dont' need to striup off any of the TodoWarrior extra fields as they
    # will simply be ignored when exporting
    Write-Verbose "Exporting $(@($toBeExported).count) todo(s) to '$($config.TodoTaskPath)'."
    $toBeExported | Export-TodoTxt -Path $config.TodoTaskPath
}