# Device Identity

Every IoT hub has an identity registry that stores information about the devices permitted to connect to the IoT hub. Before a device can connect to an IoT hub, there must be an entry for that device in the IoT hub's identity registry. A device must also authenticate with the IoT hub based on credentials stored in the identity registry.

The device ID stored in the identity registry is case-sensitive.

At a high level, the identity registry is a REST-capable collection of device identity resources. When you add an entry in the identity registry, IoT Hub creates a set of per-device resources such as the queue that contains in-flight cloud-to-device messages.

Use the identity registry when you need to:

* Provision devices that connect to your IoT hub.
* Control per-device access to your hub's device-facing endpoints.

## Module Identity

In IoT Hub, under each device identity, you can create up to 20 module identities. Each module identity implicitly generates a module twin. Similar to device twins, module twins are JSON documents that store module state information including metadata, configurations, and conditions. Azure IoT Hub maintains a module twin for each module that you connect to IoT Hub.

On the device side, the IoT Hub device SDKs enable you to create modules where each one opens an independent connection to IoT Hub. This functionality enables you to use separate namespaces for different components on your device. For example, you have a vending machine that has three different sensors. Each sensor is controlled by different departments in your company. You can create a module for each sensor. This way, each department is only able to send jobs or direct methods to the sensor that they control, avoiding conflicts and user errors.

Module identity and module twin provide the same capabilities as device identity and device twin but at a finer granularity. This finer granularity enables capable devices, such as operating system-based devices or firmware devices managing multiple components, to isolate configuration and conditions for each of those components. Module identity and module twins provide a management separation of concerns when working with IoT devices that have modular software components.

## Identity registry operations

The IoT Hub identity registry exposes the following operations:

* Create device or module identity
* Update device or module identity
* Retrieve device or module identity by ID
* Delete device or module identity
* List up to 1000 identities
* Export device identities to Azure blob storage
* Import device identities from Azure blob storage

---

**Instructor Notes**

[Understand the identity registry in your IoT hub](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-identity-registry)

[Understand and use module twins in IoT Hub](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-module-twins)
