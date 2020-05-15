#!/usr/bin/pwsh
param(
    [Parameter(Mandatory=$true)]
    [string]
    $SubscriptionID,    
    [Parameter(Mandatory=$true)]
    [string]
    $IoTHubName,
    [Parameter(Mandatory=$true)]
    [string]
    $YourId,
    [Parameter(Mandatory=$true)]
    [string]
    $ResourceGroup,
    [Parameter(Mandatory=$true)]
    [string]
    $Location,    
    [Parameter(Mandatory=$true)]
    [string]
    $StorageAccountName,
    [Parameter(Mandatory=$true)]
    [string]
    $StorageAccountKey,
    [Parameter(Mandatory=$true)]
    [string]
    $Container,
    [Parameter(Mandatory=$true)]
    [string]
    $ScriptLocation
)

# Set the current Subcription to the one used in BASH
Get-AzSubscription -SubscriptionId $SubscriptionID | Select-AzSubscription >> build.log

# Update jobdefinition.json to include the location
$pathToJson = $ScriptLocation + "/JobDefinition.json"
$jobDefinition = Get-Content $pathToJson | ConvertFrom-Json
$jobDefinition.location = $Location
$jobDefinition | ConvertTo-Json | set-content $pathToJson

$jobName = "vibrationJob"
Write-Host "Creating job" $jobName -ForegroundColor DarkYellow
$job = New-AzStreamAnalyticsJob `
  -ResourceGroupName $ResourceGroup `
  -File $pathToJson `
  -Name $jobName `
  -Force 

# Update JobInputDefinition
$pathToJson = $ScriptLocation + "/JobInputDefinition.json"
$jobInputDefinition = Get-Content $pathToJson | ConvertFrom-Json -Depth 10
$jobInputDefinition.properties.datasource.properties.iotHubNamespace = $IoTHubName
$jobInputDefinition | ConvertTo-Json -Depth 10 | set-content $pathToJson

$jobInputName = "vibrationInput"
Write-Host "Creating job input" $jobInputName  -ForegroundColor DarkYellow
$jobInput = New-AzStreamAnalyticsInput `
  -ResourceGroupName $resourceGroup `
  -JobName $jobName `
  -File $pathToJson `
  -Name $jobInputName 

# Update JobOutputDefinition
$pathToJson = $ScriptLocation + "/JobOutputDefinition.json"
$JobOutputDefinition = Get-Content $pathToJson | ConvertFrom-Json -Depth 10
$JobOutputDefinition.properties.datasource.properties.storageAccounts[0].accountName = $StorageAccountName
$JobOutputDefinition.properties.datasource.properties.storageAccounts[0].accountKey = $StorageAccountKey
$JobOutputDefinition.properties.datasource.properties.container = $Container
$JobOutputDefinition | ConvertTo-Json -Depth 10 | set-content $pathToJson

$jobOutputName = "vibrationOutput"
Write-Host "Creating job output" $jobOutputName -ForegroundColor DarkYellow
$jobOutput = New-AzStreamAnalyticsOutput `
  -ResourceGroupName $resourceGroup `
  -JobName $jobName `
  -File $pathToJson `
  -Name $jobOutputName -Force 

# Create Query
$jobTransformationName = "VibrationJobTransformation"
$pathToJson = $ScriptLocation + "/JobTransformationDefinition.json"
Write-Host "Creating job transformation" $jobTransformationName -ForegroundColor DarkYellow
$jobTransformation = New-AzStreamAnalyticsTransformation `
  -ResourceGroupName $resourceGroup `
  -JobName $jobName `
  -File $pathToJson `
  -Name $jobTransformationName -Force 
  
