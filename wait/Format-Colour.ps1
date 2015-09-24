<#
.SYNOPSIS
	Short description. Appears in all basic, -detailed, -full, -examples
.DESCRIPTION
	Longer description. Appears in basic, -full and -detailed
.NOTES
	Based on the Format-Color function written by 
	File Name	: Format-Colour.ps1
	Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 17/09/15 - Initial version
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

# http://www.bgreco.net/powershell/format-color/

function Format-Colour
{
	[CmdletBinding()]
	Param (
		[Parameter(ValueFromPipeline=$True)]
		[string[]]$lines,
		
		[ValidateNotNullOrEmpty()]
		[hashtable]$Config = $poshTodoConfig
	)
	
	Begin
	{
		$regex = [regex]"(?<=\d+\s+)(\d+\.\d+)"
		#"^\d+\.\d+"
	}

	Process
	{
		foreach ($line in $lines) 
		{
			# if the line starts with a space it is a continuation of the last so write in in the same colour	
			if (-not ($line.StartsWith(" ")))
			{
				$colour = ''

				$result = $regex.Matches($line)
				foreach($minWeight in $Config['WeightForegroundColour'].Keys)
				{
					if ([single]$result.Value -ge [single]$minWeight)
					{
						$colour = $Config['WeightForegroundColour'][$minWeight]
						break
					}
				}
			}
			
			if ($colour) 
			{
				Write-Host $line -ForegroundColor $colour
			} 
			else 
			{
				Write-Host $line
			}
		}
	}
}