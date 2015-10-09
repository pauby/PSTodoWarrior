<# 
.SYNOPSIS
    Test the configuration data
.DESCRIPTION
    NOTE: This is not used at the moment!

    Test the configuration data for essential elements:

        todoTaskFile
        todoDoneFile
    
    Does not check for optional elements.
.NOTES 
    File Name	: Test-TodoConfig.ps1  
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 14/09/15 - Initial version

    TODO        : Need to expans this function to check for more.
.PARAMETER Config
    The configuration object to test.
.OUTPUTS
    Whether the configuration is valid or not. Output type is [bool]
.EXAMPLE
    Test-TodoConfig -Config $config

    Tests the configuration $config for validity.
#>

function Test-TodoConfig
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