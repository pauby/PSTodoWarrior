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
        [ValidateNotNullOrEmpty()]
        [object[]]$TodoObject,

        [Parameter(Mandatory, ParameterSetName="Strings")]
        [string[]]$TodoString,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [switch]$Append
    )

    if (-not $Append)
    {
        Write-Verbose "Deleting todo file $Path"
        Remove-Item -Path $Path -Force
        Write-Verbose "File $Path deleted."
    }

    Write-Verbose "Appending todo to the todo file at $Path"

    $toBeWritten = @()
    if ($TodoObject)
    {
        Write-Verbose "We have todo objects to export."

        foreach ($todo in $TodoObject)
        {
            Write-Verbose "Converting todo object to a string so we can write it to the todo file."
            $toBeWritten += ConvertTo-TodoString $todo
        }
    }
    else
    {
        Write-Verbose "We have todo strings to export."
        $toBeWritten = $TodoString
    }

    try
    {
        $toBeWritten | Add-Content -Path $Path -Encoding UTF8 -Force -ErrorAction SilentlyContinue
    }
    catch
    {
        Write-Warning "Could not write new todo to the todo file at $Path."
        Exit
    }
}

