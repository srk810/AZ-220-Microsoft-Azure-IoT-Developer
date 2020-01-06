# Introduction to Security Agents

Azure Security Center for IoT security agents offer enhanced security capabilities, such as monitoring remote connections, active applications, login events, and operating system configuration best practices. Security agents handle raw event collection from the device operating system, event aggregation to reduce cost, and configuration through a device module twin. Security messages are sent through your IoT Hub, into Azure Security Center for IoT analytics services.

A reference architecture for Linux and Windows security agents is provided with support for both C# and C.

You can use the following workflow to deploy and test your Azure Security Center for IoT security agents:

1. Enable Azure Security Center for IoT service to your IoT Hub

1. If your IoT Hub has no registered devices, Register a new device.

1. Create an azureiotsecurity security module for your devices.

    To install the agent on an Azure simulated device instead of installing on an actual device, spin up a new Azure Virtual Machine (VM) in an available zone.

1. Deploy an Azure Security Center for IoT security agent on your IoT device, or new VM.

1. Follow the instructions for **trigger_events** to run a harmless simulation of an attack.

    The simulated attack provides an opportunity to verify that Azure Security Center for IoT alert are triggered as expected. 

## Understand Security Agent Options

Security agents offer the same set of features for C and C#, and support for similar configuration options is provided for both language options.

The C-based security agent has a lower memory footprint, and is the ideal choice for devices with fewer available resources.

|     |C-based security agent|C#-based security agent|
|-----|----------------------|-----------------------|
|Open-source|Available under MIT license in GitHub|Available under MIT license in GitHub|
|Development language|C|C#|
|Supported Windows platforms?|No|Yes|
|Windows prerequisites|    |WMI|
|Supported Linux platforms?|Yes, x64 and x86|Yes, x64 only|
|Linux prerequisites|libunwind8, libcurl3, uuid-runtime, auditd, audispd-plugins|libunwind8, libcurl3, uuid-runtime, auditd, audispd-plugins, sudo, netstat, iptables|
|Disk footprint|10.5 MB|90 MB|33 MB|
|Authentication to IoT Hub|Yes|Yes|
|Security data collection|Yes|Yes|
|Event aggregation|Yes|Yes|
|Remote configuration through security module twin|Yes|Yes|

## Security Agent Installation Guidelines

For Windows: The Install SecurityAgent.ps1 script must be executed from an Administrator PowerShell window.

For Linux: The InstallSecurityAgent.sh must be run as superuser. We recommend prefixing the installation command with “sudo”.

## Choose an Agent "Flavor"

Answer the following questions about your IoT devices to select the correct agent:

* Are you using Windows Server or Windows IoT Core?

    Deploy a C#-based security agent for Windows.

* Are you using a Linux distribution with x86 architecture?

    Deploy a C-based security agent for Linux.

* Are you using a Linux distribution with x64 architecture?

    Both agent flavors can be used. Deploy a C-based security agent for Linux and/or Deploy a C#-based security agent for Linux.

Both agent flavors offer the same set of features and support similar configuration options. See Security agent comparison to learn more.

## Supported platforms

The following list includes all currently supported platforms.

|Azure Security Center for IoT agent|Operating System|Architecture|
|-----------------------------------|----------------|------------|
|C|Ubuntu 16.04|x64|
|C|Ubuntu 18.04|x64|
|C|Debian 9|x64, x86|
|C#|Ubuntu 16.04|x64|
|C#|Ubuntu 18.04|x64|
|C#|Debian 9|x64|
|C#|Windows Server 2016|X64|
|C#|Windows 10 IoT Core, build 17763|x64|

---

**Instructor Notes**

[Get started with Azure Security Center for IoT device security agents](https://docs.microsoft.com/en-us/azure/asc-for-iot/security-agents)

[Select and deploy a security agent on your IoT device](https://docs.microsoft.com/en-us/azure/asc-for-iot/how-to-deploy-agent)

[]()
