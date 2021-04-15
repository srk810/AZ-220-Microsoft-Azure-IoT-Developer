@description('Your unique ID - i.e. dm041221')
param yourId string

@description('Specify the location of the resources.')
param location string = resourceGroup().location

var iotHubName = concat('iot-az220-training-', yourId)

module hub './iotHub.bicep' = {
  name: 'hubDeploy'
  params: {
    iotHubName: iotHubName
    skuName: 's1'
    skuUnits: 1
    location: location
  }
}

var deviceID = 'sensor-v-3000'

resource devices 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'createDevice'
  kind: 'AzurePowerShell'
  location: location
  properties: {
    azPowerShellVersion: '7'
    retentionInterval: 'P1D'
    arguments: '-ioTHubName ${iotHubName} -deviceID ${deviceID}'
    primaryScriptUri: 'https://raw.githubusercontent.com/MicrosoftLearning/AZ-220-Microsoft-Azure-IoT-Developer/bicep/Allfiles/Bicep/create-device.ps1'
  }
}

output connectionString string = hub.outputs.connectionString
output deviceConnectionString string = reference('createDevice').outputs.deviceConnectionString
