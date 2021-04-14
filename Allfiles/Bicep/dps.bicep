@description('The DPS name')
param provisioningServiceName string

@description('Specify the location of the resources.')
param location string

@description('The SKU to use for the IoT Hub.')
param skuName string

@description('The number of IoT Hub units.')
param skuUnits int

@description('IoT Hub connection string.')
param iotHubConnectionString string

resource provisioningServiceName_resource 'Microsoft.Devices/provisioningServices@2020-01-01' = {
  name: provisioningServiceName
  location: location
  sku: {
    name: skuName
    capacity: skuUnits
  }
  properties: {
    iotHubs: [
      {
        connectionString: iotHubConnectionString
        location: location
      }
    ]
  }
}
