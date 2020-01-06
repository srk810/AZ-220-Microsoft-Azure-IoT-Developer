# Device Management Patterns

IoT Hub enables the following set of device management patterns.

**Reboot**: The back-end app informs the device through a direct method that it has initiated a reboot. The device uses the reported properties to update the reboot status of the device.

![IoT Device Management - Device Reboot Pattern](../../Linked_Image_Files/M08_L01-DeviceManagement-reboot-pattern.png)

**Factory Reset**: The back-end app informs the device through a direct method that it has initiated a factory reset. The device uses the reported properties to update the factory reset status of the device.

![IoT Device Management - Factory Reset Pattern](../../Linked_Image_Files/M08_L01-DeviceManagement-factory-reset-pattern.png)

**Configuration**: The back-end app uses the desired properties to configure software running on the device. The device uses the reported properties to update configuration status of the device.

![IoT Device Management - Configuration Pattern](../../Linked_Image_Files/M08_L01-DeviceManagement-configuration-pattern.png)

**Firmware Update**: The back-end app uses an automatic device management configuration to select the devices to receive the update, to tell the devices where to find the update, and to monitor the update process. The device initiates a multistep process to download, verify, and apply the firmware image, and then reboot the device before reconnecting to the IoT Hub service. Throughout the multistep process, the device uses the reported properties to update the progress and status of the device.

![IoT Device Management - Firmware Update Pattern](../../Linked_Image_Files/M08_L01-DeviceManagement-firmware-update-pattern.png)

**Reporting Progress and Status**: The solution back end runs device twin queries, across a set of devices, to report on the status and progress of actions running on the devices.

![IoT Device Management - Reporting Progress and Status Pattern](../../Linked_Image_Files/M08_L01-DeviceManagement-reporting-progress-and-status-pattern.png)

---

**Instructor Notes**

[Overview of device management with IoT Hub](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-device-management-overview)
