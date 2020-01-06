# Auto-Provisioning

The Device Provisioning Service enables just-in-time provisioning of devices to an IoT hub, without requiring human intervention. After successful provisioning, devices connect directly with their designated IoT Hub. This process is referred to as auto-provisioning, and provides an out-of-the-box registration and initial configuration experience for devices.

## Three Phases of Auto-Provisioning

Azure IoT auto-provisioning can be broken into three phases:

1. Service configuration - a one-time configuration of the Azure IoT Hub and IoT Hub Device Provisioning Service instances, establishing them and creating linkage between them.

1. Device enrollment - the process of making the Device Provisioning Service instance aware of the devices that will attempt to register in the future. Enrollment is accomplished by configuring device identity information in the provisioning service, as either an "individual enrollment" for a single device, or a "group enrollment" for multiple devices. Identity is based on the attestation mechanism the device is designed to use, which allows the provisioning service to attest to the device's authenticity during registration:

    * Trusted Platform Module (TPM): configured as an "individual enrollment", the device identity is based on the TPM registration ID and the public endorsement key. Given that TPM is a specification, the service only expects to attest per the specification, regardless of TPM implementation (hardware or software). TPM is a type of hardware security module (HSM).

    * X509: configured as either an "individual enrollment" or "group enrollment", the device identity is based on an X.509 digital certificate, which is uploaded to the enrollment as a .pem or .cer file.

    **Note**: Although not a prerequisite for using Device Provisioning Services, Microsoft strongly recommends that your device use a Hardware Security Module (HSM) to store sensitive device identity information, such as keys and X.509 certificates.

1. Device registration and configuration - initiated upon boot up by registration software, which is built using a Device Provisioning Service client SDK appropriate for the device and attestation mechanism. The software establishes a connection to the provisioning service for authentication of the device, and subsequent registration in the IoT Hub. Upon successful registration, the device is provided with its IoT Hub unique device ID and connection information, allowing it to pull its initial configuration and begin the telemetry process. In production environments, this phase can occur weeks or months after the previous two phases.

## Auto-provisioning Operation

The following diagram summarizes the sequencing of operations during device auto-provisioning: 

![Auto-Provisioning Operation](../../Linked_Image_Files/M03_L01_Auto-provisioning-diagram.png)

| Operation                            | Description                                                                                                                                                                                                        |
|--------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Encode identity and registration URL | Based on the attestation mechanism used, the manufacturer is responsible for encoding the device identity info, and the Device Provisioning Service registration URL.                                              |
| Provide device identity              | As the originator of the device identity info, the manufacturer is responsible for communicating it to the operator (or a designated agent), or directly enrolling it to the Device Provisioning Service via APIs. |
| Configure auto-provisioning          | This operation corresponds with the first phase of auto-provisioning.                                                                                                                                              |
| Enroll device identity               | This operation corresponds with the second phase of auto-provisioning.                                                                                                                                             |
| Build/Deploy registration software   | This operation corresponds with the third phase of auto-provisioning. The Developer is responsible for building and deploying the registration software to the device, using the appropriate SDK.                  |
| Bootup and register                  | This operation corresponds with the third phase of auto-provisioning, fulfilled by the device registration software built by the Developer.                                                                        |

---

**Instructor Notes**

[Auto-provisioning concepts](https://docs.microsoft.com/en-us/azure/iot-dps/concepts-auto-provisioning)

(MCB) The operation diagram looks like one that would end up on a slide but be unreadable there.  There's probably no time to recreate it in a usable way for a slide but the need is there.