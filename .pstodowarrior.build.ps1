Import-Module PowerShellBuild -force
. PowerShellBuild.IB.Tasks

# at the top of the PSM1 file this has to go in there

# this needs to go at the end


$PSBPreference.Build.CompileModule = $true
# $PSBPreference.Build.CompileHeader = "Set-StrictMode -Version Latest`n"
# $PSBPreference.Build.CompileFooter = "`nSet-Alias t Use-Todo"
# $PSBPreference.Build.Dependencies                           = 'StageFiles', 'BuildHelp'
$PSBPreference.Test.Enabled = $true
$PSBPreference.Test.CodeCoverage.Enabled = $true
$PSBPreference.Test.CodeCoverage.Threshold = 0.75
$PSBPreference.Test.CodeCoverage.Files =
    (Join-Path -Path $PSBPreference.Build.ModuleOutDir -ChildPath "*.psm1")
$PSBPreference.Test.ScriptAnalysis.Enabled = $true
$PSBPreference.Test.ScriptAnalysis.FailBuildOnSeverityLevel = 'Error'

function Import-PTHBuildModule {
    [CmdletBinding()]
    Param ()

    # build the filename
    $moduleScript = "{0}\{1}.psm1" -f $PSBPreference.Test.OutputPath, $PSBPreference.General.ModuleName
    if (Test-Path -Path $moduleScript) {
        Remove-Module -Name $moduleScript -ErrorAction SilentlyContinue
        Import-Module -Name $moduleScript -Force -ErrorAction Stop

        $importedModule = Get-Module -Name $env:BHProjectName
        Write-Verbose "Imported module '$($importedModule.Path)'"
    }
    else {
        throw "Module manifest '$moduleScript' does not exist!"
    }
}

task LocalDeploy {
    $sourcePath = $PSBPreference.Build.ModuleOutDir
    $destPath = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) `
        -ChildPath "WindowsPowerShell\Modules\$($PSBPreference.General.ModuleName)\$($PSBPreference.General.ModuleVersion)\"

    if (Test-Path -Path $destPath) {
        Remove-Item -Path $destPath -Recurse -Force
    }
    Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force
}

Task Clean Init, {
    Clear-PSBuildOutputFolder -Path $PSBPreference.Build.ModuleOutDir

    # Remove docs folder
    Remove-Item -Path $PSBPreference.Docs.RootDir -Recurse -Force -ErrorAction SilentlyContinue
}

Task Build StageFiles, BuildHelp
Task Test Pester