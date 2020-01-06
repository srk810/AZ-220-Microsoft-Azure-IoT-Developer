# Azure IoT Devices

The devices that you implement within an Azure IoT solution can range from constrained sensors and single purpose microcontrollers, to powerful gateways that route communications for groups of devices.

**Note**: Microsoft maintains an online device catalog that provides a list of hardware devices certified to work with IoT Hub - [Azure Certified for IoT Device Catalog](https://catalog.azureiotsolutions.com/alldevices).

## Azure IoT Device Types

For the purpose of this course, we will describe the devices that connect to IoT Hub as being one of the following; IoT Devices, IoT Edge Devices, or Simulated Devices.

* IoT Devices: An IoT device is typically a small-scale, standalone computing device that may collect data or control other devices. For example, a device might be an environmental monitoring device, or a controller for the watering and ventilation systems in a greenhouse.

* IoT Edge Devices: IoT Edge devices have the IoT Edge runtime installed and are flagged as IoT Edge device in the device details. An IoT Edge device can be used as a field gateway device, meaning that it is an IoT Edge device that connects downstream devices to the Azure IoT Hub (downstream devices can be either IoT devices or IoT Edge devices).

* Simulated Devices: A simulated device is a software representation of a physical device that runs on your local machine or in the cloud. Simulated devices can be used in various stages during the rollout of an IoT solution to represent individual device behaviors or to generate a telemetry workload.

## Create an IoT Device using the Azure Portal

When you create a new IoT device using the Azure portal, you will specify a device ID and a method for device authentication. IoT hub uses an identity registry to store information about the individual devices that are permitted to connect to it.

* Device ID: The device identity is a unique identifier that is assigned to a device.

* Authentication Type: Device authentication can be accomplished using either a Symmetric key pair or X.509 Certificate. The certificate can either be self-signed or come from a certificate authority.

---

**Instructor Notes**

[Azure Certified for IoT Device Catalog](https://catalog.azureiotsolutions.com/alldevices)

[device concepts](https://docs.microsoft.com/en-us/azure/iot-dps/concepts-device)

[Understand the identity registry in your IoT hub](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-identity-registry)

[How an IoT Edge device can be used as a gateway](https://docs.microsoft.com/en-us/azure/iot-edge/iot-edge-as-gateway)

[Understand Azure IoT Edge modules](https://docs.microsoft.com/en-us/azure/iot-edge/iot-edge-modules)
