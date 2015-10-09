    <#     .SYNOPSIS        Displays a visual representation of a calendar.
    .DESCRIPTION        Displays a visual representation of a calendar. This function supports multiple months        and lets you highlight specific date ranges or days.
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
    .PARAMETER Start        The first month to display.
    .PARAMETER HighlightDay        Specific days (numbered) to highlight. Used for date ranges like (25..31).        Date ranges are specified by the Windows PowerShell range syntax. These dates are        enclosed in square brackets.
	.INPUTS
		Documentary text, eg: 
		Input type  [Universal.SolarSystem.Planetary.CommonSense] 
		Appears in -full 
	.OUTPUTS
		Documentary Text, eg: 
		Output type  [Universal.SolarSystem.Planetary.Wisdom] 
		Appears in -full 
    .EXAMPLE        Show-Calendar
		
		Show a default display of this month.
    .EXAMPLE        Show-Calendar -Start "March, 2010" -End "May, 2010"

		Display a date range
#>

function Remove-Todo
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateRange(1,65535)]
        [int[]]$LineNums,

        [ValidateNotNullOrEmpty()]
        [string]$Path = $poshTodoConfig['todoTaskFile'],

        [hashtable]$Config = $poshTodoConfig,

        [switch]$Force
    )

    Write-Verbose "Importing all todos from $Path"
    $sourceTodos = Import-Todo -Path $Path
    if ($sourceTodos -eq $null)
    {
        Write-Verbose "Could not read todos from $Path or there were no todos to read."
        Exit
    }

    Write-Verbose "Read $($sourceTodos.Count) todos."
    if ($sourceTodos.Count -gt 0)
    {
        Write-Verbose "Creating a new todo list skipping over the one to be removed."
        $destTodos = @($sourceTodos | where-object { $LineNums -notcontains $_.Line })
        Write-Verbose "New todo list is now $($destTodos.Count) lines long (original list was $($sourceTodos.Count) lines long)."
        Export-Todo -TodoObject $destTodos -Path $Path -Force:$($Force.IsPresent) -BackupPath $Config['BackupPath'] -DaysToKeep $Config['BackupDaysToKeep'] -Verbose:$VerbosePreference
    }
    else
    {
        Write-Verbose "0 todos read so nothing to remove!"
    }
}