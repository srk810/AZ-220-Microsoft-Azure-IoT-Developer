---
lab:
    title: 'Lab 15: Remotely monitor and control devices with Azure IoT Hub'
    module: 'Module 8: Device Management'
---

# Remotely monitor and control devices with Azure IoT Hub

## Lab Scenario

Contoso is proud of its award-winning cheeses and is careful to maintain the perfect temperature and humidity during the entire manufacturing process, but conditions during the aging process have always received special attention.

In recent years, Contoso has used environmental sensors to record the conditions within their natural cheese caves where aging occurs, and has used that data to identify a near perfect environment. Data from the most successful (aka award producing) locations indicates that the ideal temperature for aging cheese is approximately 50 degrees Fahrenheit +/- 5 degrees (10 degrees Centigrade +/- 2.8 degrees). The ideal humidity value, measured in percentage of maximum saturation, is approximately 85% +/- 10%.

These ideal temperature and humidity values work well for most types of cheese. However, minor variations are required for especially hard or especially soft cheeses. The environment must also be adjusted at critical times/phases within the aging process to achieve specific results, such as a desired condition for the cheese rind.

Contoso is lucky enough to operate cheese caves (in certain geographic regions) that naturally maintain ideal conditions almost year-round. However, even in these locations, managing the environment during the aging process is critical. Also, natural caves often have a number of different chambers, each of which can have a slightly different environment. Cheese varieties are placed in a chamber (zone) that matches their specific requirements. To keep environmental conditions within desired limits, Contoso uses an air processing/conditioning system that controls both temperature and humidity.

Currently, an operator monitors the environmental conditions within each zone of a cave facility and adjusts the air processing system settings when required to maintain the desired temperature and humidity. Operators are able to visit each zone and check the environmental conditions every 4 hours. In locations where temperature changes dramatically between the daytime high and nighttime low, conditions can slip outside of the desired limits.

Contoso has tasked you with implementing an automated system that keeps the cave environment within control limits.

In this lab, you will be prototyping a cheese cave monitoring system that implements IoT devices. Each device is equipped with temperature and humidity sensors, and is connected to the air processing system that controls temperature and humidity for the zone where the device is located.

### Simplified Lab Conditions

The frequency of telemetry output is an important consideration in production solutions. A temperature sensor in a refrigeration unit may only need to report once a minute, whereas an acceleration sensor on an aircraft may have to report ten times per second. In some cases, the frequency at which telemetry must be sent is dependent on current conditions. For example, if the temperature our cheese cave scenario tends to drop quickly at night, you may benefit from having more frequent sensor readings beginning two hours before sunset. Of course the requirement to change the frequency of telemetry does not need to be part of a predictable pattern, the events that drive our need to change IoT device settings can be unpredictable.

To keep things simple in this lab, we will make the following assumptions:

* The device will send telemetry (temperature and humidity values) to the IoT Hub every few seconds. Although this frequency is unrealistic for a cheese cave, it is great for a lab environment when we need to see changes frequently, not every 15 minutes.
* The air processing system is a fan that can be in one of three states: On, Off, or Failed.
  * The fan is initialized to the Off state.
  * Electrical power to the fan is controlled (On/Off) using a direct method on the IoT device.
  * Device Twin desired property values are used to set the desired state of the fan. The desired property values will override any default settings for the fan/device.
  * Temperature can be controlled by turning the fan On/Off (turning the fan On will lower the temperature)

Coding in this lab is broken down into three parts: sending and receiving telemetry, invoking and running a direct method, setting and reading device twin properties.

You will start by writing two apps: one for a device to send telemetry, and one for a back-end service (that will run in the cloud) to receive the telemetry.

The following resources will be created:

![Lab 15 Architecture](media/LAB_AK_15-architecture.png)

## In this lab

In this lab, you will complete the following activities:

* Verify Lab Prerequisites
* Create a custom Azure IoT Hub, using the IoT Hub portal
* Create an IoT Hub device ID, using the IoT Hub portal
* Create an app to send device telemetry to the custom IoT Hub
* Create a back-end service app to listen for the telemetry
* Implement a direct method, to communicate settings to the remote device
* Implement device twins, to maintain remote device properties

## Lab Instructions

### Exercise 1: Verify Lab Prerequisites

This lab assumes the following Azure resources are available:

| Resource Type | Resource Name |
| :-- | :-- |
| Resource Group | AZ-220-RG |
| IoT Hub | AZ-220-HUB-*{YOUR-ID}* |
| IoT Device | CheeseCaveID |

If these resources are not available, you will need to run the **lab15-setup.azcli** script as instructed below before moving on to Exercise 2. The script file is included in the GitHub repository that you cloned locally as part of the dev environment configuration (lab 3).

The **lab15-setup.azcli** script is written to run in a **bash** shell environment - the easiest way to execute this is in the Azure Cloud Shell.

>**Note:** You will need the connection string for the **CheeseCaveID** device. If you already have this device registered with Azure IoT Hub, you can obtain the connection string by running the following command in the Azure Cloud Shell"
>
> ```bash
> az iot hub device-identity show-connection-string --hub-name AZ-220-HUB-{YOUR-ID} --device-id CheeseCaveID -o tsv
> ```

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
          * 15-Remotely monitor and control devices with Azure IoT Hub
            * Setup

    The lab15-setup.azcli script file is located in the Setup folder for lab 15.

