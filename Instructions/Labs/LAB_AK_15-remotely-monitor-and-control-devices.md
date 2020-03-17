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

Contoso is lucky enough to operate cheese caves (in certain geographic regions) that naturally maintain ideal conditions almost year-round. However, even in these locations, managing the environment during the aging process is critical. Also, natural caves often have a number of different chambers, each of which can have a slightly different environment. Cheese varities are placed in a chamber (zone) that matches their specific requirements. To keep environmental conditions within desired limits, Contoso uses an air processing/conditioning system that controls both temperature and humidity. 

Currently, an operator monitors the environmental conditions within each zone of a cave facility and adjusts the air processing system settings when required to maintain the desired temperature and humidity. Operators are able to visit each zone and check the environmental conditions every 4 hours. In locations where temperature changes dramatically between the daytime high and nighttime low, conditions can slip outside of the desired limits.

Contoso has tasked you with implementing an automated system that keeps the cave environment within control limits.

In this lab, you will be prototyping a cheese cave monitoring system that implements IoT devices. Each device is equiped with temperature and humidity sensors, and is connected to the air processing system that controls temperature and humidity for the zone where the device is located. 

### Simplified Lab Conditions

The frequency of telemetry output is an important consideration in production solutions. A temperature sensor in a refrigeration unit may only need to report once a minute, whereas an acceleration sensor on an aircraft may have to report ten times per second. In some cases, the frequency at which telemetry must be sent is dependent on current conditions. For example, if the temperature our cheese cave scenario tends to drop quickly at night, you may benefit from having more frequent sensor readings beginning two hours before sunset. Of course the requirement to change the frequency of telemetry does not need to be part of a predicatable pattern, the events that drive our need to change IoT device settings can be unpredictable.      

To keep things simple in this lab, we will make the following assumptions:

* The device will send telemetry (temperature and humidity values) to the IoT Hub every few seconds. Although this frequency is unrealistic for a cheese cave, it is great for a lab environment when we need to see changes frequently, not every 15 minutes.
* The air processing system is a fan that can be in one of three states: On, Off, or Failed. 
    * The fan is initialized to the Off state.
    * Electrical power to the fan is controlled (On/Off) using a direct method on the IoT device.
    * Device Twin desired property values are used to set the desired state of the fan. The desired property values will override any default settings for the fan/device.
    * Temperature can be controlled by turning the fan On/Off (turning the fan On will lower the temperature)

Coding in this lab is broken down into three parts: sending and receiving telemetry, invoking and running a direct method, setting and reading device twin properties.

You will start by writing two apps: one for a device to send telemetry, and one for a back-end service (that will run in the cloud) to receive the telemetry.

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
| IoT Hub | AZ-220-HUB-_{YOUR-ID}_ |
| IoT Device | CheeseCaveID |

If these resources are not available, you will need to run the **lab15-setup.azcli** script as instructed below before moving on to Exercise 2. The script file is included in the GitHub repository that you cloned locally as part of the dev environment configuration (lab 3).

The **lab15-setup.azcli** script is written to run in a **bash** shell environment - the easiest way to execute this is in the Azure Cloud Shell.

