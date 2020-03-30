$functionName = ($MyInvocation.MyCommand -split '.tests.ps1')[0]
Import-PTHBuildModule

Describe "Function Testing - $functionName" {

    InModuleScope -ModuleName PSTodoWarrior {

        $todo = @( [pscustomobject]@{ task = "Luke"; donedate = "2019-02-01"}, [pscustomobject]@{ task = "Han"} )
        Mock -ModuleName PSTodoWarrior `
            -CommandName Get-TWConfiguration { @{ TodoDonePath = 'TestDrive:\done.txt'; TodoTaskPath = 'TestDrive:\todo.txt'; AutoArchive = $true } }

        Context 'testing parameters' {
            it 'should throw if the todo list is null' {
                { Export-TWTodo -Todo $null } | Should -Throw
            }

            it 'should not throw if the todo list is empty' {
                { Export-TWTodo -Todo @() } | Should -Not -Throw
            }
        }

        Context 'testing AutoArchive setting' {
            Mock -CommandName Write-Verbose { } -Verifiable
            Mock -ModuleName PSTodoWarrior -CommandName Export-TodoTxt { }

            It 'should export completed todos to the TodoDonePath when AutoArchive is $true' {
                Mock -ModuleName PSTodoWarrior `
                    -CommandName Get-TWConfiguration { @{ TodoDonePath = 'TestDrive:\done.txt'; TodoTaskPath = 'TestDrive:\todo.txt'; AutoArchive = $true } }

                Export-TWTodo -Todo $todo -Verbose
                Assert-MockCalled -CommandName Write-Verbose -Exactly 5 -Scope It
            }

            It 'should export all todos to TodoTaskPath when AutoArchive is $false' {
                Mock -ModuleName PSTodoWarrior `
                    -CommandName Get-TWConfiguration { @{ TodoDonePath = 'TestDrive:\done.txt'; TodoTaskPath = 'TestDrive:\todo.txt'; AutoArchive = $false } }

                Export-TWTodo -Todo $todo -Verbose
                Assert-MockCalled -CommandName Write-Verbose -Exactly 2 -Scope It
            }

            It 'should export all todos to TodoTaskPath when AutoArchive is missing' {
                Mock -ModuleName PSTodoWarrior `
                    -CommandName Get-TWConfiguration { @{ TodoDonePath = 'TestDrive:\done.txt'; TodoTaskPath = 'TestDrive:\todo.txt' } }

                Export-TWTodo -Todo $todo -Verbose
                Assert-MockCalled -CommandName Write-Verbose -Exactly 2 -Scope It
            }
        }

        Context 'testing AutoArchive setting' {
            it 'should empty the backup file if the last todo is completed and AutoArchive is on' {
                $donePath = 'TestDrive:\done.txt'
                $taskPath = 'TestDrive:\todo.txt'
                Mock -ModuleName PSTodoWarrior `
                    -CommandName Get-TWConfiguration { @{ TodoDonePath = $donePath; TodoTaskPath = $taskPath; AutoArchive = $true } }

                { Export-TWTodo -Todo @( [pscustomobject]@{ task = "Luke"; createddate = "2019-09-09"; donedate = "2019-10-01" } ) } | Should -Not -Throw
                $file = Get-ChildItem -Path $taskPath
                $file.Length | Should -Be 2     # empty files have some length

                $file = Get-ChildItem -Path $donePath
                $file.Length | Should -Be 30    # this is the size on windows - may fail on ohter OS
            }
        }

        Context 'testing AutoArchive being $true and BackupFolder being defined' {

            Mock -ModuleName PSTodoWarrior -CommandName Export-TodoTxt { }

            #! the order of the 'it' statements are important. The below statement requires New-Item to be un-mocked
            #! but as Mocks are scoped at Describe and Context they 'leak' from the 'it' so this one must be before a
            #! mocked New-Item
            it 'should throw an exception if it cannot create the backup path' {
                $todoTaskPath = 'TestDrive:\todo.txt'
                $backupPath = '\\someremoteurl\fakepath\backups'
                Mock -ModuleName PSTodoWarrior -CommandName Get-TWBackupPath {
                    "{0}\20200320-101112-todo.txt" -f $backupPath
                }

                Mock -ModuleName PSTodoWarrior -CommandName Get-TWConfiguration {
                    @{
                        TodoDonePath = 'TestDrive:\done.txt'
                        TodoTaskPath = $todoTaskPath
                        AutoArchive = $true
                        BackupPath = '\\someremoteurl\fakepath\backups'
                        BackupDaysToKeep = 7
                    }
                }

                Set-Content -Path $todoTaskPath -Value "abcdefg"
                { Export-TWTodo -Todo $todo } | Should -Throw 'does not exist'
            }

            it 'should try to create the backup path if it does not exist' {
                $todoTaskPath = 'TestDrive:\todo.txt'
                $backupPath = 'TestDrive:\backups'
                Mock -ModuleName PSTodoWarrior -Verifiable -CommandName Get-TWBackupPath {
                    "{0}\20200320-101010-todo.txt" -f $backupPath
                }

                Mock -ModuleName PSTodoWarrior -Verifiable -CommandName Get-TWConfiguration {
                    @{
                        TodoDonePath = 'TestDrive:\done.txt'
                        TodoTaskPath = $todoTaskPath
                        AutoArchive = $true
                        BackupPath = $backupPath
                        BackupDaysToKeep = 7
                    }
                }
                Mock -CommandName New-Item {} -Verifiable
                Mock -CommandName Copy-Item {} -Verifiable
                # if we don't mock this then it tries to remove the file copied by Copy-Item which of course didn't
                # happen because we mocked it to do nothing!
                Mock -CommandName Remove-Item {} -Verifiable

                Set-Content -Path $todoTaskPath -Value "abcdefg"
                { Export-TWTodo -Todo $todo } | Should -Not -Throw
                Assert-MockCalled -CommandName Get-TWConfiguration -Exactly 1 -Scope It
                Assert-MockCalled -CommandName Get-TWBackupPath -Exactly 1 -Scope It
                Assert-MockCalled -CommandName New-Item -Exactly 1 -Scope It    # creating the backup folder
                Assert-MockCalled -CommandName Copy-Item -Exactly 1 -Scope It   # copying the todo file to the backup file
                Assert-MockCalled -CommandName Remove-Item -Exactly 1 -Scope It
            }
        }

        Context 'testing AutoArchive being $true and BackupFolder not defined' {

            Mock -ModuleName PSTodoWarrior -CommandName Export-TodoTxt

            it 'should still create a backup file' {
                $todoTaskPath = 'TestDrive:\todo.txt'
                $backupPath = 'TestDrive:\20200320-101010-todo.txt'
                Mock -ModuleName PSTodoWarrior -CommandName Get-TWBackupPath {
                    $backupPath
                }
                Mock -ModuleName PSTodoWarrior -CommandName Get-TWConfiguration {
                    @{
                        TodoDonePath = 'TestDrive:\done.txt'
                        TodoTaskPath = $todoTaskPath
                        AutoArchive = $true
                    }
                }
                Mock -CommandName Remove-Item       # mock this so the backup file is not removed and we can check for it

                Set-Content -Path $todoTaskPath -Value "abcdefg"        # the backup is only created if the todo file exists

                { Export-TWTodo -Todo $todo } | Should -Not -Throw
                Get-ChildItem -Path $backupPath | Should -HaveCount 1

                Assert-MockCalled -CommandName Get-TWBackupPath -Exactly 1 -Scope It
                Assert-MockCalled -CommandName Get-TWConfiguration -Exactly 1 -Scope It
                Assert-MockCalled -CommandName Remove-Item -Exactly 1 -Scope It   # copying the todo file to the backup file
            }
        }

        Context 'testing BackupFolder being set and the export failing' {

            $todoTaskPath = 'TestDrive:\todo.txt'
            $todoDonePath = 'TestDrive:\done.txt'
            $backupPath = 'TestDrive:\20200320-020304-todo.txt'
            Mock -ModuleName PSTodoWarrior -CommandName Get-TWBackupPath {
                $backupPath
            }
            Mock -ModuleName PSTodoWarrior -CommandName Get-TWConfiguration {
                @{
                    TodoDonePath = $todoDonePath
                    TodoTaskPath = $todoTaskPath
                    AutoArchive = $true
                    BackupFolder = '\'
                }
            }
            Mock -ModuleName PSTodoWarrior -CommandName Export-TodoTxt { throw }    # fail the export
            Mock -ModuleName PSTodoWarrior -CommandName Remove-Item {}

            it 'should leave the backup file if the export fails' {
                Set-Content -Path $todoTaskPath -Value "abcdefg"        # the backup is only created if the todo file exists

                { Export-TWTodo -Todo $todo } | Should -Throw
                Get-ChildItem -Path $backupPath | Should -HaveCount 1

                Assert-MockCalled -CommandName Get-TWBackupPath -Exactly 1 -Scope It
                Assert-MockCalled -CommandName Get-TWConfiguration -Exactly 1 -Scope It
                Assert-MockCalled -CommandName Remove-Item -Exactly 0 -Scope It
            }
        }
    }
}