1. Select the **lab15-setup.azcli** file, and then click **Open**.

    A notification will appear when the file upload has completed.

1. To verify that the correct file has uploaded in Azure Cloud Shell, enter the following command:

    ```bash
    ls
    ```

    The `ls` command lists the content of the current directory. You should see the lab15-setup.azcli file listed.

1. To create a directory for this lab that contains the setup script and then move into that directory, enter the following Bash commands:

    ```bash
    mkdir lab15
    mv lab15-setup.azcli lab15
    cd lab15
    ```

1. To ensure that **lab15-setup.azcli** has the execute permission, enter the following command:

    ```bash
    chmod +x lab15-setup.azcli
    ```

1. On the Cloud Shell toolbar, to edit the lab15-setup.azcli file, click **Open editor** (second button from the right - **{ }**).

1. In the **FILES** list, to expand the lab15 folder and open the script file, click **lab15**, and then click **lab15-setup.azcli**.

    The editor will now show the contents of the **lab15-setup.azcli** file.

1. In the editor, update the `{YOUR-ID}` and `SETLOCATION` assigned values.

    Referencing the sample below as an example, you need to set `{YOUR-ID}` to the Unique ID you created at the start of this course - i.e. **CAH191211**, and set `SETLOCATION` to the location that makes sense for your resources.

    ```bash
    #!/bin/bash

    YourID="{YOUR-ID}"
    RGName="AZ-220-RG"
    IoTHubName="AZ-220-HUB-$YourID"
    DeviceID="CheeseCaveID"

    Location="SETLOCATION"
    ```

    > **Note**:  The `Location` variable should be set to the short name for the location. You can see a list of the available locations and their short-names (the **Name** column) by entering this command:
    >
    > ```bash
    > az account list-locations -o Table
    > ```
    >
    > ```text
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
    ./lab15-setup.azcli
    ```

    This script can take a few minutes to run. You will see JSON output as each step completes.

    The script will first create a resource group named **AZ-220-RG** and an IoT Hub named **AZ-220-HUB-{YourID}**. If they already exist, a corresponding message will be displayed. The script will then add a device with an ID of **CheeseCaveID** to the IoT hub and display the device connection string.

1. Notice that, once the script has completed, information pertaining to your IoT Hub and device is displayed.

    The script will display information similar to the following:

    ```text
    Configuration Data:
    ------------------------------------------------
    AZ-220-HUB-{YourID} Service connectionstring:
    HostName=AZ-220-HUB-{YourID}.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=nV9WdF3Xk0jYY2Da/pz2i63/3lSeu9tkW831J4aKV2o=

    CheeseCaveID device connection string:
    HostName=AZ-220-HUB-{YourID}.azure-devices.net;DeviceId=CheeseCaveID;SharedAccessKey=TzAzgTYbEkLW4nWo51jtgvlKK7CUaAV+YBrc0qj9rD8=

    AZ-220-HUB-{YourID} eventhub endpoint:
    sb://iothub-ns-az-220-hub-2610348-5a463f1b56.servicebus.windows.net/

    AZ-220-HUB-{YourID} eventhub path:
    az-220-hub-{YourID}

    AZ-220-HUB-{YourID} eventhub SaS primarykey:
    tGEwDqI+kWoZroH6lKuIFOI7XqyetQHf7xmoSf1t+zQ=
    ```

1. Copy the output displayed by the script into a text document for use later in this lab.

    Once you have saved the information to a location where you can find it easily, you will be ready to continue with the lab.

### Exercise 2: Write Code to Send and Receive Telemetry

In this exercise, you will be creating the simulated device app (for the CheeseCaveID device) that sends telemetry to your IoT Hub.

#### Task 1: Create a Console App in Visual Studio Code

1. Open Visual Studio Code.

1. On the **Terminal** menu, click **New Terminal**.

1. At the Terminal command prompt, to create a directory called "cheesecavedevice" and change the current directory to that directory, enter the following commands:

    ```bash
    mkdir cheesecavedevice
    cd cheesecavedevice
    ```

1. To create a new .NET console application, enter the following command:

    ```bash
    dotnet new console
    ```

    This command creates a **Program.cs** file in your folder, along with a project file.

1. To install the required libraries, enter the following commands:

    ```bash
    dotnet add package Microsoft.Azure.Devices.Client
    dotnet add package Microsoft.Azure.Devices.Shared
    dotnet add package Newtonsoft.Json
    ```

1. On the **File** menu, click **Open Folder**

1. In the **Open Folder** dialog, navigate to the folder location specified in the Terminal pane, click **cheesecavedevice**, and then click **Select Folder**

    The EXPLORER pane should open in Visual Studio Code and you should see the `Program.cs` and `cheesecadedevice.csproj` files listed.

1. In the **EXPLORER** pane, click **Program.cs**.

1. In the Code Editor pane, delete the contents of the Program.cs file.

#### Task 2: Add Code to Simulate Your CheeseCaveID IoT Device

