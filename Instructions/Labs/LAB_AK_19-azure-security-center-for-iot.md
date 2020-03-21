---
lab:
    title: 'Lab 19: Detect if your IoT Device was Tampered with Azure Security Center for IoT'
    module: 'Module 10: Azure Security Center and IoT Security'
---

# Detect Device Tampering with Azure Security Center for IoT

## Lab Scenario

Contoso has built all their solutions with security in mind. However, they want to see how they can better get a unified view of security across all of their on-premises and cloud workloads, including their Azure IoT solutions. Plus, when onboarding new devices, the company wants to apply security policies across workloads (Leaf devices, Microsoft Edge devices, IoT Hub) to ensure compliance with security standards and improved security posture.

Contoso is adding a brand new assembly line outfitted with new IoT devices to help with the increasing shipping and packing demands for new orders. You want to ensure that any new devices are secured, and you also want to be able to see security recommendations that could help you to continue improving your solution's security (considering the full end-to-end IoT solution). You will start investigating using Azure IoT Center for IoT for your solution.

Contoso is also installing new connected Thermostats that will improve the ability to monitor and control temperature across different cheese caves. As part of Contoso's security requirements, you will create a custom alert to monitor whether the Thermostats exceed expected telemetry transmission frequency.

The following resources will be created:

![Lab 19 Architecture](media/LAB_AK_19-architecture.png)

## In This Lab

In this lab, you will complete the following activities:

* Verify Lab Prerequisites
* Create a new IoT Hub
* Enable Azure Security Center for IoT
* Create and register a new Device
* Create a Security Module Twin
* Install C#-based Security Agent on a Linux Device
* Configure Solution
* Configure custom alerts
* Create a console app to trigger the alert
* Review the alert in the Azure Security Center

## Lab Instructions

### Exercise 1: Verify Lab Prerequisites

This lab assumes that the following Azure resources are available:

| Resource Type | Resource Name |
| :-- | :-- |
| Resource Group | AZ-220-RG |
| IoT Hub | AZ-220-HUB-{YOUR-ID} |

If these resources are not available, you will need to run the **lab19-setup.azcli** script as instructed below before moving on to Exercise 2. The script file is included in the GitHub repository that you cloned locally as part of the dev environment configuration (lab 3).

> **Note**: The **lab19-setup.azcli** script is written to run in a **bash** shell environment - the easiest way to execute this is in the Azure Cloud Shell.

