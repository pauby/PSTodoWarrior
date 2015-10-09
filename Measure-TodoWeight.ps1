<#
.SYNOPSIS
	Short description. Appears in all basic, -detailed, -full, -examples
.DESCRIPTION
	Longer description. Appears in basic, -full and -detailed
.NOTES
	File Name	: Measure-TodoWeight
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
function Measure-TodoWeight
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,Position=0)]
        [ValidateNotNullOrEmpty()]
        [object]$Todo,
        
        [ValidateNotNullOrEmpty()]
        [hashtable]$Config
    )
    
    $weight = [single]$Config.WeightStart

    # 1 - priority
    Write-Verbose "Weighting todo priority."
    if ($Todo.Priority -ne '')
    {
        $addWeight = &$Config['WeightPriorityCalc'] $Config $Todo
        $weight += $addweight
        Write-Verbose "Todo priority is $($Todo.Priority) which has a weight of $addWeight - Total Weight: $weight"
    }
    
    # 2 - todo age
    Write-Verbose "Weighting todo age."
    $addWeight += $Todo.Age * $Config['WeightAgeFactor']
    $weight += $addweight
    Write-Verbose "Todo age is $($Todo.Age) which has a weight of $addWeight - Total Weight: $weight"
    
    # 3 - todo due in
    Write-Verbose "Weighting todo duein."
    if ($Todo.DueIn -ne "")
    { 
        if ($Todo.DueIn -gt 0)
        {
            $addWeight += (10 / $Todo.DueIn) * $Config['WeightDueInFactor']
        }
        elseif ($Todo.DueIn -eq 0)
        {
            $addWeight += 2
        }
        else
        {
            $addWeight += (-1 * $Todo.DueIn) * 3
        }

        $weight += $addWeight
        Write-Verbose "Todo due in is $($Todo.DueIn) which has a weight of $addWeight - Total Weight: $weight"
    }
    
    if ($weight -gt 99.99)
    {
        $weight = 99.99
    }
#    else
#    {
#        $weight = [math]::Round($weight, 2)
#    }
      
    $weight
}