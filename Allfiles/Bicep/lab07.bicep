@description('Your unique ID - i.e. dm041221')
param yourId string

var location = resourceGroup().location

var iotHubName = concat('iot-az220-training-', yourId)
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
    azCliVersion: '2.9.1'
    retentionInterval: 'P1D'
    arguments: '${iotHubName} ${deviceID}'
    primaryScriptUri: 'https://raw.githubusercontent.com/MicrosoftLearning/AZ-220-Microsoft-Azure-IoT-Developer/bicep/Allfiles/Bicep/create-device.sh'
  }
}

output connectionString string = hub.outputs.connectionString
output deviceConnectionString string = reference('createDevice').outputs.DeviceConnectionString
