@description('Your unique ID - i.e. dm041221')
param yourID string

var location = resourceGroup().location
var iotHubName = concat('iot-az220-training-', yourID)

module hub './iotHub.bicep' = {
  name: 'hubDeploy'
  params: {
    iotHubName: iotHubName
    location: location
  }
}

output connectionString string = hub.outputs.connectionString