In this task, you will add the code to send telemetry from a simulated device. The device sends temperature (in degrees Fahrenheit) and humidity (in percentages), regardless of whether any back-end app is listening or not.

1. Ensure that you have the **Program.cs** file open in Visual Studio Code.

    The Code Editor pane should display an empty code file.

1. Copy-and-Paste the following code into the Code Editor pane:

    ```csharp
    // Copyright (c) Microsoft. All rights reserved.
    // Licensed under the MIT license. See LICENSE file in the project root for full license information.

    using System;
    using Microsoft.Azure.Devices.Client;
    using Microsoft.Azure.Devices.Shared;
    using Newtonsoft.Json;
    using System.Text;
    using System.Threading.Tasks;
    using Newtonsoft.Json.Linq;

    namespace simulated_device
    {
        class SimulatedDevice
        {
        // Global constants.
            const float ambientTemperature = 70;                    // Ambient temperature of a southern cave, in degrees F.
            const double ambientHumidity = 99;                      // Ambient humidity in relative percentage of air saturation.
            const double desiredTempLimit = 5;                      // Acceptable range above or below the desired temp, in degrees F.
            const double desiredHumidityLimit = 10;                 // Acceptable range above or below the desired humidity, in percentages.
            const int intervalInMilliseconds = 5000;                // Interval at which telemetry is sent to the cloud.

            // Global variables.
            private static DeviceClient s_deviceClient;
            private static stateEnum fanState = stateEnum.off;                      // Initial setting of the fan.
            private static double desiredTemperature = ambientTemperature - 10;     // Initial desired temperature, in degrees F.
            private static double desiredHumidity = ambientHumidity - 20;           // Initial desired humidity in relative percentage of air saturation.

            // Enum for the state of the fan for cooling/heating, and humidifying/de-humidifying.
            enum stateEnum
            {
                off,
                on,
                failed
            }

            // The device connection string to authenticate the device with your IoT hub.
            private readonly static string s_deviceConnectionString = "<your device connection string>";

            private static void colorMessage(string text, ConsoleColor clr)
            {
                Console.ForegroundColor = clr;
                Console.WriteLine(text);
                Console.ResetColor();
            }
            private static void greenMessage(string text)
            {
                colorMessage(text, ConsoleColor.Green);
            }

            private static void redMessage(string text)
            {
                colorMessage(text, ConsoleColor.Red);
            }

            // Async method to send simulated telemetry.
            private static async void SendDeviceToCloudMessagesAsync()
            {
                double currentTemperature = ambientTemperature;         // Initial setting of temperature.
                double currentHumidity = ambientHumidity;               // Initial setting of humidity.

                Random rand = new Random();

                while (true)
                {
                    // Simulate telemetry.
                    double deltaTemperature = Math.Sign(desiredTemperature - currentTemperature);
                    double deltaHumidity = Math.Sign(desiredHumidity - currentHumidity);

                    if (fanState == stateEnum.on)
                    {
                        // If the fan is on the temperature and humidity will be nudged towards the desired values most of the time.
                        currentTemperature += (deltaTemperature * rand.NextDouble()) + rand.NextDouble() - 0.5;
                        currentHumidity += (deltaHumidity * rand.NextDouble()) + rand.NextDouble() - 0.5;

                        // Randomly fail the fan.
                        if (rand.NextDouble() < 0.01)
                        {
                            fanState = stateEnum.failed;
                            redMessage("Fan has failed");
                        }
                    }
                    else
                    {
                        // If the fan is off, or has failed, the temperature and humidity will creep up until they reaches ambient values, thereafter fluctuate randomly.
                        if (currentTemperature < ambientTemperature - 1)
                        {
                            currentTemperature += rand.NextDouble() / 10;
                        }
                        else
                        {
                            currentTemperature += rand.NextDouble() - 0.5;
                        }
                        if (currentHumidity < ambientHumidity - 1)
                        {
                            currentHumidity += rand.NextDouble() / 10;
                        }
                        else
                        {
                            currentHumidity += rand.NextDouble() - 0.5;
                        }
                    }

                    // Check: humidity can never exceed 100%.
                    currentHumidity = Math.Min(100, currentHumidity);

                    // Create JSON message.
                    var telemetryDataPoint = new
                    {
                        temperature = Math.Round(currentTemperature, 2),
                        humidity = Math.Round(currentHumidity, 2)
                    };
                    var messageString = JsonConvert.SerializeObject(telemetryDataPoint);
                    var message = new Message(Encoding.ASCII.GetBytes(messageString));

                    // Add custom application properties to the message.
                    message.Properties.Add("sensorID", "S1");
                    message.Properties.Add("fanAlert", (fanState == stateEnum.failed) ? "true" : "false");

                    // Send temperature or humidity alerts, only if they occur.
                    if ((currentTemperature > desiredTemperature + desiredTempLimit) || (currentTemperature < desiredTemperature - desiredTempLimit))
                    {
                        message.Properties.Add("temperatureAlert", "true");
                    }
                    if ((currentHumidity > desiredHumidity + desiredHumidityLimit) || (currentHumidity < desiredHumidity - desiredHumidityLimit))
                    {
                        message.Properties.Add("humidityAlert", "true");
                    }

                    Console.WriteLine("Message data: {0}", messageString);

                    // Send the telemetry message.
                    await s_deviceClient.SendEventAsync(message);
                    greenMessage("Message sent\n");

                    await Task.Delay(intervalInMilliseconds);
                }
            }
            private static void Main(string[] args)
            {
                colorMessage("Cheese Cave device app.\n", ConsoleColor.Yellow);

                // Connect to the IoT hub using the MQTT protocol.
                s_deviceClient = DeviceClient.CreateFromConnectionString(s_deviceConnectionString, TransportType.Mqtt);

                SendDeviceToCloudMessagesAsync();
                Console.ReadLine();
            }
        }
    }
    ```

