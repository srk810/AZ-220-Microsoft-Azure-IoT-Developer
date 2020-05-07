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

* Verify that the lab prerequisites are met (that you have the required Azure resources)

    * The script will create an IoT Hub if needed.
    * The script will create a new device identity needed for this lab.

* Create a simulated device app to send device telemetry to the IoT Hub
* Create a back-end service app to listen for the telemetry
* Implement a direct method, to communicate settings to the IoT device
* Implement device twins functionality, to manage IoT device properties

## Lab Instructions

### Exercise 1: Verify Lab Prerequisites

This lab assumes the following Azure resources are available:

| Resource Type | Resource Name |
| :-- | :-- |
| Resource Group | rg-az220 |
| IoT Hub | iot-az220-training-{your-id} |
| IoT Device | sensor-th-0055 |

If these resources are not available, you will need to run the **lab15-setup.azcli** script as instructed below before moving on to Exercise 2. The script file is included in the GitHub repository that you cloned locally as part of the dev environment configuration (lab 3).

The **lab15-setup.azcli** script is written to run in a **bash** shell environment - the easiest way to execute this is in the Azure Cloud Shell.

>**Note:** You will need the connection string for the **sensor-th-0055** device. If you already have this device registered with Azure IoT Hub, you can obtain the connection string by running the following command in the Azure Cloud Shell"
>
> ```bash
> az iot hub device-identity show-connection-string --hub-name iot-az220-training-{your-id} --device-id sensor-th-0055 -o tsv
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

1. On the Cloud Shell toolbar, to enable access to the lab15-setup.azcli file, click **Open editor** (second button from the right - **{ }**).

1. In the **FILES** list, to expand the lab15 folder and open the script file, click **lab15**, and then click **lab15-setup.azcli**.

    The editor will now show the contents of the **lab15-setup.azcli** file.

1. In the editor, update the `{your-id}` and `SETLOCATION` assigned values.

    Referencing the sample below as an example, you need to set `{your-id}` to the Unique ID you created at the start of this course - i.e. **cah191211**, and set `SETLOCATION` to the location that makes sense for your resources.

    ```bash
    #!/bin/bash

    YourID="{your-id}"
    RGName="rg-az220"
    IoTHubName="iot-az220-training-$YourID"
    DeviceID="sensor-th-0055"

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

    The script will first create a resource group named **rg-az220** and an IoT Hub named **iot-az220-training-{YourID}**. If they already exist, a corresponding message will be displayed. The script will then add a device with an ID of **sensor-th-0055** to the IoT hub and display the device connection string.

1. Notice that, once the script has completed, information pertaining to your IoT Hub and device is displayed.

    The script will display information similar to the following:

    ```text
    Configuration Data:
    ------------------------------------------------
    iot-az220-training-{YourID} Service connectionstring:
    HostName=iot-az220-training-{YourID}.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=nV9WdF3Xk0jYY2Da/pz2i63/3lSeu9tkW831J4aKV2o=

    sensor-th-0055 device connection string:
    HostName=iot-az220-training-{YourID}.azure-devices.net;DeviceId=sensor-th-0055;SharedAccessKey=TzAzgTYbEkLW4nWo51jtgvlKK7CUaAV+YBrc0qj9rD8=

    iot-az220-training-{YourID} eventhub endpoint:
    sb://iothub-ns-iot-az220-training-2610348-5a463f1b56.servicebus.windows.net/

    iot-az220-training-{YourID} eventhub path:
    iot-az220-training-{YourID}

    iot-az220-training-{YourID} eventhub SaS primarykey:
    tGEwDqI+kWoZroH6lKuIFOI7XqyetQHf7xmoSf1t+zQ=
    ```

1. Copy the output displayed by the script into a text document for use later in this lab.

    Once you have saved the information to a location where you can find it easily, you will be ready to continue with the lab.

### Exercise 2: Write Code to Send and Receive Telemetry

In this exercise, you will be creating the simulated device app (for the sensor-th-0055 device) that sends telemetry to your IoT Hub.

#### Task 1: Open a simulated device that generates telemetry

1. In File Explorer, navigate to the Starter folder for lab 7 (Device Message Routing).

    In _Lab 3: Setup the Development Environment_, you cloned the GitHub repository containing lab resources by downloading a ZIP file and extracting the contents locally. The extracted folder structure includes the following folder path:

    * Allfiles
      * Labs
          * 15-Remotely monitor and control devices with Azure IoT Hub
            * Starter
              * CheeseCaveDevice

1. Open **Visual Studio Code**.

1. On the **File** menu, click **Open Folder**

