# Introduction to Device Twins

Device twins are JSON documents that store device state information including metadata, configurations, and conditions. Azure IoT Hub maintains a device twin for each device that you connect to IoT Hub.

Device twins store device-related information that:

* Device and back ends can use to synchronize device conditions and configuration.
* The solution back end can use to query and target long-running operations.

The lifecycle of a device twin is linked to the corresponding device identity. Device twins are implicitly created and deleted when a device identity is created or deleted in IoT Hub.

A device twin is a JSON document that includes:

* Tags. A section of the JSON document that the solution back end can read from and write to. Tags are not visible to device apps.
* Desired properties. Used along with reported properties to synchronize device configuration or conditions. The solution back end can set desired properties, and the device app can read them. The device app can also receive notifications of changes in the desired properties.
* Reported properties. Used along with desired properties to synchronize device configuration or conditions. The device app can set reported properties, and the solution back end can read and query them.
* Device identity properties. The root of the device twin JSON document contains the read-only properties from the corresponding device identity stored in the identity registry.

![Device Twin Diagram](../../Linked_Image_Files/M02_L01_DeviceTwinDiagram.png)

## Example

The following example shows a device twin JSON document:

```json
{
    "deviceId": "devA",
    "etag": "AAAAAAAAAAc=", 
    "status": "enabled",
    "statusReason": "provisioned",
    "statusUpdateTime": "0001-01-01T00:00:00",
    "connectionState": "connected",
    "lastActivityTime": "2015-02-30T16:24:48.789Z",
    "cloudToDeviceMessageCount": 0, 
    "authenticationType": "sas",
    "x509Thumbprint": {     
        "primaryThumbprint": null, 
        "secondaryThumbprint": null 
    }, 
    "version": 2, 
    "tags": {
        "$etag": "123",
        "deploymentLocation": {
            "building": "43",
            "floor": "1"
        }
    },
    "properties": {
        "desired": {
            "telemetryConfig": {
                "sendFrequency": "5m"
            },
            "$metadata" : {...},
            "$version": 1
        },
        "reported": {
            "telemetryConfig": {
                "sendFrequency": "5m",
                "status": "success"
            },
            "batteryLevel": 55,
            "$metadata" : {...},
            "$version": 4
        }
    }
}
```

## Usage

Use device twins to:

* Store device-specific metadata in the cloud. For example, the deployment location of a vending machine.
* Report current state information such as available capabilities and conditions from your device app. For example, a device is connected to your IoT hub over cellular or WiFi.
* Synchronize the state of long-running workflows between device app and back-end app. For example, when the solution back end specifies the new firmware version to install, and the device app reports the various stages of the update process.
* Query your device metadata, configuration, or state.

## Purpose and Best Practices

Device twins enable synchronizing desired configuration from the cloud and for reporting current configuration and device properties. The best way to implement device twins within cloud solutions applications is through the Azure IoT SDKs. Device twins are best suited for configuration because they:

* Support bi-directional communication.
* Allow for both connected and disconnected device states.
* Follow the principle of eventual consistency.
* Are fully queryable in the cloud.

---

**Instructor Notes**

The intent is to introduce the concept of devices twins and show what they are, but not to actually implement device twins in any real way at this time. Device twins will be used more meaningfully in the DPS module and then again during the device management module.

[Understand and use device twins in IoT Hub](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-device-twins)

Best Practices for Device Twins - [Best practices for device configuration within an IoT solution](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-configuration-best-practices)
