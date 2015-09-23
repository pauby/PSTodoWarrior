#[CmdletBinding()]
Set-StrictMode -Version Latest

<#
$args
$args[0]

$opt = [System.Text.Regularexpressions.RegexOptions]
$linePattern = @"
    ^(?:x\ (?<done>\d{4}-\d{2}-\d{2})\ )?  # Done date
     (?:\((?<prio>[A-Z])\)\ )?             # Priority
     (?:(?<created>\d{4}-\d{2}-\d{2})?\ )? # Created date
     (?<task>.*)
    $
"@

$todoPattern = New-Object System.Text.Regularexpressions.Regex($linePattern, $opt::IgnorePatternWhitespace)


function Write-Help
{
    $helpText = @"
Usage 
------

    t command [options]


Commands
---------

a[dd]       Adds a new todo item to the list
    Ex:     t a "(A) my new task"

d[one]      Marks the specified todo items as done
    Ex:     t d 3,5,8

l[ist]      Lists all todo items in prio order
    Ex:     t l "@context +project"

p[rio]      Sets the priority of a todo item
    Ex:     t p 2,C

r[emove]    Removes the specified todo items
    Ex:     t r 1,4,10

u[pdate]    Updates the specified todo item
    Ex:     t u 2, "My updated task"

h[elp]      Displays this help message
    Ex:     t h


Environment Variables
----------------------

TODO_TASK   Full path name of your todo.txt file
TODO_DONE   Full path name of your done.txt file
"@

    Write-Host $helpText
}



$scriptsToLoad = @(
                    'Read-TodoFile.ps1',
                    'Confirm-TodoConfig.ps1',
                    'Set-TodoConfig.ps1',
                    'Get-TodoConfig.ps1',
                    'Get-TodoDefaultConfig.ps1',
                    'Get-RegexMatches.ps1',
                    'Use-TodoTxt.ps1',
                    'Add-TodoTxt.ps1',
                    'Get-TodoTxt.ps1',
                    'Get-Todo.ps1',
                    'Set-TodoTxtPrio.ps1',
                    'Set-TodoTxtTask.ps1',
                    'Set-TodoTxtDone.ps1',
                    'Remove-TodoTxt.ps1',
                    'Format-TodoTxt.ps1',
                    'Format-PartOrEmpty.ps1',
                    'Where-TodoTxt.ps1',
                    'Write-TodoTxt.ps1',
                    'Write-TodoTask.ps1',
                    'Measure-TodoWeight.ps1',
                    'New-TodoObject.ps1',
                    'Merge-Hastable.ps1',
                    'Split-Todo.ps1',
                    'Format-Colour.ps1'
                  )
#$scriptFolder = Join-Path -Path $PSScriptRoot -ChildPath '\Functions\'

#foreach ($script in $scriptsToLoad)
#{
#    Write-Verbose "Importing script file $script"
#    . (Join-Path $scriptFolder $script)
#}
#>

$scripts = Get-ChildItem -Path (Join-Path $PSScriptRoot '\*.ps1')
foreach ($script in $scripts)
{
    . $script
}

# check config is valid
# TODO: Create function to test the config is valid

#Export-ModuleMember -Function Use-TodoTxt, Get-TodoTxt
#Export-ModuleMember -Function Add-TodoTxt, Set-TodoTxtDone, Set-TodoTxtPrio, Remove-TodoTxtTask, Set-TodoTxtTask, Read-TodoFile
#Export-ModuleMember -Function Set-TodoConfig, Get-TodoConfig, Split-Todo, Write-TodoTask

Export-ModuleMember -Function *

#Set-Alias t Use-TodoTxt
#Export-ModuleMember -Alias t