$functionName = ($MyInvocation.MyCommand -split '.tests.ps1')[0]
Import-PTHBuildModule

Describe "Function Testing - $functionName" {

    InModuleScope -ModuleName PSTodoWarrior {

        $todo = @( [pscustomobject]@{ task = "Luke"; donedate = "20190201"}, [pscustomobject]@{ task = "Han"} )

        Context 'testing AutoArchive setting' {
            It 'should export completed todos to the TodoDonePath when AutoArchive is $true' {
                Mock -ModuleName PSTodoWarrior `
                    -CommandName Get-TWConfiguration { @{ TodoDonePath = 'TestDrive:\done.txt'; TodoTaskPath = 'TestDrive:\todo.txt'; AutoArchive = $true } }
                Mock -CommandName Write-Verbose {} -Verifiable
                Mock -ModuleName PSTodoWarrior -CommandName Export-TodoTxt {}

                Export-TWTodo -Todo $todo -Verbose
                Assert-MockCalled -CommandName Write-Verbose -Exactly 5 -Scope It
            }

            It 'should export all todos to TodoTaskPath when AutoArchive is $false' {
                Mock -ModuleName PSTodoWarrior `
                    -CommandName Get-TWConfiguration { @{ TodoDonePath = 'TestDrive:\done.txt'; TodoTaskPath = 'TestDrive:\todo.txt'; AutoArchive = $false } }
                Mock -CommandName Write-Verbose { } -Verifiable
                Mock -ModuleName PSTodoWarrior -CommandName Export-TodoTxt { }

                Export-TWTodo -Todo $todo -Verbose
                Assert-MockCalled -CommandName Write-Verbose -Exactly 2 -Scope It
            }

            It 'should export all todos to TodoTaskPath when AutoArchive is missing' {
                Mock -ModuleName PSTodoWarrior `
                    -CommandName Get-TWConfiguration { @{ TodoDonePath = 'TestDrive:\done.txt'; TodoTaskPath = 'TestDrive:\todo.txt' } }
                Mock -CommandName Write-Verbose { } -Verifiable
                Mock -ModuleName PSTodoWarrior -CommandName Export-TodoTxt { }

                Export-TWTodo -Todo $todo -Verbose
                Assert-MockCalled -CommandName Write-Verbose -Exactly 2 -Scope It
            }
        }

        Context 'testing BackupPath setting being defined' {

            Mock -ModuleName PSTodoWarrior -CommandName Export-TodoTxt { }

            #! the order of the 'it' statements are important. The below statement requires New-Item to be un-mocked
            #! but as Mocks are scoped at Describe and Context they 'leak' from the 'it' so this one must be before a
            #! mocked New-Item
            it 'should throw an exception if it cannot create the backup path' {
                $todoTaskPath = 'TestDrive:\todo.txt'
                Mock -ModuleName PSTodoWarrior `
                    -CommandName Get-TWConfiguration { @{ TodoDonePath = 'TestDrive:\done.txt'; TodoTaskPath = $todoTaskPath; BackupPath = '\\someremoteurl\fakepath\backups'; BackupDaysToKeep = 7 } }

                Set-Content -Path $todoTaskPath -Value "abcdefg"
                { Export-TWTodo -Todo $todo } | Should -Throw 'does not exist'
            }

            it 'should try to create the backup path if it does not exist' {
                $todoTaskPath = 'TestDrive:\todo.txt'
                Mock -ModuleName PSTodoWarrior `
                    -CommandName Get-TWConfiguration { @{ TodoDonePath = 'TestDrive:\done.txt'; TodoTaskPath = $todoTaskPath; BackupPath = 'TestDrive:\backups'; BackupDaysToKeep = 7 } }
                Mock -CommandName New-Item {} -Verifiable
                Mock -CommandName Copy-Item {} -Verifiable

                Set-Content -Path $todoTaskPath -Value "abcdefg"
                { Export-TWTodo -Todo $todo } | Should -Not -Throw
                Assert-MockCalled -CommandName New-Item -Exactly 1 -Scope It    # creating the backup folder
                Assert-MockCalled -CommandName Copy-Item -Exactly 1 -Scope It   # copying the todo file to the backup file
            }
        }

        Context 'testing BackupPath setting not being defined' {

            Mock -ModuleName PSTodoWarrior -CommandName Export-TodoTxt

            it 'should still create a backup file if no BackupPath is defined in the configuration' {
                $todoTaskPath = 'TestDrive:\todo.txt'
                $formattedDate = Get-Date -Format 'yyyymmdd'
                Mock -ModuleName PSTodoWarrior `
                    -CommandName Get-TWConfiguration { @{ TodoDonePath = 'TestDrive:\done.txt'; TodoTaskPath = $todoTaskPath; } }
                Mock -CommandName Remove-Item -Verifiable       # mock this so the backup file is not removed and we can check for it
                Set-Content -Path $todoTaskPath -Value "abcdefg"        # the backup is only created if the todo file exists

                { Export-TWTodo -Todo $todo } | Should -Not -Throw
                Assert-MockCalled -CommandName Remove-Item -Exactly 1 -Scope It   # copying the todo file to the backup file
                Get-ChildItem -Path "TestDrive:\$($formattedDate)-??????-todo.txt" | Should -HaveCount 1
            }
        }

        Context 'testing BackupPath being set and the export failing' {

            it 'should leave the backup file if the export fails' {
                $todoTaskPath = 'TestDrive:\todo.txt'
                $formattedDate = Get-Date -Format 'yyyymmdd'
                Mock -ModuleName PSTodoWarrior `
                    -CommandName Get-TWConfiguration { @{ TodoDonePath = 'TestDrive:\done.txt'; TodoTaskPath = $todoTaskPath; } }
                Mock -ModuleName PSTodoWarrior -CommandName Export-TodoTxt { throw }    # fail the export
                Set-Content -Path $todoTaskPath -Value "abcdefg"        # the backup is only created if the todo file exists

                { Export-TWTodo -Todo $todo } | Should -Throw
                Get-ChildItem -Path "TestDrive:\$($formattedDate)-??????-todo.txt" | Should -HaveCount 1
            }
        }
    }
}