1. Take a few minutes to review the code.

    > **Important:** Read through the comments in the code, noting how the temperature and humidity settings for our cheese cave scenario have worked their way into the code.

1. Locate the code line used to assign the device connection string

    ```csharp
    private readonly static string s_deviceConnectionString = "<your device connection string>";
    ```

1. Replace `<your device connection string>` with the CheeseCaveID device connection string that you save earlier in this lab.

    You should have saved the output generated by the lab15-setup.azcli setup script during Exercise 1.

    No other lines of code need to be changed.

1. On the **File** menu, to save your changes to the Program.cs file, click **Save**.

#### Task 3: Test your Code to Send Telemetry

1. In Visual Studio Code, ensure that you have the Terminal open.

1. At the Terminal command prompt, to run the simulated device app, enter the following command:

    ```bash
    dotnet run
    ```

   This command will run the **Program.cs** file in the current folder.

1. Notice the output being sent to the Terminal.

    You should quickly see console output, similar to the following:

    ![Console Output](./Media/LAB_AK_15-cheesecave-telemetry.png)

    > **Note**:  Green text is used to show things are working as they should and red text when bad stuff is happening. If you don't get a screen similar to this image, start by checking your device connection string.

1. Leave this app running.

    You need to be sending telemetry to IoT Hub later in this lab.

### Exercise 3: Create a Second App to Receive Telemetry

Now that you have your (simulated) CheeseCaveID device sending telemetry to your IoT Hub, you need to create a back-end app that can connect to IoT Hub and "listen" for that telemetry. Eventually, this back-end app will be used to automate the control of the temperature in the cheese cave.

#### Task 1: Create an app to receive telemetry

1. Open a new instance of Visual Studio Code.

    Since your simulated device app is running in the Visual Studio Code windows that you already have open, you need a new instance of Visual Studio Code for the back-end app.

1. On the **Terminal** menu, click **New Terminal**.

1. At the Terminal command prompt, to create a directory named "cheesecaveoperator" and change the current directory to that directory, enter the following commands:

   ```bash
   mkdir cheesecaveoperator
   cd cheesecaveoperator
   ```

1. To create a new .NET console application, enter the following command:

    ```bash
    dotnet new console
    ```

    This command creates a **Program.cs** file in your folder, along with a project file.

1. To install the required libraries, enter the following commands:

    ```bash
    dotnet add package Microsoft.Azure.EventHubs
    dotnet add package Microsoft.Azure.Devices
    dotnet add package Newtonsoft.Json
    ```

1. On the **File** menu, click **Open Folder**

1. In the **Open Folder** dialog, navigate to the folder location specified in the Terminal pane, click **cheesecaveoperator**, and then click **Select Folder**

    The EXPLORER pane should open in Visual Studio Code and you should see the `Program.cs` and `cheesecaveoperator.csproj` files listed.

1. In the **EXPLORER** pane, click **Program.cs**.

1. In the Code Editor pane, delete the contents of the Program.cs file.

#### Task 2: Add Code to Receive Telemetry

In this task, you will add code to your back-end app that will be used to receive telemetry from the IoT Hub Event Hub endpoint.

1. Ensure that you have the **Program.cs** file open in Visual Studio Code.

    The Code Editor pane should display an empty code file.

