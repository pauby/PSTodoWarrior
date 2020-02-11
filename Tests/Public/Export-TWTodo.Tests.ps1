$functionName = ($MyInvocation.MyCommand -split '.tests.ps1')[0]
Import-PTHBuildModule

Describe "Function Testing - $functionName" {

    InModuleScope -ModuleName PSTodoWarrior {
        $todo = @( [pscustomobject]@{ task = "Luke"; donedate = "20190201"}, [pscustomobject]@{ task = "Han"} )

        It 'should export completed todos to the TodoDonePath when AutoArchive is $true' {
            Mock -ModuleName PSTodoWarrior `
                -CommandName Get-TWConfiguration { @{ TodoDonePath = 'TestDrive:\done.txt'; TodoTaskPath = 'TestDrive:\todo.txt'; AutoArchive = $true } } `
                -Verifiable
            Mock -CommandName Write-Verbose {} -Verifiable
            Mock -ModuleName PSTodoWarrior -CommandName Export-TodoTxt {}

            Export-TWTodo -Todo $todo -Verbose
            Assert-MockCalled -CommandName Write-Verbose -Exactly 5 -Scope It
        }

        It 'should export all todos to TodoTaskPath when AutoArchive is $false' {
            Mock -ModuleName PSTodoWarrior `
                -CommandName Get-TWConfiguration { @{ TodoDonePath = 'TestDrive:\done.txt'; TodoTaskPath = 'TestDrive:\todo.txt'; AutoArchive = $false } } `
                -Verifiable
            Mock -CommandName Write-Verbose { } -Verifiable
            Mock -ModuleName PSTodoWarrior -CommandName Export-TodoTxt { }

            Export-TWTodo -Todo $todo -Verbose
            Assert-MockCalled -CommandName Write-Verbose -Exactly 2 -Scope It
        }


        It 'should export all todos to TodoTaskPath when AutoArchive is missing' {
            Mock -ModuleName PSTodoWarrior `
                -CommandName Get-TWConfiguration { @{ TodoDonePath = 'TestDrive:\done.txt'; TodoTaskPath = 'TestDrive:\todo.txt' } } `
                -Verifiable
            Mock -CommandName Write-Verbose { } -Verifiable
            Mock -ModuleName PSTodoWarrior -CommandName Export-TodoTxt { }

            Export-TWTodo -Todo $todo -Verbose
            Assert-MockCalled -CommandName Write-Verbose -Exactly 2 -Scope It
        }

    }
}