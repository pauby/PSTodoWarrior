<#
.SYNOPSIS
	Creates a new todo object.
.DESCRIPTION
	Creates a new empty todo object.
.NOTES
	File Name	: New-TodoObject
	Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 18/09/15 - Initial version

    TODO  : Need to remove the functionality to set the properties when creating an ew todo object. The only function that
            uses it is ConvertTo-TodoObject. Use Set-Todo instead as we are duplicating functionality otherwise and this functions
            scope is creeping. This function should only create a blank to object.
.LINK
	https://github.com/pauby/
.PARAMETER Property
	 Properties to set ont he new object.
.OUTPUTS
	New todo object [psobject]
.EXAMPLE
	New-TodoObject $props

    Create a new todo object with the properties in $props.
#>

function New-TodoObject
{
    [CmdletBinding()]
    Param(
        [hashtable]$Property
    )
        
	$defaultProps = @{
		"Canonical" 	= "";		# [string] the todo text as read from the todo file
		"DoneDate" 		= "";		# [string] date the todo was completed in yyyy-MM-dd format
		"CreatedDate" 	= "";		# [string] date the todo was created in yyyy-MM-dd format
		"Priority"		= "";		# [string] todo priority (A - Z)
		"Task"			= ""; 		# [string] the todo text 
		"Context"		= @();		# [string[]] the todo context (such as @computer)
		"Project"		= @();		# [string[]] the project the todo is assigned to (ie. +housebuild)
		"DueDate"		= "";		# [string] The due date of the todo (uses due:) in the format yyyy-MM-dd
  		"Threshold"		= "";		# [string] the threshold / start date of a todo (uses t:) in the format yyyy-MM-dd [for future implementation]
  		"Recurrence"	= "";		# [string]recurring todos (uses rec:) [for future implementation]
  		"Hidden"		= "";		# dummy todos that are hidden from view (uses h:) [for future implementation]
        "Addon"         = @();       # additiona key:value pairs that we don't use but will preserve
		  
		# The properties below are calculated by the script and not stored in the todo file
  		"DueIn"			= "";		# time in days the todo is due
		"Age"			= "";		# todo age in days (this is not part of the 
		"Weight"		= "";		# the weighting of this todo
	}
	
    if ($Property)
    {
        $objProps = (Merge-Hashtable $defaultProps $Property)
    }
    else
    {
        $objProps = $defaultProps
    }

    $todoObj = New-Object -Type PSObject -Property $objProps

    # if we set these in the $defaultProps the merge process would overwrite them
    Write-Verbose "Now setting some defaults."
    if (-not $todoObj.CreatedDate)
    {
        Write-Verbose "Setting default CreatedDate."
        $todoObj.CreatedDate = Get-Date -Format "yyyy-MM-dd"
        Write-Verbose "Default CreatedDate set as $($todoObj.CreatedDate)"
    }

    $config = Get-TodoConfig
    if ((-not $todoObj.Project) -and ($config['DefaultProject']))
    {
        $todoObj.Project = $config['DefaultProject']
    }

    $todoObj
}