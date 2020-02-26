function Use-TWTodo
{
<#
.SYNOPSIS
    One overall function to work with todos.
.DESCRIPTION
    This cmdlet is a wrapper for the other cmdlets and allows you to work with todos..

.PARAMETER List
    List / show the todos on the host. This is also the default when no other command switch is provided.
.EXAMPLE
    Use-TWTodo -Add 'Take car to the garage' -project 'care-maintenance' -context 'car'

    Adds a new todo.
.EXAMPLE
    Use-TWTodo -Remove 15

    Removes the todo at line 15.
.LINK
    http://www.github.com/pauby/pstodowarrior/tree/master/docs/use-twtodo.md
.NOTES
    Author: Paul Broadwith (https://pauby.com)
    Project: PSTodoWarrior (https://github.com/pauby/pstodowarrior)
#>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    Param (
        [Parameter(ParameterSetName = 'List')]
        [switch]
        $List,

        [Parameter(ParameterSetName = 'Add')]
        [string]
        $Add,

        [Parameter(ParameterSetName = 'Remove')]
        [switch]     #TODO allow an array or raneg to be used here
        $Remove,

        [Parameter(ParameterSetName = 'Complete')]
        [switch]
        $Complete,

        [Parameter(ParameterSetName = 'View')]
        [string]
        $View = 'default',      # if this default vaue is removed, adjust the 'List' code below

        [Parameter(ParameterSetName = 'Filter')]
        [Parameter(ParameterSetName = 'Remove')]
        [Parameter(ParameterSetName = 'Complete')]
        [Parameter(ParameterSetName = 'List')]
        [array]
        $Filter
    )

    # Import the settings
    $settings = Get-TWConfiguration

    # import the todos
    $script:TWTodo = Import-TWTodo

    # if the user has given us a filter, then filter the todos
    $filteredTodo = $script:TWTodo
    if ($PSBoundParameters.Keys.Contains('Filter')) {
        Write-Verbose "Filtering the todo(s). Filter is '$Filter'."

        $filteredTodo = @()
        ForEach ($f in $Filter) {
            # go through the filter and check what we have
            if ($f -is [int]) {
                Write-Verbose "Filter: Found an id '$f'."
                $filteredTodo += $script:TWTodo | Where-Object {$_.id -eq $f }
            }
            elseif ($f.StartsWith('@')) {
                Write-Verbose "Filter: Found a context '$($f.SubString(1))'"
                # skip over the '@' when checking for the context
                $filteredTodo += $script:TWTodo | Where-Object { $_.context -contains $f.SubString(1) }
            }
            elseif ($f.StartsWith('+')) {
                Write-Verbose "Filter: Found a project '$($f.SubString(1))'"
                # skip over the '+' when checking for the project
                $filteredTodo += $script:TWTodo | Where-Object { $_.project -contains $f.SubString(1) }
            }
        }

        # filter out the duplicates
        Write-Verbose "Filtering out the duplicates starting - we have $(@($filteredTodo).count)."
        $found = @()
        $filteredTodo = $filteredTodo | ForEach-Object {
            # check if we have the ID in our list
            # if we do then skip it because it's a duplicate
            # if we don't, add it and output the todo
            if ($found -notcontains $_.id) {
                $found += $_.id
                $_
            }
        }

        Write-Verbose "Filtering out duplicates complete - we have $(@($filteredTodo).count)."
    }

    # using round brackets around switch scriptblocks to make it easier to read
    # and break up the curly brackets a bit
    if ($PSBoundParameters.Keys.Contains('Add')) {
        # import the todos again in case anything has changed, add the new todo
        # and then export them (as we have made a change)
        $script:TWTodo = Import-TWTodo

        # this will output the Todo's added
        $Add | Add-TWTodo -TodoList $script:TWTodo
    }
    elseif ($PSBoundParameters.Keys.Contains('Remove')) {
        # the user is basing their removal on what they last saw so don't re-read the todolist in case it has changed

        #TODO we need to put some mechanism in here for alerting the user if
        #TODO things have changed since the last import - for example a hash of the
        #TODO todo file
        $newTodoList = $filteredTodo | Remove-TWTodo -Todo $script:TWTodo
        $removed = $script:TWTodo | Where-Object { $_ -notin $newTodoList }
        $removed
        Write-TWHost "Removed $(@(removed).count) todo(s)."

        $script:TWTodo = $newTodoList
    }
    elseif ($PSBoundParameters.Keys.Contains('Complete')) {
        # complete a todo by setting the DoneDate
        $doneDate = Get-Date -Format "yyyy-MM-dd"       #TODO this was taken straight Get-TodoTxtTodaysDate - consider making that function public and use it instead
        $filteredTodo | Set-TodoTxt -DoneDate $doneDate
        Export-TWTodo -Todo $script:TWTodo
    }
    else {
        # if we get here we have either not passed any of the 'command'
        # parameters OR have passed List or View
        #! as View has a default value we don't need to check it exists
        if ($List.IsPresent) {
            Write-Verbose "Listing todos with View '$View'."
        }
        else {
            Write-Verbose "No parameter was passed. Defaulting to listing todos with View '$View'."
        }

        # import the todos and then show them - simples!
        if ($settings.View.Keys -contains $View) {
            Write-Verbose "Found View '$View' in settings."
            $output = $filteredTodo | & $global:TWSettings.View.$View
        }
        else {
            # we only get here if the View does not exist in the settings
            if ($View -eq 'default') {
                Write-Verbose "Default View 'default' does not exist. Listing ALL todos."
                #TODO we should add a check when importing settings that the
                #TODO default View exists and if not create one like the one below
                $output = $filteredTodo
            }
            else {
                Write-Error "Cannot find View '$View'. Know Views: '$($global:TWSettings.View.Keys -join ''', ')'."
            }
        }

        $output
        Write-TWStats -Output $output -Prefix "`n"
    }
}

Set-Alias t Use-TWTodo