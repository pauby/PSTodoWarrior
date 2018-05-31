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

$params = @{
    ReleaseType     = $ReleaseType
    GitHubUserName  = $GitHubUsername
    GitHubApiKey    = $GitHubApiKey
    PSGalleryApiKey = $PSGalleryApiKey
}

. (Get-BuildScript) @params