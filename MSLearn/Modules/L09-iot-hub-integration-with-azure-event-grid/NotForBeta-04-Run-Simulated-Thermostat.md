# Run Simulated Thermostat

In this unit, you will run the Simulated Thermostat device and see the configured alert messages triggering the Logic App to send email alerts.

1. Within **Visual Studio Code**, open the **LabFiles** directory for this unit.

1. Open the **SimulatedThermostat.cs** file.

1. Locate the `s_connectionString` variable, and change it's value to the **Azure IoT Hub Connection String** for the **SimulatedThermostat** device.

    ```csharp
    private readonly static string s_connectionString = "{Your device connection string here}";
    ```

    Be sure to replace the `{Your device connection string here}` placeholder with the **SimulatedThermostat** device Connection String that was copied previously.

1. Notice the `private static void Main` method. This method calls the `DeviceClient.CreateFromConnectionString` method by passing in the IoT Hub Connection String for the device to create a new Azure IoT SDK `DeviceClient` object. The device uses the `DeviceClient` to communicate with Azure IoT Hub.

1. Notice the code within the `SendDeviceToCloudMessageAsync` method that is called within the `Main` method. This method contains the simulated thermostat code that generates some simulated sensor readings (for `temperature` and `humidity`) and then sends those sensor readings formatted as JSON to Azure IoT Hub.

1. Locate the `// TEMPERATURE ALERT` comment in the `SendDeviceToCloudMessageAsync` method. Notice the code has some logic to send a **Property** named `temperatureAlert` with the value of `true` only if the `temperature` reading from the device is greater than `31`.

    ```csharp
    message.Properties.Add("temperatureAlert", (currentTemperature > 31) ? "true" : "false");
    ```

    This `temperatureAlert` property  on the message is what the Event Grid Filters were configured to filter on when determining which events to trigger Logic App with.

1. Within **Visual Studio Code**, open the **Terminal** pane by clicking the **View** menu, then selecting **Terminal**.

1. Within the **Terminal** pane, navigate to the directory for the `/LabFiles` directory for this unit.

1. Within the **Terminal** execute the following command to build and run the **SimulatedThermostat** device.

    ```cmd/sh
    dotnet run
    ```

1. Once the **SimulatedThermostat** device is running, it will begin outputting telemetry data to the Terminal. This will be the telemetry data that it is sending to Azure IoT Hub.

    The **Terminal** output when the **SimulatedThermostat** device is running will look similar to the following:

    ```text
    12/18/2019 5:15:24 PM > Sending message: {"temperature":22.689815467544747,"humidity":78.94046861629023}
    12/18/2019 5:15:26 PM > Sending message: {"temperature":24.09503677817762,"humidity":68.38281373883729}
    12/18/2019 5:15:27 PM > Sending message: {"temperature":23.967554470974743,"humidity":71.00245486525932}
    ```

1. With the device running, watch for telemetry readings with a `temperature` greater than 31, then check your email account the Logic App is configured to send messages to. You will receive email messages for each event with a `temperature` greater than 31 since the device is passing the `temperatureAlert` property with a value of `true`.

1. When you're finished, press **Ctrl + C** in the **Terminal** to end the **SimulatedThermostat** device.