1. Copy-and-Paste the following code into the Code Editor pane:

    ```csharp
    // Copyright (c) Microsoft. All rights reserved.
    // Licensed under the MIT license. See LICENSE file in the project root for full license information.

    using System;
    using System.Threading.Tasks;
    using System.Text;
    using System.Collections.Generic;
    using System.Linq;

    using Microsoft.Azure.EventHubs;
    using Microsoft.Azure.Devices;
    using Newtonsoft.Json;

    namespace cheesecave_operator
    {
        class ReadDeviceToCloudMessages
        {
            // Global variables.
            // The Event Hub-compatible endpoint.
            private readonly static string s_eventHubsCompatibleEndpoint = "<your event hub endpoint>";

            // The Event Hub-compatible name.
            private readonly static string s_eventHubsCompatiblePath = "<your event hub path>";
            private readonly static string s_iotHubSasKey = "<your event hub Sas key>";
            private readonly static string s_iotHubSasKeyName = "service";
            private static EventHubClient s_eventHubClient;

            // Connection string for your IoT Hub.
            private readonly static string s_serviceConnectionString = "<your service connection string>";

            // Asynchronously create a PartitionReceiver for a partition and then start reading any messages sent from the simulated client.
            private static async Task ReceiveMessagesFromDeviceAsync(string partition)
            {
                // Create the receiver using the default consumer group.
                var eventHubReceiver = s_eventHubClient.CreateReceiver("$Default", partition, EventPosition.FromEnqueuedTime(DateTime.Now));
                Console.WriteLine("Created receiver on partition: " + partition);

                while (true)
                {
                    // Check for EventData - this methods times out if there is nothing to retrieve.
                    var events = await eventHubReceiver.ReceiveAsync(100);

                    // If there is data in the batch, process it.
                    if (events == null) continue;

                    foreach (EventData eventData in events)
                    {
                        string data = Encoding.UTF8.GetString(eventData.Body.Array);

                        greenMessage("Telemetry received: " + data);

                        foreach (var prop in eventData.Properties)
                        {
                            if (prop.Value.ToString() == "true")
                            {
                                redMessage(prop.Key);
                            }
                        }
                        Console.WriteLine();
                    }
                }
            }

            public static void Main(string[] args)
            {
                colorMessage("Cheese Cave Operator\n", ConsoleColor.Yellow);

                // Create an EventHubClient instance to connect to the IoT Hub Event Hubs-compatible endpoint.
                var connectionString = new EventHubsConnectionStringBuilder(new Uri(s_eventHubsCompatibleEndpoint), s_eventHubsCompatiblePath, s_iotHubSasKeyName, s_iotHubSasKey);
                s_eventHubClient = EventHubClient.CreateFromConnectionString(connectionString.ToString());

                // Create a PartitionReceiver for each partition on the hub.
                var runtimeInfo = s_eventHubClient.GetRuntimeInformationAsync().GetAwaiter().GetResult();
                var d2cPartitions = runtimeInfo.PartitionIds;

                // Create receivers to listen for messages.
                var tasks = new List<Task>();
                foreach (string partition in d2cPartitions)
                {
                    tasks.Add(ReceiveMessagesFromDeviceAsync(partition));
                }

                // Wait for all the PartitionReceivers to finish.
                Task.WaitAll(tasks.ToArray());
            }

            private static void colorMessage(string text, ConsoleColor clr)
            {
                Console.ForegroundColor = clr;
                Console.WriteLine(text);
                Console.ResetColor();
            }
            private static void greenMessage(string text)
            {
                colorMessage(text, ConsoleColor.Green);
            }

            private static void redMessage(string text)
            {
                colorMessage(text, ConsoleColor.Red);
            }
        }
    }
    ```

1. Take a few minutes to review the code.

    > **Important:** Read through the comments in the code. Our implementation only reads messages after the back-end app has been started. Any telemetry sent prior to this isn't handled.

1. Locate the code line used to assign the service connection string

    ```csharp
    private readonly static string s_serviceConnectionString = "<your service connection string>";
    ```

1. Replace `<your service connection string>` with the IoT Hub **iothubowner** shared access policy primary connection string that you save earlier in this lab.

    You should have saved the output generated by the lab15-setup.azcli setup script during Exercise 1.

    > **Note**: You may be curious as to why the **iothubowner** shared policy is used rather than the **service** shared policy. The answer is related to the IoT Hub permissions assigned to each policy. The **service** policy has the **ServiceConnect** permission and is usually used by back-end cloud services. It confers the following rights:
    >
    > * Grants access to cloud service-facing communication and monitoring endpoints.
    > * Grants permission to receive device-to-cloud messages, send cloud-to-device messages, and retrieve the corresponding delivery acknowledgments.
    > * Grants permission to retrieve delivery acknowledgments for file uploads.
    > * Grants permission to access twins to update tags and desired properties, retrieve reported properties, and run queries.
    >
    > For the first part of the lab, where the **serviceoperator** application calls a direct method to toggle the fan state, the **service** policy has sufficient rights. However, during the latter part of the lab, the device registry is queried. This is achieved via the `RegistryManager` class. In order to use the `RegistryManager` class to query the device registry, the shared access policy used to connect to the IoT Hub must have the **Registry read** permission, which confers the following right:
    >
    > * Grants read access to the identity registry.
    >
    > As the **iothubowner** policy has been granted the **Registry write** permission, it inherits the **Registry read** permission, so it is suitable for our needs.
    >
    > In a production scenario, you might consider adding a new shared access policy that has just the **Service connect** and **Registry read** permissions.

1. Replace the `<your event hub endpoint>`, `<your event hub path>`, and the `<your event hub Sas key>` with the values that you save earlier in this lab.

1. On the **File** menu, to save your changes to the Program.cs file, click **Save**.

#### Task 3: Test your Code to Receive Telemetry

This test is important, checking whether your back-end app is picking up the telemetry being sent out by your simulated device. Remember your device app is still running, and sending telemetry.

1. To run the `cheesecaveoperator` back-end app in the terminal, open a Terminal pane, and then enter the following command:

    ```bash
    dotnet run
    ```

   This command will run the **Program.cs** file in the current folder.

   > **Note**:  You can ignore the warning about the unused variable `s_serviceConnectionString` - we will be using that variable shortly.

