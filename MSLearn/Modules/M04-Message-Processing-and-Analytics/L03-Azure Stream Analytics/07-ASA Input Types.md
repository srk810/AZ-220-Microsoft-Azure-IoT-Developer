# ASA Input Types

Azure Stream Analytics jobs connect to one or more data inputs. Each input defines a connection to an existing data source. Stream Analytics accepts data incoming from several kinds of event sources including Event Hubs, IoT Hub, and Blob storage. The inputs are referenced by name in the streaming SQL query that you write for each job. In the query, you can join multiple inputs to blend data or compare streaming data with a lookup to reference data, and pass the results to outputs.

Stream Analytics has first-class integration with three kinds of resources as inputs:

* Azure Event Hubs
* Azure IoT Hub
* Azure Blob storage

These input resources can live in the same Azure subscription as your Stream Analytics job, or from a different subscription.

You can use the Azure portal, Azure PowerShell, .NET API, REST API, and Visual Studio to create, edit, and test Stream Analytics job inputs.

## Stream and reference inputs

As data is pushed to a data source, it's consumed by the Stream Analytics job and processed in real time. Inputs are divided into two types: data stream inputs and reference data inputs.

### Data stream input

A data stream is an unbounded sequence of events over time. Stream Analytics jobs must include at least one data stream input. Event Hubs, IoT Hub, and Blob storage are supported as data stream input sources. Event Hubs are used to collect event streams from multiple devices and services. These streams might include social media activity feeds, stock trade information, or data from sensors. IoT Hubs are optimized to collect data from connected devices in Internet of Things (IoT) scenarios. Blob storage can be used as an input source for ingesting bulk data as a stream, such as log files.

For more information about streaming data inputs, see Stream data as input into Stream Analytics here: [https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-define-inputs](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-define-inputs)

### Reference data input

Stream Analytics also supports input known as reference data. Reference data is either completely static or changes slowly. It is typically used to perform correlation and lookups. For example, you might join data in the data stream input to data in the reference data, much as you would perform a SQL join to look up static values. Azure Blob storage and Azure SQL Database are currently supported as input sources for reference data. Reference data source blobs have a limit of up to 300 MB in size, depending on the query complexity and allocated Streaming Units (see the Size limitation section of the reference data documentation for more details).

For more information about reference data inputs, see Using reference data for lookups in Stream Analytics here: [https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-use-reference-data](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-use-reference-data)


---

**Instructor Notes**

[Understand inputs for Azure Stream Analytics](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-add-inputs)

[Using reference data for lookups in Stream Analytics](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-use-reference-data#azure-sql-database)

[Stream data as input into Stream Analytics](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-define-inputs)

(MCB) maybe just a slide with "Stream inputs" and "reference inputs" since we detail in the next lessons?