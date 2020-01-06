# Why use Azure Time Series Insights?

Azure Time Series Insights Preview is an end-to-end platform-as-a-service (PaaS) offering. You can use it to collect, process, store, analyze, and query data at an Internet of Things (IoT) scale.

## Definition of IoT data

Industrial IoT data in asset-intensive organizations often lacks structural consistency due to the varied nature of devices and sensors in an industrial setting. Data from these streams are characterized by significant gaps, and sometimes corrupted messages, and false readings. IoT data is often meaningful in the context of additional data inputs that come from first-party or third-party sources, such as CRM or ERP that add context for end-to-end workflows. Inputs from third-party data sources such as weather data can help augment telemetry streams in a given installation.

In some industrial IoT scenarios, only a fraction of the data gets used for operational and business purposes, and analysis often requires contextualization of the data in order to be effective. Industrial data is often historicized for in-depth analysis over longer time spans to understand and correlate trends. 

Turning collected IoT data into actionable insights requires:

* Data processing to clean, filter, interpolate, transform, and prepare data for analysis.
* A structure to navigate through and understand the data, that is, to normalize and contextualize the data.
* Cost-effective storage for long or infinite retention of processed (or derived) data and raw data.

Such data provides consistent, comprehensive, current, and correct information for business analysis and reporting.

## Azure Time Series Insights for industrial IoT

The IoT landscape is diverse with customers spanning a variety of industry segments including manufacturing, automotive, energy, utilities, smart buildings, and consulting. Across this broad range of industrial IoT market, cloud-native solutions that provide comprehensive analytics targeted at large-scale IoT data are still evolving.

Azure Time Series Insights addresses this market need by providing a turnkey, end-to-end IoT analytics solution with rich semantic modeling for contextualization of time series data, asset-based insights, and best-in-class user experience for discovery, trending, anomaly detection and operational intelligence.

A rich operational analytics platform combined with our interactive data exploration capabilities, you can use Time Series Insights to derive more value out of data collected from IoT assets. The preview offering supports:

* Multi-layered storage solution with warm and cold analytics support providing customers the option to route data between warm and cold for interactive analytics over warm data as well as operational intelligence over decades of historical data.

    * A highly interactive warm analytics solution to perform frequent, and large number of queries over shorter time span data
    * A scalable, performant, and cost optimized time series data lake based on Azure Storage allowing customers to trend years’ worth of time series data in seconds.

* Semantic model support that describes the domain and metadata associated with the derived and raw signals from assets and devices.
* Flexible analytics platform to store historical time series data in customer-owned Azure Storage account, thereby allowing customers to have ownership of their IoT data. Data is stored in open source Apache Parquet format that enables connectivity and interop across a variety of data scenarios including predictive analytics, machine learning, and other custom computations done using familiar technologies including Spark, Databricks, and Jupyter.
* Rich analytics with enhanced query APIs and user experience that combines asset-based data insights with rich, ad hoc data analytics with support for interpolation, scalar and aggregate functions, categorical variables, scatter plots, and time shifting time series signals for in-depth analysis.
* Enterprise grade platform to support the scale, performance, security, and reliability needs of our enterprise IoT customers.
* Extensibility and integration support for end-to-end analytics. Time Series Insights provides an extensible analytics platform for a variety of data scenarios. Time Series Insights Power BI connector enables customers to take the queries they do in Time Series Insights directly into Power BI to get unified view of their BI and time series analytics in a single pane of glass.

## Features and Benefits

Azure Time Series Insights provides a scalable pay-as-you-go pricing model for data processing, storage (data and metadata), and query, enabling customers to tune their usage to suit their business demands.

With the introduction of these key industrial IoT capabilities, Time Series Insights also provides the following key benefits.

|Benefit|Description|
|-------|-----------|
|Multilayered storage for IoT-scale time series data|With a shared data processing pipeline for ingesting data, you can ingest data into both warm and cold stores. Use warm store for interactive queries and cold store for storing large volumes of data. To learn more about how to take advantage of high-performing asset-based queries, see queries.|
|Time Series Model to contextualize raw telemetry and derive asset-based insights|You can use the time series model to create instances, hierarchies, types, and variables for your time series data. To learn more about Time Series Model, see Time Series Model.|
|Smooth and continuous integration with other data solutions|Data in Time Series Insights cold store is stored in open-source Apache Parquet files. This enables data integration with other data solutions, 1st or 3rd party, for scenarios that include business intelligence, advanced machine learning, and predictive analytics.|
|Near real-time data exploration|The Azure Time Series Insights Preview explorer user experience provides visualization for all data streaming through the ingestion pipeline. After you connect an event source, you can view, explore, and query event data. In this way, you can validate whether a device emits data as expected. You also can monitor an IoT asset for health, productivity, and overall effectiveness.|
|Extensibility and integration|The Azure Time Series Insights Power BI Connector integration is available directly in the Time Series Explorer user experience through the Export option, allowing customers to export the time series queries they create in our user experience directly into the Power BI desktop and view their time series charts alongside other BI analytics. This opens the door to a new class of scenarios for industrial IoT enterprises who have invested in Power BI by providing a single pane of glass over analytics from various data sources including IoT time series.|
|Custom applications built on the Time Series Insights platform|Time Series Insights supports the JavaScript SDK. The SDK provides rich controls and simplified access to queries. Use the SDK to build custom IoT applications on top of Time Series Insights to suit your business needs. You also can use the Time Series Insights Query APIs directly to drive data into custom IoT applications.|

---

**Instructor Notes**

Microsoft hosts a sandbox environment of the TSI Explorer that has been pre-populated with tens of millions of rows of time series data. The site has a built-in introduction / tutorial and then allows you to explore and experiment.  You could use this demo to provide students with a quick tour of TSI.

**Note**: This demo is built for a different scenario than the main one we will be using for this course. It analyzes three factories with 16 total machines.  

Demo can be found here [time series insights demo](https://insights.timeseries.azure.com/demo). Use your Microsoft identity (such as an Office 365 login) to connect. It provides a hands-on tour of many of the main components of the TSI Explorer: the **Time selection panel**, the **Terms panel**, the chart region, the events grid, the export capabilities, the series filter... and more. 



**TODO - Reviewers: any reason to keep this information?**



(MCB) wrt the reviewer question - not sure we need this.  isn't there enough in the "what is"  part?
