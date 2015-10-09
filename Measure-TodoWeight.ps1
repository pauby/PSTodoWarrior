<#
.SYNOPSIS
	Calculates the weight of a todo.
.DESCRIPTION
	Calculates the weight of a todo.
.NOTES
	File Name	: Measure-TodoWeight
	Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 16/09/15 - Initial version
                  1.1 - 07/10/15 - Complete rewrite of the weight calculations using TaskWarrior (http://taskwarrior.org/docs/urgency.html)
                  1.2 - 09/10/15 - Simplified age calculation: if age is more than 0 age weight is added
.LINK
	https://github.com/pauby/
.PARAMETER Todo
	 The todo to calcaulte the weight of.
.OUTPUTS
    The weight of the todo. Output type [single]
.EXAMPLE
	Measure-TodoWeight $todo

    Measures the weight of $todo and outputs the calculated value.
#>
function Measure-TodoWeight
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,Position=0)]
        [ValidateNotNullOrEmpty()]
        [object]$Todo
    )
    
    $Config = Get-TodoConfig
    [single]$weight = $Config['WeightStart']
    [single]$addWeight = 0

    # priority
    Write-Verbose "Weighting todo priority."
    if (-not [string]::IsNullOrWhiteSpace($Todo.Priority))
    {
        # we calculate the priority by taking 'WeightPriority' as the value for Priority A
        # Priority B will be 1 less than A, C 2 less then etc.
        # so we take the priority, convert it to ascii and substract it from the ASCII code
        # for A and use that as the value to adjust the priority weight
        $addWeight = ([byte][char]$Todo.Priority - [byte][char]"A")
        if ($addWeight -le 0)
        {
            $addWeight = $config['WeightPriority']
        }
        else
        {
            $addWeight = $config['WeightPriority'] - $addWeight
        }
        $weight += $addWeight
        Write-Verbose "Todo priority is $($Todo.Priority) which has a weight of $addWeight - Total Weight: $weight"
    }
      
    # todo due date
    Write-Verbose "Weighting todo duein."
    if (-not [string]::IsNullOrWhitespace($Todo.DueIn))
    { 
        $addWeight = $config['WeightDueDate'] - $Todo.DueIn
        $weight += $addWeight
        Write-Verbose "Todo due in is $($Todo.DueIn) which has a weight of $addWeight - Total Weight: $weight"
    }

    # age
    Write-Verbose "Weighting todo age."
    if (-not [string]::IsNullOrWhiteSpace($Todo.Age))
    {
        if ($Todo.Age -gt 0)
        {
            $addWeight = $config['WeightAge']
        }
        else
        {
            $addWeight = 0
        }

        $weight += $addWeight
        Write-Verbose "Todo age is $($Todo.Age) which has a weight of $addWeight - Total Weight: $weight"
    }
    
    # project / tags
    Write-Verbose "Weighting tags."
    if ($Todo.Project.Count -gt 0)
    {
        $addWeight = $config['WeightHasProject']
        $weight += $addWeight
        Write-Verbose "Todo has projects / tags which has a weight of $addWeight - Total Weight: $weight"

        if ($Config.ContainsKey('WeightProject') -and $config['WeightProject'].Count -gt 0)
        {
            
            [array]$foundProjects = $Todo.Project | where { $Config['WeightProject'].Keys -contains $_ }

            foreach ($project in $foundProjects)
            {
                $addWeight = $config['WeightProject']["$project"]
                $weight += $addweight
                Write-Verbose "Found project / tag $project which has a weight of $addweight - Total weight: $weight"
            }
        }
    }

    if ($weight -gt 99.99)
    {
        $weight = 99.99
    }
      
    $weight
}