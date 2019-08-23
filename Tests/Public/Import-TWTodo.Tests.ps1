$functionName = ($MyInvocation.MyCommand -split '.tests.ps1')[0]
Import-PTHBuildModule

Describe "Function Testing - $functionName" {

    InModuleScope -ModuleName PSTodoWarrior {
        Mock -ModuleName PSTodoWarrior Import-TodoTxt { @( [pscustomobject]@{ task = "Luke"}, [pscustomobject]@{ task = "Han"} ) } -Verifiable

        # set dummy value here as it the mocked function above returns what we need
        Set-Content -Path 'TestDrive:todo.txt' -Value '.'

        $result = Import-TWTodo -Path 'TestDrive:todo.txt'

        It 'imports the correct todo count' {
            $result.count | Should Be 2
        }

        it 'should add sequentially id' {
            $pass = $true
            for ($i = 0; $i -lt $result.count; $i++) {
                if ($result[$i].ID -ne ($i+1)) {
                    $pass = $false
                }
            }
            $pass | Should -Be $true
        }

        it 'should add type of ''TWTodo''' {
            ($result | Where-Object { $_.PSObject.TypeNames -notcontains 'TWTodo' }).count | Should -Be 0
        }
    }
}