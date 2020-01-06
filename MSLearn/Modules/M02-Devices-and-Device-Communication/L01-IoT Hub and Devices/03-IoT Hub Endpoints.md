# IoT Hub Endpoints

Azure IoT Hub is a multi-tenant service that provides access to its functionality using a combination of built-in and custom endpoints.

## Built-in Endpoints

![IoT Hub Endpoints](../../Linked_Image_Files/M02_L04_IoTHubEndpoints.png)

The following list describes the endpoints:

* Resource provider. The IoT Hub resource provider exposes an Azure Resource Manager interface. This interface enables Azure subscription owners to create and delete IoT hubs, and to update IoT hub properties. IoT Hub properties govern hub-level security policies, as opposed to device-level access control, and functional options for cloud-to-device and device-to-cloud messaging. The IoT Hub resource provider also enables you to export device identities.

* Device identity management. Each IoT hub exposes a set of HTTPS REST endpoints to manage device identities (create, retrieve, update, and delete). Device identities are used for device authentication and access control.

* Device twin management. Each IoT hub exposes a set of service-facing HTTPS REST endpoints to query and update device twins (update tags and properties).

* Jobs management. Each IoT hub exposes a set of service-facing HTTPS REST endpoint to query and manage jobs.

* Device endpoints. For each device in the identity registry, IoT Hub exposes a set of endpoints:

  * Send device-to-cloud messages. A device uses this endpoint to send device-to-cloud messages.
  * Receive cloud-to-device messages. A device uses this endpoint to receive targeted cloud-to-device messages.
  * Initiate file uploads. A device uses this endpoint to receive an Azure Storage SAS URI from IoT Hub to upload a file.
  * Retrieve and update device twin properties. A device uses this endpoint to access its device twin's properties.
  * Receive direct method requests. A device uses this endpoint to listen for direct method's requests.

    These endpoints are exposed using MQTT v3.1.1, HTTPS 1.1, and AMQP 1.0 protocols. AMQP is also available over WebSockets on port 443.

* Service endpoints. Each IoT hub exposes a set of endpoints for your solution back end to communicate with your devices. With one exception, these endpoints are only exposed using the AMQP protocol. The method invocation endpoint is exposed over the HTTPS protocol.

  * Receive device-to-cloud messages. This endpoint is compatible with Azure Event Hubs. A back-end service can use it to read the device-to-cloud messages sent by your devices. You can create custom endpoints on your IoT hub in addition to this built-in endpoint.

  * Send cloud-to-device messages and receive delivery acknowledgments. These endpoints enable your solution back end to send reliable cloud-to-device messages, and to receive the corresponding delivery or expiration acknowledgments.

  * Receive file notifications. This messaging endpoint allows you to receive notifications of when your devices successfully upload a file.

  * Direct method invocation. This endpoint allows a back-end service to invoke a direct method on a device.

  * Receive operations monitoring events. This endpoint allows you to receive operations monitoring events if your IoT hub has been configured to emit them. For more information, see IoT Hub operations monitoring.

## Custom Endpoints

You can link existing Azure services in your subscription to your IoT hub to act as endpoints for message routing. These endpoints act as service endpoints and are used as sinks for message routes. Devices cannot write directly to the additional endpoints.

IoT Hub currently supports the following Azure services as additional endpoints:

* Azure Storage containers
* Event Hubs
* Service Bus Queues
* Service Bus Topics

---

**Instructor Notes**

[Reference - IoT Hub endpoints](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-endpoints)

**TODO: Reviewers - I think that this topic currently includes too much detail for this point in the course. Maybe we should highlight a few device and service endpoints for this point in the training. Then revisit the diagram when additional details become relevant. Feedback appreciated** 

(MCB) there is a lot of detail in some ways but I'm not sure how to clean it up except to maybe move the resource provider stuff out, maybe to an earlier part since it's around creating an IoT Hub and normal ARM stuff?  I guess you could high-level the high level list of endpoint types and detail later?