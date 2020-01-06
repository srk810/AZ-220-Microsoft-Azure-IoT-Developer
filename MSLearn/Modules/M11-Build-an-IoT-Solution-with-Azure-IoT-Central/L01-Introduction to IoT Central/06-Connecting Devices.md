# Connecting Devices

Azure IoT Central uses the Azure IoT Hub Device Provisioning service (DPS) to manage all device registration and connection.

Using DPS enables:

* IoT Central to support onboarding and connecting devices at scale.
* You to generate device credentials and configure the devices offline without registering the devices through IoT Central UI.
* Devices to connect using shared access signatures (SAS).
* Devices to connect using industry-standard X.509 certificates.
* You to use your own device IDs to register devices in IoT Central. Using your own device IDs simplifies integration with existing back-office systems.
* A single, consistent way to connect devices to IoT Central.

## Connect a single device

This approach is useful when you're experimenting with IoT Central or testing devices. You can use the device connection information from your IoT Central application to connect a device to your IoT Central application using the Device Provisioning Service (DPS).

## Connect devices at scale using SAS

To connect devices to IoT Central at scale using SAS, you need to register and then set up the devices.

### Register devices in bulk

To register a large number of devices with your IoT Central application, use a CSV file to import device IDs and device names. Once your devices are registered, you can export a CSV file from your IoT Central application that includes the connection information for the imported devices (including device keys and X509 certificate thumbprints).

### Set up your devices

Use the connection information from the export file in your device code to enable your devices to connect and send data to IoT to your IoT Central application.

## Connect devices using X.509 certificates

In a production environment, using X.509 certificates is the recommended device authentication mechanism for IoT Central.

The following steps describe how to connect devices to IoT Central using X.509 certificates:

1. In your IoT Central application, add and verify the intermediate or root X.509 certificate you're using to generate device certificates.

    * In the UI menu, navigate to Administration > Device Connection > Certificates (X.509) and add X.509 root or intermediate certificate you're using to generate the leaf device certificates.

    * It is important to verify that the uploader of the certificate has the certificate's private key.

      * To generate a verification code, select the button next to Verification Code.

      * Use the verification code that you generated to create an X.509 verification certificate.

      * Save the certificate as a .cer file.

      * Upload the signed verification certificate and select Verify.

1. Use a CSV file to import and register devices in your IoT Central application.

1. Set up your devices.

    Generate the leaf certificates using the uploaded root certificate. Use the Device ID as the CNAME value in the leaf certificates. The device ID should be all lower case. Then program your devices with provisioning service information. When a device is switched on for the first, it retrieves its connection information for your IoT Central application from DPS.

## Connect without registering devices

A key scenario IoT Central enables is for OEMs to mass manufacture devices that can connect to an IoT Central application without first being registered. A manufacturer must generate suitable credentials, and configure the devices in the factory. When a device turns on for the first time, it connects automatically to an IoT Central application. An IoT Central operator must approve the device before it can stat sending data.

The following diagram outlines this flow:

![IoT Central - connect without registering devices](../../Linked_Image_Files/M11_L01-IoTCentral-device-connection-flow1.png)

The following steps describe this process in more detail. The steps differ slightly depending on whether you're using SAS or X.509 certificates for device authentication:

1. Configure your connection settings:

    * **X.509 Certificates**: Add and verify the root/intermediate certificate and use it to generate the device certificates in the following step.

    * **SAS**: Copy the primary key. This key is the group SAS key for the IoT Central application. Use the key to generate the device SAS keys in the following step.

