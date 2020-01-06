# IoT for Consumer and Businesses

Consider how you might answer the following questions:

* What makes one or more connected devices an IoT implementation?
* What is the difference between consumer devices and the devices used in an IoT business implementation?

Let's take a look a the first question - what is the difference between a connected device and an IoT device? For example, a personal computer generally is connected to the Internet. Does that make it an IoT device? Is a smartwatch or door lock that both have Internet connectivity IoT devices? Definitions can be hard to come by, but it's possible to put some boundaries around devices that should be included under the umbrella of IoT and those that should not.

## Characteristics of an IoT Device

Here are some characteristics that an IoT device must have.

1. **Connected to the Internet**. The most obvious criterion is that the device has a connection to the Internet with a unique identifier, and two-way communication. Both of these properties are important for a device to be considered a part of an IoT system. The device has to be unique to ensure secure communications with both the server and with other devices and the device has to be able to consume and deliver data. A primary value proposition for IoT is data _collection_ as well as consumption.

2. **Secure**. Being able to uniquely identify a device on the Internet or within an IoT ecosystem is one aspect of security but making a device secure also means it's resistant to being hacked (both the hardware and software), uses encrypted communication protocols, and is immune to mimicry either by an alternate hardware device or a virtual device.

3. **Smart Features**. This simply means that the device must have sensors or hardware that enable it to collect specific data based on events (like smoke in the air or a light being switched on or a key being turned). There is an implication that the device should be able to do this without user interaction so it has an "embedded intelligence."

4. **Communication Capabilities**. The device should have the capability to communicate not only with cloud-based services but with other devices.

5. **Configurable**. The device should be remotely configurable or have the ability to self-adjust its configuration based on changes in the ecosystem. This includes the ability to automatically install updates, modify sensor receptivity, repair problems, and modify energy consumption among others.

6. **Programmable**. Like connectivity to the Internet, this should be a basic function of any connected device but certainly is true of IoT devices. The main idea here is that the function of the device should be able to be modified without having to make changes to its hardware. This may mean that a device has a number of sensors that could be activated or deactivated by software or, if a single-purpose device, the features should be able to be modified by software to accomplish a different task (for example, a thermostat that can deliver outside temperature readings from a service vs. taking the internal temperature readings from a sensor).

These probably wouldn't be considered "core" features but here are other properties to consider when defining a device as an "IoT device."

* **Replaceable**. In many scenarios, when an IoT device fails (for example, a sensor on an airplane engine or wind turbine), the device should be able to be replaced and it's entire firmware and software settings loaded onto the device quickly and easily. This could mean that every programmable feature of the device should be able to be stored in the cloud and downloaded to a replacement device.

* **Environmentally Flexible**. Depending on the scenario, the device should be able to maintain power, collect and store data, and smartly upload stored data in the event of a power outage, and/or loss of Internet connectivity.  

## Consumer and Business Implementations

Now let's consider the second question - what is the difference between consumer devices and the devices used in an IoT business implementation? The difference between a consumer scenario and a business scenario often comes down to how the devices are being used and why. Or viewed a bit differently, the goals of the implementation and the data being generated.

When we consider the features of IoT devices above, some may be more important in business scenarios and others take more prominence in consumer scenarios. For example, designing a device so it can easily be replaced may be more important in mission-critical business scenarios than it would be for a consumer device that checks the weather or turns on your lights.

Let's take a look at a couple of scenarios and how they might differ. Microsoft created [a case study](https://microsoft.github.io/techcasestudies/iot/2017/06/30/baxenergy.html) for an IoT implementation for BaxEnergy--a company that supplies analytic and optimization solutions for energy companies. While this white paper largely is about data ingestion and processing, it illustrates features of an IoT solution that is relevant for this business but may not be relevant for a consumer device. Microsoft outlines the following benefits of IoT in three distinct areas.

### Data Ingestion

This area defines how sensors collect and queue data for deliver to the database. Specifically, the Microsoft solution:

* No complex setup for data acquisition via VPN
* Workload reduced to read/write operations by establishing queues
* Data flow divided into hot and cold paths
* Asynchronous model allows for temporary storage of the data without putting more pressure on the already busy databases

### Data in Motion

This category defines how the solution improves real-time monitoring of the energy plant. The article notes the following improvements:

