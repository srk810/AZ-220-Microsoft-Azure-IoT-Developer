# Device Management using the IoT Extension for Azure CLI

The IoT extension for Azure CLI gives IoT developers command-line access to all IoT Hub, IoT Edge, and IoT Hub Device Provisioning Service capabilities. This includes the device management capabilities provided by the IoT Hub service.

|Management option|Task|
|-----------------|----|
|Direct methods|Make a device act such as starting or stopping sending messages or rebooting the device.|
|Twin desired properties|Put a device into certain states, such as setting an LED to green or setting the telemetry send interval to 30 minutes.|
|Twin reported properties|Get the reported state of a device. For example, the device reports the LED is blinking now.|
|Twin tags|Store device-specific metadata in the cloud. For example, the deployment location of a vending machine.|
|Device twin queries|Query all device twins to retrieve those twins with arbitrary conditions, such as identifying the devices that are available for use.|

**Note** If you don't have the IoT extension installed, the simplest way to install it is to run `az extension add --name azure-cli-iot-ext`

Before you can enter any device managemnt commands, you need to sign in to your Azure account:

```bash
az login
```

## Direct Methods

To invoke a direct method on a device, use the following command

```bash
az iot hub invoke-device-method --device-id <your device id> \
  --hub-name <your hub name> \
  --method-name <the method name> \
  --method-payload <the method payload>
```

## Device twin desired properties

Set a desired property interval = 3000 by running the following command:

```bash
az iot hub device-twin update -n <your hub name> \
  -d <your device id> --set properties.desired.interval = 3000
```

This property can be read from your device.

## Device twin reported properties

Get the reported properties of the device by running the following command:

```bash
az iot hub device-twin show -n <your hub name> -d <your device id>
```

One of the twin reported properties is `$metadata.$lastUpdated`, which shows the last time the device app updated its reported property set.

## Device twin tags

Display the tags and properties of the device by running the following command:

```bash
az iot hub device-twin show --hub-name <your hub name> --device-id <your device id>
```

Add a field role = temperature&humidity to the device by running the following command:

```bash
az iot hub device-twin update \
  --hub-name <your hub name> \
  --device-id <your device id> \
  --set tags = '{"role":"temperature&humidity"}}'
```

## Device twin queries

Query devices with a tag of role = 'temperature&humidity' by running the following command:

```bash
az iot hub query --hub-name <your hub name> \
  --query-command "SELECT * FROM devices WHERE tags.role = 'temperature&humidity'"
```

Query all devices except those with a tag of role = 'temperature&humidity' by running the following command:

```bash
az iot hub query --hub-name <your hub name> \
  --query-command "SELECT * FROM devices WHERE tags.role != 'temperature&humidity'"
```

---

**Instructor Notes**

[Use the IoT extension for Azure CLI for Azure IoT Hub device management](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-device-management-iot-extension-azure-cli-2-0)
