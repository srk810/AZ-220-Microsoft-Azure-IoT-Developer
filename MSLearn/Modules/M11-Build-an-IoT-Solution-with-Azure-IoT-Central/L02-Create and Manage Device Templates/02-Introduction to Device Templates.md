# Introduction to Device Templates

A device template is a blueprint that defines the characteristics and behaviors of a type of device that connects to an Azure IoT Central application.

A device template contains:

* A device capability model that specifies the telemetry, properties, and commands that the device implements. These capabilities are organized into one or more interfaces.
* Cloud properties that define information that your IoT Central application stores about your devices. For example, a cloud property might record the date a device was last serviced. This information is never shared with the device.
* Customizations let the builder override some of the definitions in the device capability model. For example, the builder can override the name of a device property. Property names appear in IoT Central dashboards and forms.
* Dashboards and forms let the builder create a UI that lets operators monitor and manage the devices connected to your application.

## Device Template Example

As an example, a builder could create a device template for a connected fan that has the following characteristics:

* Sends temperature telemetry
* Sends location property
* Sends fan motor error events
* Sends fan operating state
* Provides a writeable fan speed property
* Provides a command to restart the device
* Gives you an overall view of the device via a dashboard

From this device template, an operator can create and connect real fan devices. All these fans have measurements, properties, and commands that operators use to monitor and manage them. Operators use the device dashboards and forms to interact with the fan devices.

**Note**: Only builders and administrators can create, edit, and delete device templates. Any user can create devices on the Devices page from existing device templates.

## Support for IoT Plug and Play

IoT Plug and Play enables IoT Central to integrate devices, without you writing any embedded device code. At the core of IoT Plug and Play is a device capability model schema that describes device capabilities. In an IoT Central Preview application, device templates use these IoT Plug and Play device capability models.

## Creating a device template

As a builder, you have several options for creating device templates:

* Design the device template in IoT Central, and then implement its device capability model in your device code.
* Import a device capability model from the Azure Certified for IoT device catalog. Then add any cloud properties, customizations, and dashboards your IoT Central application needs.
* Create a device capability model by using Visual Studio Code. Implement your device code from the model. Manually import the device capability model into your IoT Central application, and then add any cloud properties, customizations, and dashboards your IoT Central application needs.
* Create a device capability model by using Visual Studio Code. Implement your device code from the model, and connect your real device to your IoT Central application by using a device-first connection. IoT Central finds and imports the device capability model from the public repository for you. You can then add any cloud properties, customizations, and dashboards your IoT Central application needs to the device template.

### Create a device template from the device catalog

As a builder, you can quickly start building out your solution by using an IoT Plug and Play certified device. See the list in the Azure IoT Device Catalog. IoT Central integrates with the device catalog so you can import a device capability model from any of these IoT Plug and Play certified devices. To create a device template from one of these devices in IoT Central:

1. Go to the Device Templates page in your IoT Central application.

1. Select + New, and then select any of the IoT Plug and Play certified devices from the catalog. IoT Central creates a device template based on this device capability model.

1. Add any cloud properties, customizations, or views to your device template.

1. Select Publish to make the template available for operators to view and connect devices.

### Create a device template from scratch

To create a device template in IoT Central:

1. Go to the Device Templates page in your IoT Central application.

1. Select + New > Custom.

1. Enter a name for your template, such as Environmental Sensor.

1. Press Enter. IoT Central creates an empty device template.

## Manage a device template

You can rename or delete a template from the template's home page.
After you've added a device capability model to your template, you can publish it. Until you've published the template, you can't connect a device based on this template for your operators to see in the Devices page.

---

**Instructor Notes**

[Tutorial: Define a new IoT device type in your Azure IoT Central application (preview features)](https://docs.microsoft.com/en-us/azure/iot-central/preview/tutorial-define-iot-device-type)

**REPLACES**

[Set Up a Device Template](https://docs.microsoft.com/en-us/azure/iot-central/core/howto-set-up-template)
