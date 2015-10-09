<#
.SYNOPSIS
	Short description. Appears in all basic, -detailed, -full, -examples
.DESCRIPTION
	Longer description. Appears in basic, -full and -detailed
.NOTES
	File Name	: Get-RegexMatches.ps1
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

function Get-RegexMatches
{
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$Pattern,
		
		[Parameter(Mandatory, Position=1)]
		[ValidateNotNullOrEmpty()]
		[string]$Text
	)
	
	$regex = [regex]$Pattern
    $results = $regex.Matches($Text)
	
    $matches = @()
    if ($results.count)
    {
        foreach ($result in $results)
        {
            $matches += $result.value.Trim()
        }
    }
	
	$matches
}