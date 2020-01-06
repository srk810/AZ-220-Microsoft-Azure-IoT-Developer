# Device Connection State and Lifecycle Notifications

## Device heartbeat

The IoT Hub identity registry contains a field called **connectionState**. Only use the **connectionState** field during development and debugging. IoT solutions should not query the field at run time. For example, do not query the **connectionState** field to check if a device is connected before you send a cloud-to-device message or an SMS. We recommend subscribing to the device disconnected event on Event Grid to get alerts and monitor the device connection state.

If your IoT solution needs to know if a device is connected, you can implement the _heartbeat pattern_. In the heartbeat pattern, the device sends device-to-cloud messages at least once every fixed amount of time (for example, at least once every hour). Therefore, even if a device does not have any data to send, it still sends an empty device-to-cloud message (usually with a property that identifies it as a heartbeat). On the service side, the solution maintains a map with the last heartbeat received for each device. If the solution does not receive a heartbeat message within the expected time from the device, it assumes that there is a problem with the device.

A more complex implementation could include the information from Azure Monitor and Azure Resource Health to identify devices that are trying to connect or communicate but failing. When you implement the heartbeat pattern, make sure to check IoT Hub Quotas and Throttles.

**Note**: If an IoT solution uses the connection state solely to determine whether to send cloud-to-device messages, and messages are not broadcast to large sets of devices, consider using the simpler short expiry time pattern. This pattern achieves the same result as maintaining a device connection state registry using the heartbeat pattern, while being more efficient. If you request message acknowledgements, IoT Hub can notify you about which devices are able to receive messages and which are not.

## Device and Module Lifecycle Notifications

IoT Hub can notify your IoT solution when an identity is created or deleted by sending lifecycle notifications. To do so, your IoT solution needs to create a route and to set the Data Source equal to **DeviceLifecycleEvents** or **ModuleLifecycleEvents**. By default, no lifecycle notifications are sent, that is, no such routes pre-exist. The notification message includes properties, and body.

Properties: Message system properties are prefixed with the /$ symbol.

Notification message for device:

|Name|Value|
|----|-----|
|$content-type|application/json|
|$iothub-enqueuedtime|Time when the notification was sent|
|$iothub-message-source|deviceLifecycleEvents|
|$content-encoding|utf-8|
|opType|createDeviceIdentity or deleteDeviceIdentity|
|hubName|Name of IoT Hub|
|deviceId|ID of the device|
|operationTimestamp|ISO8601 timestamp of operation|
|iothub-message-schema|deviceLifecycleNotification|

Body: This section is in JSON format and represents the twin of the created device identity. For example,

```json
{
    "deviceId":"11576-ailn-test-0-67333793211",
    "etag":"AAAAAAAAAAE=",
    "properties": {
        "desired": {
            "$metadata": {
                "$lastUpdated": "2016-02-30T16:24:48.789Z"
            },
            "$version": 1
        },
        "reported": {
            "$metadata": {
                "$lastUpdated": "2016-02-30T16:24:48.789Z"
            },
            "$version": 1
        }
    }
}
```

Notification message for module:

|Name|Value|
|----|-----|
|$content-type|application/json|
|$iothub-enqueuedtime|Time when the notification was sent|
|$iothub-message-source|moduleLifecycleEvents|
|$content-encoding|utf-8|
|opType|createModuleIdentity or deleteModuleIdentity|
|hubName|Name of IoT Hub|
|moduleId|ID of the module|
|operationTimestamp|ISO8601 timestamp of operation|
|othub-message-schema|moduleLifecycleNotification|

Body: This section is in JSON format and represents the twin of the created module identity. For example,

```json
{
    "deviceId":"11576-ailn-test-0-67333793211",
    "moduleId":"tempSensor",
    "etag":"AAAAAAAAAAE=",
    "properties": {
        "desired": {
            "$metadata": {
                "$lastUpdated": "2016-02-30T16:24:48.789Z"
            },
            "$version": 1
        },
        "reported": {
            "$metadata": {
                "$lastUpdated": "2016-02-30T16:24:48.789Z"
            },
            "$version": 1
        }
    }
}
```

## Device identity properties

Device identities are represented as JSON documents with the following properties:

