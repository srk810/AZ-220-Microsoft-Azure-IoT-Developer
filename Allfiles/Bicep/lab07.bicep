@description('Your unique ID - i.e. dm041221')
param yourID string
@description('Course ID - i.e. az220')
param courseID string

var location = resourceGroup().location
// var groupName = resourceGroup().name
var iotHubName = 'iot-${courseID}-training-${yourID}'
var identityName = '${courseID}ID'
// b24988ac-6180-42a0-ab88-20f7382dd24c is the Contributer role ID
var contributorRoleDefinitionId = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
var deviceID = 'sensor-v-3000'

module hub './modules/iotHub.bicep' = {
  name: 'deployHub'
  params: {
    iotHubName: iotHubName
    location: location
  }
}

// As the uai.id value is used below, the following cannot be moved to a module
resource uai 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  location: location
  name: identityName
}

resource uaiRole 'Microsoft.Authorization/roleAssignments@2018-09-01-preview' = {
  name: guid(subscription().subscriptionId, uai.id)
  dependsOn: [
    uai
  ]
  properties: {
    roleDefinitionId: contributorRoleDefinitionId
    principalId: reference(uai.id, '2018-11-30', 'Full').properties.principalId
    principalType:'ServicePrincipal'
  }
}
//

var scriptIdentity = {
  type: 'UserAssigned'
  userAssignedIdentities: {
    '${uai.id}': {}
  }
}

module createDevice './modules/device.bicep' = {
  name: 'createDevice'
  dependsOn: [
    hub
    uaiRole
  ]
  params: {
    iotHubName: iotHubName
    deviceID: deviceID
    scriptIdentity: scriptIdentity
  }
}

// resource devices 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
//   name: 'createDevice'
//   kind: 'AzurePowerShell'
//   location: location
//   identity: scriptIdentity
//   dependsOn: [
//     hub
//     uai
//     uaiRole
//   ]
//   properties: {
//     azPowerShellVersion: '6.0'
//     retentionInterval: 'P1D'
//     timeout: 'PT10M'
//     cleanupPreference: 'OnExpiration'
//     arguments: '${groupName} ${iotHubName} ${deviceID}'
//     scriptContent: '''
// param(
//     [Parameter(Mandatory=$true)]
//     [string]
//     $resourceGroup,

//     [Parameter(Mandatory = $true)]
//     [string]
//     $iotHub,

//     [Parameter(Mandatory = $true)]
//     [string]
//     $deviceName
// )

// $output = "Adding $($deviceName) to $($iotHub)"
// Write-Output $output

// Get-AzContext

// Add-AzIotHubDevice -ResourceGroupName $resourceGroup -IotHubName $iotHub -DeviceId $deviceName -AuthMethod "shared_private_key"

// $deviceDetails = (Get-AzIotHubDeviceConnectionString -ResourceGroupName $resourceGroup -IotHubName $iotHub -DeviceId $deviceName)

// $DeploymentScriptOutputs = @{}
// $DeploymentScriptOutputs['text'] = $output
// $DeploymentScriptOutputs['date'] = (get-date -Format FileDate).toString()
// $DeploymentScriptOutputs['deviceId'] = $deviceDetails.DeviceId
// $DeploymentScriptOutputs['connectionString'] = $deviceDetails.ConnectionString
// '''
//   }
// }

output connectionString string = hub.outputs.connectionString
output deviceConnectionString string = createDevice.outputs.deviceConnectionString