1. In the Open Folder dialog, navigate to the **15-Remotely monitor and control devices with Azure IoT Hub** folder.

1. Navigate to the **Starter** folder.

1. Click **CheeseCaveDevice**, and then click **Select Folder**.

    You should see the following files listed in the EXPLORER pane of Visual Studio Code:

    * Program.cs
    * CheeseCaveDevice.csproj

1. Open the **Program.cs** file.

    A cursory glance will reveal that the **CheeseCaveDevice** application is very similar to those used in the preceding labs. This version of the application uses symmetric Key authentication, sends both telemetry and logging messages to the IoT Hub, and has a more complex sensor implementation.

1. On the **Terminal** menu, click **New Terminal**.

    Notice the directory path indicated as part of the command prompt. You do not want to start building this project within the folder structure of a previous lab project.
  
1. At the terminal command prompt, to verify the application builds, enter the following command:

   ```bash
   dotnet build
   ```

    The output will be similar to:

    ```text
    ❯ dotnet build
    Microsoft (R) Build Engine version 16.5.0+d4cbfca49 for .NET Core
    Copyright (C) Microsoft Corporation. All rights reserved.

    Restore completed in 39.27 ms for D:\Az220-Code\AllFiles\Labs\15-Remotely monitor and control devices with Azure IoT Hub\Starter\CheeseCaveDevice\CheeseCaveDevice.csproj.
    CheeseCaveDevice -> D:\Az220-Code\AllFiles\Labs\15-Remotely monitor and control devices with Azure IoT Hub\Starter\CheeseCaveDevice\bin\Debug\netcoreapp3.1\CheeseCaveDevice.dll

    Build succeeded.
        0 Warning(s)
        0 Error(s)

    Time Elapsed 00:00:01.16
    ```

In the next task, you will configure the connection string and review the application.

#### Task 2: Configure connection and review code

The simulated device app that you build in this task simulates an IoT device that is monitoring the conveyor belt. The app will simulate sensor readings and report vibration sensor data every two seconds.

1. Return to **Visual Studio Code**, and ensure the **Program.cs** file is open.

1. Find the following line of code:

    ```csharp
    private readonly static string deviceConnectionString = "<your device connection string>";
    ```

1. Replace the **\<your device connection string\>** (line 21) with the device connection string you saved earlier.

    > **Note**: This is the only change that you are required to make to this code.

1. Save the **Program.cs** file.

1. Notice that the application structure is similar to that used in earlier units:

    * Using statements
    * Namespace definition
      * Program class - responsible for connecting to Azure IoT and sending telemetry
      * CheeseCaveSimulator class - (replaces EnvironmentSensor) rather than just generating telemetry, this class also simulates a running cheese cave environment that is impacted by the operation of a cooling fan.
      * ConsoleHelper - a class that encapsulates writing different colored text to the console

1. Review the the **Main** method:

    ```csharp
    private static void Main(string[] args)
    {
        ConsoleHelper.WriteColorMessage("Cheese Cave device app.\n", ConsoleColor.Yellow);

        // Connect to the IoT hub using the MQTT protocol.
        deviceClient = DeviceClient.CreateFromConnectionString(deviceConnectionString, TransportType.Mqtt);

        // Create an instance of the Cheese Cave Simulator
        cheeseCave = new CheeseCaveSimulator();

        // INSERT register direct method code below here

        // Get the device twin to report the initial desired properties.
        Twin deviceTwin = deviceClient.GetTwinAsync().GetAwaiter().GetResult();
        ConsoleHelper.WriteGreenMessage("Initial twin desired properties: " + deviceTwin.Properties.Desired.ToJson());

        // Set the device twin update callback.
        deviceClient.SetDesiredPropertyUpdateCallbackAsync(OnDesiredPropertyChanged, null).Wait();

        SendDeviceToCloudMessagesAsync();
        Console.ReadLine();
    }
    ```

    As in earlier labs, the **Main** method establishes a connection to the IoT hub, reads the device twin and configures the device twin property change callback.

1. Take a brief look at the **SendDeviceToCloudMessagesAsync** method.

    Notice that it is very similar to previous versions you have created in earlier labs.

1. Briefly review the **OnDesiredPropertyChanged** method.

   Notice that it is very similar to previous versions you have created in earlier labs.

1. Take a look at the **CheeseCaveSimulator** class.

   This is an evolution of the **EnvironmentSensor** class used in earlier labs. The primary difference is the introduction of a fan -  if the fan is **On**, the temperature and humidity will gradually move towards the desired values, whereas is the fan is **Off** (or **Failed**), then the temperature and humidity values will move towards the ambient values. Of interest is the fact that there is a 1% chance that fan will be set to the **Failed** state when the temperature is read.

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

