---
lab:
    title: 'Lab 16: Automate IoT Device Management with Azure IoT Hub'
    module: 'Module 8: Device Management'
---

# Automate IoT Devices Management with Azure IoT Hub

IoT devices often use optimized operating systems or even run code directly on the silicon (without the need for an actual operating system). In order to update the software running on devices like these the most common method is to flash a new version of the entire software package, including the OS as well as the apps running on it (called firmware).

Because each device has a specific purpose, its firmware is also very specific and optimized for the purpose of the device as well as the constrained resources available.

The process for updating firmware can also be specific to the hardware and to the way the hardware manufacturer created the board. This means that a part of the firmware update process is not generic and you will need to work with your device manufacturer to get the details of the firmware update process (unless you are developing your own hardware which means you probably know what the firmware update process).

While firmware updates used to be applied manually on individual devices, this practice no longer makes sense considering the number of devices used in typical IoT solutions. Firmware updates are now more commonly done over-the-air (OTA) with deployments of new firmware managed remotely from the cloud.

There is a set of common denominators to all over-the-air firmware updates for IoT devices:

1. Firmware versions are uniquely identified
1. Firmware comes in a binary file format that the device will need to acquire from an online source
1. Firmware is locally stored is some form of physical storage (ROM memory, hard drive,...)
1. Device manufacturer provide a description of the required operations on the device to update the firmware.

