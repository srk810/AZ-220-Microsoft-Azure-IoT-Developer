# Create a Device Capability Model

A device capability model describes an IoT Plug and Play device and defines the set of interfaces implemented by the device. A device capability model typically corresponds to a physical device, product, or SKU. You use the Digital Twin Definition Language to define a device capability model.

## Approaches for Creating a Capability Model

To create a device capability model, you can:

* Use IoT Central to create a custom model from scratch.
* Import a model from a JSON file. A device builder might have used Visual Studio Code to author a device capability model for your application.
* Select one of the devices from the Device Catalog. This option imports the device capability model that the manufacturer has published for this device. A device capability model imported like this is automatically published.

## Manage a Capability Model

After you create a device capability model, you can:

* Add interfaces to the model. A model must have at least one interface.
* Edit model metadata, such as its ID, namespace, and name.
* Delete the model.

## Create an Interface

A device capability must have at least one interface. An interface is a reusable collection of capabilities.

To create an interface:

1. Go to your device capability model, and choose + Add Interface.

1. On the Select an Interface page, you can:

    * Create a custom interface from scratch.
    * Import an existing interface from a file. A device builder might have used Visual Studio Code to author an interface for your device.
    * Choose one of the standard interfaces, such as the Device Information interface. Standard interfaces specify the capabilities common to many devices. These standard interfaces are published by Azure IoT, and can't be versioned or edited.

1. After you create an interface, choose Edit Identity to change the display name of the interface.

1. If you choose to create a custom interface from scratch, you can add your device's capabilities. Device capabilities are telemetry, properties, and commands.

### Telemetry

Telemetry is a stream of values sent from the device, typically from a sensor. For example, a sensor might report the ambient temperature.

The following table shows the configuration settings for a telemetry capability:

|Field|Description|
|-----|-----------|
|Display Name|The display name for the telemetry value used on dashboards and forms.|
|Name|The name of the field in the telemetry message. IoT Central generates a value for this field from the display name, but you can choose your own value if necessary.|
|Capability Type|Telemetry.|
|Semantic Type|The semantic type of the telemetry, such as temperature, state, or event. The choice of semantic type determines which of the following fields are available.|
|Schema|The telemetry data type, such as double, string, or vector. The available choices are determined by the semantic type. Schema isn't available for the event and state semantic types.|
|Severity|Only available for the event semantic type. The severities are Error, Information, or Warning.|
|State Values|Only available for the state semantic type. Define the possible state values, each of which has display name, name, enumeration type, and value.|
|Unit|A unit for the telemetry value, such as mph, %, or °C.|
|Display Unit|A display unit for use on dashboards and forms.|
|Comment|Any comments about the telemetry capability.|
|Description|A description of the telemetry capability.|

### Properties

Properties represent point-in-time values. For example, a device can use a property to report the target temperature it's trying to reach. You can set writeable properties from IoT Central.

The following table shows the configuration settings for a property capability:

|Field|Description|
|-----|-----------|
|Display Name|The display name for the property value used on dashboards and forms.|
|Name|The name of the property. IoT Central generates a value for this field from the display name, but you can choose your own value if necessary.|
|Capability Type|Property.|
|Semantic Type|The semantic type of the property, such as temperature, state, or event. The choice of semantic type determines which of the following fields are available.|
|Schema|The property data type, such as double, string, or vector. The available choices are determined by the semantic type. Schema isn't available for the event and state semantic types.|
|Writeable|If the property isn't writeable, the device can report property values to IoT Central. If the property is writeable, the device can report property values to IoT Central and IoT Central can send property updates to the device.|
|Severity|Only available for the event semantic type. The severities are Error, Information, or Warning.|
|State Values|Only available for the state semantic type. Define the possible state values, each of which has display name, name, enumeration type, and value.|
|Unit|A unit for the property value, such as mph, %, or °C.|
|Display Unit|A display unit for use on dashboards and forms.|
|Comment|Any comments about the property capability.|
|Description|A description of the property capability.|

### Commands

You can call device commands from IoT Central. Commands optionally pass parameters to the device and receive a response from the device. For example, you can call a command to reboot a device in 10 seconds.

The following table shows the configuration settings for a command capability:

|Field|Description|
|-----|-----------|
|Display Name|The display name for the command used on dashboards and forms.|
|Name|The name of the command. IoT Central generates a value for this field from the display name, but you can choose your own value if necessary.|
|Capability Type|Command.|
|Command|SynchronousExecutionType|
|Comment|Any comments about the command capability.|
|Description|A description of the command capability.|
|Request|If enabled, a definition of the request parameter, including: name, display name, schema, unit, and display unit.|
|Response|If enabled, a definition of the command response, including: name, display name, schema, unit, and display unit.|

## Manage an Interface

If you haven't published the interface, you can edit the capabilities defined by the interface. After you publish the interface, if you want to make any changes, you'll need to create a new version of the device template and version the interface. You can make changes that don't require versioning, such as display names or units, in the Customize section of the UI.

You can also export the interface as a JSON file if you want to reuse it in another capability model.

---

**Instructor Notes**

[Tutorial: Define a new IoT device type in your Azure IoT Central application (preview features)](https://docs.microsoft.com/en-us/azure/iot-central/preview/tutorial-define-iot-device-type)

**REPLACES**

[Set Up a Device Template](https://docs.microsoft.com/en-us/azure/iot-central/core/howto-set-up-template)

[Glossary of terms for IoT Plug and Play Preview](https://docs.microsoft.com/en-us/azure/iot-pnp/iot-plug-and-play-glossary)
