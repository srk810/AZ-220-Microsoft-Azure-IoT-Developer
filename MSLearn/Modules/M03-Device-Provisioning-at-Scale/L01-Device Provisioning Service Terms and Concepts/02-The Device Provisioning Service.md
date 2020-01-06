# The Device Provisioning Service

Microsoft Azure provides a rich set of integrated public cloud services for all your IoT solution needs. The IoT Hub Device Provisioning Service is a helper service for IoT Hub that enables zero-touch, just-in-time provisioning to the right IoT hub without requiring human intervention, enabling customers to provision millions of devices in a secure and scalable manner.

## When to use Device Provisioning Service

There are many provisioning scenarios in which the Device Provisioning Service is an excellent choice for getting devices connected and configured to IoT Hub, such as:

* Zero-touch provisioning to a single IoT solution without hardcoding IoT Hub connection information at the factory (initial setup)
* Load balancing devices across multiple hubs
* Connecting devices to their owner’s IoT solution based on sales transaction data (multitenancy)
* Connecting devices to a particular IoT solution depending on use-case (solution isolation)
* Connecting a device to the IoT hub with the lowest latency (geo-sharding)
* Reprovisioning based on a change in the device
* Rolling the keys used by the device to connect to IoT Hub (when not using X.509 certificates to connect)

## How DPS Works Behind the Scenes

All the scenarios listed above can be done using the provisioning service for zero-touch provisioning with the same flow. Many of the manual steps traditionally involved in provisioning are automated with the Device Provisioning Service to reduce the time to deploy IoT devices and lower the risk of manual error. The following section describes what goes on behind the scenes to get a device provisioned. The first step is manual, all of the following steps are automated.

![DPS Provisioning Flow](../../Linked_Image_Files/M03_L01_dps-provisioning-flow.png)

1. Device manufacturer adds the device registration information to the enrollment list in the Azure portal.
2. Device contacts the provisioning service endpoint set at the factory. The device passes the identifying information to the provisioning service to prove its identity.
3. The provisioning service validates the identity of the device by validating the registration ID and key against the enrollment list entry using either a nonce challenge (Trusted Platform Module) or standard X.509 verification (X.509).
4. The provisioning service registers the device with an IoT hub and populates the device's desired twin state.
5. The IoT hub returns device ID information to the provisioning service.
6. The provisioning service returns the IoT hub connection information to the device. The device can now start sending data directly to the IoT hub.
7. The device connects to IoT hub.
8. The device gets the desired state from its device twin in IoT hub.

## Features of the Device Provisioning Service

* Secure attestation support for both X.509 and TPM-based identities.
* Enrollment list containing the complete record of devices/groups of devices that may at some point register. The enrollment list contains information about the desired configuration of the device once it registers, and it can be updated at any time.
* Multiple allocation policies to control how the Device Provisioning Service assigns devices to IoT hubs in support of your scenarios.
* Monitoring and diagnostics logging to make sure everything is working properly.
* Multi-hub support allows the Device Provisioning Service to assign devices to more than one IoT hub. The Device Provisioning Service can talk to hubs across multiple Azure subscriptions.
* Cross-region support allows the Device Provisioning Service to assign devices to IoT hubs in other regions.

## Cross-platform support

The Device Provisioning Service, like all Azure IoT services, works cross-platform with a variety of operating systems. Azure offers open-source SDKs in a variety of languages to facilitate connecting devices and managing the service. The Device Provisioning Service supports the following protocols for connecting devices:

* HTTPS
* AMQP
* AMQP over web sockets
* MQTT
* MQTT over web sockets

The Device Provisioning Service only supports HTTPS connections for service operations.

---

**Instructor Notes**

[Provisioning devices with Azure IoT Hub Device Provisioning Service](https://docs.microsoft.com/en-us/azure/iot-dps/about-iot-dps)

(MCB) This feels like another reveal slide for the 8 steps of the flow, or maybe even 8 slides.  I am a little concerned that we've brought up initial device state (before the connection to the Hub) a couple of times but haven't gotten the device there yet - do we need to start at the beginning?