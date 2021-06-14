@description('Your unique ID - i.e. dm041221')
param yourID string
@description('Course ID - i.e. az220')
param courseID string

var location = resourceGroup().location
var iotHubName = 'iot-${courseID}-training-${yourID}'
module hub './iotHub.bicep' = {
  name: 'hubDeploy'
  params: {
    iotHubName: iotHubName
    location: location
  }
}

var deviceID = 'sensor-v-3000'

resource devices 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'createDevice'
  kind:'AzureCLI'
  location: location
  dependsOn: [
    hub
  ]
  properties: {
    azCliVersion: '2.20.0'
    retentionInterval: 'P1D'
    cleanupPreference: 'OnExpiration'
    arguments: '${iotHubName} ${deviceID}'
    primaryScriptUri: 'https://raw.githubusercontent.com/MicrosoftLearning/AZ-220-Microsoft-Azure-IoT-Developer/bicep/Allfiles/Bicep/create-device.sh'
  }
}

output connectionString string = hub.outputs.connectionString
output deviceConnectionString object = reference('createDevice').outputs
