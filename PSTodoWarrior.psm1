<# 
.NOTES 
    File Name	: PoshTodo.psm1
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 09/10/15 - Initial version

    TODO        : 
#>
#Requires -Version 3
Set-StrictMode -Version Latest

# Load configuration

$functionsToExport = @('Import-Todo')
$scriptsToLoad = @(
    'PSTodoWarriorConfig.ps1',
#    'Add-Todo.ps1',
#    'Backup-Todo.ps1',
#    'ConvertTo-TodoObject.ps1',
#    'ConvertTo-TodoString.ps1',
#    'Export-Todo.ps1',
#    'Format-Colour.ps1',
#    'Format-Todo.ps1',    
#    'Get-TodoConfig.ps1',
#    'Get-TodoDefaultConfig.ps1',
    'Public\Import-Todo.ps1' #,
#    'Measure-TodoWeight.ps1',
#    'Merge-Hastable.ps1',
#    'New-TodoObject.ps1',    
#    'Remove-Todo.ps1',
#    'Set-Todo.ps1',
#    'Set-TodoConfig.ps1',
#    'Test-Functions.ps1',
#    'Test-TodoConfig.ps1',
#    'Use-Todo.ps1',
#    'Utility-Functions.ps1',
#    'Write-TodoInformation.ps1'
)

foreach ($script in $scriptsToLoad)
{
    Write-Verbose "Importing script file $script"
    . (Join-Path $PSScriptRoot $script)
}

Export-ModuleMember -Function $functionsToExport

#Set-Alias t Use-Todo -Verbose:$VerbosePreference
Export-ModuleMember -Alias t