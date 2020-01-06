# Introduction to Message Routing

IoT Hub Message Routing enables users to route device-to-cloud messages to service-facing endpoints. Routing also provides a querying capability to filter the data before routing it to the endpoints. Each routing query you configure has the following properties:

|Property|Description|
|--------|-----------|
|Name|The unique name that identifies the query.|
|Source|The origin of the data stream to be acted upon. For example, device telemetry.|
|Condition|The query expression for the routing query that is run against the message application properties, system properties, message body, device twin tags, and device twin properties to determine if it is a match for the endpoint. For more information about constructing a query, see the see message routing query syntax|
|Endpoint|The name of the endpoint where IoT Hub sends messages that match the query. We recommend that you choose an endpoint in the same region as your IoT hub.|

A single message may match the condition on multiple routing queries, in which case IoT Hub delivers the message to the endpoint associated with each matched query. IoT Hub also automatically deduplicates message delivery, so if a message matches multiple queries that have the same destination, it is only written once to that destination.

## Endpoints and routing

An IoT hub has a default built-in messaging endpoint (messages/events). 

You can create custom endpoints to route messages to by linking other services in your subscription to the hub. IoT Hub currently supports the following custom endpoints:

* Azure Storage containers
* Event Hubs
* Service Bus queues
* Service Bus topics

When you use routing and custom endpoints, messages are only delivered to the built-in endpoint if they don't match any query. To deliver messages to the built-in endpoint as well as to a custom endpoint, add a route that sends messages to the built-in events endpoint.

>**Note**
>* IoT Hub only supports writing data to Azure Storage containers as blobs.
>* Service Bus queues and Service Bus topics that have Sessions or Duplicate Detection enabled are not supported as custom endpoints.

---

**Instructor Notes**

[Use message routes and custom endpoints for device-to-cloud messages](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-messages-read-custom)