|Property|Options|Description|
|--------|-------|-----------|
|deviceId|required, read-only on updates|A case-sensitive string (up to 128 characters long) of ASCII 7-bit alphanumeric characters plus certain special characters: - . + % _ # * ? ! ( ) , = @ $ '|
|generationId|required, read-only|An IoT hub-generated, case-sensitive string up to 128 characters long. This value is used to distinguish devices with the same **deviceId**, when they have been deleted and re-created.|
|etag|required, read-only|A string representing a weak ETag for the device identity, as per RFC7232.|
|auth|optional|A composite object containing authentication information and security materials.|
|auth.symkey|optional|A composite object containing a primary and a secondary key, stored in base64 format.|
|status|required|An access indicator. Can be **Enabled** or **Disabled**. If **Enabled**, the device is allowed to connect. If **Disabled**, this device cannot access any device-facing endpoint.|
|statusReason|optional|A 128 character-long string that stores the reason for the device identity status. All UTF-8 characters are allowed.|
|statusUpdateTime|read-only|A temporal indicator, showing the date and time of the last status update.|
|connectionState|read-only|A field indicating connection status: either **Connected** or **Disconnected**. This field represents the IoT Hub view of the device connection status.<br><br>**Important**: This field should be used only for development/debugging purposes. The connection state is updated only for devices using MQTT or AMQP. Also, it is based on protocol-level pings (MQTT pings, or AMQP pings), and it can have a maximum delay of only 5 minutes. For these reasons, there can be false positives, such as devices reported as connected but that are disconnected.|
|connectionStateUpdatedTime|read-only|A temporal indicator, showing the date and last time the connection state was updated.|
|lastActivityTime|read-only|A temporal indicator, showing the date and last time the device connected, received, or sent a message.|

**Note**: Connection state can only represent the IoT Hub view of the status of the connection. Updates to this state may be delayed, depending on network conditions and configurations.

**Note**: Currently the device SDKs do not support using the + and # characters in the deviceId.

## Module identity properties

Module identities are represented as JSON documents with the following properties:

|Property|Options|Description|
|--------|-------|-----------|
|deviceId|required, read-only on updates|A case-sensitive string (up to 128 characters long) of ASCII 7-bit alphanumeric characters plus certain special characters: - . + % _ # * ? ! ( ) , = @ $ '|
|moduleId|required, read-only on updates|A case-sensitive string (up to 128 characters long) of ASCII 7-bit alphanumeric characters plus certain special characters: - . + % _ # * ? ! ( ) , = @ $ '|
|generationId|required, read-only|An IoT hub-generated, case-sensitive string up to 128 characters long. This value is used to distinguish devices with the same **deviceId**, when they have been deleted and re-created.|
|etag|required, read-only|A string representing a weak ETag for the device identity, as per RFC7232.|
|auth|optional|A composite object containing authentication information and security materials.|
|auth.symkey|optional|A composite object containing a primary and a secondary key, stored in base64 format.|
|status|required|An access indicator. Can be **Enabled** or **Disabled**. If **Enabled**, the device is allowed to connect. If **Disabled**, this device cannot access any device-facing endpoint.|
|statusReason|optional|A 128 character-long string that stores the reason for the device identity status. All UTF-8 characters are allowed.|
|statusUpdateTime|read-only|A temporal indicator, showing the date and time of the last status update.|
|connectionState|read-only|A field indicating connection status: either **Connected** or **Disconnected**. This field represents the IoT Hub view of the device connection status.<br><br>**Important**: This field should be used only for development/debugging purposes. The connection state is updated only for devices using MQTT or AMQP. Also, it is based on protocol-level pings (MQTT pings, or AMQP pings), and it can have a maximum delay of only 5 minutes. For these reasons, there can be false positives, such as devices reported as connected but that are disconnected.|
|connectionStateUpdatedTime|read-only|A temporal indicator, showing the date and last time the connection state was updated.|
|lastActivityTime|read-only|A temporal indicator, showing the date and last time the device connected, received, or sent a message.|

**Note**: Currently the device SDKs do not support using the \+ and \# characters in the **deviceId** and **moduleId**.

---

**Instructor Notes**

[Device heartbeat](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-identity-registry#device-heartbeat)

[Device and module lifecycle notifications](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-identity-registry#device-and-module-lifecycle-notifications)
