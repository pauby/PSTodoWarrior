function Use-Todo
{
<# 
.SYNOPSIS
    One overall function to work with todos.
.DESCRIPTION
    This cmdlet is a wrapper for the other cmdlets and allows you to work with todos. See Command parameter for what you can do.
.LINK 
    http://www.github.com/pauby/pstodowarrior
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
.PARAMETER View
    The report to be used when displaying the todos. 
.EXAMPLE
    Use-Todo -command add -priority A -task 'Take car to the garage' -project 'care-maintenance' -context 'car'
		
	Adds a new todo.
.EXAMPLE
    Use-Todo remove 15

    Removes the todo at line 15.
#>

    [CmdletBinding()]
    Param (
        [Parameter(Position=0)]
        [ValidateSet("l", "list", "a", "add", "r", "remove", "m", "modify", "d", "done", "arch", "archive")] 
        [string]$Command = "l",

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

        [Alias("v")]
        [string]$Filter = 'default'
    )

    switch ($Command)
    {
        { $_ -in "l", "list" }
        {
            Write-Verbose "Listing todos."
            $todos = Import-Todo $todoConfig.TodoTaskFile

            # check we have a view specified and if not use the default
            if ($Filter)
            {
                Write-Verbose "Looking up view '$View'."
                if (-not $todoConfig.View.ContainsKey("$View")) {
                    Write-Verbose 'View not found. Using default.'
                    $View = 'default'
                }
                else {
                    Write-Verbose 'View found.'
                }
            }
            else {
                Write-Verbose 'View not specified - using ''default''.'
                $View = 'default'
            }


            $todos = $todos | &$todoConfig.View.$Report -Config $todoConfig
            Format-Todo $todos
            Write-TodoInformation $todos
            break
        }

        { $_ -in "a","add" }
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

            break
        }

        { $_ -in "m","modify" }
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

        { $_ -in "d","done" }
        {
            Write-Verbose "Completing todos."
            $todaysDate = Get-TodoTodaysDate
            $todos = Import-Todo $todoConfig.todoTaskFile

            $modified = @() # holds modified todos
            foreach ($todo in $todos)
            {
                if ($Line -contains $todo.Line)
                {
                    Write-Verbose "Found todo to modify: $todo"
                    $modified += $todo.PSObject.Copy() # $todo will be modified later so take a copy of it now so we can display it how it was before completion
                    $todo = $todo | Set-Todo -DoneDate $todaysDate
                }
            }

            Write-Verbose 'Finished searching for todos to modify.'
            if ($modified.Count -gt 0)
            {
                Write-Verbose "$($modified.Count) todos modified.`nExporting todos to $($todoConfig['TodoTaskFile'])"
                Export-Todo -TodoObject $todos -Path $todoConfig['todoTaskFile'] -BackupPath $todoConfig['BackupPath'] -DaysToKeep $todoConfig['BackupDaysToKeep'] -Verbose:$VerbosePreference
            }                   

            Write-Host "$($modified.Count) todos completed:`n"
            $modified | ConvertTo-TodoString 
            Write-Host
            break
        }

        { $_ -in "r","remove" }
        {
            Write-Verbose "Removing todos."
            $todos = Import-Todo $todoConfig.todoTaskFile
            $startCount = $todos.Count   
            $todos = $todos | where-object { $Line -notcontains $_.Line }
            Export-Todo -TodoObject $todos -Path $todoConfig['todoTaskFile'] -BackupPath $todoConfig['BackupPath'] -DaysToKeep $todoConfig['BackupDaysToKeep'] -Verbose:$VerbosePreference

            Write-Host "$($startCount - $todos.Count) todos removed."

            break
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
            break
        }
    }
}

