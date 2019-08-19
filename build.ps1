[CmdletBinding()]
Param (
    $Task = 'build',

    # skips the initialization of the environment, which can be slow, and jumps
    # straight to the build script
    [switch]
    $SkipInit
)

function Test-Administrator {
    if ($PSVersionTable.Platform -ne 'Unix') {
        $user = [Security.Principal.WindowsIdentity]::GetCurrent();
        (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    } else {
        # TODO: We are running in Linux so assume (at this stage) we have root / Admin - this needs resolved
        $true
    }
}

if (-not $SkipInit.IsPresent) {

    $dependencies = @{
        InvokeBuild         = 'latest'
        Configuration       = 'latest'
        PowerShellBuild     = 'latest'
        Pester              = 'latest'
        PSScriptAnalyzer    = 'latest'
        PSPesterTestHelpers = 'latest'  # I don't trust this Warren guy...
        PSDeploy            = 'latest'  # Maybe pin the version in case he breaks this...
        PSTodoTxt           = 'latest'
    }

    # dependencies
    if (-not (Get-Command -Name 'Get-PackageProvider' -ErrorAction SilentlyContinue)) {
        $null = Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
        Write-Verbose 'Bootstrapping NuGet package provider.'
        Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
    } elseif ((Get-PackageProvider).Name -notcontains 'nuget') {
        Write-Verbose 'Bootstrapping NuGet package provider.'
        Get-PackageProvider -Name NuGet -ForceBootstrap
    }

    # Trust the PSGallery is needed
    if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {
        Write-Verbose "Trusting PowerShellGallery."
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    }

    Install-Module -Name PSDepend

    if (Test-Administrator) {
        $dependencies | Invoke-PSDepend -Import -Install -Force
    } else {
        Write-Warning "Not running as Administrator - could not initialize build environment."
    }

    # Configure git
    if ($null -eq (Invoke-Expression -Command 'git config --get user.email')) {
        Write-Verbose 'Git is not configured so we need to configure it now.'
        git config --global user.email "pauby@users.noreply.github.com"
        git config --global user.name "pauby"
        git config --global core.safecrlf false
    }
}

# # Used in Pester tests to import the built module and not a module already installed on the system
# function global:Import-HelperModuleForTesting {
#     # build the filename
#     $moduleScript = "{0}\{1}.psm1" -f $env:BHBuildOutput, $env:BHProjectName
#     if (Test-Path -Path $moduleScript) {
#         Remove-Module -Name $moduleScript -ErrorAction SilentlyContinue
#         Import-Module -Name $moduleScript -Force -ErrorAction Stop

#         $importedModule = Get-Module -Name $env:BHProjectName
#         Write-Verbose "Imported module '$($importedModule.Path)'"
#     } else {
#         throw "Module manifest '$moduleScript' does not exist!"
#     }
# }

Write-Host "Tag    : $($env:CI_COMMIT_TAG)`nBranch : $($env:CI_COMMIT_REF_NAME)"

Invoke-Build -File .\.pstodowarrior.build.ps1 -Task $Task -Verbose:$VerbosePreference

Remove-Item function:Import-HelpersModuleForTesting -ErrorAction SilentlyContinue