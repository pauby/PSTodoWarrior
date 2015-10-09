<# 
.SYNOPSIS
    Used to manipulate todos.
.DESCRIPTION
    Provides access to commands to manipulate todos. Acts as a frontend for other todo functions.
.NOTES 
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 28/09/15 - Initial version
.LINK 
    http://www.github.com/pauby/poshtodo
.PARAMETER Command
    This is the command to process and can be:
        List    - displays the todos;
        Add     - adds a new todo;
        Remove  - removes a todo;
        Modify  - modifies an existing todo;
        Done    - completes a todo and marks it done;
        Archive - archives completed todos;
.PARAMETER Line
    Line number of the todo to act on.
.PARAMETER CreatedDate
    Todo creation date to be used.
.PARAMETER Priority
    Todo priority to be used.
.PARAMETER Task
    Todo task text to be used.
.PARAMETER Context
    Todo context or list to be used.
.PARAMETER Project
    Todo project or tag to be used.
.PARAMETER DueDate
    Todo due date to be used.
.PARAMETER Addon
    The addons that are to be used for the todo.
.PARAMETER Report
    The report to be used when displaying the todos. 
.EXAMPLE
    Use-Todo -command add -priority A -task 'Take car to the garage' -project 'care-maintenance' -context 'car'
		
	Adds a new todo.
.EXAMPLE
    Use-Todo remove 15

    Removes the todo at line 15.
#>

