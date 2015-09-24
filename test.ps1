cls
Set-StrictMode -Version Latest

. .\Import-Todo.ps1
. .\ConvertTo-TodoObject.ps1
. .\Get-RegexMatches.ps1
. .\New-TodoObject.ps1
. .\Merge-Hastable.ps1
. .\Confirm-TodoConfig.ps1
. .\Set-TodoConfig.ps1
. .\Get-TodoDefaultConfig.ps1
. .\Measure-TodoWeight.ps1
. .\Confirm-TodoConfig.ps1
. .\Format-Todo.ps1
. .\Get-TodoConfig.ps1
. .\Format-Colour.ps1
. .\ConvertTo-TodoString.ps1
. .\ConvertFrom-TodoObject.ps1
. .\Add-Todo.ps1
. .\Export-Todo.ps1
. .\Remove-Todo.ps1

$todoConfig = @{
	'todoTaskFile' = "c:\users\paul\sync\apps-all\todo\todo-test.txt"; 
#"c:\users\paul\sync\apps-all\todo\todo.txt"; 
    'todoDoneFile' = "c:\users\paul\sync\apps-all\todo\done-test.txt";
}

Set-TodoConfig -Config $todoConfig -Verbose
$global:poshTodoConfig = Get-TodoConfig


#$global:todo = import-todo $poshTodoConfig.todoTaskFile -verbose
#Format-Todo $todo

#$todo | % { ConvertTo-TodoString $_ }

#Add-Todo 'This is a new todo to be added for Paul @computer @home @work +ebay +camper due:2015-10-01'

$global:todo = import-todo $poshTodoConfig.todoTaskFile
Format-Todo $todo

Remove-Todo -LineNum 1,3,6 -Verbose
$global:todo = import-todo $poshTodoConfig.todoTaskFile
Format-Todo $todo