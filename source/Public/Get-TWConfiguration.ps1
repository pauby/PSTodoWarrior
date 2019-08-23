function Get-TWConfiguration {
    <#
    .SYNOPSIS
        Imports and returns the settings.
    .DESCRIPTION
        Imports and returns the settings from the $TWSettings session variable by default, however you can pass a
        settings custom object to the function.

        If the session variable does not exist or is empty, it will throw an error.
    .PARAMETER Configuration
    Pass in a configuration to use. By default ie uses the $TWConfiguration variable in the user session.

    .EXAMPLE
        Get-TWConfiguration

        Checks the $TWSettings session variable (effectively the global variable) is not empty and exists. If not, it will throw an error.
    .NOTES
        Author  : Paul Broadwith (https://github.com/pauby)
    .LINK
        https://github.com/pauby/pstodowarrior/tree/master/docs/Get-TWConfiguration.md
    #>
    Param (
        [PSCustomObject]
        $Configuration = $global:TWConfiguration,

        [switch]
        $Force
    )

    # check if we already have the configuration
    if (-not (Get-Variable -Name TWConfiguration -Scope Script -ErrorAction SilentlyContinue) -or $Force.IsPresent) {
        if ($null -eq $Configuration) {
            throw 'Configuration is empty or does not exist! By default this is the ''$TWConfiguration'' session variable. Make sure you set it!'
        }
        else {
            $script:TWConfiguration = $Configuration
        }
    }

    # lets set some of our own internal stuff
    # in PS < 5.0 using Write-Host would write to the output stream, so only write informational messages if the users
    # have set ShowInfoMsgs and we are at least PS 5.
    # if ($PSVersionTable.PSVersion.Major -gt 5 -and $script:TWSettings.ShowInfoMsgs -eq $true) {
    #     $script:TWConfiguration.DisableWriteHost = $true
    # }

    $script:TWConfiguration
}