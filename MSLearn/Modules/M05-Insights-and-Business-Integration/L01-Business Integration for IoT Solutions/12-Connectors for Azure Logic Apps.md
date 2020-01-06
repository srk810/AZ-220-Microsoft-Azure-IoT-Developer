# Connectors for Azure Logic Apps

Connectors provide quick access from Azure Logic Apps to events, data, and actions across other apps, services, systems, protocols, and platforms. By using connectors in your logic apps, you expand the capabilities for your cloud and on-premises apps to perform tasks with the data that you create and already have.

**Note**: To integrate with a service or API that doesn't have connector, you can either directly call the service over a protocol such as HTTP or create a custom connector.

Connectors are available either as built-in triggers and actions or as managed connectors:

* Built-ins: These built-in triggers and actions are "native" to Azure Logic Apps and help you create logic apps that run on custom schedules, communicate with other endpoints, receive and respond to requests, and call Azure functions, Azure API Apps (Web Apps), your own APIs managed and published with Azure API Management, and nested logic apps that can receive requests. You can also use built-in actions that help you organize and control your logic app's workflow, and also work with data.

* Managed connectors: Deployed and managed by Microsoft, these connectors provide triggers and actions for accessing cloud services, on-premises systems, or both, including Office 365, Azure Blob Storage, SQL Server, Dynamics, Salesforce, SharePoint, and more. Some connectors specifically support business-to-business (B2B) communication scenarios and require an integration account that's linked to your logic app. Before using certain connectors, you might have to first create connections, which are managed by Azure Logic Apps.

## Components of a Connector

Each connector offers a set of operations classified as 'Actions' and 'Triggers'. Once you connect to the underlying service, these operations can be easily leveraged within your apps and workflows.

### Actions

Actions are changes directed by a user. For example, you would use an action to look up, write, update, or delete data in a SQL database. All actions directly map to operations defined in the Swagger.

### Triggers

Several connectors provide triggers that can notify your app when specific events occur. For example, the FTP connector has the OnUpdatedFile trigger. You can build either a Logic App or Flow that listens to this trigger and performs an action whenever the trigger fires.

There are two types of trigger.

* Polling Triggers: These triggers call your service at a specified frequency to check for new data. When new data is available, it causes a new run of your workflow instance with the data as input.

* Push Triggers: These triggers listen for data on an endpoint, that is, they wait for an event to occur. The occurrence of this event causes a new run of your workflow instance.

## Built-ins

Logic Apps provides built-in triggers and actions so you can create schedule-based workflows, help your logic apps communicate with other apps and services, control the workflow through your logic apps, and manage or manipulate data.

Built-in triggers include the following:

