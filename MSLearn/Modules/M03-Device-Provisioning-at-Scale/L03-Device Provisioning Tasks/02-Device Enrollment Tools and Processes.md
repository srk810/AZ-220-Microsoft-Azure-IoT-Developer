# Device Enrollment Tools and Processes

The tool that you choose for a particular device enrollment scenario, and the corresponding implementation steps, will vary based on situational requirements, but the processes are discrete and defined.

## Device Enrollment Processes

There are three enrollment process that you will need to perform on a semi-regular basis:

* Create: Create an enrollment when you need to prepare a device that want to have ready to register with the Azure IoT Hub Device Provisioning Service. The enrollment record will contain the initial desired configuration for the device.

* Update: Update a device enrollment if you want to change the IoT Hub that the device should be linked to, the device ID, or the initial device twin state for the device.

* Remove: Remove enrollments when an enrolled device will not be provisioned to an IoT Hub.

## Device Enrollment Tools

There are two primary tools that you should be familiar with for performing device enrollments:

* Device Provisioning Service in the portal

* Azure CLI with the Service SDKs

---

[How to manage device enrollments with Azure Device Provisioning Service SDKs](https://docs.microsoft.com/en-us/azure/iot-dps/how-to-manage-enrollments-sdks)
