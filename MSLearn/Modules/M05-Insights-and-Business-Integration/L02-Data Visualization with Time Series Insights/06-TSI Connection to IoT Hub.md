# TSI Connection to IoT Hub

Once you have IoT Hub and TSI instances up and running, you are ready to create a dedicated consumer group in the IoT hub for the Time Series Insights environment to consume from. Each Time Series Insights event source must have its own dedicated consumer group that isn't shared with any other consumer. If multiple readers consume events from the same consumer group, all readers are likely to see failures.

## Create an IoT Hub Consumer Group for TSI

Applications use consumer groups to pull data from Azure IoT Hub. To reliably read data from your IoT hub, provide a dedicated consumer group that's used only by this Time Series Insights environment.

![TSI Connection to IoT Hub - IoT Hub Consumer Group](../../Linked_Image_Files/M05_L01_TSIConnectionToIoTHub-IoTHubConsumerGroup.png)

Under **Consumer groups**, enter a unique name for the consumer group. You will use this same name in your Time Series Insights environment when you create your event source.

## Create a TSI Event Source for IoT Hub

Switching over to the TSI side, you need to create the Event Source that you will be using to access IoT Hub data.

![TSI Connection to IoT Hub - TSI Event Source](../../Linked_Image_Files/M05_L01_TSIConnectionToIoTHub-TSIEventSource.png)

To begin the process of creating your new event source, you will first provide an Event source name (a name that's unique to this Time Series Insights environment) and specify that your Source will be an IoT Hub. Once you have these properties set, you will have a choice between using an IoT Hub from an available subscription and providing IoT Hub settings manually. The property settings requirements will be different based on your choice.

**Note**: If you want to choose advanced options, you should choose the Provide IoT Hub settings manually option.

### Use IoT Hub from Available Subscriptions

The following table describes the properties that are required for the **Use IoT Hub from available subscriptions** option:

|Property|Description|
|--------|-----------|
|Subscription|The subscription the desired iot hub belongs to.|
|IoT hub name|The name of the selected iot hub.|
|IoT hub policy name|Select the shared access policy. You can find the shared access policy on the IoT hub settings tab. Each shared access policy has a name, permissions that you set, and access keys. The shared access policy for your event source must have service connect permissions.|
|IoT hub policy key|The key is prepopulated.|
|IoT hub consumer group|The consumer group that reads events from the IoT hub. We highly recommend that you use a dedicated consumer group for your event source.|
|Event serialization format|Currently, JSON is the only available serialization format. The event messages must be in this format or no data can be read.|
|Timestamp property name|To determine this value, you need to understand the message format of the message data that's sent to the IoT hub. This value is the name of the specific event property in the message data that you want to use as the event timestamp. The value is case-sensitive. If left blank, the event enqueue time in the event source is used as the event timestamp.|

### Provide IoT Hub settings manually

The following table describes the properties that are required for the **Use IoT Hub from available subscriptions** option:

|Property|Description|
|--------|-----------|
|Subscription ID|The subscription the desired iot hub belongs to.|
|Resource group|The resource group name in which the IoT hub was created.|
|IoT hub name|The name of your IoT hub. When you created your IoT hub, you entered a name for the IoT hub.|
|IoT hub policy name|The shared access policy. You can create the shared access policy on the IoT hub settings tab. Each shared access policy has a name, permissions that you set, and access keys. The shared access policy for your event source must have service connect permissions.|
|IoT hub policy key|The shared access key that's used to authenticate access to the Azure Service Bus namespace. Enter the primary or secondary key here.|
|IoT hub consumer group|The consumer group that reads events from the IoT hub. We highly recommend that you use a dedicated consumer group for your event source.|
|Event serialization format|Currently, JSON is the only available serialization format. The event messages must be in this format or no data can be read.|
|Timestamp property name|To determine this value, you need to understand the message format of the message data that's sent to the IoT hub. This value is the name of the specific event property in the message data that you want to use as the event timestamp. The value is case-sensitive. If left blank, the event enqueue time in the event source is used as the event timestamp.|

---

[Add an IoT hub event source to your Time Series Insights environment](https://docs.microsoft.com/en-us/azure/time-series-insights/time-series-insights-how-to-add-an-event-source-iothub)
