[CmdletBinding()]
Param (
    [String]
    $ReleaseType = 'Unknown',

    [string]
    $GitHubUsername = $env:GITHUB_USERNAME,

    [string]
    $GitHubApiKey = $env:GITHUB_API_KEY,

    [string]
    $PSGalleryApiKey = $env:PSGALLERY_API_KEY
)

if (-not $PSBoundParameters.ContainsKey('Verbose')) {
    $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
}

$params = @{
    ReleaseType     = $ReleaseType
    GitHubUserName  = $GitHubUsername
    GitHubApiKey    = $GitHubApiKey
    PSGalleryApiKey = $PSGalleryApiKey
}

. (Get-BuildScript) @params

# we may not need to exclude pscodehealth so the below may not be needed
#task Test {CleanImportedModule}, 
#PSScriptAnalyzer,
#Pester,
#ValidateTestResults