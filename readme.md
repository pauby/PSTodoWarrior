# PSTodoWarrior

This is a powershell CLI to the [Todo.txt](http://todotxt.com/) todo file format with some PowerShell like features taking inspiration from [Taskwarrior](http://taskwarrior.org).

## Goal

The goal of this project is to create a command line interface to Todo.txt and add in some important Taskwarrior features such as prioritisation and ease of editing tasks.

## Configuration

```powershell
$TWSettings = [pscustomobject]@{
    TodoTaskPath        = $env:TODO_TASK
    TodoDonePath        = $env:TODO_DONE

    # Context and project name
    # name text of the Context property of the todo - usually 'Context' or 'List'
    NameContext         = 'List'
    # name text of the Project property of the todo - usually 'Project' or 'Tag'
    NameProject         = 'Tag'

    # Archives
    # if $true automatically archives completed todos to the TodoDoneFile, if $false they remain in the TodoTaskFile
    AutoArchive         = $true # not implemented yet - DO NOT USE

    # Backups
    # backups are stored in the same folder as the TodoTaskFile
    BackupFolder        = 'backups'
    # Number of backups to keep in the BackupFolder
    BackupDaysToKeep    = 7

    # Colours
    # Colours for each weights - any weight at or above the level will be that colour (up to the previous value).
    # This MUST be an ordered hashtable for it to work.
    # it's in the format 'weight number' = 'valid PowerShell colour'
    WeightForegroundColour = [ordered]@{
        20  = 'yellow'
        15  = 'red'
        1   = 'darkgreen'
    }

    # Colour for information messages
    InfoMsgsColour         = 'DarkCyan'

    # Set this to $true if you don't want information messages shown (the messages use Write-Host to display so if you
    # are working with todo objects those messages will pollute the output).
    DisableWriteHostUse    = $false

    # Weights
    # TODO: These needs explained
    WeightPriority    = 6.0
    WeightDueDate     = 12.0
    WeightHasProject  = 1.0
    WeightAge         = 2.0
    WeightProject     = @{                    # all projects / tags must be in lowercase
        next    = 15.0
        waiting = -3.0
        today   = 20.0
        someday = -15.0
    }

    # Views
    # TODO: These need explained
    TodoLimit   = 25
    View = @{
#            'default' = { param([Parameter(ValueFromPipeline=$true)][object[]]$todos, [hashtable]$config); begin { $output = @() } process { foreach ($todo in $todos) { if (($todo.Project -contains $config['ProjectDefault']) -or ($todo.Priority) -or ($todo.Project -contains $config['ProjectNextAction'])) { $output += $todo } } } end { $output | where { [string]::IsNullOrWhitespace($_.DoneDate) } | Sort-Object -Property @{e="Weight"; Descending=$true}, @{e="Line"; Descending=$False} | Select-Object -First $config['TodoLimit'] } };
#        default = { param([Parameter(ValueFromPipeline=$true)][object[]]$todos, [hashtable]$config); begin { $output = @() } process { foreach ($todo in $todos) { if (($todo.Context.Count -gt 0) -and ([string]::IsNullOrWhiteSpace($todo.DoneDate))) { $output += $todo } } } end { $output | where { [string]::IsNullOrWhitespace($_.DoneDate) } | Sort-Object -Property @{e="Weight"; Descending=$true}, @{e="Line"; Descending=$False} | Select-Object -First $config['TodoLimit'] } }
        all         = { param([Parameter(ValueFromPipeline=$true)][object[]]$todos, [hashtable]$config); begin { $output = @() } process { foreach ($todo in $todos) { $output += $todo } } end { $output | sort Weight -Descending } }
#        inbox   = { param([Parameter(ValueFromPipeline=$true)][object[]]$todos, [hashtable]$config); begin { $output = @() } process { foreach ($todo in $todos) { if ($todo.Context.Count -eq 0) { $output += $todo } } } end { $output | where { [string]::IsNullOrWhitespace($_.DoneDate) } | Sort-Object -Property Weight -Descending } }
        inbox       = { param([Parameter(ValueFromPipeline=$true)][object[]]$todos, [hashtable]$config); begin { $output = @() } process { $output += $todos | where context -contains 'inbox' } end { $output | where { [string]::IsNullOrWhitespace($_.DoneDate) } | Sort-Object -Property Weight -Descending } }
        wait        = { param([Parameter(ValueFromPipeline=$true)][object[]]$todos, [hashtable]$config); begin { $output = @() } process { $output += $todos | where project -contains 'waiting' } end { $output | where { [string]::IsNullOrWhitespace($_.DoneDate) } | Sort-Object -Property Weight -Descending } }
        today       = { param([Parameter(ValueFromPipeline=$true)][object[]]$todos, [hashtable]$config); begin { $output = @() } process { $output += $todos | where { $_.project -contains 'today' -or ($_.addon.keys -contains 'due' -and $_.addon.due -le (Get-Date -Format 'yyyy-MM-dd')) } } end { $output | where { [string]::IsNullOrWhitespace($_.DoneDate) } | Sort-Object -Property Weight -Descending } }
        duetoday    = { param([Parameter(ValueFromPipeline=$true)][object[]]$todos, [hashtable]$config); begin { $output = @() } process { $output += $todos | Where-Object { $_.addon.keys -contains 'due' } | Where-Object { $_.addon.due -eq (get-date -format 'yyyy-MM-dd') } } end { $output | where { [string]::IsNullOrWhitespace($_.DoneDate) } | Sort-Object -Property Weight -Descending } }

    }
}
```

## TODO

- [ ] Add ability to view tasks

# References

* The [Todo.txt Format](https://github.com/ginatrapani/todo.txt-cli/wiki/The-Todo.txt-Format)
* [SimpleTask](https://github.com/mpcjanssen/simpletask-android/blob/master/src/main/assets/listsandtags.en.md) - took the idea for some of the addons from here (recurring tasks, hidden tasks etc.)
* {Simpletask LIsts and Tags] (https://github.com/mpcjanssen/simpletask-android/blob/master/src/main/assets/listsandtags.en.md)
* [How to GTD with SimpleTask](https://gist.github.com/alehandrof/9941620)
* [How TaskWarrior handles Urgency](http://taskwarrior.org/docs/urgency.html)
* [How topydo handles urgency](https://github.com/bram85/topydo/wiki/Importance)
