@description('Your unique ID - i.e. dm041221')
param yourId string

var location = resourceGroup().location

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

output connectionString string = hub.outputs.connectionString