Now that you have your (simulated) sensor-th-0055 device sending telemetry to your IoT Hub, you need to create a back-end app that can connect to IoT Hub and "listen" for that telemetry. Eventually, this back-end app will be used to automate the control of the temperature in the cheese cave.

#### Task 1: Create an app to receive telemetry

1. Open a new instance of Visual Studio Code.

    Since your simulated device app is running in the Visual Studio Code windows that you already have open, you need a new instance of Visual Studio Code for the back-end app.

1. On the **Terminal** menu, click **New Terminal**.

1. At the Terminal command prompt, to create a directory named "CheeseCaveOperator" and change the current directory to that directory, enter the following commands:

   ```bash
   mkdir CheeseCaveOperator
   cd CheeseCaveOperator
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
    ```

1. On the **File** menu, click **Open Folder**

1. In the **Open Folder** dialog, navigate to the folder location specified in the Terminal pane, click **CheeseCaveOperator**, and then click **Select Folder**

    The EXPLORER pane should open in Visual Studio Code and you should see the `Program.cs` and `CheeseCaveOperator.csproj` files listed.

1. In the **EXPLORER** pane, click **Program.cs**.

1. In the Code Editor pane, delete the contents of the Program.cs file.

#### Task 2: Review the CheeseCaveOperator project file

In this task, you will add code to your back-end app that will be used to receive telemetry from the IoT Hub Event Hub endpoint.

1. In the **EXPLORER** pane, to open the application project file, click **CheeseCaveOperator.csproj**.

    The **CheeseCaveOperator.csproj** file should now be opened in the code editor pane.

