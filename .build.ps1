# This is taken directory from Invoke-Build .build.ps1 at https://github.com/nightroman/Invoke-Build/blob/master/.build.ps1
# will use this as a starting point
<#
.Synopsis
	Build script (https://github.com/pauby/PsTodoTxt)

.Description
	TASKS AND REQUIREMENTS
    Run tests
    Clean the project directory
#>

# Build script parameters are standard parameters
param(
    [switch]$NoTestDiff
)

# Ensure Invoke-Build works in the most strict mode.
Set-StrictMode -Version Latest

# Project variables
$BuildOptions = @{
    ModuleName          = 'PSTodoWarrior'
    PSGalleryApiKey     = $env:PSGALLERY_API_KEY
    BuildPath           = "$BuildRoot\build"
    SourcePath          = "$BuildRoot\source"
    TestsPath           = "$BuildRoot\tests"
    DocsPath            = "$BuildRoot\docs"
    ModuleLoadPath      = "$($env:mysyncroot)\Coding\PowerShell\Modules"
    RequiredModules     = @( "Pester", "PSScriptAnalyzer", "PlatyPS")
}

$ManifestOptions = @{
    RootModule          = "$($BuildOptions.ModuleName).psm1"
    Author              = 'Paul Broadwith'
    CompanyName         = 'Paul Broadwith'
    Copyright           = "(c) 2016-$((Get-Date).Year) Paul Broadwith"
    Description         = 'PSTodoWarrior is a PowerShell module for working with TodoTxt format files with inspiration from Taskwarrior.'
    PowerShellVersion   = '3.0'
#    FormatsToProcess    = 'PSTodoWarrior.Format.ps1xml'
    RequiredModules     = @('PsTodoTxt')
    AliasesToExport     = 't'
    Tags                = 'Todo', 'Todo.txt'
    ProjectUri = 'https://github.com/pauby/PSTodoWarrior'
    LicenseUri = 'https://github.com/pauby/PsTodoWarrior/blob/master/LICENSE'
    ReleaseNotes = 'https://github.com/pauby/PSTodoWarrior/blob/master/CHANGELOG.md'
}

<#
# Synopsis: Make the NuGet package.
task NuGet Module, {
    $text = @'
Invoke-Build is a build and test automation tool which invokes tasks defined in
PowerShell v2.0+ scripts. It is similar to psake but arguably easier to use and
more powerful. It is complete, bug free, well covered by tests.
'@
    Set-Content z\Package.nuspec @"
<?xml version="1.0"?>
<package xmlns="http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd">
	<metadata>
		<id>Invoke-Build</id>
		<version>$Version</version>
		<authors>Roman Kuzmin</authors>
		<owners>Roman Kuzmin</owners>
		<projectUrl>https://github.com/nightroman/Invoke-Build</projectUrl>
		<iconUrl>https://raw.githubusercontent.com/nightroman/Invoke-Build/master/ib.png</iconUrl>
		<licenseUrl>http://www.apache.org/licenses/LICENSE-2.0</licenseUrl>
		<requireLicenseAcceptance>false</requireLicenseAcceptance>
		<summary>$text</summary>
		<description>$text</description>
		<tags>PowerShell Build Test Automation</tags>
		<releaseNotes>https://github.com/nightroman/Invoke-Build/blob/master/Release-Notes.md</releaseNotes>
		<developmentDependency>true</developmentDependency>
	</metadata>
</package>
"@
    exec { NuGet pack z\Package.nuspec -NoDefaultExcludes -NoPackageAnalysis }
}

# Synopsis: Push NuGet package.
task PushNuGet NuGet, {
    exec { NuGet push "Invoke-Build.$Version.nupkg" -Source nuget.org }
},
CleanBuild

# Synopsis: Test v3+ and v2.
#task Test Test3, Test2, Test6
task CodeHealth {
    $pesterParams = @{
        EnableExit = $false;
        PassThru = $true;
        Strict = $true;
        Show = "Failed"
    }

    Get-ChildItem -Include '*.ps1', '*.psm1' -Path "$($BuildOptions.SourcePath)" -Recurse | ForEach-Object {
        $type = Split-Path -Path (Split-Path -Path $_.FullName -Parent) -Leaf | Where-Object { $_ -in @("public", "private") }
        $testFilename = "$($_.BaseName).Tests.ps1"
        $testPath = Join-Path -Path (Join-Path -Path "$($BuildOptions.TestsPath)" -ChildPath $type) -ChildPath $testFilename
        $results = Invoke-PSCodeHealth -Path $_ -TestsPath $testPath
        $fails = $results.ScriptAnalyzerFindingsTotal + $results.NumberOfFailedTests
        assert($fails -eq 0) ("{0} failed {1} tests." -f $testPath, $fails)
    }
}

# Synopsis: Calls tests infinitely. NOTE: normal scripts do not use ${*}.
task Loop {
    for () {
        ${*}.Tasks.Clear()
        ${*}.Errors.Clear()
        ${*}.Warnings.Clear()
        Invoke-Build . Tests\.build.ps1
    }
}
#>

# Synopsis: Remove build folder
task CleanBuild {
    Remove-Item -Path $BuildOptions.BuildPath -Force -Recurse -ErrorAction SilentlyContinue
}

# Synopsis: Cleans the module from all PowerShell module paths
task CleanModule {

    Get-Module $BuildOptions.ModuleName -ListAvailable | ForEach-Object {
        Remove-Module $_.Path -ErrorAction SilentlyContinue
        Remove-Item -Path (Split-Path -Path $_.Path -Parent) -Force -Recurse
    }
}

# Synopsis: Warn about not empty git status if .git exists.
task GitStatus -If (Test-Path .git) {
    $status = exec { git status -s }
    if ($status) {
        Write-Warning "Git status: $($status -join ', ')"
    }
}

# Synopsis: Build the PowerShell help file.
# <https://github.com/nightroman/Helps>
task Help {
    Import-Module -Name $BuildOptions.ModuleName
    New-ExternalHelp -Path $BuildOptions.DocsPath -OutputPath $BuildOptions.BuildPath\en-GB -Force
    Remove-Module -Name $BuildOptions.ModuleName
}

# Synopsis: Set $script:Version.
task Version {
    # get the version from Release-Notes
    $script:Version = . { switch -Regex -File Changelog.md {'##\s+v(\d+\.\d+\.\d+)' {return $Matches[1]}} }
    assert ($Version)
}

# Synopsis: Convert markdown files to HTML.
# <http://johnmacfarlane.net/pandoc/>
task Markdown {
    exec { pandoc.exe --standalone --from=markdown_strict --output=$($BuildOptions.BuildPath)\README.html README.md }
    exec { pandoc.exe --standalone --from=markdown_strict --output=$($BuildOptions.SourcePath)\CHANGELOG.html CHANGELOG.md }
}

# Synopsis: Make the build folder.
task Build CleanBuild, BuildManifest, {
    # mirror the source folder
    exec {$null = robocopy.exe $($BuildOptions.SourcePath) $($BuildOptions.BuildPath) /mir} (0..2)

    # copy files
    Copy-Item -Destination $BuildOptions.BuildPath -Path LICENSE
}, Help

# Synopsis: Builds the module manifest
task BuildManifest Version, {
    # make manifest
    $scripts = (Get-Item "$($BuildOptions.SourcePath)\public\*.ps1") | ForEach-Object { "public\$($_.Name)" }
    $scripts += (Get-Item "$($BuildOptions.SourcePath)\private\*.ps1") | ForEach-Object { "private\$($_.Name)" }
    $functionsToExport = ((Get-Item "$($BuildOptions.SourcePath)\public\*.ps1").BaseName) | ForEach-Object { "$_" }

    New-ModuleManifest -Path "$($BuildOptions.SourcePath)\$($BuildOptions.ModuleName).psd1" @ManifestOptions `
        -NestedModules $scripts -FunctionsToExport $functionsToExport -ModuleVersion $Version
}

# Synopsis: Push with a version tag.
task PushRelease Version, {
    $changes = exec { git status --short }
    assert (!$changes) "Please, commit changes."

    exec { git push }
    exec { git tag -a "v$Version" -m "v$Version" }
    exec { git push origin "v$Version" }
}

task PushPSGallery CleanModule, Build, {
    if (-not $BuildOptions.PSGalleryApiKey) {
        Write-Error "You need to set the environment variable PSGALLERY_API_KEY to the PowerShell Gallery API Key"
    }

    exec {$null = robocopy.exe $($BuildOptions.BuildPath) "$($BuildOptions.ModuleLoadPath)\$($BuildOptions.ModuleName)" /mir} (0..2)

    $PublishOptions = {
        Name            = $BuildOptions.ModuleName
        IconUri         = $ManifestOptions.IconUri
        LicenseUri      = $ManifestOptions.LicenseUri
        ProjectUri      = $ManifestOptions.ProjectUri
        ReleaseNotes    = $ManifestOptions.ReleaseNotes
        Tags            = $ManifestOptions.Tags
        NuGetApiKey     = $BuildOptions.PSGalleryApiKey
    }

    #Import-Module "$MyBuildPath\$ModuleName.psd1"
    Publish-Module @PublishOptions
}, CleanBuild

# Synopsis: Test and check expected output.
# Requires PowerShelf/Assert-SameFile.ps1
task Test3 {
    # invoke tests, get output and result
    $output = Invoke-Build . Tests\.build.ps1 -Result result -Summary | Out-String -Width:200
    if ($NoTestDiff) {return}

    # process and save the output
    $resultPath = "$BuildRoot\Invoke-Build-Test.log"
    $samplePath = "$HOME\data\Invoke-Build-Test.$($PSVersionTable.PSVersion.Major).log"
    $output = $output -replace '\d\d:\d\d:\d\d(?:\.\d+)?( )? *', '00:00:00.0000000$1'
    [System.IO.File]::WriteAllText($resultPath, $output, [System.Text.Encoding]::UTF8)

    # compare outputs
    Assert-SameFile $samplePath $resultPath $env:MERGE
    Remove-Item $resultPath
}

# Synopsis: Test with PowerShell v2.
task Test2 {
    $diff = if ($NoTestDiff) {'-NoTestDiff'}
    exec {powershell.exe -Version 2 -NoProfile -Command Invoke-Build Test3 $diff}
}

# Synopsis: Test with PowerShell v6.
task Test6 -If $env:powershell6 {
    $diff = if ($NoTestDiff) {'-NoTestDiff'}
    exec {& $env:powershell6 -NoProfile -Command Invoke-Build Test3 $diff}
}

task Test BuildManifest, {
    $pesterParams = @{
        EnableExit = $false;
        PassThru   = $true;
        Strict     = $true;
        Show       = "Failed"
    }

    # will throw an error and stop the build if errors
    Test-ModuleManifest "$($BuildOptions.SourcePath)\$($BuildOptions.ModuleName).psd1" -ErrorAction Stop | Out-Null

    # remove the module before we test it
    Remove-Module $BuildOptions.ModuleName -Force -ErrorAction SilentlyContinue
    $results = Invoke-Pester @pesterParams
    $fails = @($results).FailedCount
    assert($fails -eq 0) ('Failed "{0}" unit tests.' -f $fails)
}

task CodeAnalysis {
    $scriptAnalyzerParams = @{
        Path        = $BuildOptions.SourcePath
        Severity    = @('Error', 'Warning')
        Recurse     = $true
        Verbose     = $false
    }
    Invoke-ScriptAnalyzer @scriptAnalyzerParams
}

task InstallDependencies {
    $BuildOptions.RequiredModules | ForEach-Object {
        if (!(Get-Module -Name $_ -ListAvailable)) {
            Install-Module $_ -Force -Scope CurrentUser
        }
    }
}

# Synopsis: The default task: make, test, clean.
#task . Help, Test, Clean
task . GitStatus, InstallDependencies, Test, CodeAnalysis