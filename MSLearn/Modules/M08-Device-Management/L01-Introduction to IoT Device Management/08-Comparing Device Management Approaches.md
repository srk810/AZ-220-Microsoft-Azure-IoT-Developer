# Comparing Device Management Approaches

IoT Hub provides three options for device apps to expose functionality to a back-end app:

* Direct methods for communications that require immediate confirmation of the result. Direct methods are often used for interactive control of devices such as turning on a fan.
* Twin's desired properties for long-running commands intended to put the device into a certain desired state. For example, set the telemetry send interval to 30 minutes.
* Cloud-to-device messages for one-way notifications to the device app.

Of these options, direct methods and device twin properties are good choices for device management.

## Choosing Between Device Twin and Direct Method Approaches

Here is a detailed comparison of the various cloud-to-device communication options.

|     |Direct methods|Twin's desired properties|Cloud-to-device messages|
|-----|--------------|-------------------------|------------------------|
|Scenario|Commands that require immediate confirmation, such as turning on a fan.|Long-running commands intended to put the device into a certain desired state. For example, set the telemetry send interval to 30 minutes.|One-way notifications to the device app.|
|Data flow|Two-way. The device app can respond to the method right away. The solution back end receives the outcome contextually to the request.|One-way. The device app receives a notification with the property change.|One-way. The device app receives the message|
|Durability|Disconnected devices are not contacted. The solution back end is notified that the device is not connected.|Property values are preserved in the device twin. Device will read it at next reconnection. Property values are retrievable with the IoT Hub query language.|Messages can be retained by IoT Hub for up to 48 hours.|
|Targets|Single device using deviceId, or multiple devices using jobs.|Single device using deviceId, or multiple devices using jobs.|Single device by deviceId.|
|Size|Maximum direct method payload size is 128 KB.|Maximum desired properties size is 8 KB.|Up to 64 KB messages.|
|Frequency|High. For more information, see IoT Hub limits.|Medium. For more information, see IoT Hub limits.|Low. For more information, see IoT Hub limits.|
|Protocol|Available using MQTT or AMQP.|Available using MQTT or AMQP.|Available on all protocols. Device must poll when using HTTPS.|

---

**Instructor Notes**

[Cloud-to-device communications guidance](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-c2d-guidance)
