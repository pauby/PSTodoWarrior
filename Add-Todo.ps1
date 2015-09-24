<#
.SYNOPSIS
	Short description. Appears in all basic, -detailed, -full, -examples
.DESCRIPTION
	Longer description. Appears in basic, -full and -detailed
.NOTES
	Function 	: Add-Todo
	Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 20/09/15 - Initial version
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


function Add-Todo
{
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromRemainingArguments=$true)]
		[ValidateNotNullOrEmpty()]
        $todo,

        [hashtable]$Config = $poshTodoConfig	
	)

    Write-Verbose "Creating todo object."
    $todoObj = $todo | ConvertTo-TodoObject

    Write-Verbose "Exporting new todo to the todo file at $($Config['todoTaskFile'])"
    Export-Todo -Todo $todoObj -Filename $Config['todoTaskFile'] -Append

    Write-Verbose "New todo added to $($Config['todoTaskFile'])"        
}

            