function Use-Todo
{
    [CmdletBinding()]
    Param (
        [Parameter(Position=0)]
        [ValidateSet("l", "list", "a", "add", "r", "remove", "m", "modify", "d", "done", "arch", "archive")] 
        [string]$Command = "",

        [Parameter(Position=1)]
        [Alias("l")]
        [int[]]$Line,

        [Alias("cd")]
        [string]$CreatedDate,

        [Alias("pri", "u")]
        [string]$Priority,

        [ValidateNotNullOrEmpty()]
        [Alias("t")]
        [string]$Task,

        [Alias("c", "list")]
        [string[]]$Context,

        [Alias("p", "tag")]
        [string[]]$Project,

        [Alias("dd")]
        [string]$DueDate,

        [Alias("a")]
        [string[]]$Addon,

        [Alias("r")]
        [string]$Report
    )

    $todoConfig = Get-TodoConfig

    switch -regex ($Command)
    {
        "\bli?s?t?\b|^$" 
        {
            Write-Verbose "Listing todos."
            $todos = import-todo $todoConfig.todoTaskFile -Verbose:$VerbosePreference

            if ($Report)
            {
                Write-Verbose "Looking up view '$Report'."
                if (-not $todoConfig['Reports'].ContainsKey("$Report"))
                {
                    Write-Verbose 'View not found. Using default.'
                    $Report = 'default'
                }
                else
                {
                    Write-Verbose 'View found.'
                }
            }
            else
            {
                Write-Verbose 'View not specified - using ''default''.'
                $Report = 'default'
            }

            $todos = $todos | &$todoConfig['Reports']["$Report"] -Config $todoConfig
            Format-Todo $todos
            Write-TodoInformation $todos
        }

        "\bad?d?\b"
        {
            Write-Verbose "Adding a new todo."
            if ($Task)
            {
                Write-Verbose "Creating new todo object."
                $todoObj = New-TodoObject | Set-Todo -CreatedDate $CreatedDate -Priority $Priority -Task $Task -Context $Context -Project $Project -DueDate $DueDate -Addon $Addon
                Write-Verbose "Exporting new todo to the todo file at $($todoConfig['todoTaskFile'])"
                Export-Todo -TodoObject $todoObj -Path $todoConfig['todoTaskFile'] -BackupPath $todoConfig['BackupPath'] -DaysToKeep $todoConfig['BackupDaysToKeep'] -Append -Verbose:$VerbosePreference
                Write-Host "New todo added to $($todoConfig['todoTaskFile']): $($todoObj | ConvertTo-TodoString)"                   
            }
            else
            {
                Write-Host 'No task defined. No todo created.'
            }
        }

        "\bmo?d?\b"
        {
            Write-Verbose "Modifying todos $($Line -join ", ")."
#            $todos = Import-Todo $todoConfig.todoTaskFile
            $todos = Import-Todo $todoConfig.todoTaskFile

            $modified = 0 # number of todos modified
            foreach ($todo in $todos)
            {
                if ($Line -contains $todo.Line)
                {
                    Write-Verbose "Found todo to modify: $todo"
                    $todo = $todo | Set-Todo -CreatedDate $CreatedDate -Task $Task -Context $Context -Project $Project -DueDate $DueDate -Addon $Addon
                    $modified++
                }
            }

            Write-Verbose 'Finished searching for todos to modify.'
            if ($modified -gt 0)
            {
                Write-Verbose "$modified todos modified.`nExporting todos to $($todoConfig['TodoTaskFile'])"
                Export-Todo -TodoObject $todos -Path $todoConfig['todoTaskFile'] -BackupPath $todoConfig['BackupPath'] -DaysToKeep $todoConfig['BackupDaysToKeep'] -Verbose:$VerbosePreference
            }                   

            Write-Host "$modified todos modified."
        }   

        "\bdo?n?e?\b"
        {
            Write-Verbose "Completing todos."
            $todaysDate = Get-TodoTodaysDate
            $todos = Import-Todo $todoConfig.todoTaskFile

            $modified = 0 # number of todos modified
            foreach ($todo in $todos)
            {
                if ($Line -contains $todo.Line)
                {
                    Write-Verbose "Found todo to modify: $todo"
                    $todo = $todo | Set-Todo -DoneDate $todaysDate
                    $modified++
                }
            }

            Write-Verbose 'Finished searching for todos to modify.'
            if ($modified -gt 0)
            {
                Write-Verbose "$modified todos modified.`nExporting todos to $($todoConfig['TodoTaskFile'])"
                Export-Todo -TodoObject $todos -Path $todoConfig['todoTaskFile'] -BackupPath $todoConfig['BackupPath'] -DaysToKeep $todoConfig['BackupDaysToKeep'] -Verbose:$VerbosePreference
            }                   

            Write-Host "$modified todos completed.`n"
        }

        "\bre?m?o?v?e?\b"
        {
            Write-Verbose "Removing todos."
            $todos = Import-Todo $todoConfig.todoTaskFile
            $startCount = $todos.Count   
            $todos = $todos | where-object { $Line -notcontains $_.Line }
            Export-Todo -TodoObject $todos -Path $todoConfig['todoTaskFile'] -BackupPath $todoConfig['BackupPath'] -DaysToKeep $todoConfig['BackupDaysToKeep'] -Verbose:$VerbosePreference

            Write-Host "$($startCount - $todos.Count) todos removed."
        }

        "archive"
        {
            Write-Verbose "Archiving todos."
            $todos = Import-Todo $todoConfig.todoTaskFile

            $doneTodos = @()
            $activeTodos = @()
            foreach ($todo in $todos)
            {
                if ($todo.DoneDate)
                {
                    $doneTodos += $todo
                }
                else
                {
                    $activeTodos += $todo
                }
            }

            Write-Verbose "Found $($doneTodos.Count) done todos to archive.`nWriting done todos to $($todoConfig['TodoDoneFile'])"
            Export-Todo -TodoObject $doneTodos -Path $todoConfig['todoDoneFile'] -BackupPath $todoConfig['BackupPath'] -DaysToKeep $todoConfig['BackupDaysToKeep'] -Append -Verbose:$VerbosePreference
            
            Write-Verbose "Exporting $($activeTodos.Count) active todos done todos to todo file $($todoConfig['TodoTaskFile'])"
            Export-Todo -TodoObject $activeTodos -Path $todoConfig['todoTaskFile'] -BackupPath $todoConfig['BackupPath'] -DaysToKeep $todoConfig['BackupDaysToKeep'] -Verbose:$VerbosePreference

            Write-Host "$($doneTodos.Count) done todos archived."
        }
    }
}