1. Take a minute to observe the output to the Terminal.

    You should quickly see console output, and the app will display telemetry message data almost immediately if it connects to IoT Hub successfully.

    If not, carefully check your IoT Hub service connection string, noting that this string should be the service connection string, and not any other.:

    ![Console Output](./Media/LAB_AK_15-cheesecave-telemetry-received.png)

    > **Note**:  Green text is used to show things are working as they should and red text when bad stuff is happening. If you don't get a screen similar to this image, start by checking your device connection string.

1. Leave this app running for a monent longer.

1. With both apps running, visually compare the telemetry that is being sent with the telemetry that is being received.

    * Is there an exact data match?
    * Is there much of a delay between when data is sent and when it is received?

    Once you are satisfied, stop the running apps and then close the Terminal pane in both instances of VS Code. No not close the Visual Studio Code windows.

    You now have an app sending telemetry from a device, and a back-end app acknowledging receipt of the data. This unit covers the monitoring side of our scenario. The next step handles the control side - what to do when issues arise with the data. Clearly, there are issues, we're getting temperature and humidity alerts!

### Exercise 4: Write Code to Invoke a Direct Method

In this Exercise, you will update your device app by adding the code for a direct method that will simulate turning on the fan in the cheese cave. Next, you will add code to the back-end service app to invoke this direct method.

Calls from the back-end app to invoke direct methods can include multiple parameters as part of the payload. Direct methods are typically used to turn features of the device off and on, or specify settings for the device.

#### Handle Error Conditions

There are several error conditions that need to be checked for when a device receives instructions to run a direct method. One of these checks is simply to respond with an error if the fan is in a failed state. Another error condition to report is when an invalid parameter is received. Clear error reporting is important, given the potential remoteness of the device.

#### Invoke a Direct Method

Direct methods require that the back-end app prepares the parameters, then makes a call specifying a single device to invoke the method. The back-end app will then wait for, and report, a response.

The device app contains the functional code for the direct method. The function name is registered with the IoT client for the device. This process ensures the client knows what function to run when the call comes from the IoT Hub (there could be many direct methods).

#### Task 1: Add Code to Define a Direct Method in the Device App

1. Return to the Visual Studio Code instance that is running the **cheesecavedevice** app.

    > **Note**: If the app is still running, place input focus in the Terminal pane and press **CTRL+C** to exit the app.

1. Ensure that **Program.cs** is open in the code editor.

1. In the Code Editor pane, locate the bottom of the **SimulatedDevice** class.

1. To define the direct method, add the following code inside the closing squiggly brace (`}`) of the **SimulatedDevice** class:

    ```csharp
    // Handle the direct method call
    private static Task<MethodResponse> SetFanState(MethodRequest methodRequest, object userContext)
    {
        if (fanState == stateEnum.failed)
        {
            // Acknowledge the direct method call with a 400 error message.
            string result = "{\"result\":\"Fan failed\"}";
            redMessage("Direct method failed: " + result);
            return Task.FromResult(new MethodResponse(Encoding.UTF8.GetBytes(result), 400));
        }
        else
        {
            try
            {
                var data = Encoding.UTF8.GetString(methodRequest.Data);

                // Remove quotes from data.
                data = data.Replace("\"", "");

                // Parse the payload, and trigger an exception if it's not valid.
                fanState = (stateEnum)Enum.Parse(typeof(stateEnum), data);
                greenMessage("Fan set to: " + data);

                // Acknowledge the direct method call with a 200 success message.
                string result = "{\"result\":\"Executed direct method: " + methodRequest.Name + "\"}";
                return Task.FromResult(new MethodResponse(Encoding.UTF8.GetBytes(result), 200));
            }
            catch
            {
                // Acknowledge the direct method call with a 400 error message.
                string result = "{\"result\":\"Invalid parameter\"}";
                redMessage("Direct method failed: " + result);
                return Task.FromResult(new MethodResponse(Encoding.UTF8.GetBytes(result), 400));
            }
        }
    }
    ```

    > **Note**:  This code defines the implementation of the direct method and is executed when the direct method is invoked. The fan has three states: *on*, *off*, and *failed*. The method above sets the fan to either *on* or *off*. If the payload text doesn't match one of these two settings, or the fan is in a failed state, an error is returned.

1. In the Code Editor pane, scroll up slightly to locate the **Main** method.

1. Within the **Main** method, position the cursor on the blank code line just after creating the device client.

1. To register the direct method, add the following code:

    ```csharp
    // Create a handler for the direct method call
    s_deviceClient.SetMethodHandlerAsync("SetFanState", SetFanState, null).Wait();
    ```

    After adding the code, the **Main** method should look like the following:

    ```csharp
    private static void Main(string[] args)
    {
        colorMessage("Cheese Cave device app.\n", ConsoleColor.Yellow);

        // Connect to the IoT hub using the MQTT protocol.
        s_deviceClient = DeviceClient.CreateFromConnectionString(s_deviceConnectionString, TransportType.Mqtt);

        // Create a handler for the direct method call
        s_deviceClient.SetMethodHandlerAsync("SetFanState", SetFanState, null).Wait();

        SendDeviceToCloudMessagesAsync();
        Console.ReadLine();
    }
    ```

