<#
.SYNOPSIS
	Short description. Appears in all basic, -detailed, -full, -examples
.DESCRIPTION
	Longer description. Appears in basic, -full and -detailed
.NOTES
	File Name	: Get-TodoDefaultConfig
	Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 16/09/15 - Initial version
.LINK
	A hyperlink (https://github.com/pauby/). Appears in basic and -Full.
.PARAMETER firstone
	 Parameter description. Appears in -det, -full (with more info than in -det) and -Parameter (need to specify the parameter name)
.INPUTS
	Documentary text - Input type  [Universal.SolarSystem.Planetary.CommonSense]. Appears in -full
.OUTPUTS
	Documentary Text, eg: Output type  [Universal.SolarSystem.Planetary.Wisdom]. Appears in -full
.EXAMPLE
	First line is command. Other lines just text. As many as you need. Appears in -detailed and -full
#>

function Get-TodoDefaultConfig
{
	Param ()
	
	$defaultConfig = @{
#		"TodoTaskFile" 	    = $env:TODO_TASK;
#		"TodoDoneFile" 	    = $env:TODO_DONE;
		'UseListsAndTags' 	= $false;
        'InfoMsgsColour'    = 'DarkCyan';

        # Archiving
        'AutoArchive'       = $true;

        # Backups
        'BackupPath'        = "c:\users\paul\sync\apps-all\todo\backups\";
        'BackupDaysToKeep'  = 7;
        		
		# Priorities
#		'PriorityMaximum' 	= 'D';		# last priority to use - if any todo has a lower priority it will be set to this
		
		# Weighting 
        'WeightStart'       = 1.0;                    # initial weight of all todos
        'WeightAgeFactor'   = 0.01;                 # multipler for the todo age
        'WeightDueInFactor' = 0.1;
        'WeightPriorityCalc' = { param([hashtable]$config, [object]$todo); if ($config['WeightPriority'].ContainsKey($todo.Priority)) { $config['WeightPriority'][$todo.Priority] } else { 3.5 } };
                          # multipler for the todo duein
		'WeightPriority'	= @{                    # priority weightings in the format 'priority' = 'weight'
			'A' = 15.00;
			'B'	= 10.00;
			'C'	= 7.00;
			'D'	= 5.00
		};
		'WeightForegroundColour' = [ordered]@{	    # colours for each weights - any weight at or above the level will eb that colour (up to the previous value). 
			'20' 	= 'yellow';                     # This MUST be in order otherwise the colours will nto work.
			'15' 	= 'red';                        # it's in the format 'weight number' = 'valid PowerShell colour'
			'1' 	= 'darkgreen';
		}
		
		
	}
	
	$defaultConfig
}