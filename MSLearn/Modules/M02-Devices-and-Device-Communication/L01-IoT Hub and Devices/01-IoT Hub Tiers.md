# IoT Hub Tiers

Every IoT solution is different, so Azure IoT Hub offers several options based on pricing and scale.

The decision on which IoT Hub tier is right for your solution is generally made by the solution architect, however, understanding the implications of this decision is important to the IoT developer role who will be called upon to support the solution.

To evaluate which IoT Hub tier is right for your solution, consider these two questions:

* What features do I plan to use?

    Azure IoT Hub offers two tiers, basic and standard, that differ in the number of features they support. If your IoT solution is based around collecting data from devices and analyzing it centrally, then the basic tier is probably right for you. If you want to use more advanced configurations to control IoT devices remotely or distribute some of your workloads onto the devices themselves, then you should consider the standard tier. For a detailed breakdown of which features are included in each tier continue to Basic and standard tiers.

* How much data do I plan to move daily?

    Each IoT Hub tier is available in three sizes, based around how much data throughput they can handle in any given day. These sizes are numerically identified as 1, 2, and 3. For example, each unit of a level 1 IoT hub can handle 400 thousand messages a day, while a level 3 unit can handle 300 million.

## Basic and standard tiers

The standard tier of IoT Hub enables all features, and is required for any IoT solutions that want to make use of the bi-directional communication capabilities. The basic tier enables a subset of the features and is intended for IoT solutions that only need uni-directional communication from devices to the cloud. Both tiers offer the same security and authentication features.

**Note**: IoT Hub also offers a free tier that is meant for testing and evaluation. The free tier does not support upgrading to basic or standard.

|Capability|Basic tier|Free/Standard tier|
|----------|----------|------------------|
|Device-to-cloud telemetry|Yes|Yes|
|Per-device identity|Yes|Yes|
|Message routing, message enrichments, and Event Grid integration|Yes|Yes|
|HTTP, AMQP, and MQTT protocols|Yes|Yes|
|Device Provisioning Service|Yes|Yes|
|Monitoring and diagnostics|Yes|Yes|
|Cloud-to-device messaging|    |Yes|
|Device twins, Module twins, and Device management|    |Yes|
|Device streams (preview)|    |Yes|
|Azure IoT Edge|    |Yes|
|IoT Plug and Play Preview|    |Yes|

## Message throughput

Message traffic is measured for your IoT hub on a per-unit basis. When you create an IoT hub, you choose its tier and edition, and set the number of units available. You can purchase up to 200 units for the B1, B2, S1, or S2 edition, or up to 10 units for the B3 or S3 edition. After your IoT hub is created, you can change the number of units available within its edition, upgrade or downgrade between editions within its tier (B1 to B2), or upgrade from the basic to the standard tier (B1 to S1) without interrupting your existing operations.

Only one type of edition within a tier can be chosen per IoT Hub. For example, you can create an IoT Hub with multiple units of S1, but not with a mix of units from different editions, such as S1 and S2.

As an example of each tier's traffic capabilities, device-to-cloud messages follow these sustained throughput guidelines:

|Tier edition|Sustained throughput|Sustained send rate|
|------------|--------------------|-------------------|
|B1, S1|Up to 1111 KB/minute per unit<br>(1.5 GB/day/unit)|Average of 278 messages/minute per unit<br>(400,000 messages/day per unit)|
|B2, S2|Up to 16 MB/minute per unit<br>(22.8 GB/day/unit)|Average of 4,167 messages/minute per unit<br>(6 million messages/day per unit)|
|B3, S3|Up to 814 MB/minute per unit<br>(1144.4 GB/day/unit)|Average of 208,333 messages/minute per unit<br>(300 million messages/day per unit)|

## Partitions

Azure IoT hubs contain many of the core components of Azure Event Hubs, including Partitions. 

The event streams for IoT hubs are generally populated with incoming telemetry data that is reported by various IoT devices. The partitioning of the event stream is used to reduce contentions that could occur when concurrently reading and writing to event streams.

The partition limit is chosen when IoT Hub is created and cannot be changed, so long-term scale should be considered when setting partition count. The maximum partition limit is 32 for both the basic and standard tiers of IoT Hub, but most IoT hubs only need 4 partitions. The number of partitions is directly related to the number of concurrent readers you expect to have.

The decision on how many partitions are needed is made by the solution architect. The default value of 4 partitions should be used unless otherwise specified by the architect.

## Tier upgrade

Once you create your IoT hub, you can upgrade from the basic tier to the standard tier without interrupting your existing operations. The partition configuration remains unchanged when you migrate from basic tier to standard tier.

**Note**: If you want to downgrade your IoT hub, you can remove units and reduce the size of the IoT hub but you cannot downgrade to a lower tier. For example, you can move from the S2 tier to the S1 tier, but not from the S2 tier to the B1 tier.

---

**Instructor Notes**

IoT Hub is so central to an IoT solution and so interconnected to features of the solution that it's hard to choose the best starting point for a linear/sequential presentation to students (the Docs content is built for an online consumer who can start with an Overview and then follow links that go in pretty much any/every direction, which may be okay for self-serve online content).

In Module 1 we provided a high-level introduction to the IoT Hub service. This intro supported a lab that included initial setup of the service. In this module we need to help the students to start Using the service. This includes providing a deeper understanding of the initial setup from the previous module. The challenge is to pick a meaningful order in which to present the material that also minimizes terminology overload in any one topic.

We chose a topic order for this lesson that provide students with an understanding of the IoT Hub features that relate to devices and the relationship between the hub and devices.

[Choose the right IoT Hub tier for your solution](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-scaling)

[Azure IoT Hub pricing](https://azure.microsoft.com/en-us/pricing/details/iot-hub/)

[How to upgrade your IoT hub](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-upgrade)

[IoT Hub Glossary](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-glossary#modules)

(MCB) The "partition" concept is potentially very complicated and it's easy to get lost in it.  We should consider how to approach that (assuming it's not clarified later?)

(CAH) Partitions - we should not get into the weeds on how to choose the number partitions. A general level of understanding is appropriate since they will/may be setting this configuration value and may wonder what it means. I updated the content above to indicate that the number of partitions required is defined by the solution architect.

[Event Hubs terminology - Partitions](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-features#partitions)

[Event Hubs - Availability and consistency - Partition tolerance](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-availability-and-consistency#partition-tolerance)