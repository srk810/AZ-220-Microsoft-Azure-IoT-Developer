# Individual Enrollment of Device in DPS

## Lab Scenario

Contoso's Asset Monitoring and Tracking Solution will require an IoT Device that has sensors for tracking location, temperature, pressure to be added in product transport boxes. This will help track products and monitor the  condition of the transport boxes to ensure the cheese products are kept in appropriate environments during delivery.

When a new box enters the system, it is equipped with the new IoT Device. The device needs to be auto-provisioned to IoT Hub using Device Provisioning Service. When the box has arrived the sensor is removed from the box and needs to be "decommissioned" through DPS.

## In This Lab

In this lab, you will, create an Individual Enrollment within Azure Device Provisioning Service (DPS) to automatically connect a pre-built simulated device to Azure IoT Hub. You will also fully retire the device by removing it from both DPS and IoT Hub.

This lab includes:

* Verify Lab Prerequisites
* Create New Individual Enrollment in DPS
* Configure Simulated Device
* Test Simulated Device
* Retire the Device

## Exercise 1: Verify Lab Prerequisites

This lab assumes the following resources are available:

| Resource Type | Resource Name |
| :-- | :-- |
| Resource Group | AZ-220-RG |
| IoT Hub | AZ-220-HUB-{YOUR-ID} |
| Device Provisioning Service | AZ-220-DPS-{YOUR-ID} |

If the resources are unavailable, please execute the **lab-setup.azcli** script before starting the lab.

The **lab-setup.azcli** script is written to run in a **bash** shell environment - the easiest way to execute this is in the Azure Cloud Shell.

