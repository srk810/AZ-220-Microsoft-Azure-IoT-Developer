# Create a Security Module Twin

Azure Security Center for IoT offers full integration with your existing IoT device management platform, enabling you to manage your device security status as well as make use of existing device control capabilities. Azure Security Center for IoT integration is achieved by making use of the IoT Hub twin mechanism.

Azure Security Center for IoT makes use of the module twin mechanism and maintains a security module twin named azureiotsecurity for each of your devices.

The security module twin holds all the information relevant to device security for each of your devices.

To make full use of Azure Security Center for IoT features, you'll need to create, configure and use these security module twins for your new IoT Edge device.

The security module twin azureiotsecurity can be created in two ways:

* [Module batch script](https://github.com/Azure/Azure-IoT-Security/tree/master/security_module_twin) - automatically creates module twin for new devices or devices without a module twin using the default configuration.
* Manually editing each module twin individually with specific configurations for each device.


In this lab, you will be creating a security module twin manually.

1. Naviagte to your new IoT Edge device if you are not there already. 
    1. On the Azure portal menu, click Dashboard and open your IoT Hub. You can also in the portal search bar type in your IoT Hub name and select your IoT Hub resource once it pops up.
    1. In your IoT Hub, locate **IoT Device Configuration** under **Automatic Device Management**.

1. Click on **EdgeDeviceID**, and then on Add module identity.
1. In the Module Identity Name field, enter **azureiotsecurity**.
    > [!NOTE] The Module Identity must be **azureiotsecurity** and not another unique name

1. Click Save.