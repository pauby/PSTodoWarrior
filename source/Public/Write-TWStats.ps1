function Write-TWStats {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    Param (
        [PSObject]
        $Output,

        # text to prefix the stats text with
        [string]
        $Prefix,

        # text to suffix the stats text with
        [string]
        $Suffix
    )

    $stats = Get-TWStats -Output $Output

    if ($PSBoundParameters.ContainsKey('Prefix')) {
        Write-Host $Prefix -NoNewline
    }

    Write-Host "Completed: $($stats.Completed)  Overdue: $($stats.Overdue)  Due Today: $($stats.DueToday)  Due Tomorrow: $($stats.DueTomorrow)" -NoNewline

    if ($PSBoundParameters.ContainsKey('Suffix')) {
        Write-Host $Suffix
    }
    else {
        # do this here to get a newline
        Write-Host
    }
}