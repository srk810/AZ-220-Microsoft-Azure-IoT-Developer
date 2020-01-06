# Create an IoT Edge Device Template

In the case of an IoT Edge device, the device template defines the capabilities of your device and IoT Edge modules. The Capabilities (component of the device template) include the telemetry the module sends, the module properties, and the commands a module responds to.

To create an IoT Edge Device Template:

1. In the IoT Central UI, select **Device template**, and the select **+ New**.

1. On the Select template type page, select **Azure IoT Edge**, and select **Next: Customize**.

    The Customize page enables you to select the deployment manifest for your edge device. Recall that at a high level a deployment manifest is a list of module twins that are configured with their desired properties. A deployment manifest tells an IoT Edge device (or a group of devices) which modules to install, and how to configure them. Deployment manifests include the desired properties for each module twin. IoT Edge devices report back the reported properties for each module.

    **Note** If you plan to create an IoT Edge Gateway device template, you will need to select the checkbox for **Gateway device with downstream devices**.

1. On the Customize device page, under **Upload an Azure IoT Edge deployment manifest**, select **Browse**.

1. In the file selection dialog box, select the deployment manifest file, and select **Open**.

    IoT Edge validates the deployment manifest file against a schema. 

1. If the validation is successful, select **Review**.

    This page shows a list of modules from the deployment manifest.

1. Select **Create**.

The following flowchart shows the life cycle of a deployment manifest in IoT Central.

![IoT Central - deployment manifest lifecycle](../../Linked_Image_Files/M11_L02-IoTCentral-edge-device-template-deployment-manifest-flow.png)

---

**Instructor Notes**

[Tutorial: Define a new Azure IoT Edge device type in your Azure IoT Central application (preview features)](https://docs.microsoft.com/en-us/azure/iot-central/preview/tutorial-define-edge-device-type)
