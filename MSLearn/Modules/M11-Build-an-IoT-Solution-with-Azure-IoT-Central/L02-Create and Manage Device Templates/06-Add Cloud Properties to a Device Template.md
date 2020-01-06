# Add Cloud Properties to a Device Template

Use cloud properties to store information about devices in IoT Central. Cloud properties are never sent to a device. For example, you can use cloud properties to store the name of the customer who has installed the device, or the device's last service date.

The following table shows the configuration settings for a cloud property:

|Field|Description|
|-----|-----------|
|Display Name|The display name for the cloud property value used on dashboards and forms.|
|Name|The name of the cloud property. IoT Central generates a value for this field from the display name, but you can choose your own value if necessary.|
|Semantic Type|The semantic type of the property, such as temperature, state, or event. The choice of semantic type determines which of the following fields are available.|
|Schema|The cloud property data type, such as double, string, or vector. The available choices are determined by the semantic type.|

---

**Instructor Notes**

[Tutorial: Define a new IoT device type in your Azure IoT Central application (preview features)](https://docs.microsoft.com/en-us/azure/iot-central/preview/tutorial-define-iot-device-type)
