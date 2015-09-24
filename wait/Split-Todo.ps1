<# 
.SYNOPSIS 
    Splits Todo.txt task line into components. 
.DESCRIPTION 
    Splits a Todo.txt task into components such as priority, creation date, task, contextm, list etc.  
.NOTES
    A lot of the code in this function could ber replaced by one regular expression. 
 
    File Name	: Split-Todo.ps1  
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 15/09/15 - Initial version
.LINK 
    https://github.com/pauby/posh-todo
.PARAMETER TaskText
     Todo.txt task line.
.PARAMETER $Config
    Posh-Todo configuration. This defaults to $poshTodoConfig if nothing is passed. 
.OUTPUTS
    The components of the Todo.txt task as an object with these properties:
    DoneDate    - date the task was completed in format YYY-MM-DD
    CreatedDate - date the task was created in format YYYY-MM-DD
    Prio        - Priority of the task with values A-Z
    Task        - The task text
    Context     - the task context (such as @computer)
    Project     - the project the task is assigned to (ie. +housebuild)
    Key:Value   - these are the extensions that are in use (ie. id, due, threshold etc.)
    Canonical   - the Todo.txt task as was read   
.EXAMPLE 
	The first line should be the command itself
    The rest of this stuff is the description of the example. As many lines as you need.
    Appears in -detailed and -full 
.EXAMPLE
	The first line should be the command itself
    The rest of this stuff is the description of the example. As many lines as you need.
    Appears in -detailed and -full 
#>  

function Split-Todo
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$TodoText,

        [ValidateNotNullOrEmpty()]
        [hashtable]$Config = $poshTodoConfig
    )

    $currentDate = Get-Date
    $todoObj = New-TodoObject
    $opt = [System.Text.Regularexpressions.RegexOptions]
    $linePattern = 
@"
    ^(?:x\ (?<done>\d{4}-\d{2}-\d{2})\ )?  # Done date
    (?:\((?<prio>[A-Z])\)\ )?             # Priority
    (?:(?<created>\d{4}-\d{2}-\d{2})?\ )? # Created date
    (?<task>.*)
    $
"@
    $todoPattern = New-Object System.Text.Regularexpressions.Regex($linePattern, $opt::IgnorePatternWhitespace)

#    $TodoText = '(A) 2015-01-19 @apples Transfer Melodys car to her @computer @home @work paul@pauby.com @home @work paul@pauby.com 2+2 +list1 +list2 +hello id:9890 attach:1jhdst756+D'

    $global:parsedLine = $todoPattern.Match($TodoText).Groups

    $todoObj.Canonical   = $TodoText
    $todoObj.DoneDate    = $parsedLine['done'].Value
    $todoObj.CreatedDate = $parsedLine['created'].Value    
    $todoObj.Priority    = $parsedLine['prio'].Value.ToUpper()
    $todoObj.Task        = $parsedLine['task'].Value    

    $todoObj.Age = ((($currentDate) - (Get-Date $todoObj.CreatedDate)).Days)    

    $TodoText = $parsedLine['task'].value

    # finds the @ contexts
    $pattern = "(?:\s\@\S+)"
    $todoObj.Context = Get-RegexMatches -Pattern $pattern -Text $TodoText | sort value | Get-Unique
    
    if ($todoObj.Context -ne "")
    {
        $regex = [regex]"(?:\s\@\S+)"
        $TodoText = $regex.Replace($TodoText, "")
    }

    # finds the + lists
    $regex = [regex]"(?:\s\+\S+)"
    $results = $regex.Matches($TodoText) | sort value | Get-Unique
    
    $project = @()
    if ($results.count)
    {
        foreach ($result in $results)
        {
            $project += $result.value.Trim()
        }

        # Remove the @ context from the task text
        $TodoText = $regex.Replace($TodoText, "")
    }
    $todoObj.Project = $project        

    # find the key:value pairs EXCEPT when there is a // after the : (for example http:// https:// ftp:// etc. 
    # each of these get their own object member
    $regex = [regex]"(?:\s\S+\:(?!//)\S+)"
    $results = $regex.Matches($TodoText) | sort value | Get-Unique
    
<#    $pair = @()
    if ($results.count)
    {
        foreach ($result in $results)
        {
            # when split array index [0] will be the key and [1] the value
            $pair = ($result.value).Split(":")
            $todoObj | Add-Member -NotePropertyName ($pair[0]).Trim() -NotePropertyValue ($pair[1]).Trim()
        }

        # Remove the @ context from the task text
        $TodoText = $regex.Replace($TodoText, "")
    }#>
    $todoObj.Addons = $results.Clone()   

    # add the remaining fields that are part of the object spec but not added so far
        # due date
    if ($todoObj.Due -ne "")
    {
            $todoObj.DueIn = ((($currentDate) - (Get-Date $todoObj.Due)).Days) 
    }
    
        # todo age

    
    # calculate the task weight
    $todoObj.Weight = (Measure-TodoWeight $todoObj)
       
    $todoObj.task = $TodoText

    $todoObj
}