1. Using a browser, open the [Azure Shell](https://shell.azure.com/) and login with the Azure subscription you are using for this course.

1. To ensure the Azure Shell is using **Bash**, ensure the dropdown selected value in the top-left is **Bash**.

1. To upload the setup script, in the Azure Shell toolbar, click **Upload/Download files** (fourth button from the right).

1. In the dropdown, select **Upload** and in the file selection dialog, navigate to the **lab-setup.azcli** file for this lab. Select the file and click **Open** to upload it.

    A notification will appear when the file upload has completed.

1. You can verify that the file has uploaded by listing the content of the current directory by entering the `ls` command.

1. To create a directory for this lab, move **lab-setup.azcli** into that directory, and make that the current working directory, enter the following commands:

    ```bash
    mkdir lab5
    mv lab-setup.azcli lab5
    cd lab5
    ```

1. To ensure the **lab-setup.azcli** has the execute permission, enter the following commands:

    ```bash
    chmod +x lab-setup.azcli
    ```

1. To edit the **lab-setup.azcli** file, click **{ }** (Open Editor) in the toolbar (second button from the right). In the **Files** list, select **lab5** to expand it and then select **lab-setup.azcli**.

    The editor will now show the contents of the **lab-setup.azcli** file.

1. In the editor, update the values of the `{YOUR-ID}` and `{YOUR-LOCATION}` variables. Set `{YOUR-ID}` to the Unique ID you created at the start of this - i.e. **CAH121119**, and set `{YOUR-LOCATION}` to the location that makes sense for your resources.

    ```bash
    #!/bin/bash

    RGName="AZ-220-RG"
    IoTHubName="AZ-220-HUB-{YOUR-ID}"

    Location="{YOUR-LOCATION}"
    ```

    > [!NOTE] The `{YOUR-LOCATION}` variable should be set to the short name for the location. You can see a list of the available locations and their short-names (the **Name** column) by entering this command:

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

1. To save the changes made to the file and close the editor, click **...** in the top-right of the editor window and select **Close Editor**.

    If prompted to save, click **Save** and the editor will close.

    > [!NOTE] You can use **CTRL+S** to save at any time and **CTRL+Q** to close the editor.

1. To create a resources required for this lab, enter the following command:

    ```bash
    ./lab-setup.azcli
    ```

    This will take a few minutes to run. You will see JSON output as each step completes.

    Once the script has completed, you will be ready to continue with the lab.

## Exercise 2: Create new Individual Enrollment (Symmetric keys) in DPS

In this exercise, you will create a new Individual Enrollment for a device within the Device Provisioning Service (DPS) using Symmetric key attestation.

### Task 1: 

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Notice that the **AZ-220** dashboard that you created in the previous task has been loaded.

    You should see both your IoT Hub and DPS resources listed.

1. On your Resource group tile, click **AZ-220-DPS-{YOUR-ID}**.

1. On the Device Provisioning Service **Settings** pane on the left side, click **Manage enrollments**.

1. At the top of the blade, click **+ Add individual enrollment**.

1. On the **Add Enrollment** blade, in the **Mechanism** dropdown, click **Symmetric Key**. This sets the attestation method to use Symmetric key authentication.

1. Notice the **Auto-generate keys** option is checked. This sets DPS to automatically generate both Primary and Secondary Keys for the device enrollment when it's created.

    Optionally, un-checking this option enables custom keys to be manually entered.

1. In the **Registration ID** field, enter **DPSSimulatedDevice1** as the Registration ID to use for the device enrollment within DPS.

    By default, the Registration ID will be used as the IoT Hub Device ID when the device is provisioned from the enrollment. If these values need to be different, then enter the required IoT Hub Device ID in that field.

1. Notice that the **AZ-220-HUB-{YOUR-ID}** IoT Hub is selected within the **Select the IoT hubs this device can be assigned to** dropdown. This field specifies the IoT Hub(s) this device can be assigned to.

1. Locate the **Initial Device Twin State** field. This contains JSON data that represents the initial configuration of desired properties for the device.

1. In the Initial Device Twin State field, modify the `properties.desired` JSON object to include a property named `telemetryDelay` with the value of `"2"`. This will be used by the Device to set the time delay for reading sensor telemetry and sending events to IoT Hub.

    The final JSON will be like the following:

    ```json
    {
        "tags": {},
        "properties": {
            "desired": {
                "telemetryDelay": "2"
            }
        }
    }
    ```

1. Click **Save**

1. In the Manage enrollments pane, click on the **Individual Enrollments** tab to view the list of individual device enrollments.

1. In the list, click on the **DPSSimulatedDevice1** individual enrollment that was just created to view the enrollment details.

1. Locate the **Authentication Type** section, and notice the Mechanism is set to Symmetric Key.

1. Copy the **Primary Key** and **Secondary Key** values for this device enrollment, and save them for reference later.

    These are the authentication keys for the device to authenticate with the service.

1. Locate the **Initial Device Twin State**, and notice the JSON for the Device Twin Desired State contains the `telemetryDelay` property set to the value of `"2"`.

## Exercise 3: Configure Simulated Device

In this exercise, you will configure a Simulated Device written in C# to connect to Azure IoT using the Individual Enrollment created in the previous unit. You will also add code to the Simulated Device that will read and update device configuration based on the Device Twin within Azure IoT Hub.

The simulated device created in this unit is for a an asset tracking solution that will have Iot Device with sensors located within a transport box to track shipments in transit. The sensor telemetry from the device sent to Azure IoT Hub includes Temperature, Humidity, Pressure, and Latitude/Longitude coordinates of the transport box.

### Task 1: Create the Simulated Device

1. On the **Device Provisioning Service** blade, navigate to the **Overview** pane.

1. Within the Overview pane, copy the **ID Scope** for the **Device Provisioning Service**, and save it for reference later.

1. Using **Visual Studio Code**, open the `/LabFiles` folder.

1. Open the `Program.cs` file.

1. Locate the `dpsIdScope` variable, and replace the value with the **ID Scope** of the Device Provisioning Service.

    > [!NOTE]
    > The **ID Scope** for the **Device Provisioning Service** can be retrieved from within the Azure portal, by navigating to the DPS resource, then copying the **ID Scope** value on the **Overview** pane.

1. Locate the `registrationId` variable, and replace the value with the **Registration ID** of `DPSSimulatedDevice1` for the individual enrollment that was created in the Device Provisioning Service.

1. Locate the `individualEnrollmentPrimaryKey` and `individualEnrollmentSecondaryKey` variables, and replace their values with the **Primary Key** and **Secondary Key** values that were copied from the Enrollment Details for the Individual Enrollment for the device that was created in the Device Enrollment Service.

1. Review the source code for the simulated device, and take notice of the following items:

    - The `ProvisioningDeviceLogic` class contains the logic for reading from the simulated device sensors.
    - The `ProvisioningDeviceLogic.SendDeviceToCloudMessagesAsync` method contains the logic for generating the simulated sensor readings for Temperature, Humidity, Pressure, Latitude, and Longitude. This method also sends the telemetry as Device-to-Cloud messages to Azure IoT Hub.

1. Notice at the bottom of the `ProvisioningDeviceLogic.SendDeviceToCloudMessagesAsync` method, there is a `Task.Delay` call to pause the `while` loop for a period of time before reading the simulated sensors again and sending the telemetry. This code uses the `_telemetryDelay` variable that defines how many seconds to wait before sending telemetry again.

1. Locate the `_telemetryDelay` variable declaration towards the top of the `ProvisioningDeviceLogic` class. Notice the delay is defaulted to `1` second in the code.

1. To get started configuring the simulated device to set the `_telemetryDelay` based on configuration of the **Device Twin** within Azure IoT Hub, you need to add code to read the Device Twin desired state, and report back the current state.

1. Locate the `// TODO 1: Setup OnDesiredPropertyChanged Event Handling` comment. To setup the simulated device to be notified of Device Twin state changes, you need to use the `DeviceClient.SetDesiredPropertyUpdateCallbackAsync` method to wire up an event handler for the `OnDesiredPropertyChanged` event.

    Replace the `// TODO 1` comment with the following code that sets up the event handler on the DeviceClient:

    ```csharp
    Console.WriteLine("Connecting SetDesiredPropertyUpdateCallbackAsync event handler...");
    await iotClient.SetDesiredPropertyUpdateCallbackAsync(OnDesiredPropertyChanged, null).ConfigureAwait(false);
    ```

1. To complete setting up the event handler, the `OnDesiredPropertyChanged` method needs to be added to the `ProvisioningDeviceLogic` class. Add the following method code to the class, that also includes code to read the Device Twin Desired Properties, configures the `_telemetryDelay` variable, and then reports back the Reported Properties back to the Device Twin to tell Azure IoT Hub what the current state of the simulated device is configured to.

    ```csharp
    private async Task OnDesiredPropertyChanged(TwinCollection desiredProperties, object userContext)
    {
        Console.WriteLine("Desired Twin Property Changed:");
        Console.WriteLine($"{desiredProperties.ToJson()}");

        // Read the desired Twin Properties
        if (desiredProperties.Contains("telemetryDelay"))
        {
            string desiredTelemetryDelay = desiredProperties["telemetryDelay"];
            if (desiredTelemetryDelay != null)
            {
                this._telemetryDelay = int.Parse(desiredTelemetryDelay);
            }
            // if desired telemetryDelay is null or unspecified, don't change it
        }


        // Report Twin Properties
        var reportedProperties = new TwinCollection();
        reportedProperties["telemetryDelay"] = this._telemetryDelay;
        await iotClient.UpdateReportedPropertiesAsync(reportedProperties).ConfigureAwait(false);
        Console.WriteLine("Reported Twin Properties:");
        Console.WriteLine($"{reportedProperties.ToJson()}");
    }
    ```

1. Locate the `//TODO 2: Load Device Twin Properties` comment. To setup the simulated device to read the current Device Twin property desired state, and configure the device to match on device startup, add the following code in place of this comment:

    ```csharp
    Console.WriteLine("Loading Device Twin Properties...");
    var twin = await iotClient.GetTwinAsync().ConfigureAwait(false);
    await OnDesiredPropertyChanged(twin.Properties.Desired, null);
    ```

    This code calls the `DeviceTwin.GetTwinAsync` method to retrieve the Device Twin for the simulated device. It then accesses the `Properties.Desired` property object to retrieve the current Desired State for the device, and passes that to the `OnDesiredPropertyChanged` method that will configure the simulated devices `_telemetryDelay` variable.

    Notice, this code reuses the `OnDesiredPropertyChanged` method that was already created for handling _OnDesiredPropertyChanged_ events. This helps keep the code that reads the Device Twin desired state properties and configures the device at startup in a single place. The result is the code is simpler and easier to maintain.

1. Now the simulated device is all setup to be configured by the Device Twin within Azure IoT Hub.

    > [!NOTE]
    > If you need help with pasting code in the `Program.cs` file, please refer to the `/LabFiles-Completed` folder for the full source code for the Simulated Device with the Device Twin configuration code. When using this completed code sample, be sure to configure the ID Scope, Registration ID, and Individual Enrollment Keys.

## Exercise 4: Test the Simulated Device

In this unit you will run the Simulated Device and verify it's sending sensor telemetry to Azure IoT Hub. You will also update the delay at which telemetry is sent to Azure IoT Hub by updating the Device Twin for the simulated device within Azure IoT Hub.

1. In Visual Studio Code, click on the **View** menu, then click **Terminal** to open the _Terminal_ pane.

1. Run the following command within the **Terminal** to build and run the Simulated Device application. Be sure the terminal location is set to the `/LabFiles` directory with the `Program.cs` file.

    ```cmd/sh
    dotnet run
    ```

1. When the Simulated Device application runs, it will first output some details about it's status. Notice the JSON output that follows the `Desired Twin Property Changed:` line contains the desired value for the `telemetryDelay` for the device.

    ```text
    RegistrationID = DPSSimulatedDevice1
    ProvisioningClient RegisterAsync . . . Device Registration Status: Assigned
    ProvisioningClient AssignedHub: AZ-220-HUB-CP1019.azure-devices.net; DeviceID: DPSSimulatedDevice1
    Creating Symmetric Key DeviceClient authentication
    Simulated Device. Ctrl-C to exit.
    DeviceClient OpenAsync.
    Connecting SetDesiredPropertyUpdateCallbackAsync event handler...
    Loading Device Twin Properties...
    Desired Twin Property Changed:
    {"telemetryDelay":"2","$version":1}
    Reported Twin Properties:
    {"telemetryDelay":2}
    Start reading and sending device telemetry...
    ```

1. The Simulated Device application will be sending telemetry events to the Azure IoT Hub that includes the `temperature`, `humidity`, `pressure`, `latitude`, and `longitude` values.

    The terminal output will look similar to the following:

    ```text
    11/6/2019 6:38:55 PM > Sending message: {"temperature":25.59094770373355,"humidity":71.17629229611545,"pressure":1019.9274696347665,"latitude":39.82133964767944,"longitude":-98.18181981142438}
    11/6/2019 6:38:57 PM > Sending message: {"temperature":24.68789062681044,"humidity":71.52098010830628,"pressure":1022.6521258267584,"latitude":40.05846882452387,"longitude":-98.08765031156229}
    11/6/2019 6:38:59 PM > Sending message: {"temperature":28.087463226675737,"humidity":74.76071353757787,"pressure":1017.614206096327,"latitude":40.269273772972454,"longitude":-98.28354453319591}
    11/6/2019 6:39:01 PM > Sending message: {"temperature":23.575667940813894,"humidity":77.66409506912534,"pressure":1017.0118147748344,"latitude":40.21020096551372,"longitude":-98.48636739129239}
    ```

    Notice the timestamp differences between telemetry readings. The telemetry delay the simulated device is running at should be `2` seconds as configured through the Device Twin; instead of the default of `1` second in the source code.

1. Verify the simulated device telemetry is being sent to Azure IoT Hub by running the following Azure CLI command in the Azure Cloud Shell (or a different command-line window).

    ```cmd/sh
    az iot hub monitor-events --hub-name {IoTHubName} --device-id DPSSimulatedDevice1
    ```

    _Be sure to replace the **{IoTHubName}** placeholder with the name of your Azure IoT Hub._

1. With the Simulated Device running, the `telemetryDelay` configuration can be updated by editing the Device Twin Desired State within Azure IoT Hub. This can be done by configuring the Device in the Azure IoT Hub within the Azure portal.

1. Open the **Azure Portal**, and navigate to the **Azure IoT Hub** service.

1. On the IoT Hub blade, click on **IoT devices** under the **Explorers** section on the left side of the blade.

1. Within the list of IoT devices, click on the **Device ID** (DPSSimulatedDevice1) for the Simulated Device.

1. On the blade for the Simulate Device, click the **Device Twin** button at the top of the blade.

1. Within the **Device twin** blade, there is an editor with the full JSON for the Device Twin. This enables you to view and/or edit the Device Twin state directly within the Azure portal.

1. Locate the JSON for the `properties.desired` object. This contains the Desired State for the Device Twin. Notice the `telemetryDelay` property already exists, and is set to `"2"` as configured when the device was provisioned based on the Individual Enrollment in DPS.

1. Modify the `telemetryDelay` value to `"5"` to configure the Device Twin to set the Desired State to have the simulated device wait 5 seconds between telemetry readings.

1. Click **Save**

1. The `OnDesiredPropertyChanged` event will be triggered automatically within the code for the Simulated Device, and the device will update its configuration to reflect the changes to the Device Twin Desired state.

1. In Visual Studio Code, the Terminal output for the Simulated Device Application will show a message that the `Desired Twin Property Changed` along with the JSON for the new desired`telemetryDelay` property value. Once the device picks up the new configuration of Device Twin Desired state, it will automatically update to start sending sensor telemetry every 5 seconds as now configured.

    ```text
    Desired Twin Property Changed:
    {"telemetryDelay":"5","$version":2}
    Reported Twin Properties:
    {"telemetryDelay":5}
    11/6/2019 7:29:55 PM > Sending message: {"temperature":33.01780830277959,"humidity":68.52464504936927,"pressure":1023.0929576073974,"latitude":39.97641877038439,"longitude":-98.49544472071804}
    11/6/2019 7:30:00 PM > Sending message: {"temperature":33.95490410689027,"humidity":71.57070464062072,"pressure":1013.3468084112261,"latitude":40.01604868659767,"longitude":-98.51051877869526}
    11/6/2019 7:30:05 PM > Sending message: {"temperature":22.055266337494956,"humidity":67.50505594886144,"pressure":1018.1765662249767,"latitude":40.22292566031555,"longitude":-98.4367936214764}
    ```

1. The command-line window with the `az iot hub monitor-events` Azure CLI command running will also display the telemetry events sent to Azure IoT Hub being received at the new interval of 5 seconds.

## Exercise 5: Retire the Device

In this unit you will perform the necessary tasks to retire the device from both the Device Provisioning Service (DPS) and Azure IoT Hub. To fully retire an IoT Device from an Azure IoT solution it must be removed from both of these services. When the transport box arrives at it's final destination, then sensor will be removed from the box, and needs to be "decommissioned". Complete device retirement is an important step in the life cycle of IoT devices within an IoT solution.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Notice that the **AZ-220** dashboard that you created in the previous task has been loaded.

    You should see both your IoT Hub and DPS resources listed.

1. On your Resource group tile, click **AZ-220-DPS-{YOUR-ID}** to navigate to the Device Provisioning Service.

1. On the Device Provisioning Service settings pane on the left side, click **Manage enrollments**.

1. In the Manage enrollments pane, click on the **Individual Enrollments** link to view the list of individual device enrollments.

1. Select the `DPSSimulatedDevice1` individual device enrollment by checking the box next to it in the list, then click **Delete**.

    > [!NOTE]
    > Deleting the Individual Enrollment from DPS will permanently remove the enrollment. To temporarily disable the enrollment, you can set the **Enable entry** setting to **Disable** within the **Enrollment Details** for the Individual Enrollment.

1. On the **Remove enrollment** prompt, click **Yes** to confirm that you want to delete this device enrollment from the Device Provisioning Service.

1. The Individual Enrollment is now removed from the Device Provisioning Service (DPS). To complete the device retirement, the **Device ID** for the Simulated Device also must be removed from the **Azure IoT Hub** service.

1. On your Resource group tile, click **AZ-220-HUB-{YOUR-ID}** to navigate to the Azure IoT Hub.

1. On the Azure IoT Hub pane, click on **IoT devices** under **Explorers** section on the left side.

1. Select the `DPSSimulatedDevice1` **Device ID** by checking the box next to the device in the list, then click **Delete**.

    > [!NOTE] Deleting the Device ID from IoT Hub will permanently remove the device registration. To temporarily disable the device from connecting to IoT Hub, you can set the **Enable connection to IoT Hub** to **Disable** within the properties for this **Device ID**.

1. On the **Are you certain you wish to delete selected device(s)** prompt, click **Yes** to confirm that you want to delete this device from Azure IoT Hub.

Now that the Device Enrollment has been removed from the Device Provisioning Service, and the matching Device ID has been removed from the Azure IoT Hub, the simulated device has been fully retired from the solution.
