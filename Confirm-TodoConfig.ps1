<# 
.SYNOPSIS
    Test the PoshTodo configuration data
.DESCRIPTION
    Test the PoshTodo configuration data for essential elements:

        todoTaskFile
        todoDoneFile
    
    Does not check for optional elements.

    TODO: Check that all priorities allowed (up to UseLastPriority) have a value
.NOTES 
    File Name	: Test-TodoConfig.ps1  
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 14/09/15 - Initial version
.PARAMETER Config
    The configuration object to test.
.OUTPUTS
    Boolean indicating if test passed or failed.
.EXAMPLE
    Test-TodoConfig -Config $config
#>

function Confirm-TodoConfig
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,Position=0)]
        [ValidateNotNullOrEmpty()]
        [hashtable]$config
    )

    $mandatoryProps = @('todoTaskFile', 
                        'todoDoneFile'
                        )

    $filesToCheck = @(  'todoTaskFile',
                        'todoDoneFile'
                     )
                        
    
    # Test configuration for mandatory properties
    $testState = $true
    foreach ($prop in $mandatoryProps)
    {
        if (-not ($config.ContainsKey($prop)))
        {
            Write-Verbose "Configuration property $prop is missing."
            $testState = $false
        }
    }

    # Test for existence of the mandatory files
    if ($testState)
    {
        foreach ($file in $filesToCheck)        
        { 
            if (-not (Test-Path $config[$file]))
            {
                Write-Verbose "Todo file $file cannot be found."
                $testState = $false
            }
        }
    }

    $testState
}
         