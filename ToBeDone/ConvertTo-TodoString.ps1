<# .SYNOPSIS    Converts a todo object into a todo string.
.DESCRIPTION    Converts a todo object into a todo string.
.NOTES 
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 23/09/15 - Initial version
.LINK 
    http://www.github.com/pauby
.PARAMETER DoneDate
    The completion date of the todo.
.PARAMETER CreatedDate
    Created date for the todo. If this is omitted the current date will be used.
.PARAMETER Priority
    Priority of the todo.
.PARAMETER Task
    The task text of the todo.
.PARAMETER Context
    The context of the task.
.PARAMETER Project
    The project the todo belongs to.
.PARAMETER DueDate
    The due date of the todo.
.PARAMETER Addon
    The addon text for the todo.
.INPUTS
    Input type [PSObject]
.OUTPUTS
    Output type [string].EXAMPLE    $todoObject | ConvertTo-TodoString

    Converts the object to a todo string.
.EXAMPLE    ConvertTo-TodoString -Task 'Take car to the garage' -Context 'car' -Project 'car_maintenance'
    Creates a todo string from the parameters.
#>

function ConvertTo-TodoString
{
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$DoneDate,
    
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$CreatedDate = (Get-Date -Format "yyyy-MM-dd"),

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$Priority,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Task,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string[]]$Context,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string[]]$Project,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$DueDate,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string[]]$Addon    
    )

    Begin 
    { 
        $format = "{0}{1}{2} {3}{4}{5}{6}{7}"
    }

    Process
    {
        $format -f
            $( if ($DoneDate -ne "") { "x $DoneDate " } ), 
            $( if ($Priority -ne "") { "($Priority) " } ),
            $CreatedDate,
            $Task,
            $( if ($Context -ne "") { " @$($Context -join " @")" } ),
            $( if ($Project -ne "") { " +$($Project -join " +")" } ),
            $( if ($DueDate -ne "") { " due:$DueDate" } ),
            $( if ($Addon -ne "") { " $($Addon -join " ")" } )
    }

    End { }
}         