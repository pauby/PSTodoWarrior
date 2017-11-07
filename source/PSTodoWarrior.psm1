#Requires -Version 3
Set-StrictMode -Version Latest
$defaultSettingsfFilename = 'PSTodoWarriorSettings.psd1'

# Find settings file
if (Test-Path variable:TWSettingsPath) {
    Write-Verbose "Found session variable TWSettingsPath."
    $settingsPath = $TWSettingsPath
}
elseif (Test-Path env:TW_SETTINGS_PATH) {
    Write-Verbose "Found environment variable TW_SETTINGS_PATH."
    $settingsPath = $env:TW_SETTINGS_PATH
}
else {
    Write-Verbose "No settings path explicitly specified. Using home folder."
    $settingsPath = "~\$defaultSettingsfFilename"
}

if (Test-Path $settingsPath -PathType Leaf) {    
    Write-Verbose "Loading settings file $settingsPath"
    $twSettings = (& $settingsPath)
    $twSettings.SettingsPath = $settingsPath
}
else {
    throw "Cannot find settings file at $settingsPath"
}

Set-Alias t Use-Todo