1. Take a minute to review the contents of the **CaveDevice.csproj** file.

    Your file contents should be similar to the following:

    ```xml
    <Project Sdk="Microsoft.NET.Sdk">

    <PropertyGroup>
        <OutputType>Exe</OutputType>
        <TargetFramework>netcoreapp3.1</TargetFramework>
    </PropertyGroup>

    <ItemGroup>
        <PackageReference Include="Microsoft.Azure.Devices" Version="1.*" />
        <PackageReference Include="Microsoft.Azure.EventHubs" Version="4.*" />
    </ItemGroup>

    </Project>
    ```

    > **Note**: The package version numbers in your file may differ from those show above, that's okay.

    The project file (.csproj) is an XML document that specifies the type of project that you are working on. In this case, the project is an **Sdk** style project.

    As you can see, the project definition contains two sections - a **PropertyGroup** and an **ItemGroup**.

    The **PropertyGroup** defines the type of output that building this project will produce. In this case you will be building an executable file that targets .NET Core 3.1.

    The **ItemGroup** specifies any external libraries that are required for the application. These particular references are for NuGet packages, and each package reference specifies the package name and the version. The `dotnet add package` commands (that you entered in the steps above) added these references to the project file and the `dotnet restore` command ensured that all of the dependencies were downloaded.

    > **Information**: You can learn more about NuGet [here](https://docs.microsoft.com/en-us/nuget/what-is-nuget).

#### Task 3: Add the telemetry receiver code

1. In the **EXPLORER** pane, click **Program.cs**.

    The **Program.cs** file should now be opened in the code editor pane.

    The Code Editor pane should display an empty code file.

1. Copy-and-Paste the following code into the Code Editor pane:

    ```csharp
    // Copyright (c) Microsoft. All rights reserved.
    // Licensed under the MIT license. See LICENSE file in the project root for full license information.

    // INSERT using statements below here

    namespace CheeseCaveOperator
    {
        class Program
        {
            // INSERT variables below here

            // INSERT Main method below here

            // INSERT ReceiveMessagesFromDeviceAsync method below here

            // INSERT InvokeMethod method below here

            // INSERT Device twins section below here
        }

        internal static class ConsoleHelper
        {
            internal static void WriteColorMessage(string text, ConsoleColor clr)
            {
                Console.ForegroundColor = clr;
                Console.WriteLine(text);
                Console.ResetColor();
            }
            internal static void WriteGreenMessage(string text)
            {
                WriteColorMessage(text, ConsoleColor.Green);
            }

            internal static void WriteRedMessage(string text)
            {
                WriteColorMessage(text, ConsoleColor.Red);
            }
        }
    }
    ```

    This code outlines the structure of the operator app.

1. Locate the `// INSERT using statements below here` comment.

1. To specify the namespaces that the application code will be using, enter the following code:

    ```csharp
    using System;
    using System.Threading.Tasks;
    using System.Text;
    using System.Collections.Generic;
    using System.Linq;

    using Microsoft.Azure.EventHubs;
    using Microsoft.Azure.Devices;
    using Newtonsoft.Json;
    ```

    Notice that as well as specifying **System**, you are also declaring other namespaces that the code will be using, such as **System.Text** for encoding strings, **System.Threading.Tasks** for asynchronous tasks, and the namespaces for the two packages you added earlier.

    > **Tip**: When inserting code, the code layout may not be ideal. You can have Visual Studio Code format the document for you by right-clicking in the code editor pane and then clicking **Format Document**. You can achieve the same result by opening the **Task** pane (press **F1**) and typing **Format Document** and then pressing **Enter**. And on Windows, the shortcut for this task is **SHIFT+ALT+F**.

1. Locate the `// INSERT variables below here` comment.

1. To specify the variables that the program is using, enter the following code:

    ```csharp
    // Global variables.
    // The Event Hub-compatible endpoint.
    private readonly static string eventHubsCompatibleEndpoint = "<your event hub endpoint>";

    // The Event Hub-compatible name.
    private readonly static string eventHubsCompatiblePath = "<your event hub path>";
    private readonly static string iotHubSasKey = "<your event hub Sas key>";
    private readonly static string iotHubSasKeyName = "service";
    private static EventHubClient eventHubClient;
    private static ServiceClient serviceClient;

    // Connection string for your IoT Hub.
    private readonly static string serviceConnectionString = "<your service connection string>";

    private readonly static string deviceId = "sensor-th-0055";
    ```

1. Take a moment to review the code (and code comments) that you just entered.

    The **eventHubsCompatibleEndpoint** variable is used to store the URI for the IoT Hub built-in service-facing endpoint (messages/events) that is compatible with Event Hubs.

    The **eventHubsCompatiblePath** variable will contain the path to the Event Hub entity.

    The **iotHubSasKey** variable will contain the key name to the corresponding shared access policy rule for the namespace, or entity.

    The **iotHubSasKeyName** variable will contain the key for the corresponding shared access policy rule of the namespace or entity.

    The **eventHubClient** variable will contain the event hub client instance, which will be used to receive messages from the IoT Hub.

    The **serviceClient** variable will contain the service client instance that will be sued to send message from the app to the IoT Hub (and from there, on to targeted devices, etc.).

    The **serviceConnectionString** variable will contain the connection string that will enable the operator app to connect to the IoT Hub.

    The **deviceId** variable contains the device ID used by the **CheeseCaveDevice** application.

1. Locate the code line used to assign the service connection string

    ```csharp
    private readonly static string serviceConnectionString = "<your service connection string>";
    ```

1. Replace **\<your service connection string\>** with the IoT Hub **iothubowner** shared access policy primary connection string that you save earlier in this lab.

    You should have saved the output generated by the lab15-setup.azcli setup script during Exercise 1.

    > **Note**: You may be curious as to why the **iothubowner** shared policy is used rather than the **service** shared policy. The answer is related to the IoT Hub permissions assigned to each policy. The **service** policy has the **ServiceConnect** permission and is usually used by back-end cloud services. It confers the following rights:
    >
    > * Grants access to cloud service-facing communication and monitoring endpoints.
    > * Grants permission to receive device-to-cloud messages, send cloud-to-device messages, and retrieve the corresponding delivery acknowledgments.
    > * Grants permission to retrieve delivery acknowledgments for file uploads.
    > * Grants permission to access twins to update tags and desired properties, retrieve reported properties, and run queries.
    >
    > For the first part of the lab, where the **serviceoperator** application calls a direct method to toggle the fan state, the **service** policy has sufficient rights. However, during the latter part of the lab, the device registry is queried. This is achieved via the **RegistryManager** class. In order to use the **RegistryManager** class to query the device registry, the shared access policy used to connect to the IoT Hub must have the **Registry read** permission, which confers the following right:
    >
    > * Grants read access to the identity registry.
    >
    > As the **iothubowner** policy has been granted the **Registry write** permission, it inherits the **Registry read** permission, so it is suitable for our needs.
    >
    > In a production scenario, you might consider adding a new shared access policy that has just the **Service connect** and **Registry read** permissions.

1. Replace the **\<your event hub endpoint\>**, **\<your event hub path\>**, and the **\<your event hub SaS key\>** with the values that you saved earlier in this lab.

1. Locate the `// INSERT Main method below here` comment.

1. To implement the **Main** method, enter the following code:

    ```csharp
    public static void Main(string[] args)
    {
        ConsoleHelper.WriteColorMessage("Cheese Cave Operator\n", ConsoleColor.Yellow);

        // Create an EventHubClient instance to connect to the IoT Hub Event Hubs-compatible endpoint.
        var connectionString = new EventHubsConnectionStringBuilder(new Uri(eventHubsCompatibleEndpoint), eventHubsCompatiblePath, iotHubSasKeyName, iotHubSasKey);
        eventHubClient = EventHubClient.CreateFromConnectionString(connectionString.ToString());

        // Create a PartitionReceiver for each partition on the hub.
        var runtimeInfo = eventHubClient.GetRuntimeInformationAsync().GetAwaiter().GetResult();
        var d2cPartitions = runtimeInfo.PartitionIds;

        // INSERT create registry manager instance below here

        // INSERT create service client instance below here

        // Create receivers to listen for messages.
        var tasks = new List<Task>();
        foreach (string partition in d2cPartitions)
        {
            tasks.Add(ReceiveMessagesFromDeviceAsync(partition));
        }

        // Wait for all the PartitionReceivers to finish.
        Task.WaitAll(tasks.ToArray());
    }
    ```

1. Take a moment to review the code (and code comments) that you just entered.

    Notice the use of the **EventHubsConnectionStringBuilder** class to construct the **EventHubClient** connection string - this is effectively a helper class that concatenates the various values into the correct format. This is then used to connect to the event hub endpoint and populate the **eventHubClient** variable.

    The **eventHubClient** is then used to retrieve the run time information for the event hub. This information contains:

    * **CreatedAt** - the Date/Time the Event Hub was created
    * **PartitionCount** - the number of partitions (most IoT Hubs are configured with 4 partitions)
    * **PartitionIds** - a string array containing the partition IDs
    * **Path** - the event hub entity path

    The array of partition IDs is stored in **d2cPartitions** variable, where it will be shortly used to create a list of tasks that will receive messages from each partition.

    > **Information**: You can learn more about the purpose of partitions [here](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-scaling#partitions).

    As messages sent from devices to an IoT Hub may be handled by any of the partitions, the app has to retrieve messages from each. The next section of code creates a list of asynchronous tasks - each task will receive messages from a specific partition. The final line will wait for all tasks to complete - as each task is going to be in an infinite loop, this line prevents the application from exiting.

1. Locate the `INSERT ReceiveMessagesFromDeviceAsync method below here` comment.

1. To implement the **ReceiveMessagesFromDeviceAsync** method, enter the following code:

    ```csharp
    // Asynchronously create a PartitionReceiver for a partition and then start reading any messages sent from the simulated client.
    private static async Task ReceiveMessagesFromDeviceAsync(string partition)
    {
        // Create the receiver using the default consumer group.
        var eventHubReceiver = eventHubClient.CreateReceiver("$Default", partition, EventPosition.FromEnqueuedTime(DateTime.Now));
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

                ConsoleHelper.WriteGreenMessage("Telemetry received: " + data);

                foreach (var prop in eventData.Properties)
                {
                    if (prop.Value.ToString() == "true")
                    {
                        ConsoleHelper.WriteRedMessage(prop.Key);
                    }
                }
                Console.WriteLine();
            }
        }
    }
    ```

    As you can see, this method is with the target partition supplied as an argument. Recall that for the default configuration where 4 partitions are specified, this method is called 4 times, each running asynchronously and in parallel, one for each partition.

    The first part of this method creates an event hub receiver. The code specifies that the **$Default** consumer group is used, (although it is common to create a custom consumer group), the partition, and finally at what position in the event partition's data to start receiving from. In this case, the receiver will only be interested in messages enqueued from the current time onwards - there are other options that allow the start of the data stream, the end of the data stream, or a specific offset to be provided.

    > **Information**: You can learn more about consumer groups [here](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-features#consumer-groups)

    Once the receiver is created, the app enters an infinite loop and waits to receive events.

    > **Note**: The `eventHubReceiver.ReceiveAsync(100)` code specifies the maximum number of events that can be received in one go, however, it does not wait for that many - it will return as soon as at least one is available. If no events are returned (due to a timeout), then the loop continues and the code waits for more events.

    If one or more events are received, then each event data body is converted from a byte array to a string and written to the console. The event data properties are then iterated and, in this case, checked to see if a value is true - in the current scenario, this represents an alert. Should an alert be found, it is written to the console.

1. On the **File** menu, to save your changes to the Program.cs file, click **Save**.

#### Task 3: Test your Code to Receive Telemetry

This test is important, checking whether your back-end app is picking up the telemetry being sent out by your simulated device. Remember your device app is still running, and sending telemetry.

1. To run the **CheeseCaveOperator** back-end app in the terminal, open a Terminal pane, and then enter the following command:

    ```bash
    dotnet run
    ```

   This command will run the **Program.cs** file in the current folder.

   > **Note**:  You can ignore the warning about the unused variable **serviceConnectionString** - we will be using that variable shortly.

1. Take a minute to observe the output to the Terminal.

    You should quickly see console output, and the app will display telemetry message data almost immediately if it connects to IoT Hub successfully.

    If not, carefully check your IoT Hub service connection string, noting that this string should be the service connection string, and not any other.:

    ![Console Output](./Media/LAB_AK_15-cheesecave-telemetry-received.png)

    > **Note**:  Green text is used to show things are working as they should and red text when bad stuff is happening. If you don't get a screen similar to this image, start by checking your device connection string.

1. Leave this app running for a moment longer.

1. With both apps running, visually compare the telemetry that is being sent with the telemetry that is being received.

    * Is there an exact data match?
    * Is there much of a delay between when data is sent and when it is received?

    Once you are satisfied, stop the running apps and then close the Terminal pane in both instances of VS Code. No not close the Visual Studio Code windows.

    You now have an app sending telemetry from a device, and a back-end app acknowledging receipt of the data. 

In the next Exercise you will begin work on the steps that handle the control side - what to do when issues arise with the data. Clearly, there are issues, we're getting temperature and humidity alerts!

### Exercise 4: Write Code to Invoke a Direct Method

In this Exercise, you will update your device app by adding the code for a direct method that will simulate turning on the fan in the cheese cave. Next, you will add code to the back-end service app to invoke this direct method.

Calls from the back-end app to invoke direct methods can include multiple parameters as part of the payload. Direct methods are typically used to turn features of the device off and on, or specify settings for the device.

#### Handle Error Conditions

There are several error conditions that need to be checked for when a device receives instructions to run a direct method. One of these checks is simply to respond with an error if the fan is in a failed state. Another error condition to report is when an invalid parameter is received. Clear error reporting is important, given the potential remoteness of the device.

#### Invoke a Direct Method

Direct methods require that the back-end app prepares the parameters, then makes a call specifying a single device to invoke the method. The back-end app will then wait for, and report, a response.

The device app contains the functional code for the direct method. The function name is registered with the IoT client for the device. This process ensures the client knows what function to run when the call comes from the IoT Hub (there could be many direct methods).

#### Task 1: Add Code to Define a Direct Method in the Device App

1. Return to the Visual Studio Code instance that is running the **CheeseCaveDevice** app.

    > **Note**: If the app is still running, place input focus in the Terminal pane and press **CTRL+C** to exit the app.

1. Ensure that **Program.cs** is open in the code editor.

1. Locate the `INSERT register direct method code below here` comment.

1. To register the direct method, add the following code:

    ```csharp
    // Create a handler for the direct method call
    deviceClient.SetMethodHandlerAsync("SetFanState", SetFanState, null).Wait();
    ```

    Additionally, the **SetFanState** direct method handler is setup. Note that the device client **SetMethodHandlerAsync** method takes the remote method `"SetFanState"` name as an argument, along with the actual local method to call, and a user context object (in this case null).

1. Locate the `INSERT SetFanState method below here` comment.

1. To implement the **SetFanState** direct method, enter the following code:

    ```csharp
    // Handle the direct method call
    private static Task<MethodResponse> SetFanState(MethodRequest methodRequest, object userContext)
    {
        if (cheeseCave.FanState == StateEnum.Failed)
        {
            // Acknowledge the direct method call with a 400 error message.
            string result = "{\"result\":\"Fan failed\"}";
            ConsoleHelper.WriteRedMessage("Direct method failed: " + result);
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
                cheeseCave.UpdateFan((StateEnum)Enum.Parse(typeof(StateEnum), data));
                ConsoleHelper.WriteGreenMessage("Fan set to: " + data);

                // Acknowledge the direct method call with a 200 success message.
                string result = "{\"result\":\"Executed direct method: " + methodRequest.Name + "\"}";
                return Task.FromResult(new MethodResponse(Encoding.UTF8.GetBytes(result), 200));
            }
            catch
            {
                // Acknowledge the direct method call with a 400 error message.
                string result = "{\"result\":\"Invalid parameter\"}";
                ConsoleHelper.WriteRedMessage("Direct method failed: " + result);
                return Task.FromResult(new MethodResponse(Encoding.UTF8.GetBytes(result), 400));
            }
        }
    }
    ```

    This is the method that is executed on the device when the associated remote method, also called **SetFanState**, is invoked via an IoT Hub. Notice that as well as receiving a **MethodRequest** instance, it also receives the **userContext** object that was defined when the direct message callback was register (in this case it will be null). 

    The first line of this method determines whether the cheese cave fan is currently in a **Failed** state - the assumption made by the cheese cave simulator is that once the fan has failed, any subsequent command will automatically fail. Therefore, a JSON string is created with the **result** property set to **Fan Failed**. A new **MethodResponse** object is then constructed, with the result string encoded into a byte array and an HTTP status code - in this instance, **400** is used which, in the context of a REST API means a generic client-side error has occurred. As direct method callbacks are required to return a **Task\<MethodResponse\>**, a new task is created and returned.

    > **Information**: You can learn more about how HTTP Status Codes are used within REST APIs [here](https://restfulapi.net/http-status-codes/).

    If the fan state is not **Failed**, the code then proceeds to process the data sent as part of the method request. The **methodRequest.Data** property contains the data in the form of a byte array, so it is first converted to a string. In this scenario, the following two values are expected (including the quotes):

    * "On"
    * "Off"

    It is assumed that the received data maps to members of the **StateEnum** :

    ```csharp
    internal enum StateEnum
    {
        Off,
        On,
        Failed
    }
    ```

    In order to parse the data, the quotes must first be removed and then the **Enum.Parse** method is used to find a matching enum value. Should this fail (the data needs to match exactly), an exception is thrown, which is caught below. Notice that the exception handler creates and returns a similar error method response to the one created for the fan failed state.

    If a matching value is found in the **StateEnum**, the cheese cave simulator **UpdateFan** method is called. In this case, the method merely sets the **FanState** property to the supplied value - a real-world implementation would interact with the fan to change the state and determine if the state change was successful. However, in this scenario, success is assumed and the appropriate **result** and **MethodResponse** are created and returned - this time using the HTTP Status code **200** to indicate success.

1. On the **File** menu, to save the Program.cs file, click **Save**.

You have now completed the coding that is required on the device side. Next, you need to add code to the back-end service that will invoke the direct method.

#### Task 2: Add Code to Call Your Direct Method

1. Return to the Visual Studio Code instance that is running the **CheeseCaveOperator** app.

    > **Note**: If the app is still running, place input focus in the Terminal pane and press **CTRL+C** to exit the app.

1. Ensure that **Program.cs** is open in the code editor.

1. Locate the `INSERT ServiceClient variable below here` comment.

1. To add a global variable to hold the service client instance, enter the following code:

    ```csharp
    private static ServiceClient serviceClient;
    ```

1. Locate the `INSERT create service client instance below here` comment.

1. To add the code that creates a service client instance and invokes the direct method, enter the following code:

    ```csharp
    // Create a ServiceClient to communicate with service-facing endpoint on your hub.
    serviceClient = ServiceClient.CreateFromConnectionString(serviceConnectionString);
    InvokeMethod().GetAwaiter().GetResult();
    ```

1. Locate the `INSERT InvokeMethod method below here` comment.

1. To add the code that invokes the direct method, enter the following code:

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
            var response = await serviceClient.InvokeDeviceMethodAsync(deviceId, methodInvocation);

            if (response.Status == 200)
            {
                ConsoleHelper.WriteGreenMessage("Direct method invoked: " + response.GetPayloadAsJson());
            }
            else
            {
                ConsoleHelper.WriteRedMessage("Direct method failed: " + response.GetPayloadAsJson());
            }
        }
        catch
        {
            ConsoleHelper.WriteRedMessage("Direct method failed: timed-out");
        }
    }
    ```

    > **Note**: This code is used to invoke the **SetFanState** direct method on the device app.

1. On the **File** menu, to save the Program.cs file, click **Save**.

You have now completed the code changes to support the **SetFanState** direct method.

#### Task 3: Test the direct method

To test the direct method, you will need to start the apps in the correct order. You can't invoke a direct method that hasn't been registered!

1. Start the **CheeseCaveDevice** device app.

    It will begin writing to the terminal, and telemetry will appear.

1. Start the **CheeseCaveOperator** back-end app.

    > **Note**:  If you see the message `Direct method failed: timed-out` then double check you have saved the changes in the **CheeseCaveDevice** and started the app.

    The CheeseCaveOperator back-end app will immediately call the direct method.

    Notice the output similar to the following:

    ![Console Output](./Media/LAB_AK_15-cheesecave-direct-method-sent.png)

1. Now check the console output for the **CheeseCaveDevice** device app, you should see that the fan has been turned on.

   ![Console Output](./Media/LAB_AK_15-cheesecave-direct-method-received.png)

You are now successfully monitoring and controlling a remote device. You have implemented a direct method on the device that can be invoked from the cloud. In our scenario, the direct method is used to turn on a fan, which will bring the environment in the cave to our desired settings.

What if you might want to remotely specify the desired settings for the cheese cave environment? Perhaps you want to set a particular target temperature for the cheese cave at a certain point in the aging process. You could specify desired settings with a direct method (which is a valid approach), or you could use another feature of IoT Hub, called device twins. In the next Exercise, you will work on implementing device twin properties within your solution.

### Exercise 5: Implement the Device Twin functionality

In this exercise, we'll add some code to both the device app and back-end service app, to show device twin synchronization in operation.

As a reminder, a device twin contains four types of information:

* **Tags**: information on the device that isn't visible to the device.
* **Desired properties**: the desired settings specified by the back-end app.
* **Reported properties**: the reported values of the settings on the device.
* **Device identity properties**: read-only information identifying the device.

Device twins, which are managed through IoT Hub, are designed for querying, and they are synchronized with the real IoT device. The device twin can be queried, at any time, by the back-end app. This query can return the current state information for the device. Getting this data doesn't involve a call to the device, as the device and twin will have synchronized. Much of the functionality of device twins is provided by Azure IoT Hub, so not much code needs to be written to make use of them.

There is some overlap between the functionality of device twins and direct methods. We could set device properties using direct methods, which might seem an intuitive way of doing things. However, using direct methods would require the back-end app to record those settings explicitly, if they ever needed to be accessed. Using device twins, this information is stored and maintained by default.

#### Task 1: Add Code To Use Device Twins To Synchronize Device Properties

1. Return to the Visual Studio Code instance that is running the **CheeseCaveOperator** back-end app.

1. If the app is still running, place input focus on the terminal and press **CTRL+C** to exit the app.

1. Ensure that the **Program.cs** is open.

1. In the Code Editor pane, locate the bottom of the **ReadDeviceToCloudMessages** class.

1. Just above the closing squiggly brace for the **ReadDeviceToCloudMessages** class, add the following code:

    ```csharp
    // Device twins section.
    private static RegistryManager registryManager;

    private static async Task SetTwinProperties()
    {
        var twin = await registryManager.GetTwinAsync("sensor-th-0055");
        var patch =
            @"{
                tags: {
                    customerID: 'Customer1',
                    cheeseCave: 'CheeseCave1'
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
          "SELECT * FROM devices WHERE tags.cheeseCave = 'CheeseCave1'", 100);
        var twinsInCheeseCave1 = await query.GetNextAsTwinAsync();
        Console.WriteLine("Devices in CheeseCave1: {0}",
          string.Join(", ", twinsInCheeseCave1.Select(t => t.DeviceId)));

    }
    ```

    > **Note**:  The **SetTwinProperties** method creates a piece of JSON that defines tags and properties that will be added to the device twin, and then updates the twin. The next part of the method demonstrates how a query can be performed to list the devices where the **cheeseCave** tag is set to "CheeseCave1". This query requires that the connection has the **Registry read** permission.

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

1. Return to the Visual Studio Code instance that is running the **CheeseCaveDevice** app.

1. If the app is still running, place input focus on the terminal and press **CTRL+C** to exit the app.

1. Ensure that the **Program.cs** file is open in the Code Editor pane.

1. In the Code Editor pane, scroll down to locate the end of the **Program** class.

1. Inside the closing squiggly brace of the **Program** class, add the following code:

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

1. Start the **CheeseCaveDevice** device app. It will begin writing to the terminal, and telemetry will appear.

1. Start the **CheeseCaveOperator** back-end app.

1. Check the console output for the **CheeseCaveDevice** device app and confirm that the device twin synchronized correctly.

    ![Console Output](./Media/LAB_AK_15-cheesecave-device-twin-received.png)

    If we let the fan do its work, we should eventually get rid of those red alerts!

    ![Console Output](./Media/LAB_AK_15-cheesecave-device-twin-success.png)

1. For both instances of Visual Studio Code, stop the app and then close the Visual Studio Code window.

The code provided in this module isn't industrial quality. It does show how to use direct methods and device twins. However, the messages are sent only when the back-end service app is first run. Typically, a back-end service app would require a browser interface, for an operator to send direct methods, or set device twin properties, when required.