Azure IoT Hub offers advanced support for implementing device management operations on single devices and on collections of devices. The [Automatic Device Management](https://docs.microsoft.com/azure/iot-hub/iot-hub-auto-device-config) feature enables you to simply configure a set of operations, trigger them, and then monitor their progress.

## Lab Scenario

The automated air processing system that you implemented in Contoso's cheese caves has helped the company to raise their already high quality bar. The company has more award winning cheeses than ever before.

Your base solution consists of IoT devices that are integrated with sensors and a climate control system to provide real-time control of temperature and humidity within a multi-chamber cave system. You also developed a simple back-end app that demonstrated the ability to manage devices using both direct methods and device twin properties.

Contoso has extended the simple back-end app from your initial solution to include an online portal that operators can use to monitor and remotely manage the cave environment. With the new portal, operators can even customize the temperature and humidity within the cave based on the type of cheese or for a specific phase within the cheese aging process. Each chamber or zone within the cave can be controlled separately.

The IT department will be maintaining the back-end portal that they developed for the operators, but your manager has agreed to manage the device-side of the solution. 

For you, this means two things: 

1. The Operations team at Contoso is always looking for ways to make improvements. These improvements often lead to requests for new features in the device software. 

1. The IoT devices that are deployed to cave locations need the latest security patches to ensure privacy and to prevent hackers from taking control of the system. In order to maintain system security, you need to keep the devices up to date by remotely updating their firmware.

You plan to implement features of IoT Hub that enable automatic device management and device management at scale.

## In this lab

In this lab, you will complete the following activities:

* Verify Lab Prerequisites
* Write code for a simulated device that will implement a firmware update
* Test the firmware update process on a single device using Azure IoT Hub automatic device management

## Lab Instructions

### Exercise 1: Verify Lab Prerequisites

This lab assumes the following Azure resources are available:

| Resource Type | Resource Name |
| :-- | :-- |
| Resource Group | AZ-220-RG |
| IoT Hub | AZ-220-HUB-_{YOUR-ID}_ |
| IoT Device | SimulatedSolutionThermostat |

If these resources are not available, you will need to run the **lab16-setup.azcli** script as instructed below before moving on to Exercise 2. The script file is included in the GitHub repository that you cloned locally as part of the dev environment configuration (lab 3).

>**Note:** You will need the connection string for the **SimulatedSolutionThermostat** device. If you already have this device registered with Azure IoT Hub, you can obtain the connection string by running the following command in the Azure Cloud Shell"
>
> ```bash
> az iot hub device-identity show-connection-string --hub-name AZ-220-HUB-_{YOUR-ID}_ --device-id SimulatedThermostat -o tsv
> ```

The **lab16-setup.azcli** script is written to run in a **bash** shell environment - the easiest way to execute this is in the Azure Cloud Shell.

1. Using a browser, open the [Azure Shell](https://shell.azure.com/) and login with the Azure subscription you are using for this course.

    If you are prompted about setting up storage for Cloud Shell, accept the defaults.

1. Verify that the Azure Cloud Shell is using **Bash**.

    The dropdown in the top-left corner of the Azure Cloud Shell page is used to select the environment. Verify that the selected dropdown value is **Bash**.

1. On the Azure Shell toolbar, click **Upload/Download files** (fourth button from the right).

1. In the dropdown, click **Upload**.

1. In the file selection dialog, navigate to the folder location of the GitHub lab files that you downloaded when you configured your development environment.

    In _Lab 3: Setup the Development Environment_, you cloned the GitHub repository containing lab resources by downloading a ZIP file and extracting the contents locally. The extracted folder structure includes the following folder path:

    * Allfiles
      * Labs
          * 16-Automate IoT Device Management with Azure IoT Hub
            * Setup

    The lab16-setup.azcli script file is located in the Setup folder for lab 16.

1. Select the **lab16-setup.azcli** file, and then click **Open**.

    A notification will appear when the file upload has completed.

1. To verify that the correct file has uploaded in Azure Cloud Shell, enter the following command:

    ```bash
    ls
    ```

    The `ls` command lists the content of the current directory. You should see the lab16-setup.azcli file listed.

1. To create a directory for this lab that contains the setup script and then move into that directory, enter the following Bash commands:

    ```bash
    mkdir lab16
    mv lab16-setup.azcli lab16
    cd lab16
    ```

1. To ensure that **lab16-setup.azcli** has the execute permission, enter the following command:

    ```bash
    chmod +x lab16-setup.azcli
    ```

1. On the Cloud Shell toolbar, to edit the lab16-setup.azcli file, click **Open Editor** (second button from the right - **{ }**).

1. In the **FILES** list, to expand the lab16 folder and open the script file, click **lab16**, and then click **lab16-setup.azcli**.

    The editor will now show the contents of the **lab16-setup.azcli** file.

1. In the editor, update the `{YOUR-ID}` and `{YOUR-LOCATION}` assigned values.

    In the reference sample below, you need to set `{YOUR-ID}` to the Unique ID you created at the start of this course - i.e. **CAH191211**, and set `{YOUR-LOCATION}` to the location that makes sense for your resources.

    ```bash
    #!/bin/bash

    RGName="AZ-220-RG"
    IoTHubName="AZ-220-HUB-{YOUR-ID}"

    Location="{YOUR-LOCATION}"
    ```

    > **Note**:  The `{YOUR-LOCATION}` variable should be set to the short name for the region. You can see a list of the available regions and their short-names (the **Name** column) by entering this command:
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
    ./lab16-setup.azcli
    ```

    This script can take a few minutes to run. You will see JSON output as each step completes.

    The script will first create a resource group named **AZ-220-RG** and an IoT Hub named **AZ-220-HUB-{YourID}**. If they already exist, a corresponding message will be displayed. The script will then add a device with an ID of **SimulatedSolutionThermostat** to the IoT hub and display the device connection string.

1. Notice that, once the script has completed, the connection string for the device is displayed.

    The connection string starts with "HostName="

1. Copy the connection string into a text document, and note that it is for the **SimulatedSolutionThermostat** device.

    Once you have saved the connection string to a location where you can find it easily, you will be ready to continue with the lab.

### Exercise 2: Write code to simulate device that implements firmware update

In this exercise, you will create a simple simulator that will manage the device twin desired properties changes and will trigger a local process simulating a firmware update. The overall process would be exactly the same for a real device with the exception of the actual steps for the local firmware update. You will then use the Azure Portal to configure and execute a firmware update for a single device. IoT Hub will use the device twin properties to transfer the configuration change request to the device and monitor the progress.

#### Task 1: Create the device simulator app

1. To use C# in Visual Studio Code, ensure both [.NET Core](https://dotnet.microsoft.com/download), and the [C# extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp) are installed

1. Open a terminal in Visual Studio Code. Create a folder called **fwupdatedevice** and Navigate to the **fwupdatedevice** folder by running the following commands in the terminal:

    ```cmd/sh
    mkdir fwupdatedevice
    cd fwupdatedevice
    ```

1. Enter the following command in the terminal to create a **Program.cs** file in your folder, along with a project file.

    ```cmd/sh
    dotnet new console
    ```

1. Enter `dotnet restore` in the terminal. This command gives your app access to the required .NET packages.

    ```cmd/sh
    dotnet restore
    ```

1. In the terminal, install the required libraries. Enter the following commands and make sure all three libraries are installed:

    ```cmd/sh
    dotnet add package Microsoft.Azure.Devices.Client
    dotnet add package Microsoft.Azure.Devices.Shared
    dotnet add package Newtonsoft.Json
    ```

1. From the **File** menu, open up the **Program.cs** file, and delete the default contents.

#### Task 2: Add code to your app

1. Open the **Program.cs** file for the device app.

1. Copy and paste the following code.

    ```cs
    // Copyright (c) Microsoft. All rights reserved.
    // Licensed under the MIT license. See LICENSE file in the project root for full license information.

    using Microsoft.Azure.Devices.Shared;
    using Microsoft.Azure.Devices.Client;
    using System;
    using System.Threading.Tasks;

    namespace fwupdatedevice
    {
        class SimulatedDevice
        {
            // The device connection string to authenticate the device with your IoT hub.
            static string s_deviceConnectionString = "";

            // Device ID variable
            static string DeviceID="unknown";

            // Firmware version variable
            static string DeviceFWVersion = "1.0.0";

            // Simple console log function
            static void LogToConsole(string text)
            {
                // we prefix the logs with the device ID
                Console.WriteLine(DeviceID + ": " + text);
            }

            // Function to retreive firmware version from the OS/HW
            static string GetFirmwareVersion()
            {
                // In here you would get the actual firmware version from the hardware. For the simulation purposes we will just send back the FWVersion variable value
                return DeviceFWVersion;
            }

            // Function for updating a device twin reported property to report on the current Firmware (update) status
            // Here are the values expected in the "firmware" update property by the firmware update configuration in IoT Hub
            //  currentFwVersion: The firmware version currently running on the device.
            //  pendingFwVersion: The next version to update to, should match what's
            //                    specified in the desired properties. Blank if there
            //                    is no pending update (fwUpdateStatus is 'current').
            //  fwUpdateStatus:   Defines the progress of the update so that it can be
            //                    categorized from a summary view. One of:
            //         - current:     There is no pending firmware update. currentFwVersion should
            //                    match fwVersion from desired properties.
            //         - downloading: Firmware update image is downloading.
            //         - verifying:   Verifying image file checksum and any other validations.
            //         - applying:    Update to the new image file is in progress.
            //         - rebooting:   Device is rebooting as part of update process.
            //         - error:       An error occurred during the update process. Additional details
            //                    should be specified in fwUpdateSubstatus.
            //         - rolledback:  Update rolled back to the previous version due to an error.
            //  fwUpdateSubstatus: Any additional detail for the fwUpdateStatus . May include
            //                     reasons for error or rollback states, or download %.
            //
            // reported: {
            //       firmware: {
            //         currentFwVersion: '1.0.0',
            //         pendingFwVersion: '',
            //         fwUpdateStatus: 'current',
            //         fwUpdateSubstatus: '',
            //         lastFwUpdateStartTime: '',
            //         lastFwUpdateEndTime: ''
            //   }
            // }

            static async Task UpdateFWUpdateStatus(DeviceClient client, string currentFwVersion, string pendingFwVersion, string fwUpdateStatus, string fwUpdateSubstatus, string lastFwUpdateStartTime, string lastFwUpdateEndTime)
            {
                TwinCollection properties = new TwinCollection();
                if (currentFwVersion!=null)
                    properties["currentFwVersion"] = currentFwVersion;
                if (pendingFwVersion!=null)
                    properties["pendingFwVersion"] = pendingFwVersion;
                if (fwUpdateStatus!=null)
                    properties["fwUpdateStatus"] = fwUpdateStatus;
                if (fwUpdateSubstatus!=null)
                    properties["fwUpdateSubstatus"] = fwUpdateSubstatus;
                if (lastFwUpdateStartTime!=null)
                    properties["lastFwUpdateStartTime"] = lastFwUpdateStartTime;
                if (lastFwUpdateEndTime!=null)
                    properties["lastFwUpdateEndTime"] = lastFwUpdateEndTime;

                TwinCollection reportedProperties = new TwinCollection();
                reportedProperties["firmware"] = properties;

                await client.UpdateReportedPropertiesAsync(reportedProperties).ConfigureAwait(false);
            }

            // Execute firmware update on the device
            static async Task UpdateFirmware(DeviceClient client, string fwVersion, string fwPackageURI, string fwPackageCheckValue)
            {
                LogToConsole("A firmware update was requested from version " + GetFirmwareVersion() + " to version " + fwVersion);
                await UpdateFWUpdateStatus(client, null, fwVersion, null, null, DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ"), null);

                // Get new firmware binary. Here you would download the binary or retrieve it from the source as instructed for your device, then double check with a hash the integrity of the binary you downloaded
                LogToConsole("Downloading new firmware package from " + fwPackageURI);
                await UpdateFWUpdateStatus(client, null, null, "downloading", "0", null, null);
                await Task.Delay(2 * 1000);
                await UpdateFWUpdateStatus(client, null, null, "downloading", "25", null, null);
                await Task.Delay(2 * 1000);
                await UpdateFWUpdateStatus(client, null, null, "downloading", "50", null, null);
                await Task.Delay(2 * 1000);
                await UpdateFWUpdateStatus(client, null, null, "downloading", "75", null, null);
                await Task.Delay(2 * 1000);
                await UpdateFWUpdateStatus(client, null, null, "downloading", "100", null, null);
                // report the binary has been downloaded
                LogToConsole("The new firmware package has been successfully downloaded.");

                // Check binary integrity
                LogToConsole("Verifying firmware package with checksum " + fwPackageCheckValue);
                await UpdateFWUpdateStatus(client, null, null, "verifying", null, null, null);
                await Task.Delay(5 * 1000);
                // report the binary has been downloaded
                LogToConsole("The new firmware binary package has been successfully verified");

                // Apply new firmware
                LogToConsole("Applying new firmware");
                await UpdateFWUpdateStatus(client, null, null, "applying", null, null, null);
                await Task.Delay(5 * 1000);

                // On a real device you would reboot at the end of the process and the device at boot time would report the actual firmware version, which if successful should be the new version.
                // For the sake of the simulation, we will simply wait some time and report the new firmware version
                LogToConsole("Rebooting");
                await UpdateFWUpdateStatus(client, null, null, "rebooting", null, null, DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ"));
                await Task.Delay(5 * 1000);

                // On a real device you would issue a command to reboot the device. Here we are simply runing the init function
                DeviceFWVersion = fwVersion;
                await InitDevice(client);

            }

            // Callback for responding to desired property changes
            static async Task OnDesiredPropertyChanged(TwinCollection desiredProperties, object userContext)
            {
                LogToConsole("Desired property changed:");
                LogToConsole($"{desiredProperties.ToJson()}");

                // Execute firmware update
                if (desiredProperties.Contains("firmware") && (desiredProperties["firmware"]!=null))
                {
                    // In the desired properties, we will find the following information:
                    // fwVersion: the version number of the new firmware to flash
                    // fwPackageURI: URI from where to download the new firmware binary
                    // fwPackageCheckValue: Hash for validating the integrity of the binary downloaded
                    // We will assume the version of the firmware is a new one
                    TwinCollection fwProperties = new TwinCollection(desiredProperties["firmware"].ToString());
                    await UpdateFirmware((DeviceClient)userContext, fwProperties["fwVersion"].ToString(), fwProperties["fwPackageURI"].ToString(), fwProperties["fwPackageCheckValue"].ToString());

                }
            }

            static async Task InitDevice(DeviceClient client)
            {
                LogToConsole("Device booted");
                LogToConsole("Current firmware version: " + GetFirmwareVersion());
                await UpdateFWUpdateStatus(client, GetFirmwareVersion(), "", "current", "", "", "");
            }

            static async Task Main(string[] args)
            {
                // Get the device connection string from the command line
                if (string.IsNullOrEmpty(s_deviceConnectionString) && args.Length > 0)
                {
                    s_deviceConnectionString = args[0];
                } else
                {
                    Console.WriteLine("Please enter the connection string as argument.");
                    return;
                }

                DeviceClient deviceClient = DeviceClient.CreateFromConnectionString(s_deviceConnectionString, TransportType.Mqtt);

                if (deviceClient == null)
                {
                    Console.WriteLine("Failed to create DeviceClient!");
                    return;
                }

                // Get the device ID
                string[] elements = s_deviceConnectionString.Split('=',';');

                for(int i=0;i<elements.Length; i+=2)
                {
                    if (elements[i]=="DeviceId") DeviceID = elements[i+1];
                }

                // Run device init routine
                await InitDevice(deviceClient);

                // Attach callback for Desired Properties changes
                await deviceClient.SetDesiredPropertyUpdateCallbackAsync(OnDesiredPropertyChanged, deviceClient).ConfigureAwait(false);

                // Wait for keystroke to end app
                // TODO
                while (true)
                {
                    Console.ReadLine();
                    return;
                }
            }
        }
    }

    ```

    > **Note**: 
    > Read through the comments in the code, noting how the device reacts to device twin changes to execute a firmware update based on the configuration shared in the desired Property "firmware". You can also note the function that will report the current firmware update status through the reported properties of the device twin.

1. After you've entered the code below into the **Program.cs** file, you can run the app with the command `dotnet run`. This command will run the **Program.cs** file in the current folder, so ensure you are in the fwupdatedevice folder.

    ```cmd/sh
    dotnet run
    ```

1. Save the **Program.cs** file.

At this point your device is ready to be manage from IoT Hub. Next, we will test that the firmware update process works as expected for this simulated device.

### Exercise 3: Test firmware update on a single device

In this exercise, we will use the Azure portal to create a new device management configuration and apply it to our single simulated device.

#### Task 1: Start device simulator

In the same terminal you setup the application for the simulated device, start the simulator typing the following command (replacing \<device connection string\> with the device connection string you got at the end of task 2):

``` bash
dotnet run "<device connection string>"
```

You should see the following output in the terminal (where "mydevice" is the device ID you used when creating the device identity):

``` bash
    mydevice: Device booted
    mydevice: Current firmware version: 1.0.0
```

> **Note**: 
> Make sure to put "" around your connection string. For example: "HostName=AZ-220-HUB-{YourID}.azure-devices.net;DeviceId=SimulatedSolutionThermostat;SharedAccessKey={}="

#### Task 2: Create the device management configuration

1. Sign into the [Azure portal](https://portal.azure.com/learn.docs.microsoft.com?azure-portal=true).

1. Go to the IoT Hub blade. You can find your IoT Hub by typing in the search bar (on top) the name you used when creating it in task 2.

1. In the IoT Hub, find the **Automatic Device Management** blade and select **IoT Device Configuration**, then select **Add Device Configuration**

1. Enter an ID for the configuration such as **firmwareupdate** then click on **Next: Twins settings >** on the bottom.

1. For the **Device Twin Property** field, enter the following:

    ``` bash
    properties.desired.firmware
    ```

1. In the **Device Twin Property Content** field type the following. Then click on **Next: Metrics >**

    ``` json
    {
        "fwVersion":"1.0.1",
        "fwPackageURI":"https://MyPackage.uri",
        "fwPackageCheckValue":"1234"
    }
    ```

1. In the **Metrics** blade we will define a custom metric to track the firmware update was effective. Create a new custom metric called **"fwupdated"** and type in the below criteria, then click on **Next: Target devices >**

    ``` SQL
        SELECT deviceId FROM devices
            WHERE properties.reported.firmware.currentFwVersion='1.0.1'
    ```

1. In the **Priority** field, type **"10"** and in the **Target Condition** field, type in the following query, replacing "\<your device id\>" with the device Id you used to create the device in task 2, then click on **Next: Review + Create >**

    ``` SQL
        deviceId='<your device id>'
    ```

1. On the next blade you should see the validation succeed for your new configuration. Click on **Create**.

1. Once the configuration has been created you will see it in the **Automatic Device Management** blade.

At this point IoT Hub will look for devices matching the configuration's target devices criteria, and will apply the firmware update configuration automatically.

You have validated that the firmware update process on your simulated device works. You can stop the device simulator by simply pressing the "Enter" key in the terminal.
