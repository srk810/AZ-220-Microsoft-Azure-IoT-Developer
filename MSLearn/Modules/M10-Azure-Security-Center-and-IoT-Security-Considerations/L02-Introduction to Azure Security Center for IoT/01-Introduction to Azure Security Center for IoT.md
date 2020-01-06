# Introduction to Azure Security Center for IoT

Azure Security Center for IoT enables you to unify security management and enable end-to-end threat detection and analysis across hybrid cloud workloads and your Azure IoT solution.

Azure Security Center for IoT is composed of the following components:

* IoT Hub integration
* Device agents (optional)
* Send security message SDK
* Analytics pipeline

## Secure your entire IoT solution from IoT devices to Azure cloud.

Choose from our seamless agentless solution or take advantage of agent-based comprehensive security, Azure Security Center for IoT provides threat prevention and analysis for every device, IoT Edge and IoT Hub, across your IoT assets.

As billions of new devices are connected to the Internet, and integrated into our daily lives and our businesses, your security operations teams must ensure their security strategies evolve quickly enough to cover each new attack surface. Like any other system, to comprehensively secure your IoT solution, it requires protection at every stage of implementation.

Azure Security Center for IoT simplifies hybrid workload protection by delivering unified visibility and control, adaptive threat prevention, and intelligent threat detection and response across workloads running on edge, on-premises, in Azure, and in other clouds.

![Security Center - Azure IoT Security Architecture](../../Linked_Image_Files/M10_L02-SecurityCenter-azure-iot-security-architecture.png)

### Unified visibility and control

Get a unified view of security across all of your on-premises and cloud workloads, including your Azure IoT solution. Onboard new devices, and apply security policies across your workloads (Leaf devices, Microsoft Edge devices, IoT Hub) to ensure compliance with security standards and improved security posture.

### Adaptive threat prevention

Use Azure Security Center for IoT to continuously monitor the security of machines, networks, and Azure services. Choose from hundreds of built-in security assessments or create your own in the central Azure Security Center for IoT Hub dashboard. Optimize your security settings and improve your security score with actionable recommendations across virtual machines, networks, apps, and data. With newly added IoT capabilities, you can now reduce the attack surface for your Azure IoT solution and remediate issues before they can be exploited.

### Intelligent threat detection and response

Use advanced analytics and the Microsoft Intelligent Security Graph to get an edge over evolving cyber-attacks. Built-in behavioral analytics and machine learning identify attacks and zero-day exploits. Monitor your IoT solution for incoming attacks and post-breach activity. Streamline device investigation and remediation with interactive tools and contextual threat intelligence.

## Azure Security Center for IoT Prerequisites

### Minimum requirements

* IoT Hub Standard tier 

    * RBAC role Owner level privileges

* Log Analytics Workspace
* Azure Security Center (recommended) 

    * Use of Azure Security Center is a recommendation, and not a requirement. Without Azure Security Center, you'll be unable to view your other Azure resources within IoT Hub.

### Working with Azure Security Center for IoT service

Azure Security Center for IoT insights and reporting are available using Azure IoT Hub and Azure Security Center. To enable Azure Security Center for IoT on your Azure IoT Hub, an account with Owner level privileges is required. After enabling ASC for IoT in your IoT Hub, Azure Security Center for IoT insights are displayed as the Security feature in Azure IoT Hub and as IoT in Azure Security Center.

### Supported service regions

Azure Security Center for IoT is currently supported for IoT Hubs in the following Azure regions:

* Central US
* East US
* East US 2
* West Central US
* West US
* West US2
* Central US South
* North Central US
* Canada Central
* Canada East
* North Europe
* Brazil South
* France Central
* UK West
* UK South
* West Europe
* Northern Europe
* Japan West
* Japan East
* Australia Southeast
* Australia East
* East Asia
* Southeast Asia
* Korea Central
* Korea South
* Central India
* South India

Azure Security Center for IoT routes all traffic from all European regions to the West Europe regional data center and all remaining regions to the Central US regional data center.

### Where's my IoT Hub?

Check your IoT Hub location to verify service availability before you begin.

* Open your IoT Hub.
* Click Overview.
* Verify the location listed matches one of the supported service regions.

### Supported platforms for agents

Azure Security Center for IoT agents supports a growing list of devices and platforms.

---

**Instructor Notes**

[Introducing Azure Security Center for IoT](https://docs.microsoft.com/en-us/azure/asc-for-iot/overview)
