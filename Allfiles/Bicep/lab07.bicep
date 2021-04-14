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

resource script 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'deviceDeploy'
  kind: 'AzurePowerShell'
  location: location
  properties: {
    azPowerShellVersion: '7'
    retentionInterval: 'P1D'
    scriptContent:
  }

}

output connectionString string = hub.outputs.connectionString
