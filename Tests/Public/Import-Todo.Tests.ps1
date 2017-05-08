$ourModule = 'PSTodoWarrior'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$projRoot = Split-Path -Parent $here
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
<#
$functionName = $sut -replace '\.ps1'
$functionScript = Get-ChildItem $sut -Recurse | Select-Object -First 1
if ($null -eq $functionScript) {
    Write-Host "Cannot find the script $sut in any child directories. Will not check the code quality with PSScriptAnalyser." -ForegroundColor 'Red'
}

if (Test-Path -Path "$ourModule.psd1") {
    Remove-Module $ourModule -ErrorAction SilentlyContinue
    Import-Module ".\$ourModule.psd1" -Force
}
else {
    throw "Module .\$ourModule.psd1 not found in current directory"
}
#>

Remove-Module $ourModule -ErrorAction SilentlyContinue
Import-Module (Join-Path -Path $projRoot -ChildPath $ourModule) -Force

#InModuleScope -ModuleName $ourModule {

    Describe "Script Testing" {
        Context "Parameter Validation" {
            It "Should throw an exception for an empty path" {
                { Import-Todo -Path ''  } | Should throw "Cannot validate argument on parameter 'Path'"
            }

            It "Should throw an exception if the todo file does not exist" {
                { Import-Todo -Path 'TestDrive:missing.txt' } | Should throw "Cannot validate argument on parameter 'Path'"
            }
        }

        Context "Processing and Logic" {

            Mock -ModuleName PsTodoWarrior Import-TodoTxt { @( [pscustomobject]@{ task = "abc"}, [pscustomobject]@{ task = "def"} ) } -Verifiable

            It 'Adds a line property to each todo' {
                # need to create an empty file as the function tests for this 
                Set-Content -Path 'TestDrive:todo.txt' -Value "."
                $todo = Import-Todo -Path 'TestDrive:todo.txt'
                $todo.count | Should Be 2
                for ($i = 0; $i -lt $todo.count; $i++) {
                    $todo[$i].Line | Should be ($i+1) 
                }
                { Assert-VerifiableMocks } | Should not throw
            }
        }

        Context "Output" {
            # the output comes from the ConvertFrom-TodoTxtString function. We tested this has been
            # called above so no further output tests needed
        }
#    }
}
