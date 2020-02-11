function Write-TWHost {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ValueFromRemainingArguments)]
        [string]
        $Arguments
    )

    $settings = Get-TWConfiguration

    if (-not $settings.DisableWriteHostUse) {
        Write-Host @Arguments
    }
}