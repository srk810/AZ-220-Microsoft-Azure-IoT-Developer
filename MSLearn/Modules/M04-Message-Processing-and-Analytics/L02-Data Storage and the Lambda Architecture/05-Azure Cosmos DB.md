# Azure Cosmos DB

Today’s applications are required to be highly responsive and always online. To achieve low latency and high availability, instances of these applications need to be deployed in datacenters that are close to their users. Applications need to respond in real time to large changes in usage at peak hours, store ever increasing volumes of data, and make this data available to users in milliseconds.

## Key Benefits

* Azure Cosmos DB natively partitions your data for high availability and scalability. Azure Cosmos DB offers 99.99% guarantees for availability, throughput, low latency, and consistency on all single-region accounts and all multi-region accounts with relaxed consistency, and 99.999% read availability on all multi-region database accounts.
* Azure Cosmos DB has SSD backed storage with low-latency order-of-millisecond response times.
* Azure Cosmos DB's support for consistency levels like eventual, consistent prefix, session, and bounded-staleness allows for full flexibility and low cost-to-performance ratio. No database service offers as much flexibility as Azure Cosmos DB in levels consistency.
* Azure Cosmos DB has a flexible data-friendly pricing model that meters storage and throughput independently.
* Azure Cosmos DB's reserved throughput model allows you to think in terms of number of reads/writes instead of CPU/memory/IOPs of the underlying hardware.
* Azure Cosmos DB's design lets you scale to massive request volumes in the order of trillions of requests per day.

## Cosmos DB Scenarios for IoT

### Scenario 1

IoT use cases commonly share some patterns in how they ingest, process, and store data. First, these systems need to ingest bursts of data from device sensors of various locales. Next, these systems process and analyze streaming data to derive real-time insights. The data is then archived to cold storage for batch analytics. Microsoft Azure offers rich services that can be applied for IoT use cases including Azure Cosmos DB, Azure Event Hubs, Azure Stream Analytics, Azure Notification Hub, Azure Machine Learning, Azure HDInsight, and Power BI.

Bursts of data can be ingested by Azure IoT Hub as it offers high throughput data ingestion with low latency. Data ingested that needs to be processed for real-time insight can be funneled to Azure Stream Analytics for real-time analytics. Data can be loaded into Azure Cosmos DB for adhoc querying. Once the data is loaded into Azure Cosmos DB, the data is ready to be queried. In addition, new data and changes to existing data can be read on change feed. Change feed is a persistent, append only log that stores changes to Cosmos containers in sequential order. The all data or just changes to data in Azure Cosmos DB can be used as reference data as part of real-time analytics. In addition, data can further be refined and processed by connecting Azure Cosmos DB data to HDInsight for Pig, Hive, or Map/Reduce jobs. Refined data is then loaded back to Azure Cosmos DB for reporting.

### Scenario 2

The data generated from increasing network sensors brings an unprecedented visibility into previously opaque systems and processes. The key is to find actionable insights in this torrent of information regardless of where IoT devices are distributed around the globe. Azure Cosmos DB allows IOT companies to analyze high-velocity sensor, and time-series data in real-time anywhere around the world. It allows you to harness the true value of an interconnected world to deliver improved customer experiences, operational efficiencies, and new revenue opportunities.

---

**Instructor Notes**

[Welcome to Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/introduction)

[Azure Stream Analytics output to Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-documentdb-output)

[Use-cases for built-in analytics with Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/analytics-usecases)

[Common Azure Cosmos DB use cases](https://docs.microsoft.com/en-us/azure/cosmos-db/use-cases)
