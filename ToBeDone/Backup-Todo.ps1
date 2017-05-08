<# .SYNOPSIS    Creates a backup copy of the file.
.DESCRIPTION
    Creates a backup copy of the file in the backup folder and modifies the filename to include the date and time of the backup.
.NOTES 
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 25/09/15 - Initial version
.LINK 
    http://www.github.com/pauby.PARAMETER Path    Path of the file to backup.
.PARAMETER BackupPath    The path to the backup folder.
.PARAMETER DaysToKeep
    The number of days to keep backups for. Any files older than this will be removed.
.OUTPUTS
    Nothing..EXAMPLE    Backup-Todo -Path c:\todo.txt -BackupPath c:\todo-backups -DaysToKeep 7

    Backup up the file c:\todo.txt using the backup path of c:\todo-backups as the backup location and keep only 7 days worth of backups.
#>

function Backup-Todo
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateScript( { Test-Path $_ } )]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$BackupPath,

        [Parameter(Mandatory)]
        [ValidateRange(1, 999)]
        [int]$DaysToKeep,

        [switch]$Force
    )

    Write-Verbose "Checking that backup path $BackupPath exists."
    if (-not (Test-Path -Path $BackupPath))
    {
        Write-Verbose "Backup path $BackupPath does nto exist. Creating it."
        $error.clear()
        New-Item -Path $BackupPath -ItemType Directory -Force -Verbose:$VerbosePreference
        if (!$?)
        {
            Write-Verbose "Cannot create backup path $BackupPath`nExiting"
            Exit
        }

        Write-Verbose "Backup path $BackupPath created."
    }


    Write-Verbose "Backing up the current todo file $Path to $BackupPath"
    $backupFilename = (Get-Date -Format "yyyyMMdd_HHmmss_") + (Split-Path -Path $Path -Leaf)
    $backupPathname = Join-Path -Path $BackupPath -ChildPath $backupFilename
    $error.Clear()
    Write-Verbose "Copying file $Path to $backupPathname"
    Copy-Item -Path $Path -Destination $backupPathname -Force -Verbose:$VerbosePreference
    if (!$?)
    {
        Write-Verbose "Cannot create a backup of todo file $Path to $backupPathname`nExiting."
        Exit
    }

    # check all other todo files and rmove those older than DaysToKeep
}