1. Generate your device credentials

    * **Certificates X.509**: Generate the leaf-certificates for your devices using the root or intermediate certificate you added to your IoT Central application. Make sure you use the lower-case **Device ID** as the CNAME in the leaf certificates. For testing purposes only, use this command-line tool to generate device certificates [https://github.com/Azure/azure-iot-sdk-c/blob/master/tools/CACertificates/CACertificateOverview.md](https://github.com/Azure/azure-iot-sdk-c/blob/master/tools/CACertificates/CACertificateOverview.md).

    * **SAS**: Use this command line tool to generate device SAS keys [https://www.npmjs.com/package/dps-keygen](https://www.npmjs.com/package/dps-keygen). Use the group **Primary Key** from the previous step. The Device ID must be lower-case.

1. To set up your devices, flash each device with the **Scope ID**, **Device ID**, and **X.509 device certificate** or **SAS key**.

1. Then turn on the device for it to connect to your IoT Central application. When you switch on a device, it first connects to DPS to retrieve its IoT Central registration information.

1. The connected device initially shows up as **Unassociated** on the **Devices** page. The device provisioning status is **Registered**. **Migrate** the device to the appropriate device template and approve the device to connect to your IoT Central application. The device can then retrieve a connection string from IoT Hub and start sending data. Device provisioning is now complete and the provisioning status is now **Provisioned**.

## Individual enrollment based device connectivity

For customers connecting devices that have authentication credentials that are per device individual enrollment is the option. An individual enrollment is an entry for a single device that may connect. Individual enrollments may use either X.509 leaf certificates or SAS tokens (from a physical or virtual TPM) as attestation mechanisms. The device ID (aka registration ID) in an individual enrollment is alphanumeric, lowercase, and may contain hyphens.

**Note**: When you create an Individual enrollment for a device it takes precedence over the default Group enrollment based attestations (SAS, X509) in your app.

### Creating individual enrollments

IoT Central supports the following attestation mechanisms

1. **Symmetric key attestation**: Symmetric key attestation is a simple approach to authenticating a device with a Device Provisioning Service instance. To create an individual enrollment with Symmetric keys; open the Connect dialog, select Individual Enrollment and Mechanism “SAS” and input the Primary and Secondary keys. SAS keys must be base64 encoded. Here is the link to code samples to help write your device code to provision devices using Symmetric keys and individual enrollments.

1. **X.509 certificates**: X.509 certificates as the title suggests is a cert based attestation mechanism, an excellent way to scale production. To create an individual enrollment with Symmetric keys select Individual Enrollment and Mechanism “X.509” and upload the primary and secondary certificates and save to create the enrollment. Device certificates used with an Individual enrollment entry have a requirement that the Subject Name must be set to the Device ID (aka registration ID) of the Individual Enrollment entry.

1. **TPM attestation**: TPM stands for Trusted Platform Module and is a type of hardware security module (HSM) and is one of the most secure ways to connect your devices. This article assumes you are using a discrete, firmware, or integrated TPM. Software emulated TPMs are well-suited for prototyping or testing, but they do not provide the same level of security as discrete, firmware, or integrated TPMs do. We do not recommend using software TPMs in production. To create an individual enrollment with Symmetric keys select Individual Enrollment and Mechanism “TPM” and input the endorsement keys to create the enrollment.For more information about types of TPMs, you can learn more about TPM attestation here. Here is the link to code samples to help write your device code to provision devices using TPM. To create a TPM based attestation, type in the endorsement key and save.

## Connect devices with IoT Plug and Play

One of the key features of IoT Plug and Play with IoT Central is the ability to associate device templates automatically on device connection. Along with device credentials, devices can now send the **CapabilityModelId** as part of the device registration call and IoT Central will discover and associate the device template. The discovery process follows the following order:

Associates with the device template if it's already published in the IoT Central application.
Fetches from the public repository of published and certified capability models.

Below is the format of the additional payload the device would send during the DPS registration call

```javascript
'__iot:interfaces': {
              CapabilityModelId: <this is the URN for the capability model>
          }
```

**Note**: Note that the Auto-Approve option should be enabled for devices to automatically connect, discover the model and start sending data.

## Device status

When a real device connects to your IoT Central application, its device status changes as follows:

1. The device status is first **Registered**. This status means the device is created in IoT Central, and has a device ID. A device is registered when:

    * A new real device is added on the **Devices** page.
    * A set of devices is added using **Import** on the **Devices** page.

1. The device status changes to **Provisioned** when the device that connected to your IoT Central application with valid credentials completes the provisioning step. In this step, the device retrieves a connection string from IoT Hub. The device can now connect to IoT Hub and start sending data.

1. An operator can block a device. When a device is blocked, it can't send data to your IoT Central application. Blocked devices have a status of **Blocked**. An operator must reset the device before it can resume sending data. When an operator unblocks a device the status returns to its previous value, **Registered** or **Provisioned**.

1. The device status is **Waiting for Approval** which means the **Auto Approve** option is disabled and requires all the devices connecting to IoT Central be explicitly approved by an operator. Devices not registered manually on the **Devices** page, but connected with valid credentials will have the device status **Waiting for Approval**. Operators can approve these devices from the **Devices** page using the **Approve** button.

1. The device status is **Unassociated** which means that the devices connecting to IoT Central do not have a Device Template associated to them. This typically happens in the following scenarios:

    * A set of devices is added using **Import** on the **Devices** page without specifying the Device Template
    * Devices not registered manually on the **Devices** page connected with valid credentials but without specifying the Template ID during registration.
    * The Operator can associate a device to a Template from the **Devices** page using the **Migrate** button.

---

**Instructor Notes**

[Get connected to Azure IoT Central (preview features)](https://docs.microsoft.com/en-us/azure/iot-central/preview/overview-iot-central-get-connected)

**REPLACES**

[Device connectivity in Azure IoT Central](https://docs.microsoft.com/en-us/azure/iot-central/core/concepts-connectivity)
