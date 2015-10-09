<# .SYNOPSIS    Writes informational messages to the host.
.DESCRIPTION    Writes information messages to the host about the todos. 
.NOTES 
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 25/09/15 - Initial version

    TODO        : Unsure of the use of this function. Consider removal.
.LINK 
    https://www.github.com/pauby/ .PARAMETER Todo    The todos.
.EXAMPLE    Write-TodoInformation -Todo $todos

    Writes information about the todos to the host.
#>

function Write-TodoInformation
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]]$Todo
    )

    $config = Get-TodoConfig

    Write-Verbose "Counting completed todos."
    $todosCompleted = @(($Todo | where { $_.DoneDate -ne "" })).Count
    if ($todosCompleted -gt 0)
    {
        $infoText = "* $todosCompleted completed todos found."
        if ($config.AutoArchive)
        {
            $infoText += " Completed todos will be automatically archived."
        }

        Write-Host $infoText -ForegroundColor $config.InfoMsgsColour
        Write-Host
    }
}


