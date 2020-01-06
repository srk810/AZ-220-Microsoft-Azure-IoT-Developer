# Introduction to IoT Plug and Play and Azure Digital Twins

The additional capabilities offered by the Azure IoT Central preview features include support for two other tools that Microsoft is making available as preview - IoT Plug and Play and Azure Digital Twins:

* IoT Plug and Play: IoT Plug and Play Preview provides a mechanism for device creators to pre-load devices with operational capabilities, and which Azure IoT tools (such as IoT Hub, DPS, IoT Central, etc.) can recognize, interpret, and implement out of the box.
* Azure Digital Twins: Azure Digital Twins Preview is an Azure PaaS service that enables IoT solution developer teams to create full-featured virtual models of the physical environment where devices deployed. Azure Digital Twins integrates with the other Azure IoT PaaS and SaaS tools so that your digital twin truly is an functionally accurate and highly useful representation of the physical environment.   

## IoT Plug and Play Preview

IoT Plug and Play Preview enables solution developers to integrate devices with their solutions without writing any embedded code. At the core of IoT Plug and Play is a device capability model schema that describes device capabilities. This schema is a JSON document that's structured as a set of interfaces that include definitions of:

* Properties that represent the read-only and read/write state of a device or other entity. For example, a device serial number may be a read-only property and a target temperature on a thermostat may be a read/write property.
* Telemetry that is the data emitted by a device, whether the data is a regular stream of sensor readings, an occasional error, or information message.
* Commands that describe a function or operation that can be done on a device. For example, a command could reboot a gateway or take a picture using a remote camera.

You can reuse interfaces across device capability models to make collaboration easier and to speed up development.

To make IoT Plug and Play work seamlessly with Azure Digital Twins, the IoT Plug and Play schema is defined using the Digital Twin Definition Language (DTDL). IoT Plug and Play and the DTDL are open to the community, and Microsoft welcomes collaboration with customers, partners, and the industry. Both are based on open W3C standards such as JSON-LD and RDF, which enable easier adoption across services and tooling. Additionally, there's no extra cost for using IoT Plug and Play and DTDL. Standard rates for Azure IoT Hub, Azure IoT Central, and other Azure services remain the same.

Solutions built on IoT Hub or IoT Central can benefit from IoT Plug and Play.

### IoT Plug and Play User Roles 

IoT Plug and Play is useful for two types of developers:

* A solution developer is responsible for developing an IoT solution using Azure IoT and other Azure resources and for identifying IoT devices to integrate.
* A device developer creates the code that runs on a device connected to your solution.

### Use IoT Plug and Play Devices

As a solution developer, you can develop a cloud-hosted IoT solution that uses IoT Plug and Play devices with solution based on either IoT Central or IoT Hub.

You can find IoT Plug and Play devices through the Azure Certified for IoT device catalog. Each IoT Plug and Play device in the catalog has been validated, and has a device capability model. View the device capability model to understand the device's functionality or use it to simulate the device in Azure IoT Central.

When you connect an IoT Plug and Play device, you can view its device capability model, the interfaces included in the model, and the telemetry, properties, and commands defined in those interfaces.

### Regional Availability for IoT Plug and Play

During public preview, IoT Plug and Play is available in the North Europe, Central US, and Japan East regions. Please make sure you create your hub in one of these regions.

### Message Quotas in IoT Hub

During public preview, IoT Plug and Play devices send separate messages per interface, which may increase the number of messages counted towards your message quota.

## Azure Digital Twins Preview

Azure Digital Twins Preview is an Azure IoT service that creates comprehensive models of the physical environment. It can create spatial intelligence graphs to model the relationships and interactions between people, spaces, and devices.

With Azure Digital Twins, you can query data from a physical space rather than from many disparate sensors. This service helps you build reusable, highly scalable, spatially aware experiences that link streaming data across the digital and physical world. Your apps are enhanced by these uniquely relevant contextual features.

Azure Digital Twins applies to all types of environments, such as, warehouses, offices, schools, hospitals, and banks. It can even be used for stadiums, factories, parking lots, parks, smart grids, and cities. The following are some scenarios where Azure Digital Twins can be helpful:

* Predict maintenance needs for a factory.
* Analyze real-time energy requirements for an electrical grid.
* Optimize the use of available space for an office.
* Track daily temperature across several states.
* Monitor busy drone paths.
* Identify autonomous vehicles.
* Analyze occupancy levels for a building.
* Find the busiest cash register in your store.

Whatever your real-world business scenario is, it's likely a corresponding digital instance can be provisioned through Azure Digital Twins.

### Key Capabilities of Azure Digital Twins

Azure Digital Twins has the following key capabilities.

#### Spatial intelligence graph

The spatial intelligence graph, or spatial graph, is a virtual representation of the physical environment. You can use it to model the relationships between people, places, and devices.

Consider a smart utility app that involves several electricity usage meters connected across a neighborhood. The smart utility company must accurately monitor and predict electricity usage and billing. Each device and sensor must be modeled with context about the location and the customer that's to be billed. You can use the spatial intelligence graph to model these kinds of complex relationships.

#### Digital twin object models

Digital twin object models are predefined device protocols and data schema. They align your solution’s domain-specific needs to accelerate and simplify development.

For example, a room occupancy application might use predefined space types such as campus, building, floor, and room.

#### Multiple and nested tenants

You can build solutions that scale securely and can be reused for multiple tenants. You also can create multiple subtenants that can be accessed and used in an isolated and secure manner.

An example is a space utilization app that's configured to isolate a tenant's data from other tenants' data within a single building. Or the app is used to combine data for a single tenant with numerous buildings.

#### Advanced compute capabilities

With user-defined functions, you can define and run custom functions against incoming device data to send signals to predefined endpoints. This advanced capability improves customization and automation of device tasks.

An example is a smart agriculture application that includes a user-defined function to assess soil moisture sensor readings and the weather forecast. The app then sends signals about the irrigation needs.

#### Built-in access control

By using access and identity management features such as role-based access control and Azure Active Directory, you can securely control access for individuals and devices.

An example is a facilities management app that's configured to allow occupants of a room to set the temperature within a specified range. Facilities managers are allowed to set the temperature in any room to any value.

#### Ecosystem

You can connect an Azure Digital Twins instance to many powerful Azure services. These services include Azure Stream Analytics, Azure AI, and Azure Storage. They also include Azure Maps, Microsoft Mixed Reality, Dynamics 365, or Office 365.

An example is a smart office building application that uses Azure Digital Twins to represent teams and devices located on many floors. As devices stream live data into the provisioned Digital Twin instance, Stream Analytics processes that data to provide actionable key insights. The data is stored in Azure Storage and converted into a shareable file format. The file is distributed across the whole organization by using Office 365.

---

**Instructor Notes**

[What is IoT Plug and Play Preview?](https://docs.microsoft.com/en-us/azure/iot-pnp/overview-iot-plug-and-play)

[Overview of Azure Digital Twins](https://docs.microsoft.com/en-us/azure/digital-twins/about-digital-twins)
