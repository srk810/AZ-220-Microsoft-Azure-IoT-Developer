@description('The IoT Hub name')
param iotHubName string

@description('The DPS name')
param provisioningServiceName string

@description('Specify the location of the resources.')
param location string

@description('The SKU to use for the IoT Hub.')
param skuName string

@description('The number of IoT Hub units.')
param skuUnits int

module hub './iotHub.bicep' = {
  name: 'hubDeploy'
  params: {
    iotHubName: iotHubName
    skuName: skuName
    skuUnits: skuUnits
    location: location
  }
}

module dps './dps.bicep' = {
  name: 'dpsDeploy'
  params: {
    provisioningServiceName: provisioningServiceName
    location: location
    skuName: skuName
    skuUnits: skuUnits
    iotHubConnectionString: hub.outputs.connectionString
  }
}

output iotHubConnectionString string = hub.outputs.connectionString
