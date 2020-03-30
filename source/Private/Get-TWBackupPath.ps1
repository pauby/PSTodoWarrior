<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-TWBackupPath {
    [CmdletBinding()]
    param()

    # get the config
    $config = Get-TWConfiguration

    # determine if there is a configuration for backing up the todo file before
    # we modify it - if not, still back it up and remove it when we are finished
    $backupFilename = "{0}-{1}-{2}" -f (Get-TodoTxtTodaysDate), (Get-Date -Format "HHmmss"), (Split-Path -Path $config.TodoTaskPath -Leaf)
    if ($config.BackupFolder) {
        # so the user has provided us with a backup folder to use
        $backupRoot = (Split-Path -Path $config.TodoTaskPath -parent)
        $backupPath = Join-Path -Path $backupRoot -ChildPath $config.BackupFolder
    }
    else {
        # we have no defined backup path but we still need to backup the file before modifying it - use the todo task path
        $backupPath = Split-Path -Path $config.TodoTaskPath -Parent
    }

    Join-Path -Path $backupPath -ChildPath $backupFilename
}