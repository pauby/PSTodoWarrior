<# 
.SYNOPSIS
    Sets a todo's properties.
.DESCRIPTION
    Validates and sets a todo's properties.
.NOTES 
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 28/09/15 - Initial version
.LINK 
    https://www.github.com/pauby
.PARAMETER TodoObject
    The todo object to set the properties of.
.PARAMETER DoneDate
    The done date to set. This is only validated as a date in the corretc format and can be any date past, future or present.
.PARAMETER CreatedDate
    The created date to set. This is only validated as a date in the corretc format and can be any date past, future or present.
.PARAMETER Priority
    The priority of the todo.
.PARAMETER Task
    The tasks description of the todo.
.PARAMETER Context
    The context(s) of the todo.
.PARAMETER Project
    The project(s) of the todo.
.PARAMETER DueDate
    The due date of the todo. This is only validated as a date in the corretc format and can be any date past, future or present.
.PARAMETER Addon
    The addon key:value pairs of the todo.
.INPUTS
	Todo object of type [psobject]
.OUTPUTS
	The modified todo object or type [psobject]
.EXAMPLE
    $todoObj = $todoObj | Set-Todo -Priority "B"

    Sets the priority of the $todoObj to "B" and outputs the modified todo.
#>

function Set-Todo
{
    [CmdletBinding()]
	Param(
        [Parameter(Mandatory, Position=1, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [object[]]$TodoObject,

        [Parameter(ValueFromPipelineByProperty=$true)]
        [Alias("dd")]
        [string]$DoneDate,

        [Parameter(ValueFromPipelineByProperty=$true)]
        [Alias("cd")]
        [string]$CreatedDate,

        [Parameter(ValueFromPipelineByProperty=$true)]
        [Alias("pri", "u")]
        [string]$Priority,

        [Parameter(ValueFromPipelineByProperty=$true)]
        [Alias("t")]
        [string]$Task,

        [Parameter(ValueFromPipelineByProperty=$true)]
        [Alias("c")]
        [string[]]$Context,

        [Parameter(ValueFromPipelineByProperty=$true)]
        [Alias("p")]
        [string[]]$Project,

        [Parameter(ValueFromPipelineByProperty=$true)]
        [Alias("due")]
        [string]$DueDate,

        [Parameter(ValueFromPipelineByProperty=$true)]
        [Alias("a")]
        [string[]]$Addon
    )

    Begin 
    {
        Write-Verbose "Testing validity of values that are to be set. Skipping Task and Addon as they don't have a format to test."

        if ($DoneDate)
        {
            Write-Verbose "DoneDate is to be set. Testing it's valid."
            if (Test-TodoDate -Date $DoneDate)
            {
                Write-Verbose "DoneDate has been tested and is in the correct format."
            }
            else
            {
                Write-Verbose "DoneDate is invalid - setting it to blank to skip it."
                $DoneDate = ""
            }
        }

        if ($CreatedDate)
        {
            Write-Verbose "CreatedDate is to be set. Testing it's valid."
            if (Test-TodoDate -Date $CreatedDate)
            {
                Write-Verbose "CreatedDate has been tested and is in the correct format."
            }
            else
            {
                Write-Verbose "CreatedDate is invalid - setting it to blank to skip it."
                $CreatedDate = ""
            }
        }

        if ($Priority)
        {
            Write-Verbose "Priority is to be set. Testing it's valid."
            if (Test-TodoPriority -Priority $Priority)
            {
                Write-Verbose "Priority has been tested and is valid." 
            }
            else
            {
                Write-Verbose "Priority is invalid - setting it to blank to skip it."
                $Priority = ""
            }
        }

        if ($Context)
        {
            Write-Verbose "Context is to be set. Testing it's valid."
            if (Test-TodoContext -Context $Context)
            {
                Write-Verbose "Context(s) have been tested and are valid."
            }
            else
            {
                Write-Verbose "One or more contexts are invalid - setting them to an empty array to skip them."
                $Context = @()
            }
        }

        if ($Project)
        {
            Write-Verbose "Project is to be set. Testing it's valid."
            if (Test-TodoProject -Project $Project)
            {
                Write-Verbose "Project(s) have been testwed and they are valid."
            }
            else
            {
                Write-Verbose "One or more projects are invalid - setting them to an empty array to skip them."
                $Project = @()
            }
        }

        if ($DueDate)
        {
            Write-Verbose "DueDate is to be set. Testing it's valid."
            if (Test-TodoDate -Date $DueDate)
            {
                Write-Verbose "DueDate has been tested and is in the correct format."
            }
            else
            {
                Write-Verbose "DueDate is invalid - setting it to blank to skip it."
                $DueDate = ""
            }
        }
    }

    Process
    {
        Write-Verbose "Modifying object $_"
        if ($DoneDate)
        {
            Write-Verbose "Setting DoneDate to $DoneDate."
            $_.DoneDate = $DoneDate
        }

        if ($CreatedDate)
        {
            Write-Verbose "Setting CreatedDate to $CreatedDate."
            $_.CreatedDate = $CreatedDate
        }

        if ($Priority)
        {
            Write-Verbose "Setting Priority to $Priority."
            $_.Priority = $Priority
        }

        if ($Task)
        {
            Write-Verbose "Setting Task to $Task"
            $_.Task = $Task
        }

        if ($Context)
        {
            Write-Verbose "Setting Context to $($Context -join ", ")."
            $_.Context = $Context
        }

        if ($Project)
        {
            Write-Verbose "Setting Project to $($Project -join ", ")."
            $_.Project = $Project
        }

        if ($DueDate)
        {
            Write-Verbose "Setting DueDate to $DueDate."
            $_.DueDate = $DueDate
        }

        if ($Addon)
        {
            Write-Verbose "Setting Addon to $($Addon -join ", ")."
            $_.Addon = $Addon
        }
                
        Write-Verbose "Object modified. $_"

        $_
    }

    End { }
}