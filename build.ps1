[CmdletBinding()]
Param (
    $Task = 'build'
)

$dependModules = @(
    @{
        Name = 'InvokeBuild'
    },
    @{
        Name = 'Configuration'
    },
    @{
        Name            = 'PowerShellBuild'
        MinimumVersion  = '0.3.0-beta'
        AllowPrerelease = $true
    },
    @{
        Name           = 'Pester'
        MinimumVersion = 4.4.3
    }
    @{
        Name           = 'PSScriptAnalyzer'
        MinimumVersion = '1.17.1'
    }
)

# Initialize the build environment if the session is running as Admin
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if (Test-Administrator) {
    ..\Initialize-Build.ps1 -RequiredModule $dependModules -Verbose:$VerbosePreference
} else {
    Write-Warning "Not running as Administrator - could not initialize build environment."
}

# Used in Pester tests to import the built module and not a module already installed on the system
function global:Import-HelperModuleForTesting {
    # build the filename
    $moduleScript = "{0}\{1}.psm1" -f $env:BHBuildOutput, $env:BHProjectName
    if (Test-Path -Path $moduleScript) {
        Remove-Module -Name $moduleScript -ErrorAction SilentlyContinue
        Import-Module -Name $moduleScript -Force -ErrorAction Stop

        $importedModule = Get-Module -Name $env:BHProjectName
        Write-Verbose "Imported module '$($importedModule.Path)'"
    } else {
        throw "Module manifest '$moduleScript' does not exist!"
    }
}

Invoke-Build -File .\.pstodowarrior.build.ps1 -Task $Task -Verbose:$VerbosePreference

Remove-Item function:Import-HelpersModuleForTesting -ErrorAction SilentlyContinue