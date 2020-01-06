# Device Management using the Azure IoT Tools for VS Code

Azure IoT Tools extension for Visual Studio Code includes the ability to perform device management tasks.

|Management option|Task|
|-----------------|----|
|Invoke Direct Method|Make a device perform an action, such as starting or stopping the process of sending messages, or rebooting the device.|
|Edit Device Twin|Examine reported properties to get the reported state of a device. For example, the device reports the LED is blinking now.<br>Use resired properties to put a device into certain states, such as setting an LED to green or setting the telemetry send interval to 30 minutes.|
|Cloud-to-device messages|Send notifications to a device. For example, "It is very likely to rain today. Don't forget to bring an umbrella."|

The Azure IoT Tools extension provides additional capabilities for working with devices in addition to these device management capablities.

## Access Your IoT Hub and Devices

When using the Azure IoT Tools extension for VS Code, the first step is to access to your IoT Hub through your Azure subscription.

* In the bottom left corner of the VS Code window, click **Azure IoT Hub**.

    When the Azure IoT Tools extension for VS Code is installed, the Azure IoT Hub section is added to the VS Code Explorer pane.
 
1. To the right of Azure IoT Hub, click the elipsis (...).

    The elipsis (...) provides access to the More Options context menu.

1. On the content menu, click **Select IoT Hub**

    A pop-up will be displayed on screen to let you sign in to Azure.

    After you sign in, your Azure Subscription list will be shown. 

1. Select the Azure Subscription that you will be using.

1. Select the IoT Hub that you will be using.

    After a few seconds, the VS Code Explorer pane will be updated to show a Devices section under Azure IoT Hub. The Devices section will display a list of the devices connected to the IoT Hub that your selected.

## Access Device Management Commands

You can access the device management commands by right-clicking a device in the Explorer pane, and then selecting a command from the context menu.

### Invoke a Direct Method

To invoke a direct method on a device:

1. In the VS Code Explorer pane, right-click the device that you are interested in.

1. On the context menu for your device, click **Invoke Direct Method**.

1. Enter the method name in the input box, and then the associated payload value.

    The results will be shown in OUTPUT > Azure IoT Hub Toolkit view. If the direct method that you specify does exist on the device, you will see message similar to the following:

    Failed to invike Direct Method: Not found 

### Review a Device Twin

To review the contents of a device twin document (json file):

1. In the VS Code Explorer pane, right-click the device that you are interested in.

1. On the context menu for your device, click **Edit Device Twin**.

    An azure-iot-device-twin.json file will be opened in VS Code showing the contents of the device twin document.

### Update a Device Twin 

After opening a device twin document, you can update desired properties as follows:

1. Make some edits to the properties.desired field.

    You can also make changes to tags. Tags can be used to support of device management tasks that act on a group of devices that have the same tag value setting.
 
1. Right-click anywhere within the azure-iot-device-twin.json document.

    This will open the VS Code context menu for the open document.
 
1. On the context menu, to save the changes to the device twin, click **Update Device Twin**.

### Send Cloud-to-Device Messages

To send a message from your IoT hub to your device, follow these steps:

1. In the VS Code Explorer pane, right-click the device that you are interested in.

1. On the context menu for your device, click **Send C2D Message to Device**.

1. Enter the message in input box.

    Results will be shown in OUTPUT > Azure IoT Hub Toolkit view.

---

**Instructor Notes**

[Use Azure IoT Tools for Visual Studio Code for Azure IoT Hub device management](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-device-management-iot-toolkit)
