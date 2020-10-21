function Format-TWOutput {
    <#
    .SYNOPSIS
        Formats the TaskWarrior todos.
    .DESCRIPTION
        Formats the TaskWarrior todos when displayed on the screen.

        At the moment only coloured output is shown when ShowAlternatingColour is set.
    .PARAMETER Todo
    The array of todos to be formatted.

    .EXAMPLE
        $todos | Format-TWOutput

        Formats the todos in the $todos variable and displays them on the screen.
    .NOTES
        Author  : Paul Broadwith (https://github.com/pauby)
    .LINK
        https://github.com/pauby/pstodowarrior/tree/master/docs/Format-TWTodo.md
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [System.Collections.ArrayList]
        $Todo
    )

    Begin {
        # Import the settings
        $config = Get-TWConfiguration

        # initialise index
        $index = 0
    }

    Process {
        ForEach ($t in $Todo) {
            # If we have an alternating line colour then show it
            if ($config.ShowAlternatingColour) {
                $OriginalForegroundColor = $Host.UI.RawUI.ForegroundColor
                # as we may be using filtered output, the ID will not be sequential
                # use an index instead

                #Write-Host "count: $($output.count)"
                # colour every 2nd line
                if ($index %2 -eq 0) {
                    $Host.UI.RawUI.ForegroundColor = $config.ShowAlternatingColour
                    $t
                    $Host.UI.RawUI.ForegroundColor = $OriginalForegroundColor
                } else {
                    $t
                }
                #Write-Host "Index: $index"
                $index++
            } else {
                $t
            }
        }
    }

    End { }
}
