# Cloud Service Components of an IoT Solution

In this topic, you'll learn:

* About cloud-based gateways and storage options
* About cloud-based analytics and data visualization
* About how to use machine learning in IoT solutions

As we noted in the last topic, the cloud services you choose is an essential part of your overall solution. In fact, the cloud services used in your solution constitutes the 'I' in IoT. There are options from many of the larger companies participating in this space as well as offerings from startups and medium-sized businesses. You can explore the individual offerings on your own. In this topic, we'll look at categories of services these companies offer to give you an idea of how cloud services fit into an overall IoT architecture.

## Cloud Gateways

In an earlier topic in this lesson, we looked at, briefly, the concept of a field gateway--a piece of hardware that brokers communication between IoT devices and cloud services. Cloud gateways do more than broker communication. They provide a set of services that devices can run either locally or in the cloud. Cloud gateways can provide workloads such as (among others):

* Authentication and authorization
* Message brokering
* Data storage and filtering
* Data analytics
* Functions (discrete code blocks that perform specific tasks)

![Cloud Gateway](../../Linked_Image_Files/M01_L03_cloud_gateway.png "Cloud Gateway")

## Data Storage Options

Given the centrality of data in an IoT solution, figuring out the right cloud-based data storage and retrieval options ranks high on the list in terms of importance. IoT devices can generate enormous amounts of data very quickly and storing high volumes of data in the cloud can not become expensive but also unwieldy--you have to be able to do something with the data and too much of it can make analytics and decision-making harder.

Cloud service providers are continually updating their data services to make it easier and more cost-effective for organizations to store, manage,and analyze data. Even so, a thorough analysis of cloud storage technical options and prices should be a fundamental part of any IoT architecture. For example, some architectures may demand a multi-tiered approach with some data being stored on the device, other stored in on-premise databases and other data stored in the cloud. Depending on the needed architecture, you should be sure the cloud services you choose supports your needs.

Here are some other concepts to be aware of when considering cloud storage.

Data is often time series data and is required to be stored where it can be used in visualization and reporting as well as later accessed for additional processing. It is common to have data split into “warm” and "cold" data stores. The **warm data store** holds recent data that needs to be accessed with low latency. Data stored in **cold storage** is typically historical data. Most often the cold storage database solution chosen will be cheaper in cost but offer fewer query and reporting features than the warm database solution.

**Note**: The Lambda architecture for data storage going to warm and cold storage is introduced later in this course.

A common implementation for storage is to keep a recent range (e.g. the last day, week, or month) of telemetry data in warm storage and to store historical data in cold storage. With this implementation, the application has access to the most recent data and can quickly observe recent telemetry data and trends. Retrieving historical information for devices can be accomplished using cold storage, generally with higher latency than if the data were in warm storage.

![Warm and Cold Storage](../../Linked_Image_Files/M01_L03_warm-cold-storage.png "Warm and Cold Storage")

Cloud service providers may provide services to support both types of storage and make managing data across these types easier.[^1]

[^1]: You can read more about warm and cold storage different technologies Microsoft Azure provides for managing these storage options in section 3.5 of the [Azure Reference Architecure document](https://aka.ms/iotrefarchitecture).

## Analytics Services and Data Visualization

### Analytics

Once data is captured and stored, it only becomes useful when it provides insights into the physical world from which your IoT devices have captured the data. This is where analytic services come into play.

Azure Analysis Services, for example, enable architects to use advanced mashup and modeling features to combine data from multiple data sources, define metrics, and secure data in a single, trusted tabular [semantic data model](https://en.wikipedia.org/wiki/Semantic_data_model). The data model provides an easier and faster way for users to browse massive amounts of data for ad-hoc data analysis.

Without analytics, data collected from IoT would be too voluminous and unstructured to visualize or gain insights. Analytic services enable architects to build meaningful relationships between sets of data in order to make it easier to manage. For example, Azure Stream Analytics can take stream data from IoT devices and engineers can specify a transformation query that defines how to look for data, patterns, or relationships. The transformation query leverages a SQL-like query language that is used to filter, sort, aggregate, and join streaming data over a period of time.

![Stream Analytics](../../Linked_Image_Files/M01_L03_stream-analytics.png "Stream Analytics")

### Data Visualization

Stream analytics can help condition data so its easier to manage and provides models that give insight into what you need to understand or learn. Once the data is conditioned and you've created the right models, the data can be visualized using tools like Microsoft's Power BI or Tableau so it can be acted upon.

Data visualization tools can take input from various data streams and combine them into "dashboards" that can be used to tell a story about the data that was collected. Ultimately, this is the goal of IoT.

![Data Visualization](../../Linked_Image_Files/M01_L03_data-visualization.png "Data Visualization")

## Machine Learning

Machine Learning (ML) is one of the more exiting developments in modern computer science. It's a complex field but one that is producing significant positive results with large datasets. As we've said throughout this course, IoT devices produces large large volumes of data. Analytic systems help engineers to model the existing data in meaningful ways. [Machine learning](https://en.wikipedia.org/wiki/Machine_learning) takes this a step further and can actually make predictions about what new data will show and provide insights that would not be possible without the machine learning algorithms.

As the name states, the technology gives computers the ability to "learn" (predict) from data by expressing trends or a direction future data will take. This can provide engineers with a powerful mechanism for enabling a wide variety of scenarios.

Using big data and machine learning to predict purchasing decisions is one simple example. Suppose a retailer has warehouse space in various cities and needs to determine which items to stock in those cities in order to be able to get products to customers in the most efficient and timely way. Using machine learning the retailer can predict, for example, that a given set of users that purchase a specific television tend to buy a particular type of cable and other accessories like tv stands and audio equipment. This would allow the retailer to keep those items in the warehouse near where those television sales are popular so that if a customer orders the cable or other accessory, the item can be shipped more and get to the customer more quickly.

Can you think of other, IoT-specific scenarios where machine learning would be help enable various scenarios that can make the IoT architecture more effective?

Because of the tremendous amount of computer power needed to perform the calculations needed to do this type of analysis, cloud-based ML technology tends to be the most effective at providing the type of insights machine learning promises.

## Conclusion

In this topic, we've surveyed the various cloud-based services and technologies that make IoT possible. Below, you can try your hand at using the Azure cloud to model IoT scenarios. While these exercises are just an introduction to the space, they can give you a good feel for how the technology works together and how it can be used in an IoT architecture.
