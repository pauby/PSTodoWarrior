    <# 
    .SYNOPSIS
        Displays a visual representation of a calendar.
    .DESCRIPTION
        Displays a visual representation of a calendar. This function supports multiple months
        and lets you highlight specific date ranges or days.
    .NOTES 
        Additional Notes, eg 
        Author		: Paul Broadwith (paul@pauby.com)
	    History		: 1.0 - 22/09/15 - Initial version
        Appears in -full
    .LINK 
        A hyper link, eg 
        http://www.pshscripts.blogspot.com 
        Becomes: "RELATED LINKS"  
        Appears in basic and -Full 
    .PARAMETER Start
        The first month to display.
    .PARAMETER HighlightDay
        Specific days (numbered) to highlight. Used for date ranges like (25..31).
        Date ranges are specified by the Windows PowerShell range syntax. These dates are
        enclosed in square brackets.
	.INPUTS
		Documentary text, eg: 
		Input type  [Universal.SolarSystem.Planetary.CommonSense] 
		Appears in -full 
	.OUTPUTS
		Documentary Text, eg: 
		Output type  [Universal.SolarSystem.Planetary.Wisdom] 
		Appears in -full 
    .EXAMPLE
        Show-Calendar
		
		Show a default display of this month.
    .EXAMPLE
        Show-Calendar -Start "March, 2010" -End "May, 2010"

		Display a date range
#>

function ConvertTo-TodoObject
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ValueFromPipeline=$true)]
        [string[]]$RawTodo
    )

    Begin
    {
        Write-Verbose "Converting raw todos to objects."
        $currentDate = Get-Date

        # create regex to extra the first poart of the todo
        $opt = [System.Text.Regularexpressions.RegexOptions]
        $linePattern = "^(?:x\ (?<done>\d{4}-\d{2}-\d{2})\ )?(?:\((?<prio>[A-Z])\)\ )?(?:(?<created>\d{4}-\d{2}-\d{2})?\ )?(?<task>.*)"
#       $

<#@"
        ^(?:x\ (?<done>\d{4}-\d{2}-\d{2})\ )?  # Done date
        (?:\((?<prio>[A-Z])\)\ )?             # Priority
        (?:(?<created>\d{4}-\d{2}-\d{2})?\ )? # Created date
        (?<task>.*)
        $
"@#>
#        $todoPattern = New-Object System.Text.Regularexpressions.Regex($linePattern, $opt::IgnorePatternWhitespace)
        $regexLine = [regex]"^(?:x\ (?<done>\d{4}-\d{2}-\d{2})\ )?(?:\((?<prio>[A-Z])\)\ )?(?:(?<created>\d{4}-\d{2}-\d{2})?\ )?(?<task>.*)"
        $regexContext = [regex]"((?<=\s)(?:@\S+))+"
        $regexProject = [regex]"((?<=\s)(?:\+\S+))+"
        $regexDue = [regex]"(?:due:\d{4}-\d{2}-\d{2})"
#"(?i)due:(?<due>[0-9]+-[0-9]+-[0-9]+)"
        $regexAddon = [regex]"(?<=\s)(?:\S+\:(?!//)\S+)"
        #"(?:\s\S+\:(?!//)\S+)"
        $lineNum = 0
    }

    Process
    { 
        Write-Verbose "--- Start of $_"
#        $parsedLine = $todoPattern.Match($_).Groups
        $parsedLine = $regexLine.Match($_).Groups

        $todo = @{}
        $lineNum++
        $todo['Line']        = $lineNum
        $todo['Canonical']   = $_
        $todo['DoneDate']    = $parsedLine['done'].Value
        $todo['CreatedDate'] = $parsedLine['created'].Value    
        $todo['Priority']    = $parsedLine['prio'].Value.ToUpper()
        $todo['Task']        = $parsedLine['task'].Value    
        $todo['Age']         = ((($currentDate) - (Get-Date $todo['CreatedDate'])).Days)    

        Write-Verbose "Looking for context / lists in the todo text."
        if ($regexContext.IsMatch($todo['Task']))
        {
            $todo['Context'] = @($regexContext.Matches($todo['Task']) | sort value | Get-Unique)
            Write-Verbose "Found $($todo['Context'].Count) context / lists: $($todo['Context'] -join ',')"
            Write-verbose "Removing the context from the todo task."
            $todo['Task'] = $regexContext.Replace($todo['Task'], "")
        }
       
        Write-Verbose "Looking for projects / tags in the todo."        
        if ($regexProject.IsMatch($todo['Task']))
        {
            $todo['Project'] = @($regexProject.Matches($todo['Task']) | Sort value | Get-Unique)
            Write-Verbose "Found $($todo['Project'].Count) projects / tags: $($todo['Project'] -join ',')"
            Write-Verbose 'Removing the project from the todo task.'
            $todo['Task'] = $regexProject.Replace($todo['Task'], "")
        }

        Write-Verbose "Looking for due date."
        if ($regexDue.IsMatch($todo['Task']))
        {
            $todo['Due'] = ([string]$regexDue.Matches($todo['Task'])).Substring(4) # extracting the date part (4 chars onwards) - due:2011-01-01
            Write-Verbose "Found due date: $($todo['Due'])"
            $todo['DueIn'] = ((($currentDate) - (Get-Date $todo['Due'])).Days) 
            Write-Verbose "Calculated time todo is DueIn: $($todo['DueIn'])"
            Write-Verbose 'Removing the due date from the todo task.'
            $todo['Task'] = $regexDue.Replace($todo['Task'], "")
        }
        else
        {
            Write-Verbose "Due date not found."
        }

        # find the key:value pairs EXCEPT when there is a // after the : (for example http:// https:// ftp:// etc. 
        # each of these get their own object member
        Write-Verbose "Looking for addon key:value pairs."
        if ($regexAddon.IsMatch($todo['Task']))
        {
            $todo['Addon'] = $regexAddon.Matches($todo['Task'])
            Write-Verbose "Found $($todo['Addon'].Count) key:value pairs: $($todo['Addon'] -join ',')"
            Write-Verbose 'Removing addons from the todo task.'
            $todo['Task'] = $regexAddon.Replace($todo['Task'], "")
        }

        Write-Debug ($todo | Out-String)

        Write-Verbose "--- End"

        New-TodoObject -Property $todo
    }

    End {}
}
            