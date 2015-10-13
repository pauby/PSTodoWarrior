<#
.SYNOPSIS
	Gets the default configuration.
.DESCRIPTION
	Gets the default configuration.
.NOTES
	File Name	: Get-TodoDefaultConfig
	Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 16/09/15 - Initial version
.LINK
    https://www.github.com/pauby
.OUTPUTS
    Output type is [hashtable]
.EXAMPLE
    Get-TodoDefaultConfig

    Get the default configuration.
#>

function Get-TodoDefaultConfig
{
    [CmdletBinding()]
	
	$defaultConfig = @{
#		"TodoTaskFile" 	    = $env:TODO_TASK;
#		"TodoDoneFile" 	    = $env:TODO_DONE;
		'UseListsAndTags' 	= $true;               # use @lists and +tags instead of @context and +project
        'InfoMsgsColour'    = 'DarkCyan';

        # Archiving
        'AutoArchive'       = $false; # not implemented yet - DO NOT USE

        # Backups
        'BackupPath'        = "c:\users\paul\sync\apps-all\todo\backups\";
        'BackupDaysToKeep'  = 7;
	
		'WeightForegroundColour' = [ordered]@{	    # colours for each weights - any weight at or above the level will eb that colour (up to the previous value). 
			'20' 	= 'yellow';                     # This MUST be in order otherwise the colours will nto work.
			'15' 	= 'red';                        # it's in the format 'weight number' = 'valid PowerShell colour'
			'1' 	= 'darkgreen';
		};
        'WeightPriority'    = 6.0;
        'WeightDueDate'     = 12.0;
        'WeightHasProject'  = 1.0;
        'WeightAge'         = 2.0;
        'WeightProject'     = @{                    # all projects / tags must be in lowercase
            'next'    = 15.0;
            'waiting' = -3.0;
            'today'   = 20.0;
            'someday' = -15.0;
        };

        # Views
        'TodoLimit'   = 25;
        'Reports' = @{
#            'default' = { param([Parameter(ValueFromPipeline=$true)][object[]]$todos, [hashtable]$config); begin { $output = @() } process { foreach ($todo in $todos) { if (($todo.Project -contains $config['ProjectDefault']) -or ($todo.Priority) -or ($todo.Project -contains $config['ProjectNextAction'])) { $output += $todo } } } end { $output | where { [string]::IsNullOrWhitespace($_.DoneDate) } | Sort-Object -Property @{e="Weight"; Descending=$true}, @{e="Line"; Descending=$False} | Select-Object -First $config['TodoLimit'] } };
            'default' = { param([Parameter(ValueFromPipeline=$true)][object[]]$todos, [hashtable]$config); begin { $output = @() } process { foreach ($todo in $todos) { if (($todo.Context.Count -gt 0) -and ([string]::IsNullOrWhiteSpace($todo.DoneDate))) { $output += $todo } } } end { $output | where { [string]::IsNullOrWhitespace($_.DoneDate) } | Sort-Object -Property @{e="Weight"; Descending=$true}, @{e="Line"; Descending=$False} | Select-Object -First $config['TodoLimit'] } };            
            'all'     = { param([Parameter(ValueFromPipeline=$true)][object[]]$todos, [hashtable]$config); begin { $output = @() } process { foreach ($todo in $todos) { $output += $todo } } end { $output | sort Weight -Descending } };
            'inbox'   = { param([Parameter(ValueFromPipeline=$true)][object[]]$todos, [hashtable]$config); begin { $output = @() } process { foreach ($todo in $todos) { if ($todo.Context.Count -eq 0) { $output += $todo } } } end { $output | where { [string]::IsNullOrWhitespace($_.DoneDate) } | Sort-Object -Property Weight -Descending } };
        };
	}
	
	$defaultConfig
}