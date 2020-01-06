# Azure CLI Support for Device Provisioning

Azure CLI commands can be used to accomplish many of the tasks associated with the Azure IoT Hub Device Provisioning Service.

## Azure CLI Commands for DPS

Azure CLI Commands for DPS are available in the following categories:

* DPS Service
* Access Policy
* Certificates
* Linked Hub

The commands available in each of these categories are shown in the tables below.

|Service Commands|Description|
|-------|-----------|
|az iot dps create|Create an Azure IoT Hub device provisioning service.|
|az iot dps delete|Delete an Azure IoT Hub device provisioning service.|
|az iot dps list|List Azure IoT Hub device provisioning services.|
|az iot dps show|Get the details of an Azure IoT Hub device provisioning service.|
|az iot dps update|Update an Azure IoT Hub device provisioning service.|

|Access Policy Commands|Description|
|-------|-----------|
|az iot dps access-policy|Manage Azure IoT Hub Device Provisioning Service access policies.|
|az iot dps access-policy create|Create a new shared access policy in an Azure IoT Hub device provisioning service.|
|az iot dps access-policy delete|Delete a shared access policies in an Azure IoT Hub device provisioning service.|
|az iot dps access-policy list|List all shared access policies in an Azure IoT Hub device provisioning service.|
|az iot dps access-policy show|Show details of a shared access policies in an Azure IoT Hub device provisioning service.|
|az iot dps access-policy update|Update a shared access policy in an Azure IoT Hub device provisioning service.|

|Certificate Commands|Description|
|-------|-----------|
|az iot dps certificate|Manage Azure IoT Hub Device Provisioning Service certificates.|
|az iot dps certificate create|Create/upload an Azure IoT Hub Device Provisioning Service certificate.|
|az iot dps certificate delete|Delete an Azure IoT Hub Device Provisioning Service certificate.|
|az iot dps certificate generate-verification-code|Generate a verification code for an Azure IoT Hub Device Provisioning Service certificate.|
|az iot dps certificate list|List all certificates contained within an Azure IoT Hub device provisioning service.|
|az iot dps certificate show|Show information about a particular Azure IoT Hub Device Provisioning Service certificate.|
|az iot dps certificate update|Update an Azure IoT Hub Device Provisioning Service certificate.|
|az iot dps certificate verify|Verify an Azure IoT Hub Device Provisioning Service certificate.|

|Linked Hub Commands|Description|
|-------|-----------|
|az iot dps linked-hub|Manage Azure IoT Hub Device Provisioning Service linked IoT hubs.|
|az iot dps linked-hub create|Create a linked IoT hub in an Azure IoT Hub device provisioning service.|
|az iot dps linked-hub delete|Update a linked IoT hub in an Azure IoT Hub device provisioning service.|
|az iot dps linked-hub list|List all linked IoT hubs in an Azure IoT Hub device provisioning service.|
|az iot dps linked-hub show|Show details of a linked IoT hub in an Azure IoT Hub device provisioning service.|
|az iot dps linked-hub update|Update a linked IoT hub in an Azure IoT Hub device provisioning service.|

## Using the DPS Service Commands

As noted previously, Azure CLI commands can be used to manage DPS at the service level.

**Note**: To view usage information for any Azure CLI command, enter the command followed by `--help`

### Create Command

The `az iot dps create` command can be used to create an Azure IoT Hub device provisioning service.

This command takes the following arguments:

|command arguments|description|
|-----------------|-----------|
|--name           |IoT Provisioning Service name.<br>Note: --name is a required argument.|
|--resource-group |Name of resource group. <br>Note: --resource-group is a required argument.|
|--location       |Location of your IoT Provisioning Service. Default is the location of target resource group.|
|--sku            |Pricing tier for the IoT provisioning service.  Allowed values: S1.  Default: S1.|
|--unit           |Units in your IoT Provisioning Service.  Default: 1.|

For example, the following command can be used to create an Azure IoT Hub device provisioning service with the standard pricing tier S1, in the region of the resource group: 

`az iot dps create --name MyDps --resource-group MyResourceGroup`

Or, to create an Azure IoT Hub device provisioning service with the standard pricing tier S1, in the 'eastus' region, use the following command:

`az iot dps create --name MyDps --resource-group MyResourceGroup --location eastus`

### Delete Command 

The `az iot dps delete` command can be used to delete an Azure IoT Hub device provisioning service.

This command takes the following arguments:

|command arguments|description|
|-----------------|-----------|
|--ids            |One or more resource IDs (space-delimited). If provided, no other 'Resource Id' arguments should be specified.|
|--name           |IoT Provisioning Service name.|
|--resource-group |Name of resource group.|

For example, the following command can be used to delete an Azure IoT Hub device provisioning service named 'MyDps': 

` az iot dps delete --name MyDps --resource-group MyResourceGroup`

Or, to delete an Azure IoT Hub device provisioning service 'MyDps', use the following command:

`az iot dps create --name MyDps --resource-group MyResourceGroup --location eastus`

---

**Instructor Notes**

[az iot dps - Manage Azure IoT Hub Device Provisioning Service](https://docs.microsoft.com/en-us/cli/azure/iot/dps?view=azure-cli-latest)
