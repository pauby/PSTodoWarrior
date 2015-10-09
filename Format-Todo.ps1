<# .SYNOPSIS    Formats the todo.
.DESCRIPTION    Formats the todo.
.NOTES 
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 23/09/15 - Initial version
                  1.1 - Added lists and tags support

    To display the todo in coloured format, the Weight must be the second number in the formatted output.
.LINK 
    https://www.github.com/pauby
.PARAMETER Todo    The todo to format.
.EXAMPLE    Format-Todo $Todo
		
    Formats the todo and pipes it to Format-Colour
#>

function Format-Todo
{
	[CmdletBinding()]
	Param (
			[Parameter(Mandatory,Position=0)]
			[AllowEmptyCollection()]
			[object[]]$Todo
	)	

    $Config = Get-TodoConfig

    if ($Config['UseListsandTags'])
    {
        $nameContext = 'List          '
        $nameProject = 'Tag           '
    }
    else
    {
        $nameContext = 'Context       '
        $nameProject = 'Project       '
    }

    $Todo | Format-Table -Wrap -Property `
	    @{ n='L  '; e={ $_.Line }; Alignment='left'; Width=3; },
	    @{ n='Weight'; e={ "{0:N2}" -f $_.Weight }; Alignment='right'; Width=6; },
	    @{ n='P'; e={ $_.Priority }; Width=1; },		
	    @{ n='Age  '; e={ "{0}d" -f $_.Age }; Width=5; },
	    @{ n='Due  '; e={ if (-not [string]::IsNullOrWhitespace($_.DueIn)) { "{0}d" -f $_.DueIn } }; Width=5; },
	    @{ n=$nameContext; e={ $_.Context -join "`n" }; Width=15; },
	    @{ n=$nameProject; e={ $_.Project -join "`n" }; Width=15; },
	    @{ n='Task               '; e={ $_.Task } } | Out-String -Stream | Format-Colour
}