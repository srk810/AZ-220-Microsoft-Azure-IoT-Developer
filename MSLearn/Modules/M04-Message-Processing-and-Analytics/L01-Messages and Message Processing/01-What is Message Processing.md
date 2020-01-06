# What is Message Processing

Message processing includes the series of actions that we use to communicate, modify, evaluate, react-to, and store message information. 

The Azure IoT Reference Architecture diagram illustrates the primary message processing pathways.

![Message Processing Pathways](../../Linked_Image_Files/M04_L01_MessageProcessingPaths_RefArch.JPG)

As you can see, message processing involves a broad spectrum of protocols, services, and standards. Here are some of the topics that we will focus on:

* Message Format: To support seamless interoperability across protocols, IoT Hub defines a common message format for all device-facing protocols.

* Message Routing: This IoT Hub feature enables users to route device-to-cloud messages to service endpoints like Azure Storage containers, Event Hubs, Service Bus queues, and Service Bus topics. Routing also provides a querying capability to filter the data before routing it to the endpoints. In addition to device telemetry data, you can also send non-telemetry events that can be used to trigger actions.

* Event Grid: Azure Event Grid is a fully managed event routing service that uses a publish-subscribe model. IoT Hub and Event Grid work together to integrate IoT Hub events into Azure and non-Azure services, in near-real time. IoT Hub publishes device events, which are generally available, and now also publishes telemetry events, which is in public preview.

* Message Enrichment: Message enrichment is the ability of the IoT Hub to stamp messages with additional information before the messages are sent to the designated endpoint.

* Azure Stream Analytics: Azure Stream Analytics (ASA) is a real-time analytics and complex event-processing engine that is designed to analyze and process high volumes of fast streaming data from multiple sources simultaneously. ASA supports inputs and outputs using a wide range storage options.

* Azure Functions: Azure Functions is a solution for easily running small pieces of code, or "functions," in the cloud. Azure Functions lets you develop serverless applications on Microsoft Azure and is a great solution for processing data, integrating systems, and working with the Internet-of-Things. Azure Functions provides several templates that will help you to get you started with key IoT scenarios.

* Warm and Cold Storage: For architectures that produce significant amounts of data, a common pattern is to split the data into “warm” and “cold” data stores. Traditionally, data stored in cold storage is accessed infrequently, while data stored in warm storage accessed frequently.

---

**Instructor Notes**

[Create and read IoT Hub messages](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-messages-construct)

[Use IoT Hub message routing to send device-to-cloud messages to different endpoints](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-messages-d2c)

[What is Azure Event Grid?](https://docs.microsoft.com/en-us/azure/event-grid/overview)

[Compare message routing and Event Grid for IoT Hub](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-event-grid-routing-comparison)

[Message enrichments for device-to-cloud IoT Hub messages](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-message-enrichments-overview)

[What is Azure Stream Analytics?](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction)

[An introduction to Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)

(MCB) I'm a little concerned about two things here - one, that there are some message processing topics that are not necessarily clearly connected to the architecture diagram, and two, how the diagram could be reasonably presented on a slide.  I know we need to start with the architecture, and the topics are good topics, so I don't know how to fix this right now.