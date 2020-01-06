# Reprovisioning

During the lifecycle of an IoT solution, it's common to move devices between IoT hubs. The reasons for this move may include the following scenarios:

* Geolocation / GeoLatency: As a device moves between locations, network latency is improved by having the device migrated to a closer IoT hub.
* Multi-tenancy: A device may be used within the same IoT solution and reassigned to a new customer, or customer site. This new customer may be serviced using a different IoT hub.
* Solution change: A device could be moved into a new or updated IoT solution. This reassignment may require the device to communicate with a new IoT hub that's connected to other back-end components.
* Quarantine: Similar to a solution change. A device that's malfunctioning, compromised, or out-of-date may be reassigned to an IoT hub that can only update and get back in compliance. Once the device is functioning properly, it's then migrated back to its main hub.

Reprovisioning support within the Device Provisioning Service addresses these needs. Devices can be automatically reassigned to new IoT hubs based on the reprovisioning policy that's configured on the device's enrollment entry.

## Device state data

Device state data is composed of the device twin and device capabilities. This data is stored in the Device Provisioning Service instance and the IoT hub that a device is assigned to.

![Reprovisioning State 1](../../Linked_Image_Files/M03_L01_dps-reprovisioning-state1.png)

When a device is initially provisioned with a Device Provisioning Service instance, the following steps are done:

1. The device sends a provisioning request to a Device Provisioning Service instance. The service instance authenticates the device identity based on an enrollment entry, and creates the initial configuration of the device state data. The service instance assigns the device to an IoT hub based on the enrollment configuration and returns that IoT hub assignment to the device.

1. The provisioning service instance gives a copy of any initial device state data to the assigned IoT hub. The device connects to the assigned IoT hub and begins operations.

Over time, the device state data on the IoT hub may be updated by device operations and back-end operations. The initial device state information stored in the Device Provisioning Service instance stays untouched. This untouched device state data is the initial configuration.

![Reprovisioning State 2](../../Linked_Image_Files/M03_L01_dps-reprovisioning-state2.png)

Depending on the scenario, as a device moves between IoT hubs, it may also be necessary to migrate device state updated on the previous IoT hub over to the new IoT hub. This migration is supported by reprovisioning policies in the Device Provisioning Service.

## Reprovisioning policies

Depending on the scenario, a device usually sends a request to a provisioning service instance on reboot. It also supports a method to manually trigger provisioning on demand. The reprovisioning policy on an enrollment entry determines how the device provisioning service instance handles these provisioning requests. The policy also determines whether device state data should be migrated during reprovisioning. The same policies are available for individual enrollments and enrollment groups:

* Re-provision and migrate data: This policy is the default for new enrollment entries. This policy takes action when devices associated with the enrollment entry submit a new request (1). Depending on the enrollment entry configuration, the device may be reassigned to another IoT hub. If the device is changing IoT hubs, the device registration with the initial IoT hub will be removed. The updated device state information from that initial IoT hub will be migrated over to the new IoT hub (2). During migration, the device's status will be reported as Assigning.

![Reprovisioning State 3](../../Linked_Image_Files/M03_L01_dps-reprovisioning-state3.png)

* Re-provision and reset to initial config: This policy takes action when devices associated with the enrollment entry submit a new provisioning request (1). Depending on the enrollment entry configuration, the device may be reassigned to another IoT hub. If the device is changing IoT hubs, the device registration with the initial IoT hub will be removed. The initial configuration data that the provisioning service instance received when the device was provisioned is provided to the new IoT hub (2). During migration, the device's status will be reported as Assigning.

This policy is often used for a factory reset without changing IoT hubs.

![Reprovisioning State 4](../../Linked_Image_Files/M03_L01_dps-reprovisioning-state4.png)

* Never re-provision: The device is never reassigned to a different hub. This policy is provided for managing backwards compatibility.

### Managing backwards compatibility

Before September 2018, device assignments to IoT hubs had a sticky behavior. When a device went back through the provisioning process, it would only be assigned back to the same IoT hub.

For solutions that have taken a dependency on this behavior, the provisioning service includes backwards compatibility. This behavior is presently maintained for devices according to the following criteria:

1. The devices connect with an API version before the availability of native reprovisioning support in the Device Provisioning Service. Refer to the API table below.

1. The enrollment entry for the devices doesn't have a reprovisioning policy set on them.

This compatibility makes sure that previously deployed devices experience the same behavior that's present during initial testing. To preserve the previous behavior, don't save a reprovisioning policy to these enrollments. If a reprovisioning policy is set, the reprovisioning policy takes precedence over the behavior. By allowing the reprovisioning policy to take precedence, customers can update device behavior without having to reimage the device.

The following flow chart helps to show when the behavior is present:

![Reprovisioning Compatibility Flow Chart](../../Linked_Image_Files/M03_L01_dps-reprovisioning-compatibility-flow.png)

The following table shows the API versions before the availability of native reprovisioning support in the Device Provisioning Service:

| REST API               | C SDK             | Python SDK        | Node SDK         | Java SDK          | .NET SDK         |
|------------------------|-------------------|-------------------|------------------|-------------------|------------------|
| 2018-04-01 and earlier | 1.2.8 and earlier | 1.4.2 and earlier | 1.7.3 or earlier | 1.13.0 or earlier | 1.1.0 or earlier |

**Note**: These values and links are likely to change. This is only a placeholder attempt to determine where the versions can be determined by a customer and what the expected versions will be.

---

**Instructor notes**

[IoT Hub Device reprovisioning concepts](https://docs.microsoft.com/en-us/azure/iot-dps/concepts-device-reprovision)

(MCB) we are inconsistent with respect to "IoT Hub" and "IoT hub."  Also, for slides, I'm thinking the backcompat isn't that important - maybe a hidden optional slide if anything, since greenfields won't care.