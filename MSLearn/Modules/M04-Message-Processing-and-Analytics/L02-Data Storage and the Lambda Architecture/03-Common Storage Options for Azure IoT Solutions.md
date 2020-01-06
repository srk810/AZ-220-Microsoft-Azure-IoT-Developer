# Common Storage Options for Azure IoT Solutions

There are several storage options available in Azure for IoT solutions.

## Azure Storage Options

Azure Storage is Microsoft's cloud storage solution for modern data storage scenarios. Azure Storage offers a massively scalable object store for data objects, a file system service for the cloud, a messaging store for reliable messaging, and a NoSQL store. Azure Storage is:

* Durable and highly available. Redundancy ensures that your data is safe in the event of transient hardware failures. You can also opt to replicate data across datacenters or geographical regions for additional protection from local catastrophe or natural disaster. Data replicated in this way remains highly available in the event of an unexpected outage.
* Secure. All data written to Azure Storage is encrypted by the service. Azure Storage provides you with fine-grained control over who has access to your data.
* Scalable. Azure Storage is designed to be massively scalable to meet the data storage and performance needs of today's applications.
* Managed. Microsoft Azure handles hardware maintenance, updates, and critical issues for you.
* Accessible. Data in Azure Storage is accessible from anywhere in the world over HTTP or HTTPS. Microsoft provides client libraries for Azure Storage in a variety of languages, including .NET, Java, Node.js, Python, PHP, Ruby, Go, and others, as well as a mature REST API. Azure Storage supports scripting in Azure PowerShell or Azure CLI. And the Azure portal and Azure Storage Explorer offer easy visual solutions for working with your data.

### Azure Storage services

Azure Storage includes these data services:

* Azure Blobs: A massively scalable object store for text and binary data.
* Azure Files: Managed file shares for cloud or on-premises deployments.
* Azure Queues: A messaging store for reliable messaging between application components.
* Azure Tables: A NoSQL store for schemaless storage of structured data.

**Note**: IoT Hub can route messages to Azure Blob Storage accounts.

## Azure Data Lake Gen2

Azure Data Lake Storage Gen2 is a set of capabilities dedicated to big data analytics, built on Azure Blob storage. Data Lake Storage Gen2 is the result of converging the capabilities of our two existing storage services, Azure Blob storage and Azure Data Lake Storage Gen1. Features from Azure Data Lake Storage Gen1, such as file system semantics, directory, and file level security and scale are combined with low-cost, tiered storage, high availability/disaster recovery capabilities from Azure Blob storage.

## Azure Cosmos DB

Azure Cosmos DB is Microsoft's globally distributed, multi-model database service. Cosmos DB enables you to elastically and independently scale throughput and storage across any number of Azure regions worldwide. You can elastically scale throughput and storage, and take advantage of fast, single-digit-millisecond data access using your favorite API including SQL, MongoDB, Cassandra, Tables, or Gremlin. Cosmos DB provides comprehensive service level agreements (SLAs) for throughput, latency, availability, and consistency guarantees, something no other database service offers.

## Azure SQL Database

Azure SQL Database is a general-purpose relational database, provided as a managed service. With it, you can create a highly available and high-performance data storage layer for the applications and solutions in Azure. SQL Database can be the right choice for a variety of modern cloud applications because it enables you to process both relational data and non-relational structures, such as graphs, JSON, spatial, and XML.

---

**Instructor Notes**


[Introduction to Azure Storage](https://docs.microsoft.com/en-us/azure/storage/common/storage-introduction)

[Introduction to Blob storage](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction)

[Introduction to Azure Files](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-introduction)

[Introduction to Queues](https://docs.microsoft.com/en-us/azure/storage/queues/storage-queues-introduction)

[Overview of Azure Table storage](https://docs.microsoft.com/en-us/azure/storage/tables/table-storage-overview)

[Welcome to Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/introduction)

[Azure Stream Analytics output to Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-documentdb-output)

[Introduction to Azure Data Lake Storage Gen2](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction?toc=%2fazure%2fstorage%2fblobs%2ftoc.json)


(MCB) for slides, at least, I could see one slide that lists these, then one slide for each one of the following lessons... the instructor flow would be "there are four storage services we're going to look at... let's look at each in detail."