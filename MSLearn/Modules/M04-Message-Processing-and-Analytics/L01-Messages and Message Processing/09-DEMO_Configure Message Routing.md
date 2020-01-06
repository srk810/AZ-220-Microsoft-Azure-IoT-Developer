# DEMO - Configure Message Routing



**TODO - create the demo steps**



Part I: Create resources, set up message routing

* Create the resources -- an IoT hub, a storage account, a Service Bus queue, and a simulated device. This can be done using the Azure portal, an Azure Resource Manager template, the Azure CLI, or Azure PowerShell.
* Configure the endpoints and message routes in IoT Hub for the storage account and Service Bus queue.

Part II: Send messages to the hub, view routed results

* Create a Logic App that is triggered and sends e-mail when a message is added to the Service Bus queue.
* Download and run an app that simulates an IoT Device sending messages to the hub for the different routing options.
* Create a Power BI visualization for data sent to the default endpoint.
* View the results ...
    * ...in the Service Bus queue and e-mails.
    * ...in the storage account.
    * ...in the Power BI visualization.

---

**Instructor Notes**

[Use the Azure CLI and Azure portal to configure IoT Hub message routing](https://docs.microsoft.com/en-us/azure/iot-hub/tutorial-routing)
