function Import-TWSettings {
    <#
    .SYNOPSIS
        Imports the settings file.
    .DESCRIPTION
        Imports the settings from the following folders, searched
        in order:

            - Local directory
            - Home directory (taken from env:USERPROFILE)
            - env:TW_SETTINGS_PATH

        If no settings file is found an exception is thrown.
    .EXAMPLE
        Import-TWSettings

        Searches the for the settings file 'PSTodoWarrior.Settings.psd1' in the
        local and home directories and if not found checks the filename stored
        in env:TW_SETTINGS_PATH. Once the file is found the function imports it.
    .NOTES
        Author  : Paul Broadwith (https://github.com/pauby)
        History : 1.0 - 04/04/18 - Initial release
                  1.1 - 09/07/18 - Renamed function;
                                   Error message changed if settings not found;
                                   Added parameter for settings filename;
                                   Added parameter for settings path;
    .LINK
        https://github.com/pauby/pstodowarrior/tree/master/docs/Import-TWSettings.md
    #>
    [CmdletBinding(DefaultParameterSetName = 'File')]
    Param (
        # Name of the settings file to look for - note that this is not a path.
        [Parameter(ParameterSetName = 'File')]
        [string]
        $File = 'PSTodoWarrior.Settings.ps1',

        # Path to the settings file
        [Parameter(ParameterSetName = 'Path')]
        [string]
        $Path
    )

    if ($PSBoundParameters.ContainsKey('Path')) {
        $search = $Path
    }
    else {
        # if we pipe $paths into the ForEach below then the break actually quits the
        # function
        $search = Join-Path -Path $home -ChildPath $File
        if (Test-Path -Path env:TW_SETTINGS_PATH) {
            $search += $env:TW_SETTINGS_PATH
        }
    }

    $settingsPath = $null
    ForEach ($p in $search) {
        if (Test-Path $p) {
            Write-Verbose "Found settings file '$p'."
            $settingsPath = $p
            # break out of the ForEach
            break 
        }
    }

    if ($null -ne $settingsPath) {
        # determine if this is a variable or a file we need to load from
        if ((Split-Path -Path $settingsPath -Qualifier) -eq 'variable') {
            Write-Verbose "Loading settings from variable 'TWSettings'."
            $script:TWSettings = $settingsPath
        }
        else {
            Write-Verbose "Loading settings file '$settingsPath'."
            # we cannot use the Import-PowerShellDataFile cmdlet as the settings
            # file contains scriptblocks
            $script:TWSettings = Invoke-Expression -Command (Get-Content -Raw -Path $settingsPath)
        }
    }
    else {
        # create paths to display in error message
        throw ("Could not find settings file at: '{0}'." -f ($search -join ", "))
    }
}