* Visualizing real-time monitoring without accessing the database
* Presenting the data in nearly real time
* Portal still allowing for execution of queries on historical data
* Immediate notification as soon as the device is not sending any data

### Messaging and Analytics

This category describes how incoming data is analyzed workflows are triggered based on certain event parameters.

* Creation of automatic workflows and additional services
* Instantaneous notification to wind farm operators so they can take immediate action
* Cost-effective feature
* Real-time data analytics

The advantages provided to BaxEnergy from this particular IoT implementation may be true of many business scenarios. Real time monitoring and reporting, real-time analytics, problem reporting, and asynchronous data communication are essential in many business contexts. These probably wouldn't be true in most consumer contexts.

For example, taking the paradigm case of a connected thermostat, getting real-time information about energy usage may not be that important. A customer may only need (and actually prefer) weekly or monthly reports so the data the device is collecting doesn't need to be analyzed in real time or available immediately after it's collected. Similarly, the home thermostat may not need to be able to initiate additional workflows when specific events occur or queue data if the power goes out.

## Consumer versus Business Goals for IoT

### Consumer Products and IoT

Individual consumers implement cloud connected devices (such as doorbells, thermostats, and even refrigerators) in order to make their life easier, more comfortable, or more secure. Consumer devices in the home are not typically being used for the same purpose as an IoT device implemented in a business scenario.

While IoT in the consumer space is still fairly nascent, there regularly are new examples of the technology being used to improve customer experiences and expand product features. Here are a few scenarios (some with which you may already be familiar):

* **Connected Assistants**.  Devices like the [Amazon Echo](https://www.amazon.com/Amazon-Echo-And-Alexa-Devices/b?node=9818047011) series are becoming more and more common in homes, allowing control of smart home devices such as lights and outlets, and external connection to services such as music streaming services.

* **Connected Refrigerators**. The [Samsung "Family Hub"](https://www.samsung.com/us/explore/family-hub-refrigerator/connected-hub/) line of refrigerators includes a large, touch screen that enables customers to more easily track their food inventory through the use of interior, web-enabled cameras, an easy-to-use shopping list, calendaring and TV mirroring features. While the element of data collection and analysis isn't central to this IoT solution, the refrigerator is an early look at the potential for connected appliances.

* **Connected Doorbells and Cameras**. Many companies have gotten into the consumer doorbell and camera business. The [Ring](https://ring.com/) system and Google's [Nest Hello](https://nest.com/doorbell/nest-hello/overview/) device are examples. These doorbells record and store video and enable two-way voice and one-way video calling for people at the door. The Nest device will do facial recognition and use AI to determine which type of object it detects (car, person, animal).

* **Connected Thermostats**. As we mentioned earlier, the connected thermostat is probably the most widely-used example of an IoT consumer device most likely because it was one of the first connected devices to check all the boxes in terms of using an IoT architecture. The most famous device is the [Nest Thermostat](https://nest.com/thermostats/) but there are others. These devices enable customers to view and control their indoor temperature anywhere using a mobile device and an Internet connection, set a heating and cooling schedule, view historical data on their home's temperature and energy consumption, and even get alerts when their heater's filter needs to be changed.

There are many other connected devices coming to market, that range from practical to weird. But the possibilities are nearly endless. Consumers are moving from a mindset of experimentation to anticipation that will soon evolve into expectation as connected devices enable customers to do more.

### Business Goals and IoT

In a way, business goals for IoT are simple compared with consumer goals. Businesses tend to implement IoT solutions in order to be more profitable, to increase safety for their work force, and to more easily comply with government regulations in order to create a better business environment. Profitability can be realized either directly through cost reductions or indirectly through competitive advantage. For example, businesses can use IoT to reduce their manufacturing or operating costs, which increase profits directly. Or, a business could use IoT to provide customers with improved service, resulting in increased market share (and overall profits). In most cases both the business and their customer benefit.

Business goals for IoT focus on improvement in one or more of the following areas:

* Product Quality and Extended Product Lifetime
* Service Reliability and Uptime
* Operating Efficiency
* Workforce safety
* Governmental compliance

We've been looking at specific business-focused scenarios for IoT solutions but you can read more at the [Microsoft IoT site](https://www.microsoft.com/en-us/internet-of-things) to see examples of how industry and vertical lines of business are using the technology.
