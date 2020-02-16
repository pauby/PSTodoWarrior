function Export-TWTodo
{
    <#
    .SYNOPSIS
        Exports todos.
    .DESCRIPTION
        Exports the todos to the todo list file and optionally the todo done
        file. Todos are exported to the done file is the AutoArchive
        configuration setting is defined.

        The todo list is backed up before any modifications are made to it. If
        BackupPath has been set in the configuration the backups will be made to
        that path and kept afterwards. IOf the BackupPath has not been defined
        then a backup will still ba made but it will be removed if the export
        was successful.
    .EXAMPLE
        Export-TWTodo -Todo $myTodo

        Exports the todos in $myTodo to the todo and (optionally) the done files.
    .NOTES
        Author:  Paul Broadwith (https://pauby.com)
        Project: PSTodoWarrior (https://github.com/pauby/pstodowarrior)
    .LINK
        https://www.github.com/pauby/pstodowarrior/tree/master/docs/import-twtodo.md
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [AllowEmptyCollection()]
        [System.Collections.ArrayList]
        $Todo
    )

    # get the config
    $config = Get-TWConfiguration

    # check there is a todo file before we try and back it up!
    $todoFileExisted = $false
    if (Test-Path -Path $config.TodoTaskPath) {
        $todoFileExisted = $true

        # determine if there is a configuration for backing up the todo file before
        # we modify it - if not, still back it up and remove it when we are finished
        $backupFilename = "{0}-{1}" -f (Get-Date -Format "yyyymmdd-HHMMss"), (Split-Path -Path $config.TodoTaskPath -Leaf)
        if ($config.BackupPath) {
            # before we do anything check that the path for the backups exists
            if (-not (Test-Path -Path $config.BackupPath)) {
                # path does not exist so lets try and create it
                try {
                    Write-Verbose "The 'BackupPath' given in the configuration does not exist. Trying to create '$($config.BackupPath)'."
                    New-Item -Path $config.BackupPath -ItemType Directory -Force -ErrorAction Stop
                }
                catch {
                    throw "Path '$($config.BackupPath)' does not exist. Tried to create it but failed."
                }
            }

            $backupPath = Join-Path -Path $config.BackupPath -ChildPath $backupFilename
        }
        else {
            # we have no defined backup path but we still need to backup the file before modifying it - use the todo task path
            $todoTaskPathParent = Split-Path -Path $config.TodoTaskPath -Parent
            $backupPath = Join-Path -Path $todoTaskPathParent -ChildPath $backupFilename
        }

        # make a copy of the todo file
        try {
            Write-Verbose "Trying to make a copy of the todo file '$($config.TodoTaskPath)' to '$backupPath'."
            Copy-Item -Path $config.TodoTaskPath -Destination $backupPath
        }
        catch {
            throw "Before modifying the todo file '$($config.TodoTaskPath)' I tried to make a copy to '$backupPath' but I failed."
        }
    }

    Write-Verbose "Going to export todos."

    try {
        # check if we have completed todos and autoarchiving is enabled
        $toBeExported = $Todo      # by default ALL todos are exported to the task file
        if ($config.AutoArchive -eq $true -and $config.TodoDonePath) {
            Write-Verbose "Autoarchiving of completed todo(s) is enabled."
            $completed = $Todo | Where-Object { [string]::IsNullOrEmpty($_.DoneDate) -eq $false }
            Write-Verbose "Found $(@($completed).count) completed todo(s)."

            # if we have todos that have a completed value then export them to the done file
            if ($completed) {
                Write-Verbose "Exporting $(@($completed).count) completed todo(s) to '$($config.TodoDonePath)'."
                $completed | Export-TodoTxt -Path $config.TodoDonePath -Append -ErrorAction Stop
            }

            # remove the completed todos from our current list
            $toBeExported = $Todo | Where-Object { [string]::IsNullOrEmpty($_.DoneDate) -eq $true }
        }

        # we don't need to strip off any of the TodoWarrior extra fields as they
        # will simply be ignored when exporting
        if ($toBeExported.Count -eq 0) {
            Write-Verbose "No todos to export - emptying files '$($config.TodoTaskPath)'."
            Set-Content -Path $config.TodoTaskPath -Value ''
        }
        else {
            Write-Verbose "Exporting $(@($toBeExported).count) todo(s) to '$($config.TodoTaskPath)'."
            $toBeExported | Export-TodoTxt -Path $config.TodoTaskPath -ErrorAction Stop
        }
    }
    catch {
        # if something has gone wrong lets throw, warn the user and let them fix whatever it was
        throw "There was an error exporting to the todo file '$($config.TodoTaskPath)'. A backup was made beforehand and it is at '$backupPath' which you can use if the todo file is in an inconsistent state. (Error: $Error["
    }

    # if we don't have a backup folder specified AND if the todo file actually existed then remove the temporary file
    # we created before modifying the original todo file
    if (-not $config.BackupPath -and $todoFileExisted) {
        Write-Verbose "Everything went okay with the export so removing the todo backup file '$backupPath'."
        try {
            Remove-Item -Path $backupPath
        }
        catch {
            # lets not make this a terminating error. Just warn the user and move on.
            Write-Warning "I tried to remove the backup todo file at '$backupPath' but failed. It is still there and needs to be removed manually."
        }
    }
}