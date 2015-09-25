<# .SYNOPSIS    Displays a visual representation of a calendar.
.DESCRIPTION    Displays a visual representation of a calendar. This function supports multiple months    and lets you highlight specific date ranges or days.
.NOTES 
    Additional Notes, eg 
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 24/09/15 - Initial version
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

function Export-Todo
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName="Objects")]
        [AllowEmptyCollection()]
        [object[]]$TodoObject,

        [Parameter(Mandatory, ParameterSetName="Strings")]
        [AllowEmptyCollection()]
        [string[]]$TodoString,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$BackupPath,

        [Parameter(Mandatory)]
        [int]$DaysToKeep,

        [switch]$Force, #forces overwriting readonly files

        [switch]$Append
    )

    Write-Verbose "Taking a backup of the todo file before we export."
    Backup-Todo -Path $Path -BackupPath $BackupPath -DaysToKeep $DaysToKeep -Force:$($Force.IsPresent)

    if (-not $Append)
    {
        Write-Verbose "Exporting all todos to the todo file at $Path so need to clear it first."
        Clear-Content -Path $Path -Force:$($Force.IsPresent) -ErrorAction SilentlyContinue
        if ($?)
        {
            Write-Verbose "File $Path cleared."
        }
        else
        {
            Write-Warning "Could not clear contents of todo file $Path prior to writing new todos.`nExiting."
            Exit
        }
    }
    else
    {
        Write-Verbose "Appending todo(s) to the todo file at $Path"
    }

    $toBeWritten = @() # will hold the todos to be written after converting the objects to string or from the strings passed
    if ($TodoObject)
    {
        if (($TodoObject -ne $null) -and ($TodoObject.Count -gt 0))
        {
            Write-Verbose "We have $($TodoObject.Count) todo objects to export."
            foreach ($todo in $TodoObject)
            {
                Write-Verbose "Converting todo object to a string so we can write it to the todo file."
                $toBeWritten += ConvertTo-TodoString $todo
            }
        }
        else
        {
            Write-Verbose "We have 0 todo objects to export."
        }
    }
    else
    {
        if (($TodoString -ne $null) -and ($TodoString.Count -gt 0))
        {
            Write-Verbose "We have $($TodoString.Count) todo strings to export."
            $toBeWritten = @($TodoString)
        }
        else
        {
            Write-Verbose "We have 0 todo strings to export."
        }
    }

    if ($toBeWritten.Count -gt 0)
    {

        Write-Verbose "Writing the todos to the todo file at $Path"
        $toBeWritten | Add-Content -Path $Path -Encoding UTF8 -Force:$($Force.IsPresent) -ErrorAction SilentlyContinue
        if ($?)
        {
            Write-Verbose "Todos written"
        }
        else
        {
            Write-Warning "Could not write todo(s) to the todo file at $Path."
            Exit
        }
    }
    else
    {
        Write-Verbose "No todos to be written."
    }
}

