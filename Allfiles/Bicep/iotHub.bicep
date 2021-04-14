@description('The IoT Hub name')
param iotHubName string

@description('Specify the location of the resources.')
param location string

@description('The SKU to use for the IoT Hub.')
param skuName string

@description('The number of IoT Hub units.')
param skuUnits int

resource hub 'Microsoft.Devices/IotHubs@2020-08-31' = {
  name: iotHubName
  location: location
  sku: {
    name: skuName
    capacity: skuUnits
  }
}

var iotHubKeyName = 'iothubowner'
var iotHubConnectionString = 'HostName=${hub.properties.hostName};SharedAccessKeyName=${iotHubKeyName};SharedAccessKey=${listkeys(resourceId('Microsoft.Devices/Iothubs/Iothubkeys', hub.name, iotHubKeyName), '2020-03-01').primaryKey}'

output connectionString string = iotHubConnectionString
