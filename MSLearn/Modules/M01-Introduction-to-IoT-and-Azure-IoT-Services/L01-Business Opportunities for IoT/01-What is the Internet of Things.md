# What is the Internet of Things?

Although IoT has matured as a technology in recent years, a range of definitions still proliferate. The most commonly accepted of these definitions is similar to the following:

_The Internet of Things is the network of physical devices that combine IP connectivity with software, sensors, actuators, and other electronics to directly integrate the physical world into our computer-based systems, resulting in efficiency improvements and economic benefits_

Some definitions take this a bit further by adding that IoT will make our lives easier, more efficient, and more cost effective.

Although these types of definitions do provide us with some specifics, they often try to encompass all possibilities within a single sentence, which can make them somewhat convoluted and confusing. Here is a simpler version of the definition above:

_The Internet of Things is a network of Internet connected devices that communicate embedded sensor data to the cloud for centralized processing_

This definition gets more to the essence of what IoT is, but probably doesn't give us enough nuance to really understand the space. In fact, coming up with a definition is pretty challenging even though the core concepts are fairly straightforward. The international organization Institute of Electrical and Electronics Engineers (IEEE) has been developing [a white paper](https://iot.ieee.org/images/files/pdf/IEEE_IoT_Towards_Definition_Internet_of_Things_Revision1_27MAY15.pdf) just on a definition of IoT. Their paper is 75 pages long (86 with glossary and notes) so far (it's not final) and the definition alone at the end of the paper is roughly four pages long (pages 70-73). If you want a comprehensive overview of the technology, this is the place to start.

Thankfully, we don't have to go as deep as the IEEE to get a good overview of the technology. Put simply, IoT involves two essential components:

1. A device-side (made up of individual devices) that acts as a data source
2. A cloud-side that gathers data and provides resources for analyzing it

Of course, once we dig in we will find that both the device-side and the cloud-side involve complex implementations that provide hundreds of required features, and even the communication between the device and cloud requires secure communication protocols. But at least we have something simple that can get us started.

## Simple IoT Example

Perhaps the best way to understand an IoT solution is to consider an example. The specifics of this example are fictional but it should illustrate how the technology could be used.

### Scenario

Suppose a small town is trying to figure out how to price water during the summer months. They want the town to look nice and enable people to keep their lawns green but they also want to discourage people from wasting water which is in shorter supply during the summer. The town's officials need data to determine how often people actually _need_ to water their lawns to keep them green and will use this data to help inform what price they should put on water usage during the summer.

### The IoT Solution

In order to collect they data they need, the town's officials select 100 homes at random across the town and ask them to install a small water sensor in their lawns. The sensor will detect the amount of moisture in the soil and send that data over the home's Wi-Fi connection to a central cloud service that will collect and store the data.

#### The Devices

The devices have the following requirements:

* They must be small and unobtrusive.
* They must be able to connect to Wi-Fi and be monitored by the home owner.
* They must be battery operated and be able to run for 6 months without needing a new battery.
* They must be able to detect moisture in the soil in percent saturation.
* They must be able to store data for a 72-hour period in case the connection with the Wi-Fi router is lost.
* They must be able to provide a rudimentary failure signal.

There could be a lot of other device requirements but these are the basics the device must contain. City engineers visit each house that has agreed to install the sensor, place the device in the yard at an optimal location, connect the device to the home's Wi-Fi router, and test the connection with the cloud service.

#### The Data

The devices are programmed to collect moisture data every hour for a 24 hour period and average the readings to form a single number that is sent to the cloud service for storage. The dataset includes the device ID, the GPS location, a time/date stamp, moisture level, and other relevant metadata.

#### The Cloud Service

City engineers implement a cloud-based solution to listen for incoming data from each device and collect that data in a database. The cloud service also listens for failure signals and can alert city engineers of an actual or pending device failure. The cloud services include an IoT gateway that handles communication with the devices, a storage solution to store the data, stream analytics service to manage the data coming in from the devices and an analytic service to analyze the data and inform decision making.

#### Analytics and Assessment

In our scenario, the town officials will use this data to better understand how often people actually are watering their lawns and how often they need to, and to make recommendations to both the homeowners and policy makers about water usage and costs. Since weather is variable, the city engineers may need to collect data for many months to get accurate and actionable data. But the first step is to collect the data in the first place and that's the power of IoT.

---

**Instructor Notes**

[What is Azure Internet of Things](https://docs.microsoft.com/en-us/azure/iot-fundamentals/iot-introduction)

For additional scenarios, see the list the IEEE is compiling [here](https://iot.ieee.org/iot-scenarios.html).  

(MCB) This feels like two slides - one that's the two bullet points as a definition and one that talks about the example?  Also, this example is really great, but I'm assuming it will flow all the way from end to end - if not, some reconsideration should happen.
