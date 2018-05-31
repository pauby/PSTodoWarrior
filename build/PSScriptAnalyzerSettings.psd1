# PSScriptAnalyzerSettings.psd1
@{
    # this i sjust causing problems just now - keep checking it
    ExcludeRules         = @('Measure-WriteHost')
    #IncludeDefaultRules = $true
    # This cannot be used as yet in this file
    # https://github.com/PowerShell/PSScriptAnalyzer/issues/675
    #CustomRulePath      = "CommunityAnalyzerRules.psm1"
    
    Rules = @{
        PSProvideCommentHelp = @{
            Enable                  = $true
            ExportedOnly            = $false
            BlockComment            = $true
            VSCodeSnippetCorrection = $false
            Placement               = "begin"
        }

        PSPlaceOpenBrace           = @{
            Enable             = $true
            OnSameLine         = $true
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
        }

        PSPlaceCloseBrace          = @{
            Enable             = $true
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
            NoEmptyLineBefore  = $false
        }

        PSUseConsistentIndentation = @{
            Enable          = $false
            Kind            = 'space'
            IndentationSize = 4
        }

        PSUseConsistentWhitespace  = @{
            Enable         = $true
            # if this is true it causes issues with scriptblocks
            CheckOpenBrace = $false
            CheckOpenParen = $true
            CheckOperator  = $true
            CheckSeparator = $true
        }

        PSAlignAssignmentStatement = @{
            Enable         = $true
            CheckHashtable = $true
        }
    }
}