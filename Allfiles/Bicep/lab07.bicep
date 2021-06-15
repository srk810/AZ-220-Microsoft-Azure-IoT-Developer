@description('Your unique ID - i.e. dm041221')
param yourID string
@description('Course ID - i.e. az220')
param courseID string

var location = resourceGroup().location
var groupName = resourceGroup().name
var iotHubName = 'iot-${courseID}-training-${yourID}'
module hub './iotHub.bicep' = {
  name: 'hubDeploy'
  params: {
    iotHubName: iotHubName
    location: location
  }
}

var deviceID = 'sensor-v-3000'

resource uai 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  location: location
  name: 'ID1'
}

resource devices 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'createDevice'
  kind: 'AzurePowerShell'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uai.id}': {}
    }
  }
  dependsOn: [
    hub
  ]
  properties: {
    azPowerShellVersion: '6.0'
    retentionInterval: 'P1D'
    timeout: 'PT10M'
    cleanupPreference: 'OnExpiration'
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

Connect-AzAccount -Identity

Add-AzIotHubDevice -ResourceGroupName $resourceGroup -IotHubName $iotHub -DeviceId $deviceName -AuthMethod "shared_private_key"

$deviceDetails = (Get-AzIotHubDeviceConnectionString -ResourceGroupName $resourceGroup -IotHubName $iotHub -DeviceId $deviceName)

$DeploymentScriptOutputs = @{}
$DeploymentScriptOutputs['text'] = $output
$DeploymentScriptOutputs['date'] = (get-date -Format FileDate).toString()
$DeploymentScriptOutputs['deviceId'] = $deviceDetails.DeviceId
$DeploymentScriptOutputs['connectionString'] = $deviceDetails.ConnectionString
'''
  }
}

output connectionString string = hub.outputs.connectionString
output deviceConnectionString object = reference('createDevice').outputs.connectionString
