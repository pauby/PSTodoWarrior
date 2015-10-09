<# .SYNOPSIS    Displays a visual representation of a calendar.
.DESCRIPTION    Displays a visual representation of a calendar. This function supports multiple months    and lets you highlight specific date ranges or days.
.NOTES 
    Additional Notes, eg 
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 23/09/15 - Initial version
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

function ConvertTo-TodoString
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [object]$TodoObj
    )

    "{0}{1}{2} {3}{4}{5}{6}{7}" -f
        $( if ($TodoObj.DoneDate -ne "") { "x $($TodoObj.DoneDate) " } ), 
        $( if ($TodoObj.Priority -ne "") { "$($TodoObj.Priority) " } ),
        $TodoObj.CreatedDate,
        $TodoObj.Task,
        $( if ($TodoObj.Context -ne "") { " $($TodoObj.Context -join " ")" } ),
        $( if ($TodoObj.Project -ne "") { " $($TodoObj.Project -join " ")" } ),
        $( if ($TodoObj.DueDate -ne "") { " due:$($TodoObj.DueDate)" } ),
        $( if ($TodoObj.Addon -ne "") { " $($TodoObj.Addon -join " ")" } )
}
         