<# .SYNOPSIS    Imports todos from teh todo file.
.DESCRIPTION    Reads todos from the todo file and has them converted to todo objects before output.
.NOTES 
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 22/09/15 - Initial version
                  1.1 - 09/10/15 - Added throwing error if $Path not found.
.LINK 
    https://www.guthub.com/pauby
.PARAMETER Path    Path to the todo file.
.OUTPUTS
    Output is [array]
.EXAMPLE    Import-Todo c:\todo.txt

    Reads the todos in the todo.txt file, has them converted to objects before outputting them..
#>

function Import-Todo
{
    [CmdletBinding()]
    Param (
        [ValidateScript( { Test-Path $_ } )]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )

    Write-Verbose "Checking todo file $Path exists."
    if (-not (Test-Path $Path))
    {
        throw "Cannot find $Path"
    }

    Write-Verbose "Retrieving contents of todo file $Path."
    $todos = @(Get-Content -Path $Path -Encoding UTF8 -Verbose:$VerbosePreference)

    if ($todos.count -gt 0)
    {
        $output = @($todos | ConvertTo-TodoObject -Verbose:$VerbosePreference)
    }
    else
    {
        $output = @()
    }

    ,$output
}