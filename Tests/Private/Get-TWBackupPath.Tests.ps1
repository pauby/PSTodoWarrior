$functionName = ($MyInvocation.MyCommand -split '.tests.ps1')[0]
Import-PTHBuildModule

Describe "Function Testing - $functionName" {

    InModuleScope -ModuleName PSTodoWarrior {
        $expecteddate = "20200330"
        $expectedTime = "101112"

        Mock -ModuleName PSTodoWarrior -CommandName Get-TodoTxtTodaysDate {
            $expectedDate
        }
        Mock -ModuleName PSTodoWarrior -CommandName Get-Date `
            -ParameterFilter { $Format -eq "HHmmss" } {
            $expectedTime
        }

        Context 'Testing AutoArchive being $true but BackupFolder not specified' {
            Mock -ModuleName PSTodoWarrior -CommandName Get-TWConfiguration {
                @{
                    TodoDonePath = 'TestDrive:\mytodo\done.txt'
                    TodoTaskPath = 'TestDrive:\mytodo\todo.txt'
                    AutoArchive = $true
                }
            }

            It "should return the correct backup location when 'BackupFolder' has not been specified" {
                $expected = "TestDrive:\mytodo\{0}-{1}-todo.txt" -f $expectedDate, $expectedTime
                $result = Get-TWBackupPath
                $result | Should -Be $expected
            }
        }

        Context 'Testing AutoArchive being $true and BackupFolder configured' {
            Mock -ModuleName PSTodoWarrior -CommandName Get-TWConfiguration {
                @{
                    TodoDonePath = 'TestDrive:\mytodo\done.txt'
                    TodoTaskPath = 'TestDrive:\mytodo\todo.txt'
                    AutoArchive  = $true
                    BackupFolder = 'luke'
                }
            }

            It "should return the correct backup location when 'BackupFolder' has been specified" {
                $expected = "TestDrive:\mytodo\luke\{0}-{1}-todo.txt" -f $expectedDate, $expectedTime
                $result = Get-TWBackupPath
                $result | Should -Be $expected
            }
        }
    }
}