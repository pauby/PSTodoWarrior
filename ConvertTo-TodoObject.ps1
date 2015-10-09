<# 
.SYNOPSIS
    Converts a todo string to a todo object
.DESCRIPTION
    Converts a todo string to a todo object.
.NOTES 
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 22/09/15 - Initial version
.LINK 
    http://www.github.com/pauby
.PARAMETER RawTodo
    This is the raw todo text - ie. 'take car to garage @car +car_maintenance'
.INPUTS
	Input type [String]
.OUTPUTS
	Output type [PSObject]
.EXAMPLE
    ConvertTo-TodoObject -RawTodo 'take car to garage @car +car_maintenance'
		
	Converts the RawTodo into a todo object.
.EXAMPLE
    $todo = 'take car to garage @car +car_maintenance'
    $todo | ConvertTo-Todoobject

	Converts $todo into a todo object.
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
        $config = Get-TodoConfig

        Write-Verbose "Converting raw todos to objects."
        $currentDate = Get-Date

        # create regex to extra the first poart of the todo
            # $linePattern = "^(?:x\ (?<done>\d{4}-\d{2}-\d{2})\ )?(?:\((?<prio>[A-Z])\)\ )?(?:(?<created>\d{4}-\d{2}-\d{2})?\ )?(?<task>.*)"
        $regexLine = [regex]"^(?:x\ (?<done>\d{4}-\d{2}-\d{2})\ )?(?:\((?<prio>[A-Za-z])\)\ )?(?:(?<created>\d{4}-\d{2}-\d{2})?\ )?(?<task>.*)"
        $regexContext = [regex]"(?:\s@\S+)" # this regex is also used to replace the context with <blank> so it needs to capture the '@' too or this will be left
            #"((?<=\s)(?:@\S+))+"
        $regexProject = [regex]"(?:\s\+\S+)" # this regex is also used to replace the context with <blank> so it needs to capture the '@' too or this will be left
            #"((?<=\s)(?:\+\S+))+"
        $regexDue = [regex]"(?:due:\d{4}-\d{2}-\d{2})"
            #"(?i)due:(?<due>[0-9]+-[0-9]+-[0-9]+)"
        $regexAddon = [regex]"(?<=\s)(?:\S+\:(?!//)\S+)"
            #"(?:\s\S+\:(?!//)\S+)"
        $lineNum = 0
    }

    Process
    { 
        Write-Verbose "--- Start of $_"
        $parsedLine = $regexLine.Match($_).Groups

        $todo = @{}
        $lineNum++
        $todo['Line']        = $lineNum
        $todo['Canonical']   = $_
        $todo['DoneDate']    = $parsedLine['done'].Value
        $todo['CreatedDate'] = $parsedLine['created'].Value    
        $todo['Priority']    = $parsedLine['prio'].Value.ToUpper()
        $todo['Task']        = $parsedLine['task'].Value
        
        Write-Verbose "Looking for context / lists in the todo text."
        if ($regexContext.IsMatch($todo['Task']))
        {
            $todo['Context'] = @($regexContext.Matches($todo['Task']) | sort value | Get-Unique | % { $_.ToString().Trim() } | % { $_.Substring(1) } )
            Write-Verbose "Found $($todo['Context'].Count) context / lists: $($todo['Context'] -join ',')"
            Write-verbose "Removing the context from the todo task."
            $todo['Task'] = $regexContext.Replace($todo['Task'], "")
        }
       
        Write-Verbose "Looking for projects / tags in the todo."        
        if ($regexProject.IsMatch($todo['Task']))
        {
            $todo['Project'] = @($regexProject.Matches($todo['Task']) | Sort value | Get-Unique | % { $_.ToString().Trim() } | % { $_.Substring(1) } )
            Write-Verbose "Found $($todo['Project'].Count) projects / tags: $($todo['Project'] -join ',')"
            Write-Verbose 'Removing the project from the todo task.'
            $todo['Task'] = $regexProject.Replace($todo['Task'], "")
        }

        Write-Verbose "Looking for due date."
        if ($regexDue.IsMatch($todo['Task']))
        {
            $todo['DueDate'] = ([string]$regexDue.Matches($todo['Task'])).Substring(4) # extracting the date part (4 chars onwards) - due:2011-01-01
            Write-Verbose "Found due date: $($todo['DueDate'])"
            $todo['DueIn'] = ((Get-Date $todo['DueDate']) - $currentDate).Days
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

        Write-Verbose "Tidying up the todo task."
        $todo['Task'] = $todo['Task'].Trim()

        Write-Debug ($todo | Out-String)

        Write-Verbose "--- End"

        Write-Verbose "Creating new TodoObject."
        $todoObj = New-TodoObject -Property $todo

        # keep this calculation until after the object has been created as the object sets a valid CreatedDate
        Write-Verbose "Calculating the todo age from CreatedDate $($todoObj.CreatedDate)."
        $todoObj.Age = ((($currentDate) - (Get-Date $todoObj.CreatedDate)).Days)    

        # This calculation should be done after the object has been created and all other object changes made
        Write-Verbose "Measuring the todo's weight."
        $todoObj.Weight = Measure-TodoWeight -Todo $todoObj -Verbose:$VerbosePreference
        Write-Verbose "Todo weight is $($todoObj.Weight)"

        $todoObj
    }

    End {}
}