<#
.SYNOPSIS
	Writes a todo to the host in colour.
.DESCRIPTION
	Writes a todo to the host in colour depending on the weight of the todo.
    A regular expression is used to extract the weight from the string and the weight 
    value is used to find the correct colour from the 'WeightForegroundColour' hashtable 
    in the configuration.
    Note that the regular expression finds the weight as the second set of numbers in the string. If you format
    your todo differently this will not pick up the weight unless you adjust the regular expression.
.NOTES
	Based on the Format-Color function written by Brad Greco at http://www.bgreco.net/powershell/format-color/
	File Name	: Format-Colour.ps1
	Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 17/09/15 - Initial version
.LINK
	https://github.com/pauby/
.PARAMETER Line
	 Lines of text to write to the host.
.EXAMPLE
    Format-Colour $todos

    Writes the todos to the host file with colour based on their weight.
#>

function Format-Colour
{
	[CmdletBinding()]
	Param (
		[Parameter(ValueFromPipeline=$True)]
		[string[]]$Line
	)
	
	Begin
	{
        # this regegular expression expects the weight to the be the second number in the string. For example:
        # 101 10.1 .....
        # (in this case 101 is the line number)
		$regex = [regex]"(?<=\d+\s+)(\d+\.\d+)"
		#"^\d+\.\d+"
        $config = Get-TodoConfig
	}

	Process
	{
		# if the line starts with a space it is a continuation of the last so write in in the same colour	
		if (-not ($line.StartsWith(" ")))
		{
			$colour = ''

			$result = $regex.Match($line)
			foreach($minWeight in $config['WeightForegroundColour'].Keys)
			{
				if ([single]$result.Value -ge [single]$minWeight)
				{
					$colour = $config['WeightForegroundColour'][$minWeight]
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