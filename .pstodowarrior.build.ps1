Import-Module PowerShellBuild -force
. PowerShellBuild.IB.Tasks

# OutDir defaults to 'Output' (note capital 'O'). The folder is actually
# 'output' (note lowercase 'o'). This makes no difference on Windows but on
# Docker Linux it doesn't find the path, tries to create it and fails.
$PSBPreference.Build.OutDir =
    Join-Path -Path $PSBPreference.General.ProjectRoot -ChildPath "output"
$PSBPreference.Build.ModuleOutDir =
    Join-Path `
        -Path $PSBPreference.Build.OutDir `
        -ChildPath ("{0}{1}{2}" -f
            $PSBPreference.General.ModuleName,
            [IO.Path]::DirectorySeparatorChar,
            $PSBPreference.General.ModuleVersion)
$PSBPreference.Build.CompileModule = $true
# $PSBPreference.Build.CompileHeader = "Set-StrictMode -Version Latest`n"
# $PSBPreference.Build.CompileFooter = "`nSet-Alias t Use-Todo"
# $PSBPreference.Build.Dependencies                           = 'StageFiles', 'BuildHelp'
$PSBPreference.Test.Enabled = $true
$PSBPreference.Test.RootDir = Join-Path -Path $PSBPreference.General.ProjectRoot -ChildPath "Tests"
$PSBPreference.Test.CodeCoverage.Enabled = $false
$PSBPreference.Test.CodeCoverage.Threshold = 0.0    # chance to 0.70 once we have more tests
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