1. On the **File** menu, to save the Program.cs file, click **Save**.

You have now completed the coding that is required on the device side. Next, you need to add code to the back-end service that will invoke the direct method.

#### Task 2: Add Code to Call Your Direct Method

1. Return to the Visual Studio Code instance that is running the **cheesecaveoperator** app.

    > **Note**: If the app is still running, place input focus in the Terminal pane and press **CTRL+C** to exit the app.

1. Ensure that **Program.cs** is open in the code editor.

1. At the top of the **ReadDeviceToCloudMessages** class, add the following coe to the list of global variables:

    ```csharp
    private static ServiceClient s_serviceClient;
    ```

1. Scroll down to locate the **Main** method.

1. On the blank code line below the **Main** method, add the following task:

    ```csharp
    // Handle invoking a direct method.
    private static async Task InvokeMethod()
    {
        try
        {
            var methodInvocation = new CloudToDeviceMethod("SetFanState") { ResponseTimeout = TimeSpan.FromSeconds(30) };
            string payload = JsonConvert.SerializeObject("on");

            methodInvocation.SetPayloadJson(payload);

            // Invoke the direct method asynchronously and get the response from the simulated device.
            var response = await s_serviceClient.InvokeDeviceMethodAsync("CheeseCaveID", methodInvocation);

            if (response.Status == 200)
            {
                greenMessage("Direct method invoked: " + response.GetPayloadAsJson());
            }
            else
            {
                redMessage("Direct method failed: " + response.GetPayloadAsJson());
            }
        }
        catch
        {
            redMessage("Direct method failed: timed-out");
        }
    }
    ```

    > **Note**: This code is used to invoke the **SetFanState** direct method on the device app.

1. Within the **Main** method, position the cursor on the blank code line just above the `Create receivers to listen for messages` comment.

1. Before the code for creating the receivers to listen for messages, add the following code:

    ```csharp
    // Create a ServiceClient to communicate with service-facing endpoint on your hub.
    s_serviceClient = ServiceClient.CreateFromConnectionString(s_serviceConnectionString);
    InvokeMethod().GetAwaiter().GetResult();
    ```

    > **Note**: This code creates the ServiceClient object that we use to connect to the IoT Hub. The connection to IoT Hub enables us to invoke the direct method on the device.

1. On the **File** menu, to save the Program.cs file, click **Save**.

You have now completed the code changes to support the **SetFanState** direct method.

#### Task 3: Test the direct method

To test the direct method, you will need to start the apps in the correct order. You can't invoke a direct method that hasn't been registered!

1. Start the **cheesecavedevice** device app.

    It will begin writing to the terminal, and telemetry will appear.

1. Start the **cheesecaveoperator** back-end app.

    > **Note**:  If you see the message `Direct method failed: timed-out` then double check you have saved the changes in the **cheesecavedevice** and started the app.

    The cheesecaveoperator back-end app will immediately call the direct method.

    Notice the output similar to the following:

    ![Console Output](./Media/LAB_AK_15-cheesecave-direct-method-sent.png)

1. Now check the console output for the **cheesecavedevice** device app, you should see that the fan has been turned on.

   ![Console Output](./Media/LAB_AK_15-cheesecave-direct-method-received.png)

You are now successfully monitoring and controlling a remote device. You have implemented a direct method on the device that can be invoked from the cloud. In our scenario, the direct method is used to turn on a fan, which will bring the environment in the cave to our desired settings.

What if you might want to remotely specify the desired settings for the cheese cave environment? Perhaps you want to set a particular target temperature for the cheese cave at a certain point in the aging process. You could specify desired settings with a direct method (which is a valid approach), or you could use another feature of IoT Hub, called device twins. In the next Exercise, you will work on implementing device twin properties within your solution.

### Exercise 5: Write Code for Device Twins

In this exercise, we'll add some code to both the device app and back-end service app, to show device twin synchronization in operation.

As a reminder, a device twin contains four types of information:

* **Tags**: information on the device that isn't visible to the device.
* **Desired properties**: the desired settings specified by the back-end app.
* **Reported properties**: the reported values of the settings on the device.
* **Device identity properties**: read-only information identifying the device.

Device twins, which are managed through IoT Hub, are designed for querying, and they are synchronized with the real IoT device. The device twin can be queried, at any time, by the back-end app. This query can return the current state information for the device. Getting this data doesn't involve a call to the device, as the device and twin will have synchronized. Much of the functionality of device twins is provided by Azure IoT Hub, so not much code needs to be written to make use of them.

There is some overlap between the functionality of device twins and direct methods. We could set device properties using direct methods, which might seem an intuitive way of doing things. However, using direct methods would require the back-end app to record those settings explicitly, if they ever needed to be accessed. Using device twins, this information is stored and maintained by default.

#### Task 1: Add Code To Use Device Twins To Synchronize Device Properties

1. Return to the Visual Studio Code instance that is running the **cheesecaveoperator** back-end app.

1. If the app is still running, place input focus on the terminal and press **CTRL+C** to exit the app.

1. Ensure that the **Program.cs** is open.

1. In the Code Editor pane, locate the bottom of the **ReadDeviceToCloudMessages** class.

