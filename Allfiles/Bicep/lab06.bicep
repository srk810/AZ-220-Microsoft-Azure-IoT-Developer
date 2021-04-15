@description('Your unique ID - i.e. dm041221')
param yourId string

var location = resourceGroup().location
var iotHubName = concat('iot-az220-training-', yourId)
var provisioningServiceName = concat('dps-az220-training-', yourId)

module hubAndDps './hubAndDps.bicep' = {
  name: 'iotHubAndDpsDeploy'
  params: {
    iotHubName: iotHubName
    provisioningServiceName: provisioningServiceName
    skuName: 'S1'
    skuUnits: 1
    location: location
  }
}

output connectionString string = hubAndDps.outputs.iotHubConnectionString