|Trigger|Description|
|------------|-----------|
|Recurrance|- Run your logic app on a specified schedule, ranging from basic to complex recurrences, with the Recurrence trigger.<br>- Pause your logic app for a specified duration with the Delay action.<br>- Pause your logic app until the specified date and time with the Delay until action.|
|HTTP|Communicate with any endpoint over HTTP with both triggers and actions for HTTP, HTTP + Swagger, and HTTP + Webhook.|
|Request|- Make your logic app callable from other apps or services, trigger on Event Grid resource events, or trigger on responses to Azure Security Center alerts with the Request trigger.<br>- Send responses to an app or service with the Response action.|
|Batch messages|- Process messages in batches with the Batch messages trigger.<br>- Call logic apps that have existing batch triggers with the Send messages to batch action.|
|Azure Functions|Call Azure functions that run custom code snippets (C# or Node.js) from your logic apps.|
|Azure API Management|Call triggers and actions defined by your own APIs that you manage and publish with Azure API Management.|
|Azure App Services|Call Azure API Apps, or Web Apps, hosted on Azure App Service. The triggers and actions defined by these apps appear like any other first-class triggers and actions when Swagger is included.|
|Azure Logic Apps|Call other logic apps that start with a Request trigger.|

### Control workflow

Logic Apps provides built-in actions for structuring and controlling the actions in your logic app's workflow:

|Action|Description|
|------------|-----------|
|Condition|Evaluate a condition and run different actions based on whether the condition is true or false.|
|For each|Perform the same actions on every item in an array.|
|Scope|Group actions into scopes, which get their own status after the actions in the scope finish running.|
|Switch|Group actions into cases, which are assigned unique values except for the default case. Run only that case whose assigned value matches the result from an expression, object, or token. If no matches exist, run the default case.|
|Terminate|Stop an actively running logic app workflow.|
|Until|Repeat actions until the specified condition is true or some state has changed.|

### Manage or manipulate data

Logic Apps provides built-in actions for working with data outputs and their formats:

|Action|Description|
|------------|-----------|
|Data Operations|Perform operations with data:<br>- Compose: Create a single output from multiple inputs with various types.<br>- Create CSV table: Create a comma-separated-value (CSV) table from an array with JSON objects.<br>- Create HTML table: Create an HTML table from an array with JSON objects.<br>- Filter array: Create an array from items in another array that meet your criteria.<br>- Join: Create a string from all items in an array and separate those items with the specified delimiter.<br>- Parse JSON: Create user-friendly tokens from properties and their values in JSON content so you can use those properties in your workflow.<br>- Select: Create an array with JSON objects by transforming items or values in another array and mapping those items to specified properties.|
|Date Time|Perform operations with timestamps:<br>- Add to time: Add the specified number of units to a timestamp.<br>- Convert time zone: Convert a timestamp from the source time zone to the target time zone.<br>- Current time: Return the current timestamp as a string.<br>- Get future time: Return the current timestamp plus the specified time units.<br>- Get past time: Return the current timestamp minus the specified time units.<br>- Subtract from time: Subtract a number of time units from a timestamp.|
|Variables|Perform operations with variables:<br>- Append to array variable: Insert a value as the last item in an array stored by a variable.<br>- Append to string variable: Insert a value as the last character in a string stored by a variable.<br>- Decrement variable: Decrease a variable by a constant value.<br>- Increment variable: Increase a variable by a constant value.<br>- Initialize variable: Create a variable and declare its data type and initial value.<br>- Set variable: Assign a different value to an existing variable.|

## Managed API connectors

Logic Apps provides these popular Standard connectors for automating tasks, processes, and workflows with these services or systems.

|Connector|Description|
|------------|-----------|
|Azure Service Bus|Manage asynchronous messages, sessions, and topic subscriptions with the most commonly used connector in Logic Apps.|
|SQL Server|Connect to your SQL Server on premises or an Azure SQL Database in the cloud so you can manage records, run stored procedures, or perform queries.|
|Office 365<br>Outlook|Connect to your Office 365 email account so you can create and manage emails, tasks, calendar events and meetings, contacts, requests, and more.|
|Azure Blob<br>Storage|Connect to your storage account so you can create and manage blob content.|
|SFTP|Connect to SFTP servers you can access from the internet so you can work with your files and folders.|
|SharePoint<br>Online|Connect to SharePoint Online so you can manage files, attachments, folders, and more.|
|Dynamics 365<br>CRM Online|Connect to your Dynamics 365 account so you can create and manage records, items, and more.|
|FTP|Connect to FTP servers you can access from the internet so you can work with your files and folders.|
|Salesforce|Connect to your Salesforce account so you can create and manage items such as records, jobs, objects, and more.|
|Twitter|Connect to your Twitter account so you can manage tweets, followers, your timeline, and more. Save your tweets to SQL, Excel, or SharePoint.|
|Azure Event Hubs|Consume and publish events through an Event Hub. For example, get output from your logic app with Event Hubs, and then send that output to a real-time analytics provider.|
|Azure Event<br>Grid|Monitor events published by an Event Grid, for example, when Azure resources or third-party resources change.|

## On-premises connectors

Logic Apps provides Standard connectors for accessing data and resources in on-premises systems. Before you can create a connection to an on-premises system, you must first download, install, and set up an on-premises data gateway. This gateway provides a secure communication channel without having to set up the necessary network infrastructure.

## Integration account connectors

Logic Apps provides Standard connectors for building business-to-business (B2B) solutions with your logic apps when you create and pay for an integration account, which is available through the Enterprise Integration Pack (EIP) in Azure. With this account, you can create and store B2B artifacts such as trading partners, agreements, maps, schemas, certificates, and so on. To use these artifacts, associate your logic apps with your integration account. If you currently use BizTalk Server, these connectors might seem familiar already.

## Triggers and Actions

Connectors can provide triggers, actions, or both. A trigger is the first step in any logic app, usually specifying the event that fires the trigger and starts running your logic app. For example, the FTP connector has a trigger that starts your logic app "when a file is added or modified". Some triggers regularly check for the specified event or data and then fire when they detect the specified event or data. Other triggers wait but fire instantly when a specific event happens or when new data is available. Triggers also pass along any required data to your logic app. Your logic app can read and use that data throughout the workflow. For example, the Twitter connector has a trigger, "When a new tweet is posted", that passes the tweet's content into your logic app's workflow.

After a trigger fires, Azure Logic Apps creates an instance of your logic app and starts running the actions in your logic app's workflow. Actions are the steps that follow the trigger and perform tasks in your logic app's workflow. For example, you can create a logic app that gets customer data from a SQL database and process that data in later actions.

Here are the general kinds of triggers that Azure Logic Apps provides:

* Recurrence trigger: This trigger runs on a specified schedule and isn't tightly associated with a particular service or system.
* Polling trigger: This trigger regularly polls a specific service or system based on the specified schedule, checking for new data or whether a specific event happened. If new data is available or the specific event happened, the trigger creates and runs a new instance of your logic app, which can now use the data that's passed as input.
* Push trigger: This trigger waits and listens for new data or for an event to happen. When new data is available or when the event happens, the trigger creates and runs new instance of your logic app, which can now use the data that's passed as input.

## Connector configuration

Each connector's triggers and actions provide their own properties for you to configure. Many connectors also require that you first create a connection to the target service or system and provide authentication credentials or other configuration details before you can use a trigger or action in your logic app. For example, you must authorize a connection to a Twitter account for accessing data or to post on your behalf.

For connectors that use Azure Active Directory (Azure AD) OAuth, creating a connection means signing into the service, such as Office 365, Salesforce, or GitHub, where your access token is encrypted and securely stored in an Azure secret store. Other connectors, such as FTP and SQL, require a connection that has configuration details, such as the server address, username, and password. These connection configuration details are also encrypted and securely stored. Learn more about encryption in Azure.

Connections can access the target service or system for as long as that service or system allows. For services that use Azure AD OAuth connections, such as Office 365 and Dynamics, Azure Logic Apps refreshes access tokens indefinitely. Other services might have limits on how long Azure Logic Apps can use a token without refreshing. Generally, some actions invalidate all access tokens, such as changing your password.

---

**Instructor Notes**

[Connectors for Azure Logic Apps](https://docs.microsoft.com/en-us/azure/connectors/apis-list)

[Connectors](https://docs.microsoft.com/en-us/connectors/)