1. Just above the closing squiggly brace for the **ReadDeviceToCloudMessages** class, add the following code:

    ```csharp
    // Device twins section.
    private static RegistryManager registryManager;

    private static async Task SetTwinProperties()
    {
        var twin = await registryManager.GetTwinAsync("CheeseCaveID");
        var patch =
            @"{
                tags: {
                    customerID: 'Customer1',
                    cellar: 'Cellar1'
                },
                properties: {
                    desired: {
                        patchId: 'set values',
                        temperature: '50',
                        humidity: '85'
                    }
                }
        }";
        await registryManager.UpdateTwinAsync(twin.DeviceId, patch, twin.ETag);

        var query = registryManager.CreateQuery(
          "SELECT * FROM devices WHERE tags.cellar = 'Cellar1'", 100);
        var twinsInCellar1 = await query.GetNextAsTwinAsync();
        Console.WriteLine("Devices in Cellar1: {0}",
          string.Join(", ", twinsInCellar1.Select(t => t.DeviceId)));

    }
    ```

    > **Note**:  The **SetTwinProperties** method creates a piece of JSON that defines tags and properties that will be added to the device twin, and then updates the twin. The next part of the method demonstrates how a query can be performed to list the devices where the **cellar** tag is set to "Cellar1". This query requires that the connection has the **Registry read** permission.

1. In the Code Editor pane, scroll up to find the **Main** method.

1. In the **Main** method, locate the code lines creating a service client.

1. Before the code creating the service client, add the following code:

    ```csharp
    // A registry manager is used to access the digital twins.
    registryManager = RegistryManager.CreateFromConnectionString(s_serviceConnectionString);
    SetTwinProperties().Wait();
    ```

    > **Note**: Read the comments that are included in the Main method.

1. On the **File** menu, to save the Program.cs file, click **Save**.

#### Task 2: Add Code to Synchronize Device Twin Settings for the Device

1. Return to the Visual Studio Code instance that is running the **cheesecavedevice** app.

1. If the app is still running, place input focus on the terminal and press **CTRL+C** to exit the app.

1. Ensure that the **Program.cs** file is open in the Code Editor pane.

1. In the Code Editor pane, scroll down to locate the end of the **SimulatedDevice** class.

1. Inside the closing squiggly brace of the **SimulatedDevice** class, add the following code:

    ```csharp
    private static async Task OnDesiredPropertyChanged(TwinCollection desiredProperties, object userContext)
    {
        try
        {
            desiredHumidity = desiredProperties["humidity"];
            desiredTemperature = desiredProperties["temperature"];
            greenMessage("Setting desired humidity to " + desiredProperties["humidity"]);
            greenMessage("Setting desired temperature to " + desiredProperties["temperature"]);

            // Report the properties back to the IoT Hub.
            var reportedProperties = new TwinCollection();
            reportedProperties["fanstate"] = fanState.ToString();
            reportedProperties["humidity"] = desiredHumidity;
            reportedProperties["temperature"] = desiredTemperature;
            await s_deviceClient.UpdateReportedPropertiesAsync(reportedProperties);

            greenMessage("\nTwin state reported: " + reportedProperties.ToJson());
        }
        catch
        {
            redMessage("Failed to update device twin");
        }
    }
    ```

    > **Note**: This code defines the handler that is invoked when a desired property changes in the device twin. Notice that new values are then reported back to the IoT Hub to confirm the change.

1. In the Code Editor pane, scroll up to the **Main** method.

1. Within the **Main** method, locate the code that creates a handler for the direct method.

1. Position the cursor on the blank line below the handler for the direct method.

1. To register the desired property changed handler, add the following code:

    ```csharp
    // Get the device twin to report the initial desired properties.
    Twin deviceTwin = s_deviceClient.GetTwinAsync().GetAwaiter().GetResult();
    greenMessage("Initial twin desired properties: " + deviceTwin.Properties.Desired.ToJson());

    // Set the device twin update callback.
    s_deviceClient.SetDesiredPropertyUpdateCallbackAsync(OnDesiredPropertyChanged, null).Wait();
    ```

1. On the **File** menu, to save the Program.cs file, click **Save**.

    > **Note**:  Now you have added support for device twins to your app, you can reconsider having explicit variables such as **desiredHumidity**. You could use the variables in the device twin object instead.

#### Task 3: Test the Device Twins

To test the method, start the apps in the correct order.

1. Start the **cheesecavedevice** device app. It will begin writing to the terminal, and telemetry will appear.

1. Start the **cheesecaveoperator** back-end app.

1. Check the console output for the **cheesecavedevice** device app and confirm that the device twin synchronized correctly.

    ![Console Output](./media/LAB_AK_15-cheesecave-device-twin-received.png)

    If we let the fan do its work, we should eventually get rid of those red alerts!

    ![Console Output](./media/LAB_AK_15-cheesecave-device-twin-success.png)

1. For both instances of Visual Studio Code, stop the app and then close the Visual Studio Code window.

The code provided in this module isn't industrial quality. It does show how to use direct methods and device twins. However, the messages are sent only when the back-end service app is first run. Typically, a back-end service app would require a browser interface, for an operator to send direct methods, or set device twin properties, when required.
