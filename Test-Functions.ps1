﻿<# 
.DESCRIPTION
    File Name	: Test-Functions.ps1  
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 28/09/15 - Initial version
.LINK 
    https://www.github.com/pauby
#>

<# 
.DESCRIPTION
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 28/09/15 - Initial version

    TODO        : Might be easier to this via a regular expression.
.LINK 
    https://www.github.com/pauby
.PARAMETER TestDate
.OUTPUTS
	Whether the date is valid or not. Output type is [bool]
.EXAMPLE

    Tests to ensure the date '2015-10-10' is in the valid todo date format and outputs $true or $false.
#>
function Test-TodoDate
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$TestDate
    )

    # what we do here is first of all pass the date to Get-Date and ask it to format it in yyyy-MM-dd. 
    # If it doesn't output the same as the input the date is not in a valid format.
    # also make sure we don't display errors if there is invalid input
    $error.Clear()
    $result = Get-Date $TestDate -Format "yyyy-MM-dd" -ErrorAction SilentlyContinue
    if ($result.CompareTo($TestDate) -ne 0 -or $? -eq $false) # test if the date returned is not the same as the input or we have an error
    {
        $false
    }
    else
    {
        $true
    }
}

<# 
.DESCRIPTION
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 28/09/15 - Initial version

    A valid priority is a single character string that is between A and Z. 
    
    TODO        : Might be easier to this via a regular expression.
.LINK 
    https://www.github.com/pauby/ 
.PARAMETER Priority
.OUTPUTS
	Whether the priority is correct. Output type is [bool]
.EXAMPLE

    Tests to see if the priority "N" is valid and outputs $true or $false.
#>
function Test-TodoPriority
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]$Priority
    )

    # ensure priority is one character long, is a letter between A and Z
    $Priority = $Priority.ToUpper()
    ($Priority.CompareTo("A") -ge 0) -and ($Priority.CompareTo("Z") -le 0) -and ($Priority.Length -eq 1)
}

<# 
.DESCRIPTION
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 28/09/15 - Initial version

    A valid context is a string contains no whitespace and starting with an '@'

    TODO        : The function should only test a single context string so we know which one if any fail.
                  At the moment if any of the contexts fail we fail the whole test.
.LINK 
    https://www.github.com/pauby/ 
.PARAMETER Context
.OUTPUTS
	Whether the context(s) are valid or not. Output type is [bool]
.EXAMPLE

    Tests to see if the contexts "@computer" and "@home" are valid and returns $true or $false.
#>
function Test-TodoContext
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Context
    )

    # Context, as stored in the object, should just be a word with no spaces andf not start with an @
    # this regex is to match whitespace or an @ - if they match anything then the context is invalid
    $regex = [regex]"(?:[@\s])"
    #"(?:@\S+)"

    foreach ($item in $Context)
    {
        if ($regex.Match($item))
        {
            $false
            break
        }
    }

    # if we get here each context must be valid
    $true
}

<# 
.DESCRIPTION
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 28/09/15 - Initial version

    A valid format of project is a string with no whitespace that starts with a '+'.

    TODO        : The function should only test a single context string so we know which one if any fail.
                  At the moment if any of the contexts fail we fail the whole test.
.LINK 
    https://www.github.com/pauby/ 
.PARAMETER Project
.OUTPUTS
	Whether the project(s) are valid. Output tye is [bool]
.EXAMPLE

    Tests if the projects "+computer" and "+home" are valid and outputs $true or $false.
#>
function Test-TodoProject
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Project
    )

    # Project, as stored in the object, should just be a word with no spaces andf not start with an +
    # this regex is to match whitespace or a + - if they match anything then the project is invalid
    $regex = [regex]"(?:[\+\s])"
    #"(?:\+\S+)"

    foreach ($item in $Project)
    {
        if ($regex.Match($item))
        {
            $false
            break
        }
    }

    # if we get here each context must be valid
    $true
}