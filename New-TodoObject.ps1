<#
.SYNOPSIS
	Short description. Appears in all basic, -detailed, -full, -examples
.DESCRIPTION
	Longer description. Appears in basic, -full and -detailed
.NOTES
	File Name	: New-TodoObject
	Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 18/09/15 - Initial version
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

function New-TodoObject
{
    [CmdletBinding()]
    Param(
        [hashtable]$Property
    )
        
	$defaultProps = @{
		"Canonical" 	= "";		# [string] the todo text as read from the todo file
		"DoneDate" 		= "";		# [string] date the todo was completed in yyyy-MM-dd format
		"CreatedDate" 	= Get-Date -Format "yyyy-MM-dd";		# [string] date the todo was created in yyyy-MM-dd format
		"Priority"		= "";		# [string] todo priority (A - Z)
		"Task"			= ""; 		# [string] the todo text 
		"Context"		= "";		# [string[]] the todo context (such as @computer)
		"Project"		= "";		# [string[]] the project the todo is assigned to (ie. +housebuild)
		"Due"			= "";		# [string] The due date of the todo (uses due:) in the format yyyy-MM-dd
  		"Threshold"		= "";		# [string] the threshold / start date of a todo (uses t:) in the format yyyy-MM-dd [for future implementation]
  		"Recurrence"	= "";		# [string]recurring todos (uses rec:) [for future implementation]
  		"Hidden"		= "";		# dummy todos that are hidden from view (uses h:) [for future implementation]
        "Addon"         = "";       # additiona key:value pairs that we don't use but will preserve
		  
		# The properties below are calculated by the script and not stored in the todo file
  		"DueIn"			= "";		# time in days the todo is due
		"Age"			= "";		# todo age in days (this is not part of the 
		"Weight"		= "";		# the weighting of this todo
	}
	
	$todoObj = New-Object -Type PSObject -Property (Merge-Hashtable $defaultProps $Property)
    #$todoObj | gm

<#    Write-Verbose 'Created new Todo Object with default properties.'

    # if we have a hastable of properties passed then add them to the new object
    if ($Property)
    {
        Write-Verbose 'Assigning specified properties to new todo object.'
        foreach ($key in $Property.Keys)
        {
            if ($todoObj.ContainsKey($key))
            {
                $todoObj.$key = $Property.$key
            }
            else
            {
                Write-Verbose 'Invalid key $key in new Todo Object properties.'
                Exit
            }
        }
    }#>

    $todoObj
}