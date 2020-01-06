# Azure IoT Hub Service SDK

The IoT Hub Service SDKs enable you to build backend applications that interact directly with IoT Hub. The service SDKs contain code that facilitates building applications to manage your IoT hub, send C2D messages, schedule jobs, invoke direct methods, or send desired property updates to your IoT devices or modules.

## Coding Language Support

Five languages are currently supported: C, C#, Java, Node.js, and Python.

## Backend App Scenarios

* Identity registry (CRUD): Use your backend app to perform CRUD operation for individual device or in bulk.
* Cloud-to-device messaging: Use your backend app to send cloud-to-device messages in AMQP and AMQP-WS, and set up cloud-to-device message receivers.
* Direct Methods operations: Use your backend app to invoke direct method on device.
* Device Twins operations: Use your backend app to perform twin operations. The .NET (C#) SDK only supports Get Twin at the moment.
* Query: Use your backend app to perform query for information.
* Jobs: Use your backend app to perform job operation.
* File Upload: Set up your backend app to send file upload notification receiver.

Here is a detailed comparison of the various cloud-to-device communication options.

|        | Direct methods |Twin's desired properties | Cloud-to-device messages |
|--------|----------------|--------------------------|--------------------------|
|Scenario|Commands that require immediate confirmation, such as turning on a fan.|Long-running commands intended to put the device into a certain desired state. For example, set the telemetry send interval to 30 minutes.|One-way notifications to the device app.|
|Data flow|Two-way. The device app can respond to the method right away. The solution back end receives the outcome contextually to the request.|One-way. The device app receives a notification with the property change.|One-way. The device app receives the message|
|Durability|Disconnected devices are not contacted. The solution back end is notified that the device is not connected.|Property values are preserved in the device twin. Device will read it at next reconnection. Property values are retrievable with the IoT Hub query language.|Messages can be retained by IoT Hub for up to 48 hours.|
|Targets|Single device using deviceId, or multiple devices using jobs.|Single device using deviceId, or multiple devices using jobs.|Single device by deviceId.|
|Size|Maximum direct method payload size is 128 KB.|Maximum desired properties size is 8 KB.|Up to 64 KB messages.|
|Frequency|High. For more information, see IoT Hub limits.|Medium. For more information, see IoT Hub limits.|Low. For more information, see IoT Hub limits.|
|Protocol|Available using MQTT or AMQP.|Available using MQTT or AMQP.|Available on all protocols. Device must poll when using HTTPS.|

---

**Instructor Notes**

[Understand and use Azure IoT Hub SDKs](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-sdks)

[Send cloud-to-device messages from an IoT hub](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-messages-c2d)

[Cloud-to-device communications guidance](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-c2d-guidance)

[Send messages from the cloud to your device with IoT Hub (.NET)](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-csharp-csharp-c2d)

[GitHub - azure-iot-sdk-csharp](https://github.com/Azure/azure-iot-sdk-csharp)

(MCB) I'm not sure how I'd present this in any kind of interesting way right now, but I'm also not sure how to fix that.  It seems like we need this info somehow.