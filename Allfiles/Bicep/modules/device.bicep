@description('The IoT Hub name')
param iotHubName string

@description('Specify the location of the resources.')
param location string = resourceGroup().location

@description('Specify the Group Name.')
param groupName string = resourceGroup().name

@description('The SKU to use for the IoT Hub.')
param scriptIdentity object

@description('The Device ID')
param deviceID string

@description('Used to uniquely identify the script instance')
param utcValue string = utcNow()

resource devices 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'createDevice${utcValue}'
  kind: 'AzurePowerShell'
  location: location
  identity: scriptIdentity
  properties: {
    azPowerShellVersion: '6.0'
    retentionInterval: 'PT1H'
    forceUpdateTag: utcValue
    timeout: 'PT10M'
    arguments: '${groupName} ${iotHubName} ${deviceID}'
    scriptContent: '''
param(
    [Parameter(Mandatory=$true)]
    [string]
    $resourceGroup,

    [Parameter(Mandatory = $true)]
    [string]
    $iotHub,

    [Parameter(Mandatory = $true)]
    [string]
    $deviceName
)

$output = "Adding $($deviceName) to $($iotHub)"
Write-Output $output

Add-AzIotHubDevice -ResourceGroupName $resourceGroup -IotHubName $iotHub -DeviceId $deviceName -AuthMethod "shared_private_key"

$deviceDetails = (Get-AzIotHubDeviceConnectionString -ResourceGroupName $resourceGroup -IotHubName $iotHub -DeviceId $deviceName)

$DeploymentScriptOutputs = @{}
$DeploymentScriptOutputs['text'] = $output
$DeploymentScriptOutputs['date'] = (get-date -Format FileDate).toString()
$DeploymentScriptOutputs['deviceId'] = $deviceDetails.DeviceId
$DeploymentScriptOutputs['connectionString'] = $deviceDetails.ConnectionString
# primary key
$DeploymentScriptOutputs['primaryKey'] = ($deviceDetails.ConnectionString -replace ';', "`r`n" | ConvertFrom-StringData).SharedAccessKey

# secondary key
$deviceDetails = (Get-AzIotHubDeviceConnectionString -ResourceGroupName $resourceGroup -IotHubName -KeyType secondary $iotHub -DeviceId $deviceName)
$DeploymentScriptOutputs[secondaryKey'] = ($deviceDetails.ConnectionString -replace ';', "`r`n" | ConvertFrom-StringData).SharedAccessKey
'''
  }
}

output deviceConnectionString string = reference('createDevice').outputs.connectionString
output primaryKey string = reference('createDevice').outputs.primaryKey
output secondaryKey string = reference('createDevice').outputs.secondaryKey
