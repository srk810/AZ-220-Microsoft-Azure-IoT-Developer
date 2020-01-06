# Deprovisioning Process

You may find it necessary to deprovision devices that were previously auto-provisioned through the Device Provisioning Service. For example, a device may be sold or moved to a different IoT hub, or it may be lost, stolen, or otherwise compromised.

In general, deprovisioning a device involves two steps:

* Disenroll the device from your provisioning service, to prevent future auto-provisioning. Depending on whether you want to revoke access temporarily or permanently, you may want to either disable or delete an enrollment entry. For devices that use X.509 attestation, you may want to disable/delete an entry in the hierarchy of your existing enrollment groups.

  * To learn how to disenroll a device, see [How to disenroll a device from Azure IoT Hub Device Provisioning Service](https://docs.microsoft.com/en-us/azure/iot-dps/how-to-revoke-device-access-portal).
  * To learn how to disenroll a device programmatically using one of the provisioning service SDKs, see [Manage device enrollments with service SDKs](https://docs.microsoft.com/en-us/azure/iot-dps/how-to-manage-enrollments-sdks).

* Deregister the device from your IoT Hub, to prevent future communications and data transfer. Again, you can temporarily disable or permanently delete the device's entry in the identity registry for the IoT Hub where it was provisioned. See [Disable devices](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-identity-registry#disable-devices) to learn more about disablement. See "Device Management / IoT Devices" for your IoT Hub resource, in the Azure portal.

The exact steps you take to deprovision a device depend on its attestation mechanism and its applicable enrollment entry with your provisioning service. 

---

**Instructor Notes**

[How to deprovision devices that were previously auto-provisioned](https://docs.microsoft.com/en-us/azure/iot-dps/how-to-unprovision-devices)
