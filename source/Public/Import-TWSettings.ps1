function Import-TWSettings {
    <#
    .SYNOPSIS
    Read the settings file.
    
    .DESCRIPTION
    Finds the TodoWarrior settings file and executes it to retrieve the settings.
    
    The settings file is looked for in the following locations, in order:

    1. Looks for a variable called TWSettingsPath and uses the path it contains;
    2. Looks for an environment variable called TW_SETTINGS_PATH and uses the path it contains;
    3. Looks for the filename in the user home folder (whatever the environment variable USERPROFILE points to);
    
    .EXAMPLE
    Import-TWSettings

    Looks for the settings file
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    Param (
        # Hashtable containing the settings
        [Parameter(ParameterSetName = 'Variable')]
        [hashtable]
        $Settings,

        # Full path to the settings file
        [Parameter(ParameterSetName = 'Path')]
        [string]
        $Path,

        # Filename of the settings file to search the default locations for
        [Parameter(ParameterSetName = 'Filename')]
        [string]
        $Filename = 'PSTodoWarriorSettings.ps1'
    )

    if ($PSBoundParameters.ContainsKey('Settings')) {
        $script:TWSettings = $Settings
        return
    }
    elseif ($PSBoundParameters.ContainsKey('Path')) {
        $settingsPath = $Path
    }
    elseif ($PSBoundParameters.ContainsKey('Filename')) {
        Write-Verbose "No settings path explicitly specified. Using home folder."
        $settingsPath = Join-Path -Path $env:USERPROFILE -ChildPath $Filename
    }
    else {
        # determine which way to find the settings file 
        if (Test-Path -Path variable:TWSettingsPath) {
            Write-Verbose "Found session variable TWSettingsPath."
            $settingsPath = $TWSettingsPath
        }
        elseif (Test-Path -Path env:TW_SETTINGS_PATH) {
            Write-Verbose "Found environment variable TW_SETTINGS_PATH."
            $settingsPath = $env:TW_SETTINGS_PATH
        } 
        else {
            Write-Verbose "No settings path explicitly specified. Using home folder."
            $settingsPath = Join-Path -Path $env:USERPROFILE -ChildPath $Filename
        }
    }

    # execute the settings file
    if (Test-Path -Path $settingsPath -PathType Leaf) {    
        Write-Verbose "Reading settings file '$settingsPath'"

        # the settings file could contain PowerShell code so we need to execute it 
        $script:TWSettings = (& $settingsPath)
        $script:TWSettings.SettingsPath = $settingsPath
    }
    else {
        throw "Cannot find settings file at $settingsPath"
    }
}