function Import-TodoSettings {
    <#
    .SYNOPSIS
        Imports the settings file.
    .DESCRIPTION
        Imports the settings file, by default called
        'PSTodoWarrior.Settings.psd1' file from the following folders, searched
        in order:

            - Local directory
            - Home directory (taken from env:USERPROFILE)
            - env:TW_SETTINGS_PATH

        If no settings file is found an exception is thrown.
    .EXAMPLE
        Import-TodoSettings

        Searches the for the settings file 'PSTodoWarrior.Settings.psd1' in the
        local and home directories and if not found checks the filename stored
        in env:TW_SETTINGS_PATH. Once the file is found the function imports it.
    .NOTES
        Author  : Paul Broadwith (https://github.com/pauby)
        History : 1.0 - 04/04/18 - Initial release
    #>
    [CmdletBinding()]
    Param ()

    $defaultSettingsFilename = 'PSTodoWarrior.Settings.psd1'

    # if we pipe $paths into the ForEach below then the break actually quits the
    # function
    $paths = ".\$defaultSettingsFilename", "$env:USERPROFILE\$defaultSettingsFilename", "$env:TW_SETTINGS_PATH" |`
        Where-Object { -not [string]::ISNullOrEmpty($_) }
    $settingsPath = ''
    ForEach ($p in $paths) {
        if (Test-Path $p) {
            Write-Verbose "Found settings file '$p'."
            $settingsPath = $p
            # break out of the ForEach
            break 
        }
    }

    if ($settingsPath -ne '') {
        Write-Verbose "Loading settings file '$settingsPath'."
        # we cannot use the Import-PowerShellDataFile cmdlet as the settings
        # file contains scriptblocks
        $script:TWSettings = Invoke-Expression -Command (Get-Content -Raw -Path $settingsPath)
        $script:TWSettings.SettingsPath = $settingsPath
    }
    else {
        throw "Could not find settings file either in environment variable 'TW_SETTINGS_PATH' or at '~\$defaultSettingsFilename'."
    }
}
