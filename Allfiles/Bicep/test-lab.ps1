[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $Lab,
    [Parameter()]
    [string]
    $Environment = "Test"

)

Write-Host 'Ensure the scripts have been pushed!' -ForegroundColor Yellow

$bicepPath = ".\$($Lab).bicep"
$jsonPath = "..\ARM\$($Lab).json"
$branchName = 'bicep'

if ($Environment -eq "Prod") {
    $branchName = 'master'
}

$portalUrl = 'https://portal.azure.com/#create/Microsoft.Template/'
$githubUrl = "https://raw.githubusercontent.com/MicrosoftLearning/AZ-220-Microsoft-Azure-IoT-Developer/$($branchName)/Allfiles/Bicep/$($Lab).json"

$finalUrl = "$($portalUrl)$([System.Web.HttpUtility]::UrlEncode($githubUrl))"

Write-Host $bicepPath
$exists = Test-Path $jsonPath
Write-Host $exists
Write-Host $Environment
Write-Host $finalUrl

Start-Process $finalUrl