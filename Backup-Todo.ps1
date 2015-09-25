<# .SYNOPSIS    Displays a visual representation of a calendar.
.DESCRIPTION    Displays a visual representation of a calendar. This function supports multiple months    and lets you highlight specific date ranges or days.
.NOTES 
    Additional Notes, eg 
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 25/09/15 - Initial version
    Appears in -full
.LINK 
    A hyper link, eg 
    http://www.pshscripts.blogspot.com 
    Becomes: "RELATED LINKS"  
    Appears in basic and -Full 
.PARAMETER Start    The first month to display.
.PARAMETER HighlightDay    Specific days (numbered) to highlight. Used for date ranges like (25..31).    Date ranges are specified by the Windows PowerShell range syntax. These dates are    enclosed in square brackets.
.INPUTS
	Documentary text, eg: 
	Input type  [Universal.SolarSystem.Planetary.CommonSense] 
	Appears in -full 
.OUTPUTS
	Documentary Text, eg: 
	Output type  [Universal.SolarSystem.Planetary.Wisdom] 
	Appears in -full 
.EXAMPLE    Show-Calendar
		
	Show a default display of this month.
.EXAMPLE    Show-Calendar -Start "March, 2010" -End "May, 2010"

	Display a date range
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