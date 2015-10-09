<# 
.SYNOPSIS
    Displays a visual representation of a calendar.
.DESCRIPTION
    Displays a visual representation of a calendar. This function supports multiple months
    and lets you highlight specific date ranges or days.
.NOTES 
    Additional Notes, eg 
    File Name	: Untitled1.ps1  
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 11/09/15 - Initial version
    Appears in -full  
.PARAMETER Start
    The first month to display.
.PARAMETER HighlightDay
    Specific days (numbered) to highlight. Used for date ranges like (25..31).
    Date ranges are specified by the Windows PowerShell range syntax. These dates are
    enclosed in square brackets.
.EXAMPLE
    # Show a default display of this month.
    Show-Calendar
.EXAMPLE
    # Display a date range.
    Show-Calendar -Start "March, 2010" -End "May, 2010"
#>

function Get-TodoConfig
{
    $poshTodoConfig
}