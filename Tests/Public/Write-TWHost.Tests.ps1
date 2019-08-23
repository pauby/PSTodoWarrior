$functionName = ($MyInvocation.MyCommand -split '.tests.ps1')[0]
Import-PTHBuildModule

Describe "Function Testing - $functionName" {

    InModuleScope -ModuleName PSTodoWarrior {
        Mock -CommandName Write-Host { } -Verifiable

        It 'should use Write-Host if ''DisableWriteHostUse'' is missing' {
            $global:TWConfiguration = @{ abc = 123 }
            Write-TWHost -Message 'Help me Obi-Wan'

            Assert-MockCalled -CommandName Write-Host -Exactly 1 -Scope It
        }

        It 'should use Write-Host if ''DisableWriteHostUse'' is $false' {
            $global:TWConfiguration = @{ abc = 123 }
            Write-TWHost -Message 'Help me Obi-Wan'

            Assert-MockCalled -CommandName Write-Host -Exactly 1 -Scope It
        }


        It 'should not use Write-Host is ''DisableWriteHostUse'' is $true' {
            Get-TWConfiguration -Configuration @{ DisableWriteHostUse = $true } -Force
            Write-TWHost -Message 'Help me Obi-Wan'

            Assert-MockCalled -CommandName Write-Host -Exactly 0 -Scope It
        }

    }
}