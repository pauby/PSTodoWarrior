$functionName = ($MyInvocation.MyCommand -split '.tests.ps1')[0]
Import-PTHBuildModule

Describe "Function Testing - $functionName" {

    InModuleScope -ModuleName PSTodoWarrior {
        Mock -ModuleName PSTodoWarrior -CommandName Export-TWTodo { return $Todo } -Verifiable
        $todoParam = @(
            [pscustomobject]@{ task = "Luke" },
            [pscustomobject]@{ task = "Han" },
            [pscustomobject]@{ task = "Chewy" },
            [pscustomobject]@{ task = "Leia" },
            [pscustomobject]@{ task = "C3PO" },
            [pscustomobject]@{ task = "R2D2" }
        )

        It 'should remove the correct number of todos with no duplicate ID''s' {
            $result = Remove-TWTodo -Todo $todoParam -ID 1, 3, 5
            $result.Count | Should -Be 3
            $result[0].task -eq "Han" | Should -Be $true
            $result[1].task -eq "Leia" | Should -Be $true
            $result[2].task -eq "R2D2" | Should -Be $true
            Assert-MockCalled -CommandName Export-TWTodo -Exactly 1 -Scope It
        }

        It 'should remove the correct number of todos with duplicate ID''s' {
            $result = Remove-TWTodo -Todo $todoParam -ID 2, 4, 2, 6, 4
            $result.Count | Should -Be 3
            $result[0].task -eq "Luke" | Should -Be $true
            $result[1].task -eq "Chewy" | Should -Be $true
            $result[2].task -eq "C3PO" | Should -Be $true
            Assert-MockCalled -CommandName Export-TWTodo -Exactly 1 -Scope It
        }

        It 'should return an empty list if all todos are removed' {
            $result = Remove-TWTodo -Todo $todoParam -ID 2, 4, 2, 6, 4, 1, 5, 3, 1
            $result | Should -Be $null
        }
    }
}