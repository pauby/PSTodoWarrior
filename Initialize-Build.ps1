#Requires -RunAsAdministrator

[CmdletBinding()]
Param (
    # Hashtable:
    #   Same parameters as Install-Module - Name is mandatory
    [hashtable[]]
    $RequiredModule,

    [string[]]
    $ChocoPackage
)

# dependencies
if (-not (Get-Command -Name 'Get-PackageProvider' -ErrorAction SilentlyContinue)) {
    $null = Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Write-Verbose 'Bootstrapping NuGet package provider.'
    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
}

Set-PSRepository -Name PSGallery -InstallationPOlicy Trusted

$RequiredModule | ForEach-Object {
    if (-not (Get-Module -Name $_.Name -ListAvailable)) {
        Write-Verbose "Installing module '$($_.Name)'."
        Install-Module @_ -SkipPublisherCheck -AllowClobber
    }
    else {
        Write-Verbose "Module '$($_.Name)' already installed."
    }
    Import-Module -Name $_.Name -Force
}

if (@($ChocoPackage.count) -gt 0) {
    # Check if Chocolatey is installed
    $chocoInstalled = $true
    try {
        Write-Verbose 'Checking if Chocolatey is installed'
        Invoke-Expression -Command 'choco.exe' | Out-Null
    }
    catch {
        try {
            Write-Verbose 'Chocolatey not installed. Installing.'
            # taken from https://chocolatey.org/install
            Set-ExecutionPolicy Bypass -Scope Process -Force
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        }
        catch {
            $chocoInstalled = $false
            Write-Verbose 'Could not install Chocolatey'
        }
    }

    if ($chocoInstalled) {
        $ChocoPackage | ForEach-Object {
            Write-Verbose "Installing '$_' package."
            choco install $_ -y
        }

        Write-Verbose 'Refreshing the PATH'
        refreshenv
    }
} #end if

# Configure git
if ($null -eq (Invoke-Expression -Command 'git config --get user.email')) {
    Write-Verbose 'Git is not configured so we need to configure it now.'
    Invoke-Expression -Command 'git config --global user.email "pauby@users.noreply.github.com"'
    Invoke-Expression -Command 'git config --global user.name "pauby"'
    Invoke-Expression -Command 'git config --global core.safecrlf false'
}