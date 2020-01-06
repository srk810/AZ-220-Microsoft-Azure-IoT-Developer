# DEMO - Event Grid and Logic Apps

To monitor and respond to specific events that happen in Azure resources or third-party resources, you can automate and run tasks as a workflow by creating a logic app that uses minimal code. These resources can publish events to an Azure event grid. In turn, the event grid pushes those events to subscribers that have queues, webhooks, or event hubs as endpoints. As a subscriber, your logic app can wait for those events from the event grid before running automated workflows to perform tasks.

Azure Logic Apps can help you orchestrate workflows across on-premises and cloud services, one or more enterprises, and across various protocols. A logic app begins with a trigger, which is then followed by one or more actions that can be sequenced using built-in controls, such as conditions and iterators. This flexibility makes Logic Apps an ideal IoT solution for IoT monitoring scenarios. For example, the arrival of telemetry data from a device at an IoT Hub endpoint can initiate logic app workflows to warehouse the data in an Azure Storage blob, send email alerts to warn of data anomalies, schedule a technician visit if a device reports a failure, and so on.

**TODO: Construct a demo that helps support the lab - Route device messages based on telemetry content (only route alerts messages to Event Grid to trigger a workflow), and workflow can be about triggering a Logic Apps which sends an email when alert is flagged by device**

---

**Instructor Notes**

[IoT remote monitoring and notifications with Azure Logic Apps connecting your IoT hub and mailbox](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-monitoring-notifications-with-azure-logic-apps)

[Tutorial: Send email notifications about Azure IoT Hub events using Logic Apps](https://docs.microsoft.com/en-us/azure/event-grid/publish-iot-hub-events-to-logic-apps)

[Tutorial: Monitor virtual machine changes by using Azure Event Grid and Logic Apps](https://docs.microsoft.com/en-us/azure/event-grid/monitor-virtual-machine-changes-event-grid-logic-app)
