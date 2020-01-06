# Configure Built-in IoT Hub Integration

The built-in option for Azure Security Center for IoT enables you to use the service without using Azure Security Center for IoT security agents.

## Enable Azure Security Center for IoT on your IoT Hub

To enable security on your IoT Hub:

* Open your IoT Hub in the Azure portal.
* On the left side menu, under the Security section, click **Overview**.
* On the Overview blade, click **Secure your IoT solution**.

That's all that need to be completed to enable Azure Security Center for IoT on your IoT Hub. If Azure Security Center for IoT was previously enabled and then disabled, you can re-enable from the Overview blade by clicking the Settings button and then selecting Enable. 

### Geolocation and IP address handling

To secure your IoT solution, IP addresses of incoming and outgoing connections to and from your IoT devices, IoT Edge, and IoT Hub(s) are collected and stored by default. This information is essential to detect abnormal connectivity from suspicious IP sources. For example, when attempts are made to establish connections from an IP source of a known botnet or from an IP source outside your geolocation. Azure Security Center for IoT service offers the flexibility to enable and disable collection of IP address data at any time.

To enable or disable collection of IP address data:

* Open your IoT Hub and then select Overview from the Security menu.
* Choose the Settings screen and modify the geolocation and/or IP handling settings as you wish.

### Log Analytics creation

When Azure Security Center for IoT is turned on, a default Azure Log Analytics workspace is created to store raw security events, alerts, and recommendations for your IoT devices, IoT Edge, and IoT Hub. Each month, the first five (5) GB of data ingested per customer to the Azure Log Analytics service is free. Every GB of data ingested into your Azure Log Analytics workspace is retained at no charge for the first 31 days.

To change the workspace configuration of Log Analytics:

* Open your IoT Hub and then select Overview from the Security menu.
* Choose the Settings screen and modify the workspace configuration of Log Analytics settings as you wish.

### Customize your IoT security solution

By default, turning on the Azure Security Center for IoT solution automatically secures all IoT Hubs under your Azure subscription.

In addition to automatic relationship detection, you can also pick and choose which other Azure resource groups to tag as part of your IoT solution.

Your selections allow you to add entire subscriptions, resource groups, or single resources.

After defining all of the resource relationships, Azure Security Center for IoT leverages Azure Security Center to provide you security recommendations and alerts for these resources.

To turn Azure Security Center for IoT service on a specific IoT Hub on or off:

* Open your IoT Hub and then select Overview from the Security menu.
* Choose the Settings screen and modify the security settings of any IoT hub in your Azure subscription as you wish.

To add new resource to your IoT solution, do the following:

* Open your IoT Hub in Azure portal.
* On the left side menu, under the Security section, click **Resources**.
* Click Edit, and then choose the resources groups that belong to your IoT solution.
* Click **Add**.

---

**Instructor Notes**

[Get started with Built-in IoT Hub integration](https://docs.microsoft.com/en-us/azure/asc-for-iot/iot-hub-integration)

[Quickstart: Onboard Azure Security Center for IoT service in IoT Hub](https://docs.microsoft.com/en-us/azure/asc-for-iot/quickstart-onboard-iot-hub)

[Quickstart: Configure your IoT solution](https://docs.microsoft.com/en-us/azure/asc-for-iot/quickstart-configure-your-solution)

[Create a Log Analytics workspace in the Azure portal](https://docs.microsoft.com/en-us/azure/azure-monitor/learn/quick-create-workspace)
