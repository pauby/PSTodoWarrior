$functionName = ($MyInvocation.MyCommand -split '.tests.ps1')[0]
Import-PTHBuildModule

Describe "Function Testing - $functionName" {

    InModuleScope -ModuleName PSTodoWarrior {
        Mock -ModuleName PSTodoWarrior -CommandName Export-TWTodo { } -Verifiable
        [System.Collections.ArrayList]$list = @() # empty list to start

        It 'should add a Todo to the list and return the Todo' {
            $result = Add-TWTodo -TodoList $list -Todo "this is a test +test @home"
            $result.task | Should -BeExactly "this is a test"
            $result.project | Should -Be @('test')
            $result.context | Should -Be @('home')
            Assert-MockCalled -CommandName Export-TWTodo -Exactly 1 -Scope It
        }

        It 'should add a Todo to the list and return the Todo when passed in the pipeline' {
            $todo = @( "this is a test +test @home", "this is another test +anothertest @somewhere" )

            $result = $todo | Add-TWTodo -TodoList $list
            $result[0].task | Should -BeExactly "this is a test"
            $result[0].project | Should -Be @('test')
            $result[0].context | Should -Be @('home')

            $result[1].task | Should -BeExactly "this is another test"
            $result[1].project | Should -Be @('anothertest')
            $result[1].context | Should -Be @('somewhere')

            Assert-MockCalled -CommandName Export-TWTodo -Exactly 1 -Scope It
        }
    }
}