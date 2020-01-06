# Azure IoT SDKs

Azure IoT provides a set of open-source Software Development Kits (SDKs) to simplify and accelerate the development of IoT solutions built with Azure IoT Hub. Using the SDKs in prototyping and production enables you to:

* Develop a “future-proof” solution with minimal code: While you can use protocol libraries to communicate with Azure IoT Hub, you may come back to this decision later and regret it. You will miss out on a lot of upcoming advanced features of IoT Hub and spend time redeveloping code and functionality that you could get for free. The SDKs support new features from IoT Hub, so you can incorporate them with minimal code and ensure your solution is up-to-date.
* Leverage features designed for a complete software solution and focus on your specific need: The SDKs contain many libraries that address key problems and needs of IoT solutions such as security, device management, reliability, etc. You can speed up time to market by leveraging these libraries directly and focus on developing for your specific IoT scenario.
* Develop with your preferred language for different platform: You can develop with C, C#, Java, Node.js, or Python without worrying about protocol specific intricacy. The SDKs provide out-of-box support for a range of platforms and the C SDK can be ported to new platforms.
* Benefit from the flexibility of open source with support from Microsoft and community: The SDKs are available open source on GitHub and Microsoft works in the open. You can modify, adapt, and contribute to the code that will run your devices and your applications.

There are two categories of software development kits (SDKs) for working with IoT Hub:

* IoT Hub Device SDKs enable you to build apps that run on your IoT devices using device client or module client. These apps send telemetry to your IoT hub, and optionally receive messages, job, method, or twin updates from your IoT hub. You can also use module client to author modules for Azure IoT Edge runtime.
* IoT Hub Service SDKs enable you to build backend applications to manage your IoT hub, and optionally send messages, schedule jobs, invoke direct methods, or send desired property updates to your IoT devices or modules.

In addition, we also provide a set of SDKs for working with the Device Provisioning Service.

* Provisioning Device SDKs enable you to build apps that run on your IoT devices to communicate with the Device Provisioning Service.
* Provisioning Service SDKs enable you to build backend applications to manage your enrollments in the Device Provisioning Service.

## Azure IoT Device SDKs Platform Support

Microsoft publishes open-source SDKs on GitHub for the following languages: C, .NET (C#), Node.js, Java, and Python.

Microsoft provides SDK support in the following ways:

* Continuously builds and runs end-to-end tests against the master branch of the relevant SDK in GitHub on several popular platforms. To provide test coverage across different compiler versions, Microsoft generally tests against the latest LTS (Long Term Support) version and the most popular version.
* Provides installation guidance or installation packages if applicable.
* Fully supports the SDKs on GitHub with open-source code, a path for customer contributions, and product team engagement with GitHub issues.

---

**Instructor Notes**

[Benefits of using the Azure IoT SDKs, and pitfalls to avoid if you don’t](https://azure.microsoft.com/en-us/blog/benefits-of-using-the-azure-iot-sdks-in-your-azure-iot-solution/)

[Understand and use Azure IoT Hub SDKs](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-sdks)

[Azure IoT Device SDKs Platform Support](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-device-sdk-platform-support)
