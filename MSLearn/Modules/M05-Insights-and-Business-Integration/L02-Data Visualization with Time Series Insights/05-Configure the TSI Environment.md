# Configure the TSI Environment

Azure Time Series Insights is a fully managed analytics, storage, and visualization service that makes it incredibly simple to explore and analyze billions of IoT events simultaneously. Time Series Insights gives you a global view of your data, letting you quickly validate your IoT solution and avoid costly downtime to mission-critical devices by helping you discover hidden trends, spot anomalies, and conduct root-cause analyses in near real-time.

* Find actionable insights in seconds
* Start in seconds, scale in minutes
* Create a global view of your IoT-scale data
* Leverage Time Series Insights in your Apps and Solutions

## Create Your TSI Resource  

You can create a new Azure Time Series Insights resource in the Azure portal using the following steps:

1. Search the Azure Marketplace for "Time Series Insights".

    ![Time Series Insights Set Up - Create Instance](../../Linked_Image_Files/M05_L01_AzureTSI-Setup-1-create.PNG)

1. On the Create Time Series Insights environment blade, fill in the parameters on the Basic tab

    |Parameter|Action|
    |---------|------|
    |Environment name|Enter a unique name for the Azure Time Series Insights Preview environment.|
    |Subscription|Enter the subscription where you want to create the Azure Time Series Insights Preview environment. A best practice is to use the same subscription as the rest of the IoT resources that are created by the device simulator.|
    |Resource group|Select an existing resource group or create a new resource group for the Azure Time Series Insights Preview environment resource. A resource group is a container for Azure resources. A best practice is to use the same resource group as the other IoT resources that are created by the device simulator.|
    |Location|Select a data center region for your Azure Time Series Insights Preview environment. To avoid additional latency, it's best to create your Azure Time Series Insights Preview environment in the same region as your IoT hub created by the device simulator.|
    |Tier|Select PAYG (pay-as-you-go). This is the SKU for the Azure Time Series Insights Preview product.|
    |Property ID|Enter a value that uniquely identifies your time series instance. The value you enter in the Property ID box cannot be changed later. When the data source is an IoT Hub, iothub-connection-device-id is often used. To learn more about Time Series ID, see Best practices for choosing a Time Series ID.|
    |Storage account name|Enter a globally unique name for a new storage account.|
    |Enable warm store|Select Yes to enable warm store.|
    |Data retention (in days)|Choose the default option of 7 days.|

    ![Time Series Insights Set Up - Set Parameters 1](../../Linked_Image_Files/M05_L01_AzureTSI-Setup-2-parameters-1.PNG)

    ![Time Series Insights Set Up - Set Parameters 2](../../Linked_Image_Files/M05_L01_AzureTSI-Setup-2-parameters-2.PNG)

    Once you have this information entered, navigate to the Event Source tab.

1. Fill in the parameters on the Event Source tab

    |Parameter|Action|
    |---------|------|
    |Create an event source?|Select Yes.|
    |Name|Enter a unique value for the event source name.|
    |Source type|Select IoT Hub.|
    |Select a hub|Choose Select existing.|
    |Subscription|Select the subscription that you are using for this course.|
    |IoT Hub name|Select the IoT hub name that you are using for this course.|
    |IoT Hub access policy|Select iothubowner.|
    |IoT Hub consumer group|Select New, enter a unique name, and then select Add. The consumer group must be a unique value in Azure Time Series Insights Preview.|
    |Timestamp property|This value is used to identify the Timestamp property in your incoming telemetry data. Time Series Insights defaults to the incoming timestamp from IoT Hub.|

    ![Time Series Insights Set Up - Set Parameters 3](../../Linked_Image_Files/M05_L01_AzureTSI-Setup-2-parameters-3.PNG)

    Once you have this information entered, navigate to the Review + Create tab.

1. Use the Review + Create tab to ensure that you entered values correctly, and then click Create to deploy your TSI service.

    You have access to your Azure Time Series Insights Preview environment by default if you are an owner of the Azure subscription. You can verify that you have access by opening your TSI service and checking to see that your credentials are listed on the Data Access Policies blade. 
