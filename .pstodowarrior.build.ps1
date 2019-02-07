Import-Module PowerShellBuild -force
. PowerShellBuild.IB.Tasks

$PSBPreference.Build.CompileModule = $true
# $PSBPreference.Build.Dependencies                           = 'StageFiles', 'BuildHelp'
$PSBPreference.Test.Enabled = $true
$PSBPreference.Test.CodeCoverage.Enabled = $true
$PSBPreference.Test.CodeCoverage.Threshold = 0.75
$PSBPreference.Test.CodeCoverage.Files =
(Join-Path -Path $PSBPreference.Build.ModuleOutDir -ChildPath "*.psm1")
$PSBPreference.Test.ScriptAnalysis.Enabled = $true
$PSBPreference.Test.ScriptAnalysis.FailBuildOnSeverityLevel = 'Error'

task LocalDeploy {
    $sourcePath = $PSBPreference.Build.ModuleOutDir
    $destPath = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) `
        -ChildPath "WindowsPowerShell\Modules\$($PSBPreference.General.ModuleName)\$($PSBPreference.General.ModuleVersion)\"

    if (Test-Path -Path $destPath) {
        Remove-Item -Path $destPath -Recurse -Force
    }
    Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force
}

$moduleVersion = (Get-Module -Name PowerShellBuild -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1).Version
if ($moduleVersion -le [version]"0.3.0") {
    task Build {
        #Write-Host "Setting env"
        #[Environment]::SetEnvironmentVariable("BHBuildOutput", $PSBPreference.Build.ModuleOutDir, "machine")
    }, StageFiles, BuildHelp

    task Init {
        Initialize-PSBuild
        Set-BuildEnvironment -BuildOutput $PSBPreference.Build.ModuleOutDir -Force
        $nl = [System.Environment]::NewLine
        "$nl`Environment variables:"
        (Get-Item ENV:BH*).Foreach( {
                '{0,-20}{1}' -f $_.name, $_.value
            })
    }
}