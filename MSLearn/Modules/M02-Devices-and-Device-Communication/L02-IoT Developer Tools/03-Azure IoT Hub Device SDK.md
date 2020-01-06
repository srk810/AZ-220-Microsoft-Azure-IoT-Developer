# Azure IoT Hub Device SDKs

The Microsoft Azure IoT device SDKs contain code that facilitates building applications that connect to and are managed by Azure IoT Hub services.

## Coding Language Support

Depending on the IoT scenario and your developer experience, you may have a preferred language or platform. The SDKs got you covered. Broad language and platform support with protocol flexibility allows you to develop in your preferred environment without worrying about protocol specific intricacy. Five languages are currently supported: C, C#, Java, Node.js, and Python. Microsoft strives to maintain consistency of APIs across the five languages, as much as language specific constructs allow.

Each language is being maintained as a public repository on GitHub, including sample code and documentation. In addition, the SDKs are available as binary packages from Nuget for C#, Maven for Java, apt-get for some Linux Distributions, npm for Node.js and pip for Python.

## Platform Testing

The SDKs are regularly tested on the following platforms (when languages apply):

* Linux (Ubuntu, Debian, Raspbian)
* Windows
* MBED
* Arduino (Huzzah, ThingDev, FeatherM0), FreeRTOS (ESP32, ESP8266)
* .NETFramework 4.5, UWP, PCL (Profile 7 – UWP, Xamarin.iOS, Xamarin.Android), .NetMicroFramework, .NetStandard 1.3
* Intel Edison

## Supported Protocols

IoT Hub allows devices to use the following protocols for device-side communications:

* MQTT
* MQTT over WebSockets
* AMQP
* AMQP over WebSockets
* HTTPS

---

**Instructor Notes**

[Understand and use Azure IoT Hub SDKs](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-sdks)

[Microsoft Azure IoT Device SDK for C](https://docs.microsoft.com/en-us/azure/iot-hub/iot-c-sdk-ref/)

[Reference - choose a communication protocol](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-protocols)

[Communicate with your IoT hub using the MQTT protocol](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-mqtt-support)

[Communicate with your IoT hub by using the AMQP Protocol](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-amqp-support)

[Azure IoT libraries for .NET](https://docs.microsoft.com/en-us/dotnet/api/overview/azure/iot?view=azure-dotnet)

[Send device-to-cloud and cloud-to-device messages with IoT Hub](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-messaging)
