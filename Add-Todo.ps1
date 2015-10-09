<#
.SYNOPSIS
	Adds a todo.
.DESCRIPTION
	Adds a todo.
.NOTES
	Function 	: Add-Todo
	Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 20/09/15 - Initial version
.LINK
	https://github.com/pauby/
.PARAMETER Todo
	 String to add as a todo. This string contains all components of the todo.
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
    The addon text for the tofo.
.OUTPUTS
	Nothing
.EXAMPLE
    Add-Todo -Todo 'Take the car to the garage @car +car_maintenance due:2015-12-22'

    Creates a todo with the text 'Take the car to the garage' in the project car_maintenance and with context of car and due date of 22 December 2015
.EXAMPLE
    Add-Todo -Priority B -Task 'Take the car to the garage' -Context car -Project car_maintenance -Due 2015-12-22

    Creates a todo with the text 'Take the car to the garage' in the project car_maintenance and with context of car and due date of 22 December 2015
#>


function Add-Todo
{
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromRemainingArguments=$true, ParameterSetName="Object")]
		[ValidateNotNullOrEmpty()]
        [Alias("to", "td")]
        [string]$Todo,

        [Parameter(ParameterSetName="SeparateParams")]
        [Alias("cd")]
        [string]$CreatedDate = (Get-Date -Format "yyyy-MM-dd"),

        [Parameter(ParameterSetName="SeparateParams")]
        [Alias("pri", "u")]
        [string]$Priority,

        [Parameter(Mandatory, ParameterSetName="SeparateParams")]
        [ValidateNotNullOrEmpty()]
        [Alias("t")]
        [string]$Task,

        [Parameter(ParameterSetName="SeparateParams")]
        [Alias("c")]
        [string[]]$Context,

        [Parameter(ParameterSetName="SeparateParams")]
        [Alias("p")]
        [string[]]$Project,

        [Parameter(ParameterSetName="SeparateParams")]
        [Alias("dd")]
        [string]$DueDate,

        [Parameter(ParameterSetName="SeparateParams")]
        [Alias("a")]
        [string[]]$Addon
    )

    $config = Get-TodoConfig

    Write-Verbose "Checking if we are working with separate parameters or a todo."
    if ($Todo)
    {
        Write-Verbose "We are working with a todo."
        $workingTodo = $Todo 
    }
    else
    {
        # get a working todo text string 
        Write-Verbose "Working with separate parameters."
        $workingTodo = ConvertTo-TodoString -CreatedDate $CreatedDate -Priority $Priority -Task $Task -Context $Context -Project $Project -DueDate $DueDate -Addon $Addon
    }
        
    Write-Verbose "Creating todo object."
    $todoObj = $workingTodo | ConvertTo-TodoObject

    Write-Verbose "Exporting new todo to the todo file at $($config['todoTaskFile'])"
    Export-Todo -TodoObject $todoObj -Path $config['todoTaskFile'] -BackupPath $config['BackupPath'] -DaysToKeep $config['BackupDaysToKeep'] -Append

    Write-Verbose "New todo added to $($config['todoTaskFile'])"
}