1. Using a browser, open the [Azure Cloud Shell](https://shell.azure.com/) and login with the Azure subscription you are using for this course.

1. If you are prompted about setting up storage for Cloud Shell, accept the defaults.

1. Verify that the Azure Shell is using **Bash**.

    The dropdown in the top-left corner of the Azure Cloud Shell page is used to select the environment. Verify that the selected dropdown value is **Bash**.

1. On the Azure Shell toolbar, click **Upload/Download files** (fourth button from the right).

1. In the dropdown, click **Upload**.

1. In the file selection dialog, navigate to the folder location of the GitHub lab files that you downloaded when you configured your development environment.

    In Lab 3 of this course, "Setup the Development Environment", you cloned the GitHub repository containing lab resources by downloading a ZIP file and extracting the contents locally. The extracted folder structure includes the following folder path:

    * Allfiles
      * Labs
          * 19-Detect if your IoT Device was Tampered with Azure Security Center for IoT
            * Setup

    The lab19-setup.azcli script file is located in the Setup folder for lab 19.

1. Select the **lab19-setup.azcli** file, and then click **Open**.

    A notification will appear when the file upload has completed.

1. To verify that the correct file has uploaded, enter the following command:

    ```bash
    ls
    ```

    The `ls` command lists the content of the current directory. You should see the lab19-setup.azcli file listed.

1. To create a directory for this lab that contains the setup script and then move into that directory, enter the following Bash commands:

    ```bash
    mkdir lab19
    mv lab19-setup.azcli lab19
    cd lab19
    ```

    These commands will create a directory for this lab, move the **lab19-setup.azcli** file into that directory, and then change directory to make the new directory the current working directory.

1. To ensure the **lab19-setup.azcli** has the execute permission, enter the following command:

    ```bash
    chmod +x lab19-setup.azcli
    ```

1. On the Cloud Shell toolbar, to edit the **lab19-setup.azcli** file, click **Open Editor** (second button from the right - **{ }**).

1. In the **Files** list, to expand the lab19 folder, click **lab19**, and then click **lab19-setup.azcli**.

    The editor will now show the contents of the **lab19-setup.azcli** file.

1. In the editor, update the values of the `{YOUR-ID}` and `{YOUR-LOCATION}` variables.

    Referencing the sample below as an example, you need to set `{YOUR-ID}` to the Unique ID you created at the start of this course - i.e. **CAH191211**, and set `{YOUR-LOCATION}` to the location that matches your resource group.

    ```bash
    #!/bin/bash

    RGName="AZ-220-RG"
    IoTHubName="AZ-220-HUB-{YOUR-ID}"

    Location="{YOUR-LOCATION}"
    ```

    > **Note**:  The `{YOUR-LOCATION}` variable should be set to the short name for the region where you are deploying all of your resources. You can see a list of the available locations and their short-names (the **Name** column) by entering this command:
    >
    > ```bash
    > az account list-locations -o Table
    >
    > DisplayName           Latitude    Longitude    Name
    > --------------------  ----------  -----------  ------------------
    > East Asia             22.267      114.188      eastasia
    > Southeast Asia        1.283       103.833      southeastasia
    > Central US            41.5908     -93.6208     centralus
    > East US               37.3719     -79.8164     eastus
    > East US 2             36.6681     -78.3889     eastus2
    > ```

1. In the top-right of the editor window, to save the changes made to the file and close the editor, click **...**, and then click **Close Editor**.

    If prompted to save, click **Save** and the editor will close.

    > **Note**:  You can use **CTRL+S** to save at any time and **CTRL+Q** to close the editor.

1. To create the resources required for this lab, enter the following command:

    ```bash
    ./lab19-setup.azcli
    ```

    This will take a few minutes to run. You will see JSON output as each step completes.

### Exercise 2: Enable Azure Security Center for IoT Hub

Azure Security Center for IoT enables you to unify security management and enable end-to-end threat detection and analysis across hybrid cloud workloads and your Azure IoT solution.

Azure Security Center for IoT is composed of the following components:

* IoT Hub integration
* Device agents (optional)
* Send security message SDK
* Analytics pipeline

#### Task 1: Enable Azure Security Center for IoT

In this task, you will enable **Azure Security Center for IoT** for your IoT Hub. 

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your Azure dashboard, click **AZ-220-HUB-{YOUR-ID}**.

    Your dashboard should have a link to your IoT Hub on the on the AZ-220-RG resource group tile.

1. On the left side navigation menu, under **Security**, and then click **Overview**.

    Azure Security Center for IoT Hub will be onboarded the first time a Security pane is opened. 
    
    * You may be prompted click **Secure your IoT solution**.
    * After a few moments you may see the message **Onboarding succeeded for this IoT hub, please refresh for changes to take effect**.

1. Take a moment to review the contents on the Security Overview pane.

#### Task 2: Log Analytics creation

When Azure Security Center for IoT is turned on, a default Azure Log Analytics workspace is created to store raw security events, alerts, and recommendations for your IoT devices, IoT Edge, and IoT Hub.

In this task, you will take a quick look at the workspace configuration of Log Analytics.

1. If needed, open the Security Overview pane for your IoT Hub.

1. At the top of the blade, to show the security settings, click **Settings**. 

    The **Settings** blade should now be open with the **Data Collection** pane displayed. 

1. Take a minute to review the Settings information displayed.

    Notice the **Workspace configuration** that has be defined for your Log Analytics workspace.

By default, turning on the Azure Security Center for IoT solution automatically secures all IoT Hubs under your Azure subscription.

### Exercise 3: Create and Register a New Device

In this exercise, you will be setting up a virtual machine that you will then use to simulate an IoT device. Later on in this lab, you will use this device to measure vibrations on a conveyor belt.

#### Task 1: Create a new IoT Device

In this task, you will create the VM that will represent your IoT device.

1. Login to [portal.azure.com](https://portal.azure.com) using your Azure account credentials.

1. On the portal menu, click **+ Create a resource**, then Search the Marketplace for **Ubuntu Server 18.04 LTS**

1. In the search results, click **Ubuntu Server 18.04 LTS**.

1. On the **Ubuntu Server 18.04 LTS** blade, click **Create**.

1. On the **Create a virtual machine** blade, under **Subscription**, ensure that the Subscription you are using for this course is selected.

1. Under the **Resource group** dropdown, click **Create new**

1. In the context menu, under **Name**, enter **AZ-220-SECVM-RG** and then click **OK**

    > **Note**: Best practice is to create a resource group for your VMs. This helps you to keep track of any addition resources that you add/create for the VM. For the simple use case in this course, the primary benefit could be ease of clean-up, but you will do a bit more with this resource group later in the lab.

1. In the **Virtual machine name** textbox, enter **vm-device01**

1. In the **Region** dropdown, select the Azure Region closest to you, or the region where your Azure IoT Hub is provisioned.

1. In the **Availability options** dropdown, ensure that **No infrastructure redundancy required** is selected.

    > **Tip**:
    > Azure offers a range of options for managing availability and resiliency for your applications. Architect your solution to use replicated VMs in Availability Zones or Availability Sets to protect your apps and data from datacenter outages and maintenance events. In this lab, we don't required any high-availability features.

1. In the **Image** dropdown, notice that **Ubuntu Server 18.04 LTS** is selected.

1. For the **Azure Spot instance** field, ensure that **No** is selected.

    > **Tip**:
    > Using Spot VMs allows you to take advantage of Azure unused capacity at a significant cost savings. At any point in time when Azure needs the capacity back, the Azure infrastructure will evict Spot VMs. Therefore, Spot VMs are great for workloads that can handle interruptions like batch processing jobs, dev/test environments, large compute workloads, and more. For this lab, we'll use a traditional VM.

1. Under **Administrator account**, to the right of **Authentication type**, click **Password**.

1. For the Administrator **Username** and **Password** fields, enter values for the VM Administrator account.

    > **Important**: Make a record of the VM Administrator username and password. In a production environment, you would need to keep these secure. For this lab it is okay to save the values to a text document so that you can find them later (in case you forget). 

1. To the right of **Inbound port rules**, notice that **SSH (22)** is selected.

    You will be using SSH to remote into the VM when you need to configure/manage the VM.

1. At the bottom of the blade, click **Review + create**.

1. Once you see the "Validation passed" message, click **Create**.

    > **Note**:
    > Deployment can take approximately 5 minutes to complete. You can continue on to the next unit while it is deploying.

#### Task 2: Register New Devices

As a device must be registered with your IoT hub before it can connect, let's create the registration.

1. On the Azure portal menu, click **Dashboard**.

1. On your AZ-220-RG resource group tile, click **AZ-220-HUB-{YOUR-ID}**.

    There are plenty of other ways to open your IoT Hub blade, use whatever method you prefer.

1. In the left side navigation menu, under **Explorers**, click **IoT devices**.

1. At the top of **IoT devices** pane, click **+ New**

1. Under **Device ID**, enter **vm-device01**

    Yes, you are using the Name that you assigned to the VM as the Device ID.

    You will be using a **Symmetric key** for authentication, so you can leave the other setting at the defaults.

1. At the bottom of the blade, click **Save**.

### Exercise 4: Create a Security Module Twin

Azure Security Center for IoT offers full integration with your existing IoT device management platform, enabling you to manage your device security status as well as make use of existing device control capabilities.

Azure Security Center for IoT makes use of the module twin mechanism and maintains a security module twin named azureiotsecurity for each of your devices. The security module twin holds all the information relevant to device security for each of your devices. To make full use of Azure Security Center for IoT features, you will need to create, configure, and use these security module twins for your new IoT Edge device.

The security module twin (**azureiotsecurity**) can be created by using either of the following methods:

* Use the [Module batch script](https://github.com/Azure/Azure-IoT-Security/tree/master/security_module_twin). This script automatically creates a module twin for new devices (or devices without a module twin) using the default configuration.
* Manually edit each module twin individually with specific configurations for each device.

In this task, you will be creating a security module twin manually.

1. In the Azure portal, if necessary, navigate to your the **IoT devices** pane of your IoT Hub.

    To open the **IoT devices** pane from your IoT Hub blade, in the left side navigation menu, under **Explorers**, click **IoT devices**.

1. Under **DEVICE ID**, click **vm-device01**.

1. On the **vm-device01** blade, near the top of the blade, click **+ Add Module Identity**.

1. On the **Add Module Identity** pane, under **Module Identity Name**, enter **azureiotsecurity**

    As we will be using Symmetric Keys for authentication, you can leave all over fields at their defaults.

1. At the bottom of the pane, click **Save**.

    Under **Module Identities**, you should now see your **azureiotsecurity** device listed. The connection state is **Disconnected**.

    > **IMPORTANT**: The Module Identity must be called **azureiotsecurity** and not another unique name.

    ![Screenshot of Azure IoT Security Module](media/LAB_AK_19-module-identity.png)

1. On the **vm-device01** blade, to the right of **Primary Key**, click **Copy**.

    > **Note**: Make sure to copy the device's **Primary Key** and not the connection string.

    ![Screenshot of Azure IoT Security Module](media/LAB_AK_19-primary-key.png)

1. Navigate back to your IoT Hub blade.

1. On the left side navigation menu, click **Overview**.

1. In the Essentials area near the top of the blade, to the right of **Hostname**, click **Copy to clipboard**, and then save the value for later.

    > **Note**: The IoT Hub Hostname looks similar to: AZ-220-HUB-CAH102119.azure-devices.net

### Exercise 5: Deploy Azure Security Center for IoT C# Security Agent

Azure Security Center for IoT provides a reference architecture for security agents that log, process, aggregate, and send security data through IoT Hub. There are C and C# based agents. C agents are recommended for devices with more restricted or minimal device resources.

Security agents support the following features:

* Collect raw security events from the underlying Operating System (Linux, Windows). To read more about available security data collectors, see Azure Security Center for IoT agent configuration.
* Aggregate raw security events into messages sent through IoT Hub.
* Authenticate with existing device identity, or a dedicated module identity. To read more, see Security agent authentication methods.
* Configure remotely through use of the **azureiotsecurity** module twin. To read more, see Configure an Azure Security Center for IoT agent.

In this exercise, you will be adding a security agent for C# that you will deploy to your simulated device (Linux VM). 

#### Task 1: Logging into IoT Device - Linux VM

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On the Azure portal menu, click **All resources**.

    Be sure to select **All resources**, not **All services**.

1. On the **All resources** blade, in the **Filter by name** textbox, enter **vm-device01**

1. Under **Name**, click **vm-device01**.

    The Overview pane for your newly created virtual machine (**vm-device01**) should now be open.

1. At the top of the blade, click **Connect**, and then click **SSH**.

1. Take a minute to review the contents of the **Connect** pane

    As you have seen previously in this course, you are provided with an example command for opening an SSH connection.

    Copy the example command to a text editor, and then remove `-i <private key path> from the command. You should be left with a command in the following format:

    ```cmd\sh
    ssh <admin user>@<ip address>
    ```

    Your command should look similar to: `ssh demouser@52.170.205.79`

1. On the Azure portal toolbar, click **Cloud Shell**.

    Ensure that the **Bash** environment is selected within the Cloud Shell.

1. At the Cloud Shell command prompt, enter the `ssh` command that you created above, and then press **Enter**.

1. When prompted with **Are you sure you want to continue connecting?**, type **yes** and then press **Enter**.

    This prompt is a security confirmation since the certificate used to secure the connection to the VM is self-signed. The answer to this prompt will be remembered for subsequent connections, and is only prompted on the first connection.

1. When prompted to enter the password, enter the Administrator password that you created for the VM.

    Notice that, once connected, the terminal command prompt will change to show the name of the Linux VM, similar to the following.

    ```cmd/sh
    demouser@vm-device01:~$
    ```

    This helps you to keep track of which VM you are connected to and the current user.

#### Task 3: Add Symmetric Keys to your device

You can connect to your IoT Hub with the C# version of the security agent. To implement the connection, you will need your device's symmetric key or certificate information.

In this lab, you will be using the symmetric key as authentication and will need to store it in a temporary text document on the device.

1. Verify that you have the **Primary key** value for your **vm-device01** device available.

    You should have save the Primary key value earlier in this lab. If not, complete the following:

    1. Open a new browser tab, and on that new tab, navigate to the Azure portal.
    1. On the Azure portal menu, click **Dashboard**, and then open your IoT Hub.
    1. On the left side navigation menu, under **Explorers**, click **IoT devices**.
    1. Under **DEVICE ID**, click **vm-device01**.
    1. From the list of details, copy your **Primary Key**.
    1. Return the the Azure Cloud Shell browser tab - you should still be connected to your **vm-device01** virtual machine.

1. At the Cloud Shell command prompt, enter the following command:

    ```cmd/sh
    echo "<primary_key>" > s.key
    ```

    This command will create a device Authentication type file with your **vm-device01** device's **Primary Key**.

    > [!NOTE] To check if you added the correct Primary key into the file, Open your file with `nano s.key` command. Check to see your device's **Primary Key** is in the file. To exit the nano editor, holding `Ctrl` and `X`. Save file by holding `shift` and `Y`. Then hit enter.

#### Task 4: Installing Security Agent

1. Ensure that the Cloud Shell session is still connected to your VM via SSH.

1. At the Cloud Shell command prompt, to download the most recent version of Security Agent for C# to your device, enter the following command:

    ```bash
    wget https://github.com/Azure/Azure-IoT-Security-Agent-CS/releases/download/0.0.6/ubuntu-18.04-x64.tar.gz
    ```

1. At the Cloud Shell command prompt, to extract the contents of the package and navigate to the `/Install` folder, enter the following command:

    ```bash
    tar -xzvf ubuntu-18.04-x64.tar.gz && cd Install
    ```

1. At the Cloud Shell command prompt, to add execute permissions to the `InstallSecurityAgent` script, enter the following command:

    ```bash
    chmod +x InstallSecurityAgent.sh
    ```

1. At the Cloud Shell command prompt, enter the following command: 

    You will need to replace the values with your authentication parameters.

    ```bash
    sudo ./InstallSecurityAgent.sh -i -aui Device -aum SymmetricKey -f <Insert file location of your s.key file> -hn <Insert your full IoT Hub host name> -di vm-device01
    ```

    Here is an example of what the command should look like:

    `sudo ./InstallSecurityAgent.sh -i -aui Device -aum SymmetricKey -f ../s.key -hn CheeseCaveHub-AB20200213.azure-devices.net -di vm-device01`

    > **Note**: Make sure that specify your IoT Hub Hostname instead of the one listed 
    
    > **IMPORTANT**:
    > Ensure you use the full IoT Hub host name - i.e. **CheeseCaveHub-AB20200213.azure-devices.net** for the `-hn` switch value.

    This script performs the following function:

    * Installs prerequisites.
    * Adds a service user (with interactive sign in disabled).
    * Installs the agent as a Daemon - assumes the device uses **systemd** for service management.
    * Configures **sudo users** to allow the agent to do certain tasks as root.
    * Configures the agent with the authentication parameters provided.

1. Observe the progress of the command by watching output in the Cloud Shell terminal.

    Notice that a reboot is required to complete agent installation.

1. In the Cloud Shell terminal, to start the reboot, enter **y**

    The SSH session will be lost when the device reboots.
 
1. At the Cloud Shell command prompt, to reconnect to your virtual machine, enter the SSH command you used earlier.

    Your Azure Security Center for IoT Agent should now be active and running.

1. At the Cloud Shell command prompt, to check the deployment status of the Azure Security Center for IoT Agent, enter the following command. 

    ```cmd/sh
    systemctl status ASCIoTAgent.service
    ```

    You should see output similar to:

    ```log
    ● ASCIoTAgent.service - Azure Security Center for IoT Agent
       Loaded: loaded (/etc/systemd/system/ASCIoTAgent.service; enabled; vendor preset: enabled)
       Active: active (running) since Wed 2020-01-15 19:08:15 UTC; 3min 3s ago
     Main PID: 1092 (ASCIoTAgent)
        Tasks: 7 (limit: 9513)
       CGroup: /system.slice/ASCIoTAgent.service
            └─1092 /var/ASCIoTAgent/ASCIoTAgent
    ```

    Specifically, you should verify that the service is **Loaded: loaded** and **Active: active (running)**.

    > **Note**: If your Azure Security Center for IoT Agent isn't running or active, please check out [Deploy Azure Security Center for IoT C# based security agent for Linux Guide Troubleshooting Section](https://docs.microsoft.com/en-us/azure/asc-for-iot/how-to-deploy-linux-cs). Common issues are that might leave the service **Active: activating** are an incorrect key value or not specifying the full IoT Hub hostname.

1. In the Azure portal, navigate back your IoT Hub blade, and then open the **vm-device01** device blade.

    Open your IoT Hub blade, on the navigation menu under **Explorers**, click **IoT devices**, and then click **vm-device01**.

1. Under **Module Identities**, notice that your **azureiotsecurity** module is now in a **Connected** state.

    ![Screenshot of Azure IoT Security Module Connected](media/LAB_AK_19-device-connected-agent.png)

Now that your Azure Security Center for IoT device agents are installed on your device, the agents will be able to collect, aggregate and analyze raw security events from your device.

### Exercise 6: Configure Solution Management

Azure Security Center for IoT provides comprehensive end-to-end security for Azure-based IoT solutions.

With Azure Security Center for IoT, you can monitor your entire IoT solution in one dashboard, surfacing all of your IoT devices, IoT platforms and back-end resources in Azure.

Once enabled on your IoT Hub, Azure Security Center for IoT automatically identifies other Azure services, also connected to your IoT Hub and related to your IoT solution.

In addition to automatic relationship detection, you can also pick and choose which other Azure resource groups to tag as part of your IoT solution. Your selections allow you to add entire subscriptions, resource groups, or single resources.

#### Task 1: Open IoT Hub

1. In your browser, open the Azure Portal and navigate to your IoT Hub.

1. On the left side navigation menu, under **Security**, click **Resources**.

    Note that the list of resources already includes your IoT Hub, the workspace that was created when Azure Security Center for IoT was activated earlier as well as the current subscription.

1. At the top of the pane, click **Edit**.

    The **Solution Management** pane opens, where you can connect additional Azure resources to your security solution by selecting their owning resource groups.

1. Under **Subscriptions**, ensure that the subscription you are using for this course is selected.

    > **Note:**
    > You can add resources from multiple subscriptions to your security solution.

1. Under **Resource groups**, select the resource group for your VM - **AZ-220-SECVM-RG**.

    You should now have two Resource Groups selected. Notice that the Resources list has updated to reflect the additional resources in the resource group you just added.

1. At the bottom of the **Solution Management** pane, click **Apply**.

    If the **Apply** button is not available, don't worry, the resources were already added.

1. Close the **Solution Management** pane.

After defining all of the resource relationships, Azure Security Center for IoT leverages Azure Security Center to provide you security recommendations and alerts for these resources.

#### Task 2: View Azure Security Center for IoT in Action

You now have your the security agent installed on your device and your solution configured. It is a good time to check out the different views for Azure Security Center for IoT.

1. On the left side navigation menu, under **Security**, click **Overview**. 

    You will see the health overview for your devices, hubs, and other resources appear on two charts. You can see the Built-in real-time monitoring, recommendations and alerts that were enabled right when you turn on your Azure IoT Security Center.

    ![Screenshot of Azure IoT Security Module](media/LAB_AK_19-security-dashboard.png)

1. On the left side navigation menu, under **Security**, click **Resources**.

    This pane provides access to the health of your resources across your IoT solution.

    > **IMPORTANT**:
    > The process that evaluates the security configuration of your IoT resources may take up to 24 hours to run, therefore the initial status displayed on the dashboard does not reflect the actual state of your resources. 

    The image below shows the dashboard status once the security evaluation has been performed.

    ![Updated Screenshot of Azure IoT Security Module](media/LAB_AK_19-updated-security-dashboard.png)

### Exercise 7: Introduce custom alerts

Custom security groups and alerts can be used to take full advantage of the end-to-end security information and categorical device knowledge across your full IoT solution. This will help you to provide better security for your solution. 

#### Why use custom alerts?

You know your IoT devices better than an out-of-the-box algorithm.

For customers who fully understand their expected device behavior, Azure Security Center for IoT allows you to translate this understanding into a device behavior policy and alert on any deviation from expected, normal behavior.

#### Task 1 - Customize an alert

As mentioned above, customers that understand the specific desired behavior of their solution can configure custom alerts that trigger when the desired behavior is exceeded. In this exercise, you will create a custom alert that monitors **Device to Cloud** messages sent via the **MQTT** protocol.

Under normal circumstances, Contoso's cheese cave monitoring system will not be sending IoT Hub temperature and humidity data at a high rate. You expect each device to send between one and five device-to-cloud messages in a five minute period. This range accommodates the dusk time period when temperature could be changing more rapidly and more frequent data might be needed to ensure values don't slip outside the established boundary values.

In this task, you will create a custom alert.

1. On your Azure portal, navigate to your IoT Hub blade.

1. On the left side navigation menu, under **Security**, click **Custom Alerts**.

1. Take a moment to examine the **Custom Alerts** pane.

    At first glance, it may appear that this pane is empty, but the item listed under **Name** is actually the **default** security group, which is created for you automatically.

    Security groups enable you to define logical groups of devices, and manage their security state in a centralized way. These groups can represent devices with specific hardware, devices deployed in a certain location, or any other group suitable to your specific needs.

1. To add a custom alert to the default security group, click **default**.

    The **Device Security Group** blade lists all active custom alerts. Since this is the first time you have visited this blade, it will be empty.

1. At the top of the blade, click **Create custom alert rule**.

    The **Create custom alert rule** pane will open. Notice that the **Device Security Group** field is populated with the **default** group.

1. In the **Custom Alert** dropdown, click **Number of device to cloud messages (MQTT protocol) is not in allowed range**.

    > **Tip**:
    > Review the the many custom alerts available. Consider how they can be used to secure your solution.

    > **Note**:
    > The **Description** and **Required Properties** will change depending upon the **Custom Alert** that is chosen.

1. Under **Required Properties**, in the **Minimal Threshold** field, enter **1**.

    This satisfies the expectation that at least one message should be sent in a 5 minute period.

1. Under **Maximal Threshold**, enter **5**.

    This satisfies the expectation that no more than five messages should be sent in a 5 minute period.

1. In the **Time Window Size** dropdown, click **00:05:00**.

    This satisfies the five minute time period that was established.

    > **Note**:
    There are 4 available time windows:
    > * 5 minutes
    > * 10 minutes
    > * 15 minutes
    > * 30 minutes

1. At the bottom of the **Create custom alert rule** pane, click **OK**.

1. At the top of the **default** (Device Security Group) blade, click **Save**.

    Without saving the new alert, the alert is deleted the next time you close IoT Hub.

    You will be returned to the list of custom alerts. Below is an image that shows a number of custom alerts:

    ![Many custom alerts](media/LAB_AK_19-many-custom-alerts.png)

### Exercise 8: Configure the Device App

In this exercise, you will create an IoT Hub device and a .Net Core console application (C#) that will leverage the **Microsoft.Azure.Devices.Client** nuget package to connect to an IoT Hub. The console application will send telemetry every 10 seconds and is designed to exceed the Device to Cloud message threshold configured in the Custom Alert (that you created in the previous exercise).

#### Task 1: Register New IoT Device

A device must be registered with your IoT hub before it can connect.

1. On the Azure portal menu, click **Dashboard**, and then open your IoT Hub.

1. On the left side navigation menu, under **Explorers**, click **IoT devices**.

1. At the top of the **IoT devices** pane, click  **+ New**

1. On the **Create a device** blade, under **Device ID**, enter **CheeseCave1-Sensor1**

    You will be using **symmetric Keys** for authentication, so leave the other values at the defaults.

1. At the bottom of the blade, click **Save**.

1. On the **IoT devices** pane, under **Device ID**, click **CheeseCave1-Sensor1**.

    You may need to click **Load More** in order to access the **CheeseCave1-Sensor1** device.

1. To the right of **Primary connection string**, click **Copy**, and then save the value to a text file.

    Be sure to note that it is the connection string for the CheeseCave1-Sensor1 device. You will need the connection string value for the device app.

#### Task 2: Create a Console App

1. Open Visual Studio Code.

1. On the **File** menu, click **Open Folder**.

1. At the top of the **Open Folder** dialog, click **New folder**, type **ThermostatDevice** and then press **Enter**.

    You can create the ThermostatDevice folder under the Lab 19 folder, or another location of your choice.

1. Click **ThermostatDevice**, and then click **Select Folder**.

1. On the **File** menu, to ensure that file auto-save is enabled, click **Auto Save**.

    You will be copying in several blocks of code, and this will ensure you are always operating against the latest edits of your files.

1. On the **View** menu, to open the integrated terminal, click **Terminal**.

1. At the Terminal command prompt, to create a new console app, enter the following command:

    ```bash
    dotnet new console
    ```

#### Task 3: Connect the App to IoT Hub

1. At the Terminal command prompt, to install the required NuGet package, enter the following command:

    ```bash
    dotnet add package Microsoft.Azure.Devices.Client
    ```

1. In the EXPLORER pane, click **Program.cs**.

1. In the Code Editor, delete all of the existing code.

1. In the Code Editor, to add the `using` statements that the app will require, enter the following code:

    ```csharp
    using System;
    using Microsoft.Azure.Devices.Client;
    using Newtonsoft.Json;
    using System.Text;
    using System.Threading.Tasks;
    ```

1. Below the `using` statements, to create a namespace for the application, enter the following code:

    ```csharp
    namespace ThermostatDevice
    {
        // add class below here
    }
    ```

1. On a blank code line below the `// add class below here` comment, too create the **ThermostatDevice** class, enter the following code:

    ```csharp
    class ThermostatDevice
    {
        // add variables below here
    }
    ```

1. On a blank code line below the `// add variables below here` comment, to define a variable for the device connection string, enter the following code:

    ```csharp
    private static DeviceClient s_deviceClient;
    private readonly static string s_connectionString = "<DEVICE-CONNECTION-STRING>";

    // add SendDeviceToCloudMessagesAsync method below here
    ```

    The first line provides a reference to the `DeviceClient`
    The second line provide a variable for the device connection string (which you copied earlier) 

    > **Tip**:
    > Replace `<DEVICE-CONNECTION-STRING>` with the device primary connection string you copied from the Azure Portal earlier.

1. On a blank code line below the `// add SendDeviceToCloudMessagesAsync method below here` comment, to send device to cloud messages to the IoT Hub, add the following code:

    ```csharp
    private static async void SendDeviceToCloudMessagesAsync()
    {
        // Initial telemetry values
        double minTemperature = 20;
        double minHumidity = 60;
        Random rand = new Random();

        // loop until the user hits CTRL+C
        while (true)
        {
            double currentTemperature = minTemperature + rand.NextDouble() * 15;
            double currentHumidity = minHumidity + rand.NextDouble() * 20;

            // Create JSON message using an anonymous type
            var telemetryDataPoint = new
            {
                temperature = currentTemperature,
                humidity = currentHumidity
            };
            var messageString = JsonConvert.SerializeObject(telemetryDataPoint);
            var message = new Message(Encoding.ASCII.GetBytes(messageString));

            // Add a custom application property to the message.
            // An IoT hub can filter on these properties without access to the message body.
            message.Properties.Add("temperatureAlert", (currentTemperature > 30) ? "true" : "false");

            // Send the telemetry message
            await s_deviceClient.SendEventAsync(message);
            Console.WriteLine("{0} > Sending message: {1}", DateTime.Now, messageString);

            // wait 10 seconds before sending the next message
            await Task.Delay(10000);
        }
    }

    // add main method below here
    ```

    Notice the `await Task.Delay(10000);` code above. This will cause a time delay so that a message will be sent every 10 seconds, which will exceed the "no more than 5 messages in 5 minutes" threshold for the custom alert.

    > **Tip**:
    > Read the code comments to understand how the method works.

1. On a blank code line below the `// add main method below here` comment, to provide a Main method (entry point) for the app, enter the following code:

    ```csharp
    private static void Main(string[] args)
    {
        Console.WriteLine("IoT Hub C# Simulated Thermostat Device. CTRL+C to exit.\n");

        // Connect to the IoT hub using the MQTT protocol
        s_deviceClient = DeviceClient.CreateFromConnectionString(s_connectionString, TransportType.Mqtt);
        SendDeviceToCloudMessagesAsync();
        Console.ReadLine();
    }
    ```

    > **Note**:
    When the `DeviceClient` instance is created, the **MQTT** protocol is specified with `TransportType.Mqtt` - this ensures that the Device to Cloud messages are sent using the protocol specified in the custom alert created.

1. At the Terminal con=mmand prompt, to build and run the application, enter the following command:

    ```bash
    dotnet run
    ```

    The output will be similar to:

    ```text
    IoT Hub C# Simulated Thermostat Device. CTRL+C to exit.

    2/28/2020 1:32:21 PM > Sending message: {"temperature":25.7199231282435,"humidity":79.50078555359542}
    2/28/2020 1:32:31 PM > Sending message: {"temperature":21.877205091005752,"humidity":61.30029373862794}
    2/28/2020 1:32:41 PM > Sending message: {"temperature":21.245898961204055,"humidity":71.36471955634873}
    2/28/2020 1:32:51 PM > Sending message: {"temperature":32.61750500072609,"humidity":66.07430422961447}
    2/28/2020 1:33:01 PM > Sending message: {"temperature":31.100763578946125,"humidity":79.93955616836416}
    2/28/2020 1:33:11 PM > Sending message: {"temperature":25.02041019034591,"humidity":70.50569472392355}
    ```

    You can leave the app running for the remainder of this lab to generate multiple alerts.

### Exercise 9: Review Security Center Alerts

At this point, your console app will have sent enough telemetry to trigger the Custom Alert created earlier. 

> **Tip**:
> The alert was set up to trigger if less than 1 and more than 5 messages where sent from a device to the cloud within a 5 minute time window.

#### Task 1: Review the Security Center Dashboard

1. On the Azure portal menu, click **Dashboard** and then open your IoT Hub.

1. On the left side navigation menu, under **Security**, click **Overview**.

    Take a look at the **Threat detection** section. You should see one or more alerts displayed in the **Device security alerts** chart:

    ![Device security alert chart](media/LAB_AK_19-device-security-alert-chart.png)

    You should also see an entry for the **CheeseCave1-Sensor1** device in the **Devices with the most alerts** tile:

    ![Devices with the most alerts tile](media/LAB_AK_19-devices-with-most-alerts-tile.png)

    > [!NOTE]
    > It can take between 10 and 15 minutes for alerts to be displayed on the dashboard.

1. Under **Threat detection**, click the **Devices with the most alerts** tile.

    This will open the same **Alerts** blade as you would see if you were to click **Security Alerts** under **Security** in the left side navigation menu.

    You will see a list of Security Alerts:

    ![Security Alert List](media/LAB_AK_19-security-alert-list.png)

    The latest alerts will be marked with a **NEW** label.

1. Click the latest alert.

    A detail pane will open. The **General information** provides high-level information concerning the alert. Beneath this, the **Last 10 Affected Devices** should list the **CheeseCave1-Sensor1** device.

    ![Custom Alert Details Pane](media/LAB_AK_19-custom-alert-details-pane.png)

1. Return to Visual Studio Code and exit the device app.

    You can close the app by placing input focus on the Terminal window and pressing **CTRL+C**.
