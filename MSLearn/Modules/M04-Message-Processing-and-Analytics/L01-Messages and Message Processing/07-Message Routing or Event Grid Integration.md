# Message Routing or Event Grid Integration?

Azure IoT Hub provides the capability to stream data from your connected devices and integrate that data into your business applications. IoT Hub offers two methods for integrating IoT events into other Azure services or business applications.

1. **IoT Hub message routing**: This IoT Hub feature enables users to route device-to-cloud messages to service endpoints like Azure Storage containers, Event Hubs, Service Bus queues, and Service Bus topics. Routing also provides a querying capability to filter the data before routing it to the endpoints. In addition to device telemetry data, you can also send non-telemetry events that can be used to trigger actions.

2. **IoT Hub integration with Event Grid**: Azure Event Grid is a fully managed event routing service that uses a publish-subscribe model. IoT Hub and Event Grid work together to integrate IoT Hub events into Azure and non-Azure services, in near-real time. IoT Hub publishes device events, which are generally available, and now also publishes telemetry events, which is in public preview.

## Differences

While both message routing and Event Grid enable alert configuration, there are some key differences between the two. Refer to the following table for details:

|Feature|IoT Hub message routing|IoT Hub integration with Event Grid|
|-------|-----------------------|-----------------------------------|
|Device messages and events|Yes, message routing can be used for telemetry data, report device twin changes, device lifecycle events, and digital twin change events (part of the IoT Plug and Play public preview).|Yes, Event Grid can be used for telemetry data but can also report when devices are created, deleted, connected, and disconnected from IoT Hub|
|Ordering|Yes, ordering of events is maintained.|No, order of events is not guaranteed.|
|Filtering|Rich filtering on message application properties, message system properties, message body, device twin tags, and device twin properties. Filtering isn't applied to digital twin change events.|Filtering based on event type, subject type and attributes in each event. When subscribing to telemetry events, you can apply additional filters on the data to filter on message properties, message body and device twin in your IoT Hub, before publishing to Event Grid. |
|Endpoints|Event Hubs<br>Azure Blob Storage<br>Service Bus queue<br>Service Bus topics<br><br>Paid IoT Hub SKUs (S1, S2, and S3) are limited to 10 custom endpoints. 100 routes can be created per IoT Hub.|Azure Functions<br>Azure Automation<br>Event Hubs<br>Logic Apps<br>Storage Blob<br>Custom Topics<br>Queue Storage<br>Microsoft Flow<br>Third-party services through WebHooks<br><br>500 endpoints per IoT Hub are supported.|
|Cost|There is no separate charge for message routing. Only ingress of telemetry into IoT Hub is charged. For example, if you have a message routed to three different endpoints, you are billed for only one message.|There is no charge from IoT Hub. Event Grid offers the first 100,000 operations per month for free, and then $0.60 per million operations afterwards.|

## Similarities

IoT Hub message routing and Event Grid have similarities too, some of which are detailed in the following table:

|Feature|IoT Hub message routing|IoT Hub integration with Event Grid|
|-------|-----------------------|-----------------------------------|
|Maximum message size|256 KB, device-to-cloud|256 KB, device-to-cloud|
|Reliability|High: Delivers each message to the endpoint at least once for each route. Expires all messages that are not delivered within one hour.|High: Delivers each message to the webhook at least once for each subscription. Expires all events that are not delivered within 24 hours.|
|Scalability|High: Optimized to support millions of simultaneously connected devices sending billions of messages.|High: Capable of routing 10,000,000 events per second per region.|
|Latency|Low: Near-real time.|Low: Near-real time.|
|Send to multiple endpoints|Yes, send a single message to multiple endpoints.|Yes, send a single message to multiple endpoints.|
|Security|Iot Hub provides per-device identity and revocable access control.|Event Grid provides validation at three points: event subscriptions, event publishing, and webhook event delivery.|

## How to choose

IoT Hub message routing and the IoT Hub integration with Event Grid perform different actions to achieve similar results. They both take information from your IoT Hub solution and pass it on so that other services can react. So how do you decide which one to use? Consider the following questions to help guide your decision:

* What kind of data are you sending to the endpoints?

    Use IoT Hub message routing when you have to send telemetry data to other services. Message routing also enables querying message application and system properties, message body, device twin tags, and device twin properties.

    The IoT Hub integration with Event Grid works with events that occur in the IoT Hub service. These IoT Hub events include telemetry data, device created, deleted, connected, and disconnected. When subscribing to telemetry events, you can apply additional filters on the data to filter on message properties, message body and device twin in your IoT Hub, before publishing to Event Grid.

* What endpoints need to receive this information?

    IoT Hub message routing supports limited number of unique endpoints and endpoint types, but you can build connectors to reroute the data and events to additional endpoints.

    The IoT Hub integration with Event Grid supports 500 endpoints per IoT Hub and a larger variety of endpoint types. It natively integrates with Azure Functions, Logic Apps, Storage and Service Bus queues, and also works with webhooks to extend sending data outside of the Azure service ecosystem and into third-party business applications.

* Does it matter if your data arrives in order?

    IoT Hub message routing maintains the order in which messages are sent, so that they arrive in the same way.

    Event Grid does not guarantee that endpoints will receive events in the same order that they occurred. For those cases in which absolute order of messages is significant and/or in which a consumer needs a trustworthy unique identifier for messages, we recommend using message routing.

---

**Instructor Notes**

[Compare message routing and Event Grid for IoT Hub](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-event-grid-routing-comparison)

(MCB) this is all reference material.  I don't think a usable slide can come out of this except maybe to name both choices and say there are pros and cons to each.
