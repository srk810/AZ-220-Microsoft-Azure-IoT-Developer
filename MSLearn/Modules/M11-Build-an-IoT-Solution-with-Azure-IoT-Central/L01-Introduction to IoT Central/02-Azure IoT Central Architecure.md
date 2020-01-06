# Azure IoT Central Architecture

Azure IoT Central app platform is built on top of the Azure IoT PaaS services and the architecture shown here:

![IoT Central - Architecture](../../Linked_Image_Files/M11_L01-IoTCentral-architecture.png)

## Devices

Devices exchange data with your Azure IoT Central application. A device can:

* Send measurements such as telemetry.
* Synchronize settings with your application.

In Azure IoT Central, the data that a device can exchange with your application is specified in a device template.

## Azure IoT Edge devices

As well as devices created using the Azure IoT SDKs, you can also connect Azure IoT Edge devices to an IoT Central application. IoT Edge lets you run cloud intelligence and custom logic directly on IoT devices managed by IoT Central. The IoT Edge runtime enables you to:

* Install and update workloads on the device.
* Maintain IoT Edge security standards on the device.
* Ensure that IoT Edge modules are always running.
* Report module health to the cloud for remote monitoring.
* Manage communication between downstream leaf devices and an IoT Edge device, between modules on an IoT Edge device, and between an IoT Edge device and the cloud.

![IoT Central - Architecture](../../Linked_Image_Files/M11_L01-IoTCentral-iotedge-device-connection.png)

IoT Central enables the following capabilities to for IoT Edge devices:

* Device templates to describe the capabilities of an IoT Edge device, such as:

  * Deployment manifest upload capability, which helps you manage a manifest for a fleet of devices.
  * Modules that run on the IoT Edge device.
  * The telemetry each module sends.
  * The properties each module reports.
  * The commands each module responds to.
  * The relationships between an IoT Edge gateway device capability model and downstream device capability model.
  * Cloud properties that aren't stored on the IoT Edge device.
  * Customizations, dashboards, and forms that are part of your IoT Central application.

* The ability to provision IoT Edge devices at scale using Azure IoT device provisioning service.
* Rules and actions.
* Custom dashboards and analytics.
* Continuous data export of telemetry from IoT Edge devices.

### IoT Edge device types

IoT Central classifies IoT Edge device types as follows:

* Standalone devices. An IoT Edge standalone device can have downstream leaf devices, but these devices aren't provisioned in IoT Central.
* Gateway devices with downstream devices. Both gateway device and downstream devices are provisioned in IoT Central.

## Cloud gateway

Azure IoT Central uses Azure IoT Hub as a cloud gateway that enables device connectivity.

## Data stores

Azure IoT Central stores application data in the cloud. Application data stored includes:

* Device templates.
* Device identities.
* Device metadata.
* User and role data.

Azure IoT Central uses a time series store for the measurement data sent from your devices.

## Analytics

The analytics service is responsible for generating the custom reporting data that the application displays. An operator can customize the analytics displayed in the application. The analytics service is built on top of Azure Time Series Insights and processes the measurement data sent from your devices.

## Rules and actions

Rules and actions work closely together to automate tasks within the application. A builder can define rules based on device telemetry such as the temperature exceeding a defined threshold. Azure IoT Central uses a stream processor to determine when the rule conditions are met. When a rule condition is met, it triggers an action defined by the builder. For example, an action can send an email to notify an engineer that the temperature in a device is too high.

IoT Central device templates provide a device definition that includes:

* **Device capability model**: Device capability models specify the capabilities of a device such as the telemetry it sends, the properties that define the device state, and the commands the device responds to. Device capabilities are organized into one or more interfaces.
* **Cloud properties**: Cloud properties specify the properties IoT Central stores for a device. These properties are only stored in IoT Central and are never sent to a device.
* **Views**: Views specify the dashboards and forms the builder creates to let the operator monitor and manage the devices.
* **Customizations**: Customizations let the builder override some of the definitions in the device capability model to make them more relevant to the IoT Central application.

An IoT Central application can have one or more simulated and real devices based on each device template.

## Data export

In an Azure IoT Central application, you can continuously export your data to your own Azure Event Hubs and Azure Service Bus instances. You can also periodically export your data to your Azure Blob storage account. IoT Central can export measurements, devices, and device templates.

## Batch device updates

In an Azure IoT Central application, you can create and run jobs to manage connected devices. These jobs let you do bulk updates to device properties or settings, or run commands. For example, you can create a job to increase the fan speed for multiple refrigerated vending machines.

## Role-based access control (RBAC)

An administrator can define access rules for an Azure IoT Central application using the predefined roles. An administrator can assign users to roles that determine what areas of the application the user has access to.

## Security

Security features within Azure IoT Central include:

* Data is encrypted in transit and at rest.
* Authentication is provided either by Azure Active Directory or Microsoft Account. Two-factor authentication is supported.
* Full tenant isolation.
* Device level security.

## UI shell

The UI shell is a modern, responsive, HTML5 browser-based application. An administrator can customize the UI of the application by applying custom themes and modifying the help links to point to your own custom help resources.

An operator can create personalized application dashboards. You can have several dashboards that display different data and switch between them.

---

**Instructor Notes**

[Azure IoT Central architecture (preview features)](https://docs.microsoft.com/en-us/azure/iot-central/preview/concepts-architecture)

**REPLACES**

[Azure IoT Central architecture](https://docs.microsoft.com/en-us/azure/iot-central/core/concepts-architecture)
