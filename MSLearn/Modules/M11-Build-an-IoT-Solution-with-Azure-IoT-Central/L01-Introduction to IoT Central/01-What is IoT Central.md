# What is Azure IoT Central?

**Note**: This training includes the use of features that are only available in the preview release of Azure IoT Central.

**Warning** The IoT Plug and Play capabilities in Azure IoT Central are currently in public preview. Don't use an IoT Plug and Play enabled IoT Central application template for production workloads. For production environments use an IoT central application created from a current, generally available, application template.

Azure IoT Central is an IoT app platform that reduces the burden and cost of developing, managing, and maintaining enterprise-grade IoT solutions. Choosing to build with Azure IoT Central gives you the opportunity to focus your time, money, and energy on transforming your business with IoT data, rather than just maintaining and updating a complex and continually evolving IoT infrastructure.

The easy-to-use interface makes it simple to monitor device conditions, create rules, and manage millions of devices and their data throughout their life cycle. Furthermore, it enables you to act on device insights by extending IoT intelligence into line-of-business applications.

**Note**: As an Azure IoT Developer it is important to know when and how to implement Azure IoT Central for your business or a for customer.

## User Personas

There are four primary users, or personas, who interact with the Azure IoT Central application. You can think of these personas as four different people, or as one person performing four different roles:

* A builder is responsible for defining the types of devices that connect to the application and customizing the application for the operator.
* An operator manages the devices connected to the application.
* An administrator is responsible for tasks such as managing user roles and permissions within the application.
* A device developer creates the code that runs on a device connected to your application.

## Create your Azure IoT Central application

As a solution builder, you use Azure IoT Central to create a custom, cloud-hosted IoT solution for your organization. A custom IoT solution typically consists of:

* A cloud-based application that receives telemetry from your devices and enables you to manage those devices.
* Multiple devices running custom code connected to your cloud-based application.

You can quickly deploy a new IoT Central application and then customize it to your specific requirements in your browser. As a solution builder, you use the web-based tools to create a device template for the devices that connect to your application. A device template is the blueprint that defines the characteristics and behavior of a type of device such as the:

* Telemetry it sends.
* Business properties that an operator can modify.
* Device properties that are set by a device and are read-only in the application.
* Properties, that an operator sets, that determine the behavior of the device.

This device template includes:

* A device capability model that describes the capabilities a device should implement such as the telemetry it sends and the properties it reports.
* Cloud properties that aren't stored on the device.
* Customizations, dashboards, and forms that are part of your IoT Central application.

### Create device templates

IoT Plug and Play enables IoT Central to integrate devices without you writing any embedded device code. At the core of IoT Plug and Play, is a device capability model schema that describes device capabilities. In an IoT Central preview application, device templates use these IoT Plug and Play device capability models.

As a solution builder, you have several options for creating device templates:

* Design the device template in IoT Central and then implement its device capability model in your device code.
* Import a device capability model from the Azure Certified for IoT device catalog and then add any cloud properties, customizations, and dashboards your IoT Central application needs.
* Create a device capability model using Visual Studio code. Implement your device code from the model, and connect your device to your IoT Central application. IoT Central finds the device capability model from a repository and creates a simple device template for you.
* Create a device capability model using Visual Studio code. Implement your device code from the model. Manually import the device capability model into your IoT Central application and then add any cloud properties, customizations, and dashboards your IoT Central application needs.

As a solution builder, you can use IoT Central to generate code for test devices to validate your device templates.

### Customize the UI

As a solution builder, you can also customize the IoT Central application UI for the operators who are responsible for the day-to-day use of the application. Customizations that a solution builder can make include:

* Defining the layout of properties and settings on a device template.
* Configuring custom dashboards to help operators discover insights and resolve issues faster.
* Configuring custom analytics to explore time series data from your connected devices.

## Connect your devices

After the builder defines the types of devices that can connect to the application, a device developer creates the code to run on the devices. As a device developer, you use Microsoft's open-source Azure IoT SDKs to create your device code. These SDKs have broad language, platform, and protocol support to meet your needs to connect your devices to your Azure IoT Central application. The SDKs help you implement the following device capabilities:

* Create a secure connection.
* Send telemetry.
* Report status.
* Receive configuration updates.

### Azure IoT Edge devices

As well as devices created using the Azure IoT SDKs, you can also connect Azure IoT Edge devices to an IoT Central application. Azure IoT Edge lets you run cloud intelligence and custom logic directly on IoT devices managed by IoT Central. The IoT Edge runtime enables you to:

* Install and update workloads on the device.
* Maintain Azure IoT Edge security standards on the device.
* Ensure that IoT Edge modules are always running.
* Report module health to the cloud for remote monitoring.
* Manage communication between downstream leaf devices and an IoT Edge device, between modules on an IoT Edge device, and between an IoT Edge device and the cloud.

## Manage your application

Azure IoT Central applications are fully hosted by Microsoft, which reduces the administration overhead of managing your applications.

As an operator, you use the Azure IoT Central application to manage the devices in your Azure IoT Central solution. Operators do tasks such as:

* Monitoring the devices connected to the application.
* Troubleshooting and remediating issues with devices.
* Provisioning new devices.

As a solution builder, you can define custom rules and actions that operate over data streaming from connected devices. An operator can enable or disable these rules at the device level to control and automate tasks within the application.

Administrators manage access to your application with user roles and permissions.

## Quotas

Each Azure subscription has default quotas that could impact the scope of your IoT solution. Currently, IoT Central limits the number of applications you can deploy in a subscription to 10. If you need to increase this limit, contact Microsoft support.

## Known issues

**Note**: These known issues only apply to the IoT Central preview applications.

* Rules don't support all actions (only email).
* For complex types - rules, analytics, and device groups aren't supported.
* Continuous data export doesn't support the Avro format (incompatibility).
* Simulated devices don't support all complex types.
* GeoJSON isn't currently supported.
* Map tile isn't currently supported.
* Jobs don't support complex types.
* Array schema types aren't supported.
* Application template export and application copy aren't supported.
* Only the C device SDK and the Node.js device and service SDKs are supported.
* It's only available in the United States and Europe locations.
* Device capability models must have all the interfaces defined inline in the same file.

---

**Instructor Notes**

[What is Azure IoT Central?](https://docs.microsoft.com/en-us/azure/iot-central/core/overview-iot-central)