>**Note:** You will need the connection string for the **CheeseCaveID** device. If you already have this device registered with Azure IoT Hub, you can obtain the connection string by running the following command in the Azure Cloud Shell"
>
> ```bash
> az iot hub device-identity show-connection-string --hub-name AZ-220-HUB-_{YOUR-ID}_ --device-id CheeseCaveID -o tsv
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

1. On the Cloud Shell toolbar, to edit the lab15-setup.azcli file, click **Open Editor** (second button from the right - **{ }**).

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

1. To save the changes made to the file and close the editor, click **...** in the top-right of the editor window and select **Close Editor**.

    If prompted to save, click **Save** and the editor will close.

    > **Note**:  You can use **CTRL+S** to save at any time and **CTRL+Q** to close the editor.

1. To create a resource group named **AZ-220-RG**, create an IoT Hub named **AZ-220-HUB-{YourID}**, add a device with an ID of **CheeseCaveID**, and display the device connection string, enter the following command:

    ```bash
    ./lab-setup.azcli
    ```

    This will take a few minutes to run. You will see JSON output as each step completes.

1. Once complete, the script will be display data similar to:

    ```text
    Configuration Data:
    ------------------------------------------------
    AZ-220-HUB-DM121119 Service connectionstring:
    HostName=AZ-220-HUB-DM121119.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=nV9WdF3Xk0jYY2Da/pz2i63/3lSeu9tkW831J4aKV2o=

    CheeseCaveID device connection string:
    HostName=AZ-220-HUB-DM121119.azure-devices.net;DeviceId=CheeseCaveID;SharedAccessKey=TzAzgTYbEkLW4nWo51jtgvlKK7CUaAV+YBrc0qj9rD8=

    AZ-220-HUB-DM121119 eventhub endpoint:
    sb://iothub-ns-az-220-hub-2610348-5a463f1b56.servicebus.windows.net/

    AZ-220-HUB-DM121119 eventhub path:
    az-220-hub-dm121119

    AZ-220-HUB-DM121119 eventhub SaS primarykey:
    tGEwDqI+kWoZroH6lKuIFOI7XqyetQHf7xmoSf1t+zQ=
    ```

    Copy these values to a local text file - you will need them for the coding portion of this lab.

You've now completed the preparatory work for this module, the next steps are all coding and testing. Before we advance though, a quick knowledge check!

### Exercise 2: Write Code to Send and Receive Telemetry

At the end of this unit, you'll be sending and receiving telemetry.

#### Task 1: Create an app to send telemetry

1. To use C# in Visual Studio Code, ensure both [.NET Core](https://dotnet.microsoft.com/download), and the [C# extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp) are installed.

1. To open a terminal in Visual Studio Code, open the **Terminal** menu and click **New Terminal**.

1. In the terminal, to create a directory called "cheesecavedevice" and change the current directory to that directory, enter the following commands:

   ```bash
   mkdir cheesecavedevice
   cd cheesecavedevice
   ```

1. To create a new .NET console application. enter the following command in the terminal:

    ```bash
    dotnet new console
    ```

    This command creates a **Program.cs** file in your folder, along with a project file.

1. In the terminal, to install the required libraries. Enter the following commands:

    ```bash
    dotnet add package Microsoft.Azure.Devices.Client
    dotnet add package Microsoft.Azure.Devices.Shared
    dotnet add package Newtonsoft.Json
    ```

1. From the **File** menu, open up the **Program.cs** file, and delete the default contents.

    > **Note**:  If you are unsure where the **Program.cs** file is located, enter the command `pwd` in the console to see the current directory.

1. After you've entered the code below into the **Program.cs** file, you can run the app with the command `dotnet run`. This command will run the **Program.cs** file in the current folder.

#### Task 2: Add Code to Send Telemetry

This section adds code to send telemetry from a simulated device. The device sends temperature (in degrees fahrenheit) and humidity (in percentages), regardless of whether any back-end app is listening or not.

1. If it isn't already open in Visual Studio Code, open the **Program.cs** file for the device app.

1. Copy and paste the following code:

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

    > **Important:** Read through the comments in the code, noting how the temperature and humidity settings from the description of the scenario in the introduction have worked their way into the code.

1. Replace the `<your device connection string>` with the device connection string you saved off in the previous unit. No other lines of code need to be changed.

1. Save the **Program.cs** file.

#### Task 3: Test your Code to Send Telemetry

1. To run the app in the terminal, enter the following command:

    ```bash
    dotnet run
    ```

   This command will run the **Program.cs** file in the current folder.

1. You should quickly see console output, similar to the following:

    ![Console Output](./Media/LAB_AK_15-cheesecave-telemetry.png)

    > **Note**:  Green text is used to show things are working as they should and red text when bad stuff is happening. If you don't get a screen similar to this image, start by checking your device connection string.

1. Watch the telemetry for a short while, checking that it is giving vibrations in the expected ranges.

1. You can leave this app running, as it's needed for the next section.

### Exercise 3: Create a Second App to Receive Telemetry

Now we have a device pumping out telemetry, we need to listen for that telemetry with a back-end app, also connected to our IoT Hub.

#### Task 1: Create an app to receive telemetry

1. As the device app is running in a copy of Visual Studio Code, you will need to open a new instance of Visual Studio Code.

1. To open a terminal in Visual Studio Code, open the **Terminal** menu and click **New Terminal**.

1. In the terminal, to create a directory called "cheesecaveoperator" and change the current directory to that directory, enter the following commands:

   ```bash
   mkdir cheesecaveoperator
   cd cheesecaveoperator
   ```

1. To create a new .NET console application. enter the following command in the terminal:

    ```bash
    dotnet new console
    ```

    This command creates a **Program.cs** file in your folder, along with a project file.

1. In the terminal, to install the required libraries. Enter the following commands:

    ```bash
    dotnet add package Microsoft.Azure.EventHubs
    dotnet add package Microsoft.Azure.Devices
    dotnet add package Newtonsoft.Json
    ```

1. From the **File** menu, open up the **Program.cs** file, and delete the default contents.

    > **Note**:  If you are unsure where the **Program.cs** file is located, enter the command `pwd` in the console to see the current directory.

1. After you've entered the code below into the **Program.cs** file, you can run the app with the command `dotnet run`. This command will run the **Program.cs** file in the current folder.

#### Task 2: Add Code to Receive Telemetry

This section adds code to receive telemetry from the IoT Hub Event Hub endpoint.

1. If it isn't already open in Visual Studio Code, open the **Program.cs** file for the device app.

1. Copy and paste the following code:

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

    > **Important:** Read through the comments in the code. Our implementation only reads messages after the back-end app has been started. Any telemetry sent prior to this isn't handled.

1. Replace the `<your service connection string>` with the IoT Hub **iothubowner** shared access policy primary connection string - this value was displayed by the setup script executed in the first unit of this lab.

    > **Note:** You may be curious as to why the **iothubowner** shared policy is used rather than the **service** shared policy. The answer is related to the IoT Hub permissions assigned to each policy. The **service** policy has the **ServiceConnect** permission and is usually used by back-end cloud sercives. It confers the following rights:
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
    > As the **iothubowner** policy has been granted the **Registry write** permission, it inherits the **Registry read** permission, so is suitable for our needs.
    >
    > In a production scenario, you might consider adding a new shared access policy that has just the **Service connect** and **Registry read** permissions.

1. Replace the `<your event hub endpoint>`, `<your event hub path>`, and the `<your event hub Sas key>` with the strings you saved off to your text file.

1. Save the **Program.cs** file.

#### Task 3: Test your Code to Receive Telemetry

This test is important, checking whether your back-end app is picking up the telemetry being sent out by your simulated device. Remember your device app is still running, and sending telemetry.

1. To run the app in the terminal, enter the following command:

    ```bash
    dotnet run
    ```

   This command will run the **Program.cs** file in the current folder.

   > **Note**:  You can ignore the warning about the unused variable `s_serviceConnectionString` - we will be using that variable shortly.

1. You should quickly see console output, and immediately respond if it successfully connects to IoT Hub. If not, carefully check your IoT Hub service connection string, noting that this string should be the service connection string, and not any other.:

    ![Console Output](./Media/LAB_AK_15-cheesecave-telemetry-received.png)

    > **Note**:  Green text is used to show things are working as they should and red text when bad stuff is happening. If you don't get a screen similar to this image, start by checking your device connection string.

1. Watch the telemetry for a short while, checking that it is giving vibrations in the expected ranges.

1. You can leave this app running, as it's needed for the next section.

1. Visually compare the telemetry sent and received. Is there an exact match? Is there much of a delay? If it looks good, close both the console windows for now.

Completing this unit is great progress. you've an app sending telemetry from a device, and a back-end app acknowledging receipt of the data. This unit covers the monitoring side of our scenario. The next step handles the control side - what to do when issues arise with the data. Clearly, there are issues, we're getting temperature and humidity alerts!

### Exercise 4: Write Code to Invoke a Direct Method

In this unit, we'll add code to the device app for a direct method to turn on the fan. Next, we add code to the back-end service app to invoke this direct method.

Calls from the back-end app to invoke direct methods can include multiple parameters as part of the payload. Direct methods are typically used to turn features of the device off and on, or specify settings for the device.

#### Handle Error Conditions

There are several error conditions that need to be checked for when a device receives instructions to run a direct method. One of these checks is simply to respond with an error if the fan is in a failed state. Another error condition to report is when an invalid parameter is received. Clear error reporting is important, given the potential remoteness of the device.

#### Invoke a Direct Method

Direct methods require that the back-end app prepares the parameters, then makes a call specifying a single device to invoke the method. The back-end app will then wait for, and report, a response.

The device app contains the functional code for the direct method. The function name is registered with the IoT client for the device. This process ensures the client knows what function to run when the call comes from the IoT Hub (there could be many direct methods).

#### Task 1: Add Code to Define a Direct Method in the Device App

1. Return to the Visual Studio Code instance that is running the **cheesecavedevice** app.

1. If the app is still running, place input focus on the terminal and press **CTRL+C** to exit the app.

1. In the editor, ensure **Program.cs** is open.

1. To define the direct method, add the following code at the end of the **SimulatedDevice** class:

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

    > **Note**:  This code defines the implementation of the direct method and is executed when the direct method is invoked. The fan has three states: *on*, *off*, and *failed*. The method above sets the fan to either of the first two of these states. If the payload text doesn't match one of these two, or the fan is in a failed state, an error is returned.

1. To register the direct method, add the following lines of code to the Main method, after creating the device client.

    ```csharp
    // Create a handler for the direct method call
    s_deviceClient.SetMethodHandlerAsync("SetFanState", SetFanState, null).Wait();
    ```

    The modified **Main** method should look like:

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

1. Save the **Program.cs** file.

You've completed what is needed at the device end of things. Next, we need to add code to the back-end service.

#### Task 2: Add Code to Call a Direct Method in the Back End App

1. Return to the Visual Studio Code instance that is running the **cheesecaveoperator** app.

1. If the app is still running, place input focus on the terminal and press **CTRL+C** to exit the app.

1. In the editor, ensure **Program.cs** is open.

1. Add the following line to the global variables at the top of the **ReadDeviceToCloudMessages** class:

    ```csharp
    private static ServiceClient s_serviceClient;
    ```

1. Add the following task to the **ReadDeviceToCloudMessages** class, after the **Main** method:

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

    > **Note**:  This code is used to invoke the **SetFanState** direct method on the device app.

1. Add the following code to the **Main** method, before creating the receivers to listen for messages:

    ```csharp
    // Create a ServiceClient to communicate with service-facing endpoint on your hub.
    s_serviceClient = ServiceClient.CreateFromConnectionString(s_serviceConnectionString);
    InvokeMethod().GetAwaiter().GetResult();
    ```

    > **Note**:  This code creates the client we used to connect to the IoT Hub so we can invoke the direct method on the device.

1. Save the **Program.cs** file.

You have now completed the code changes to support the **SetFanState** direct method.

#### Task 3: Test the direct method

To test the method, start the apps in the correct order. We can't invoke a direct method that hasn't been registered!

1. Start the **cheesecavedevice** device app. It will begin writing to the terminal, and telemetry will appear.

1. Start the **cheesecaveoperator** back-end app. This app immediately calls the direct method. Do you notice it's handled by the back-end app, with output similar to the following?

    > **Note**:  If you see the message `Direct method failed: timed-out` then double check you have saved the changes in the **cheesecavedevice** and started the app.

    ![Console Output](./Media/LAB_AK_15-cheesecave-direct-method-sent.png)

1. Now check the console output for the **cheesecavedevice** device app, you should see that the fan has been turned on.

   ![Console Output](./Media/LAB_AK_15-cheesecave-direct-method-received.png)

You are now successfully monitoring and controlling a remote device. We have turned on the fan, which will slowly move the environment in the cave to our initial desired settings. However, we might like to remotely specify those desired settings. We could specify desired settings with a direct method (which is a valid approach). Or we could use another feature of IoT Hub, called device twins. Let's look into the technology of device twins.

### Exercise 5: Write Code for Device Twins

In this exercise, we'll add some code to both the device app and back-end service app, to show device twin synchronization in operation.

As a reminder, a device twin contains four types of information:

* **Tags**: information on the device that isn't visible to the device.
* **Desired properties**: the desired settings specified by the back-end app.
* **Reported properties**: the reported values of the settings on the device.
* **Device identity properties**: read-only information identifying the device.

Device twins are designed for querying, and automatically synchronizing, with the real IoT Hub device. The device twin can be queried, at any time, by the back-end app. This query can return the current state information for the device. Getting this data doesn't involve a call to the device, as the device and twin will have synchronized automatically. Much of the functionality of device twins is provided by Azure IoT, so not much code needs to be written to make use of them.

There is some overlap between the functionality of device twins and direct methods. We could set desired properties using direct methods, which might seem an intuitive way of doing things. However, using direct methods would require the back-end app to record those settings explicitly, if they ever needed to be accessed. Using device twins, this information is stored and maintained by default.

#### Task 1: Add Code To Use Device Twins To Synchronize Device Properties

1. Return to the Visual Studio Code instance that is running the **cheesecaveoperator** app.

1. If the app is still running, place input focus on the terminal and press **CTRL+C** to exit the app.

1. In the editor, ensure **Program.cs** is open.

1. Add the following code to the end of the **ReadDeviceToCloudMessages** class:

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

    > **Note**:  The **SetTwinProperties** method creates a piece of JSON that defines tags and properties that will be added to the device twin, and then updates thew twin. The next part of the method demonstrates how a query can be performed to list the devices where the **cellar** tag is set to "Cellar1". This query requires that the connection has the **Registry read** permission.

1. Now, add the following lines to the **Main** method, before the lines creating a service client.

    ```csharp
    // A registry manager is used to access the digital twins.
    registryManager = RegistryManager.CreateFromConnectionString(s_serviceConnectionString);
    SetTwinProperties().Wait();
    ```

    > **Note**:  Read the comments in this section of code.

1. Save the **Program.cs** file.

#### Task 2: Add Code to Synchronize Device Twin Settings for the Device

1. Return to the Visual Studio Code instance that is running the **cheesecavedevice** app.

1. If the app is still running, place input focus on the terminal and press **CTRL+C** to exit the app.

1. In the editor, ensure **Program.cs** is open.

1. Add the following code at the end of the **SimulatedDevice** class:

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

    > **Note**:  This code defines handler invoked when a desired property changes in the device twin. Notice that new values are then reported back to the IoT Hub to confirm the change.

1. To register the desired property changed handler, add the following lines after the statements creating a handler for the direct method:

    ```csharp
    // Get the device twin to report the initial desired properties.
    Twin deviceTwin = s_deviceClient.GetTwinAsync().GetAwaiter().GetResult();
    greenMessage("Initial twin desired properties: " + deviceTwin.Properties.Desired.ToJson());

    // Set the device twin update callback.
    s_deviceClient.SetDesiredPropertyUpdateCallbackAsync(OnDesiredPropertyChanged, null).Wait();
    ```

1. Save the **Program.cs** file.

> **Note**:  Now you have added device twins to your app, you can reconsider having explicit variables such as **desiredHumidity**. Instead, you can use the variables in the device twin object.

#### Task 3: Test the Device Twins

To test the method, start the apps in the correct order.

1. Start the **cheesecavedevice** device app. It will begin writing to the terminal, and telemetry will appear.

1. Start the **cheesecaveoperator** back-end app.

1. Now check the console output for the **cheesecavedevice** device app, confirming the device twin synchronized correctly.

    ![Console Output](./Media/LAB_AK_15-cheesecave-device-twin-received.png)

1. If we let the fan do its work, we should eventually get rid of those red alerts!

    ![Console Output](./Media/LAB_AK_15-cheesecave-device-twin-success.png)

The code given in this module isn't industrial quality. It does show how to use direct methods, and device twins. However, the messages are sent only when the back-end service app is first run. Typically, a back-end service app would require a browser interface, for an operator to send direct methods, or set device twin properties, when required.

> **Note**:  Before you go, don't forget to close both instances of Visual Studio Code - this will exit the apps if they are still running.
