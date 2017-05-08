<# 
.SYNOPSIS
    A collection of miscellaneous small utility functions.
.DESCRIPTION
    A collection of miscellaneous small utility functions that don't deserve their own script file.
.NOTES 
    File Name	: Utility-Functions.ps1
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 29/09/15 - Initial version
.LINK 
    https://www.github.com/pauby/ 
#>

<# 
.SYNOPSIS
    Gets todays date in todo.txt format.
.DESCRIPTION
    gets todays date in the correct todo.txt format.
.NOTES 
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 29/09/15 - Initial version
.LINK 
    https://www.github.com/pauby/ 
.OUTPUTS
	Todays date. Output type is [datetime]
.EXAMPLE
    Get-TodoTodaysDate
		
	Outputs todays date.
#>
function Get-TodoTodaysDate
{
    Get-Date -Format "yyyy-MM-dd"
}