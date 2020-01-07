# Automatically provision IoT devices securely and at scale with DPS

## Lab Scenario

Our asset tracking solution is getting bigger, and provisioning devices one by one cannot scale. We want to use Device Provisioning Service to enroll many devices automatically and securely using x.509 certificate authentication.

## In This Lab

In this lab, you will setup a Group Enrollment within Device Provisioning Service (DPS) using a Root CA x.509 certificate chain. You will also configure a simulated IoT Device that will authenticate with DPS using a Device CA Certificate generated on the Root CA Certificate chain. The IoT Device will also be configured to handle changes to the Device Twin Desired Property state as configured initially through DPS, and modified via Azure IoT Hub. Finally, you will retire the IoT Device and the Group Enrollment with DPS.

This lab includes:

* Verify Lab Prerequisites
* Generate and Configure x.509 CA Certificates using OpenSSL
* Create Group Enrollment in DPS
* Configure Simulated Device with x.509 Certificate
* Handle Device Twin Desired Property Changes
* Automatic Enrollment of Simulated Device
* Retire Group Enrollment of Simulated Device

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
    mkdir lab6
    mv lab-setup.azcli lab6
    cd lab6
    ```

1. To ensure the **lab-setup.azcli** has the execute permission, enter the following commands:

    ```bash
    chmod +x lab-setup.azcli
    ```

1. To edit the **lab-setup.azcli** file, click **{ }** (Open Editor) in the toolbar (second button from the right). In the **Files** list, select **lab6** to expand it and then select **lab-setup.azcli**.

    The editor will now show the contents of the **lab-setup.azcli** file.

1. In the editor, update the values of the `{YOUR-ID}` and `{YOUR-LOCATION}` variables. Set `{YOUR-ID}` to the Unique ID you created at the start of this - i.e. **CAH121119**, and set `{YOUR-LOCATION}` to the location that makes sense for your resources.

    ```bash
    #!/bin/bash

    RGName="AZ-220-RG"
    IoTHubName="AZ-220-HUB-{YOUR-ID}"
    DPSName="AZ-220-DPS-{YOUR-ID}"

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

    > [!NOTE]
    >You can use **CTRL+S** to save at any time and **CTRL+Q** to close the editor.

1. To create a resources required for this lab, enter the following command:

    ```bash
    ./lab-setup.azcli
    ```

    This will take a few minutes to run. You will see JSON output as each step completes.

    Once the script has completed, you will be ready to continue with the lab.

## Exercise 2: Generate and Configure x.509 CA Certificates using OpenSSL

In this exercise, you will generate an x.509 CA Certificate using OpenSSL within the Azure Cloud Shell. This certificate will be used to configure the Group Enrollment within the Device Provisioning Service (DPS).

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Open the **Azure Cloud Shell** by clicking the **Terminal** icon within the top header bar of the Azure portal, and select the **Bash** shell option.

    > [!NOTE] Both *Bash* and *PowerShell* interfaces for the Azure Cloud Shell support the use of **OpenSSL**. In this unit you will use some helper scripts written for the *Bash* shell.

1. Within the Azure Cloud Shell, run the following commands that will download a helper script for using *OpenSSL* to generate x.509 CA Certificates. They will be placed within the `~/certificates` directory inside your Cloud Shell storage.

    ```sh
    # create certificates directory
    mkdir certificates
    # navigate to certificates directory
    cd certificates

    # download helper script files
    curl https://raw.githubusercontent.com/Azure/azure-iot-sdk-c/master/tools/CACertificates/certGen.sh --output certGen.sh
    curl https://raw.githubusercontent.com/Azure/azure-iot-sdk-c/master/tools/CACertificates/openssl_device_intermediate_ca.cnf --output openssl_device_intermediate_ca.cnf
    curl https://raw.githubusercontent.com/Azure/azure-iot-sdk-c/master/tools/CACertificates/openssl_root_ca.cnf --output openssl_root_ca.cnf

    # update script permissions so user can read, write, and execute it
    chmod 700 certGen.sh
    ```

    These helper scripts are being downloaded from the `Azure/azure-iot-sdk-c` open source project hosted on Github. This is an open source project that's a part of the Azure IoT SDK. The `certGen.sh` helper script will help demonstrate the purpose of CA Certificates without diving into the specifics of OpenSSL configuration that's outside the scope of this unit.

    For additional instructions on using this helper script, and for instructions on how to use PowerShell instead of Bash, please see this link: <https://github.com/Azure/azure-iot-sdk-c/blob/master/tools/CACertificates/CACertificateOverview.md>

    > **Warning:** Certificates created by this helper script **MUST NOT** be used for Production. They contain hard-coded passwords ("*1234*"), expire after 30 days, and most importantly are provided for demonstration purposes to help you quickly understand CA Certificates. When building products against CA Certificates, you'll need to use your own security best practices for certification creation and lifetime management.

1. The first x.509 certificates needed are CA and intermediate certificates. These can be generated using the `certGen.sh` helper script by passing the `create_root_and_intermediate` option.

    Run the following command within the `~/certificates` directory of the **Azure Cloud Shell** to generate the CA and intermediate certificates:

    ```sh
    ./certGen.sh create_root_and_intermediate
    ```

1. The previous command generated a CA Root Certificate named `azure-iot-test-only.root.ca.cert.pem` is located within the `./certs` directory.

    Run the following command within the **Azure Cloud Shell** to download this certificate to your local machine so it can be uploaded to DPS.

    ```sh
    download ~/certificates/certs/azure-iot-test-only.root.ca.cert.pem
    ```

1. Navigate to the **Device Provisioning Service** (DPS) named `AZ-220-DPS-{YOUR-ID}` within the Azure portal.

1. On the **Device Provisioning Service** blade, click the **Certificates** link under the **Settings** section.

1. On the **Certificates** pane, click the **Add** button at the top to start process of uploading the x.509 CA Certificate to the DPS service.

1. On the **Add Certificate** pane, select the x.509 CA Certificate file in the **Certificate .pem or .cer file** upload field. This is the `azure-iot-test-only.root.ca.cert.pem` CA Certificate that was just downloaded.

1. Enter a logical name for the _Root CA Certificate_ into the **Certificate Name** field. For example, `root-ca-cert`

    This name could be the same as the name of the certificate file, or something different. This is a logical name that has no correlation to the _Common Name_ within the x.509 CA Certificate.

1. Click **Save**.

1. Once the x.509 CA Certificate has been uploaded, the **Certificates** pane will display the certificate with the **Status** of **Unverified**. Before this CA Certificate can be used to authenticate devices to DPS, you will need to verify **Proof of Possession** of the certificate.

1. To start the process of verifying **Proof of Possession** of the certificate, click on the **CA Certificate** that was just uploaded to open the **Certificate Details** pane for it.

1. On the **Certificate Details** pane, click on the **Generate Verification Code** button.

1. Copy the newly generated **Verification Code** that is displayed above the _Generate_ button.

    > [!NOTE] You will need to leave the **Certificate Details** pane **Open** while you generate the Verification Certificate. If you close the pane, you will invalidate the Verification Code and will need to generate a new one.

1. Open the **Azure Cloud Shell**, if it's not still open from earlier, and navigate to the `~/certificates` directory.

1. **Proof of Possession** of the CA Certificate is provided to DPS by uploading a certificate generated from the CA Certificate with the **Validate Code** that was just generated within DPS. This is how you provide proof that you actually own the CA Certificate.

    Run the following command, passing in the **Verification Code**, to create the **Verification Certificate**:

    ```sh
    ./certGen.sh create_verification_certificate <verification-code>
    ```

    Be sure to replace the `<verification-code>` placeholder with the **Verification Code** generated by the Azure portal.

    For example, the command run will look similar to the following:

    ```sh
    ./certGen.sh create_verification_certificate 49C900C30C78D916C46AE9D9C124E9CFFD5FCE124696FAEA
    ```

1. The previous command generated a **Verification Certificate** that is chained to the CA Certificate with the Verification Code. The generated Verification Certificate named `verification-code.cert.pem` is located within the `./certs` directory of the Azure Cloud Shell.

    Run the following command within the **Azure Cloud Shell** to download this **Verification Certificate** to your local machine so it can be uploaded to DPS.

    ```sh
    download ~/certificates/certs/verification-code.cert.pem
    ```

1. Go back to the **Certificate Details** pane for the **CA Certificate** within DPS.

1. Select the newly created, and downloaded, **Verification Certificate** file, named `verification-code.cert.pem`, within the **Verification Certificate .pem or .cer file** field.

1. Click **Verify**.

1. With the **Proof of Possession** completed for the CA Certificate, notice the **Status** for the certificate in the **Certificates** pane is now displayed as **Verified**.

## Exercise 3: Create Group Enrollment (x.509 Certificate) in DPS

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your Resource group tile, click **AZ-220-DPS-{YOUR-ID}**.

1. On the Device Provisioning Service settings pane on the left side, click **Manage enrollments**.

1. At the top of the blade, click **Add enrollment group**.

1. On the **Add Enrollment Group** blade, enter "**simulated-devices**" in the **Group name** field for the name of the enrollment group.

1. Ensure that the **Attestation Type** is set to **Certificate**.

1. Set the **Certificate Type** field to **CA Certificate**.

1. In the **Primary Certificate** dropdown, select the **CA Certificate** that was uploaded to DPS previously.

1. Notice the **Select the IoT hubs this group can be assigned to** dropdown has the **AZ-220-HUB-{YOUR-ID}** IoT Hub selected. This will ensure when the device is provisioned, it gets added to this IoT Hub.

1. In the Initial Device Twin State field, modify the `properties.desired` JSON object to include a property named `telemetryDelay` with the value of `"1"`. This will be used by the Device to set the time delay for reading sensor telemetry and sending events to IoT Hub.

    The final JSON will be like the following:

    ```js
    {
        "tags": {},
        "properties": {
            "desired": {
                "telemetryDelay": "1"
            }
        }
    }
    ```

1. Click **Save**

1. In the Manage enrollments pane, click on the **Enrollment Groups** tab to view the list of enrollment groups in DPS.

1. In the list, click on the **simulated-devices** enrollment group that was just created to view the enrollment group details.

1. On the **Enrollment Group Details** pane, locate the **Certificate Type**, notice it's set to **CA Certificate**. Also, notice the Primary Certificate information is displayed, including the ability to update the certificates if needed.

1. Locate the **Initial Device Twin State**, and notice the JSON for the Device Twin Desired State contains the `telemetryDelay` property set to the value of `"1"`.

1. Close the **Enrollment Group Details** pane.

## Exercise 4: Configure Simulated Device with x.509 certificate

In this exercise, you will configure a Simulated Device written in C# to connect to Azure IoT Hub via Device Provisioning Service (DPS) using an x.509 certificate. This unit will also introduce you to the workflow within the **Simulated Device** source code within the `/LabFiles` directory, and how it works to authenticate with DPS and send messages to IoT Hub.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Open the Azure Cloud Shell by clicking the **Terminal** icon within the top header bar of the Azure portal, and select the **Bash** shell option.

1. Within the **Azure Cloud Shell**, navigate to the `~/certificates` directory by running the following command:

    ```sh
    cd ~/certificates
    ```

    The `~/certificates` directory is where the `certGen.sh` helper scripts was downloaded to and used to generate the CA Certificate for DPS previously. This helper script will also be used to generate a device certificate within the CA Certificate chain.

1. Run the following command to generate an **x.509 Device Certificate** within the CA Certificate chain with the device name of `simulated-device1`. This certificate will generate a leaf device x.509 certificate for the Simulated Device. This certificate will be signed by the CA Certificate generated previously, and will be used to authenticate the device with the Device Provisioning Service (DPS).

    ```sh
    ./certGen.sh create_device_certificate simulated-device1
    ```

    Notice the **Device Name** of `simulated-device1` is passed to the `create_device_certificate` command of the `certGen.sh` script. This command will create a new x.509 certificate that's signed by the CA Certificate and has the specified **Device Name** set within the **Common Name**, or `CN=`, value of the **Device Certificate**.

1. Once the `create_device_certificate` command has completed, then generated **x.509 Device Certificate** will be named `new-device.cert.pfx` and will be located within the `/certs` sub-directory.

    > [!NOTE] This command overwrites the existing certificate. If you want to create a certificate for multiple devices, ensure you copy the `new-device.cert.pfx` each time.

    Run the following command to download the generated **x.509 Device Certificate** from the Cloud Shell to your local machine:

    ```sh
    download ~/certificates/certs/new-device.cert.pfx
    ```

    The Simulated Device will be configured to use this **x.509 Device Certificate** to authenticate with the Device Provisioning Service.

1. Within the Azure portal, navigate to the **Device Provisioning Service** blade, and the **Overview** pane.

1. Within the Overview pane, copy the **ID Scope** for the **Device Provisioning Service**, and save it for reference later.

    The **ID Scope** will be similar to this value: `0ne0004E52G`

1. Copy the downloaded `new-device.cert.pfx` **x.509 Device Certificate** file to the `/LabFiles` directory; within the root directory along-side the `Program.cs` file. The **Simulated Device** project will need to access this certificate file when authenticating to the Device Provisioning Service.

    After copied, the certificate file will be located in the following location:

    ```text
    /LabFiles/new-device.cert.pfx
    ```

1. Using **Visual Studio Code**, open the `/LabFiles` folder.

1. Open the `SimulatedDevice.csproj` file.

1. Within the `SimulatedDevice.csproj` file, ensure the following block of XML exists within the file. This configuration ensures that the `new-device.cert.pfx` certificate file is copied to the build folder when the C# code is compiled, and made available for the program to access when it executes.

    ```xml
        <ItemGroup>
            <None Update="new-device.cert.pfx" CopyToOutputDirectory="PreserveNewest" />
        </ItemGroup>
    ```

    If it's not there, then paste it in before the closing `</Project>` tag. The end of the file should look similar to the following:

    ```xml
            <ItemGroup>
                <None Update="new-device.cert.pfx" CopyToOutputDirectory="PreserveNewest" />
            </ItemGroup>
        </Project>
    ```

1. Open the `Program.cs` file.

1. Locate the `GlobalDeviceEndpoint` variable, and notice it's value is set to `global.azure-devices-provisioning.net`. This is the **Global Device Endpoint** for the Azure Device Provisioning Service (DPS) within the Public Azure Cloud. All devices connecting to Azure DPS will be configured with this Global Device Endpoint DNS name.

    ```csharp
    private const string GlobalDeviceEndpoint = "global.azure-devices-provisioning.net";
    ```

1. Locate the `dpsIdScope` variable, and replace the value with the **ID Scope** of the Device Provisioning Service.

   ```csharp
   private static string dpsIdScope = "<DPS-ID-Scope>";
   ```

1. Locate the `s_certificateFileName` variable. Notice the value to this variable is set to `new-device.cert.pfx`. This is the name of the **x.509 Device Certificate** file that was copied to the `/LabFiles` directory after it was previously generated using the `certGen.sh` helper script within the Cloud Shell. This variable tells the Simulated Device program code what file contains the x.509 Device Certificate to use when authenticating with the Device Provisioning Service.

1. Locate the `s_certificatePassword` variable. This variable contains the **Password** for the **x.509 Device Certificate**. Notice that it's already set to `1234`, as this is the default password used by the `certGen.sh` helper script when generating the x.509 certificates.

    > [!NOTE] For the purpose of this unit, the **Password** is hard coded. In a _Production_ device, the password will need to be stored in a more secure manner. Additionally, the certificate file (PFX) should be stored securely on a production device using a Hardware Security Module (HSM).
    >
    > An HSM (Hardware Security Module), is used for secure, hardware-based storage of device secrets, and is the most secure form of secret storage. Both X.509 certificates and SAS tokens can be stored in the HSM. HSMs can be used with both attestation mechanisms the provisioning service supports.

1. Locate the `public static int Main` method. This is the execution entry for the **Simulated Device**

    This method contains code that initiates the use of the **x.509 Device Certificate** by calling the `LoadProvisioningCertificate` method to load the certificate. The `LoadProvisioningCertificate` method returns an `X509Certificate2` object that contains the **x.509 Device Certificate** from the `new-device.cert.pfx` file.

1. Locate the `LoadProvisioningCertificate` method, and review the necessary code to load an **x.509 Certificate** from the `new-device.cert.pfx` file.

1. Notice the `public static int Main` method also contains code that initiates a **Security** `SecurityProviderX509Certificate` object for the x.509 Device Certificate. It also creates a **Transport** `ProvisioningTransportHandlerAmqp` object that defines the Simulated Device will be using **AMQP** as the communications protocol when connecting to Azure IoT Hub.

1. Notice the `ProvisioningDeviceClient.Create` method is passed the **Security** and **Transport** object, as well as the **DPS ID Scope** and **DPS Global Device Endpoint**,  that will be used to register the device with the Device Provisioning Service.

1. Notice the `ProvisioningDeviceLogic` object is instantiated by passing it the **ProvisioningDeviceClient** and **Security** objects.

    The `ProvisioningDeviceLogic` is a class define within the **Simulated Device** that contains code for the device logic. It contains code for running the device by reading from the simulated device sensors, and sending Device-to-Cloud messages to Azure IoT Hub. It will also be modified later to contain code that updates the device according to changes to Device Twin Desired Properties that are sent to the device from the cloud.

1. Locate the `ProvisioningDeviceLogic.RunAsync` method.

1. Notice the code that calls the `ProvisioningDeviceClient.RegisterAsync` method. This method Registers the device using the **Device Provisioning Service** and assigns it to an **Azure IoT Hub**.

    ```csharp
    DeviceRegistrationResult result = await _provClient.RegisterAsync().ConfigureAwait(false);
    ```

1. Notice the code that instantiates a new `DeviceAuthenticationWithX509Certificate` object. This is a Device Authentication object that will be used to authenticate the Simulated Device to **Azure IoT Hub** using the **x.509 Device Certificate**. The constructor is being passed the **DeviceId** for the device that was registered in DPS, as well as the **x.509 Device Certificate** to authenticate the device.

    ```csharp
    var auth = new DeviceAuthenticationWithX509Certificate(result.DeviceId, (_security as SecurityProviderX509).GetAuthenticationCertificate());
    ```

1. Notice the code that calls the `DeviceClient.Create` method to create a new **IoT Device Client** object that is used to communicate with the Azure IoT Hub service.

    ```csharp
    using (iotClient = DeviceClient.Create(result.AssignedHub, auth, TransportType.Amqp))
    {
    ```

    Notice this code also passes the value of `TransportType.Amqp` telling the **DeviceClient** to communicate with the Azure IoT Hub using the AMQP protocol. Alternatively, Azure IoT Hub can be connected to and communicated with using MQTT or HTTP protocols as well.

1. Notice the call to the `SendDeviceToCloudMessagesAsync` method. This is a method defined within the Simulated Device code, and is where the device logic is located to read from simulated sensors and to send Device-to-Cloud messages to Azure IoT Hub. This method also contains a loop that continues to execute while the Simulated Device is running.

    ```csharp
    await SendDeviceToCloudMessagesAsync(iotClient);
    ```

1. Notice the call to the `DeviceClient.CloseAsync` method. This method closes **DeviceClient** object, and closes the connection with Azure IoT Hub. This is the last line of code executed when the Simulated Device shuts down.

    ```csharp
    await iotClient.CloseAsync().ConfigureAwait(false);
    ```

1. Locate the `SendDeviceToCloudMessagesAsync` method.

1. Notice the code within the `SendDeviceToCloudMessagesAsync` method contains a `while` loop that has code to generate simulated sensor readings, and then send that data to Azure IoT Hub in a Device-to-Cloud message.

1. Notice the simulated sensor readings are combined into a JSON object using the following code:

    ```csharp
        var telemetryDataPoint = new
        {
            temperature = currentTemperature,
            humidity = currentHumidity,
            pressure = currentPressure,
            latitude = currentLatitude,
            longitude = currentLongitude
        };
        var messageString = JsonConvert.SerializeObject(telemetryDataPoint);
        var message = new Message(Encoding.ASCII.GetBytes(messageString));

    ```

1. Notice there is a line of code that adds a `temperatureAlert` property to the Device-to-Cloud **Message**. The value of the property is being set to a `boolean` value representing whether the _temperature_ sensor reading is greater than 30.

    ```csharp
    message.Properties.Add("temperatureAlert", (currentTemperature > 30) ? "true" : "false");
    ```

    This code is a simple example of how to add properties to the **Message** object before sending it to the Azure IoT Hub. This can be used to add additional metadata to the messages that are being send, in addition to the message body content.

1. Notice the call to the `DeviceClient.SendEventAsync` method. This method accepts the **Message** to send as a parameter, then does the work of sending the Device-to-Cloud message to Azure IoT Hub.

    ```csharp
    await deviceClient.SendEventAsync(message);
    ```

1. Notice the last line of code within the `SendDeviceToCloudMessagesAsync` method, that performs a simply delay using the `_telemetryDelay` variable to define how many seconds to wait until sending the next simulated sensor reading.

## Exercise 5: Handle Device Twin Desired Property Changes

In this exercise, you will modify the Simulated Device source code to include an event handler to update device configurations based on Device Twin Desired Properties changes sent to the device from Azure IoT Hub.

Device Twins are JSON documents that store device state information including metadata, configurations, and conditions. Azure IoT Hub maintains a device twin for each device that you connect to IoT Hub.

The Device Provisioning Service (DPS) contains the initial Device Twin Desired Properties for devices that are registered using Group Enrollment. Once the devices are registered they are created within IoT Hub using this initial Device Twin configuration from DPS. After registration, the Azure IoT Hub maintains a Device Twin (and it's properties) for each device within the IoT Hub Device Registry.

When the Device Twin Desired Properties are updated for a device within Azure IoT Hub, the desired changes are sent to the IoT Device using the `DesiredPropertyUpdateCallback` event using the C# SDK. Handling this event within device code enables the devices configuration and properties to be updated as desired by easily managing the Device Twin state for the device within Azure IoT Hub.

1. Using **Visual Studio Code**, open the `/LabFiles` folder.

1. Open the `Program.cs` file.

1. Locate the `RunAsync` method. This is the method that connects the Simulate Device to **Azure IoT Hub** using a **DeviceClient** object. You will be adding code immediately after the device connects to Azure IoT Hub that integrates an `DesiredPropertyUpdateCallback` event handler for the device to receive to Device Twin Desired Property changes.

1. Locate the `// TODO 1` comment within the **RunAsync** method, and paste in the following code that calls the `SetDesiredPropertyUpdateCallbackAsync` method to setup the `DesiredPropertyUpdateCallback` event handler to receive Device Twin Desired Property changes.

    ```csharp
    // TODO 1: Setup OnDesiredPropertyChanged Event Handling to receive Desired Properties changes
    Console.WriteLine("Connecting SetDesiredPropertyUpdateCallbackAsync event handler...");
    await iotClient.SetDesiredPropertyUpdateCallbackAsync(OnDesiredPropertyChanged, null).ConfigureAwait(false);
    ```

    Notice this code is configuring the **DeviceClient** to call a method named `OnDesiredPropertyChanged` when Device Twin Property Change events are received.

1. Now that the `SetDesiredPropertyUpdateCallbackAsync` method was used to setup the event handler, the method named `OnDesiredPropertyChanged` that it's configured to call needs to be defined.

    To define the `OnDesiredPropertyChanged` method, paste in the following code to the **ProvisioningDeviceLogic** class below the `RunAsync` method:

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

    Notice, the first block of code within the `OnDesiredPropertyChanged` event handler method that reads the `telemetryDelay` property value from the Device Twin Desired Properties. This code also take the value specified and modifies the `this._telemetryDelay` variable with the desired value to reconfigure the delay time between sending simulated sensor readings to Azure IoT Hub. Remember, this `this._telemetryDelay` variable is used within the `Task.Delay` call inside the `while` loop of the `SendDeviceToCloudMessagesAsync` method.

    Notice, the second block of the code within the `OnDesiredPropertyChanged` event handler method that reports the current state of the device to Azure IoT Hub. This code calls the `DeviceClient.UpdateReportedPropertiesAsync` method and passes it a **TwinCollection** method that contains the current state of the device properties. This code is how the device reports back to IoT Hub that it received the Device Twin Desired Properties changed event, and has now updates it's configurations accordingly. It also reports what the properties are now set to, in case they would be different than the desired state received, so that IoT Hub can maintain an accurate Device Twin that reflects the state of the device.

1. Now that the device can receive updates to the Device Twin Desired Properties from Azure IoT Hub, it also needs to be coded to configure it's initial setup when the simulated device begins execution. To do this the device will need to load the current Device Twin Desired Properties from Azure IoT Hub, and configure itself accordingly.

1. Locate the `// TODO 2` comment within the `RunAsync` method. Paste in the following code that loads the current Device Twin Desired Properties from Azure IoT Hub for the device, and then uses the same `OnDesiredPropertyChanged` method defined previously to configure the device accordingly.

    ```csharp
    // TODO 2: Load Device Twin Properties since device is just starting up
    Console.WriteLine("Loading Device Twin Properties...");
    var twin = await iotClient.GetTwinAsync().ConfigureAwait(false);
    // Use OnDesiredPropertyChanged event handler to set the loaded Device Twin Properties (re-use!)
    await OnDesiredPropertyChanged(twin.Properties.Desired, null);
    ```

    Notice the call to the `DeviceClient.GetTwinAsync` method. This method can be used by the device to retrieve the current Device Twin state at any time. It's used in this case so the device can configure itself to match the Device Twin Desired Properties when the device first starts execution.

    In this case, the `OnDesiredPropertyChanged` event handler method is being reused to keep the configuration of the `telemetryDelay` property based on the Device Twin Desired Properties to a single place. This will help make the code easier to maintain over time.

## Exercise 6: Automatic Enrollment of Simulated Device

In this exercise, you will execute the Simulated Device. When the device is run for the first time it will connect to the Device Provisioning Service (DPS) and automatically be enrolled using the configured Group Enrollment. Once enrolled into the DPS Group Enrollment, the device will be automatically registered within the Azure IoT Hub device registry. Once enrolled and registered, the device will begin communicating with Azure IoT Hub securely using the configured X.509 Certificate Authentication.

1. Using **Visual Studio Code**, open the `/LabFiles` folder containing the **Simulated Device** source code.

1. Within **Visual Studio Code**, click the **View** menu, then select **Terminal** to open the Visual Studio Code Terminal window.

1. Navigate to `/LabFiles` directory within the **Terminal**.

1. Build and execute the **SimulatedDevice** project by running the `dotnet run` command.

    ```cmd/sh
    dotnet run
    ```

    > [!NOTE] When running `dotnet run` for the Simulated Device, if a **ProvisioningTransportException** exception is displayed, the most common cause is an _Invalid certificate_ error. If this happens, ensure the CA Certificate in DPS, and the Device Certificate for the Simulated Device application are configured correctly.
    >
    > ```text
    > localmachine:LabFiles User$ dotnet run
    > Found certificate: AFF851ED016CA5AEB71E5749BCBE3415F8CF4F37 CN=simulated-device1; PrivateKey: True
    > Using certificate AFF851ED016CA5AEB71E5749BCBE3415F8CF4F37 CN=simulated-device1
    > RegistrationID = simulated-device1
    > ProvisioningClient RegisterAsync . . . Unhandled exception. Microsoft.Azure.Devices.Provisioning.Client.ProvisioningTransportException: {"errorCode":401002,"trackingId":"2e298c80-0974-493c-9fd9-6253fb055ade","message":"Invalid certificate.","timestampUtc":"2019-12-13T14:55:40.2764134Z"}
    >   at Microsoft.Azure.Devices.Provisioning.Client.Transport.ProvisioningTransportHandlerAmqp.ValidateOutcome(Outcome outcome)
    >   at Microsoft.Azure.Devices.Provisioning.Client.Transport.ProvisioningTransportHandlerAmqp.RegisterDeviceAsync(AmqpClientConnection client, String correlationId, DeviceRegistration deviceRegistration)
    >   at Microsoft.Azure.Devices.Provisioning.Client.Transport.ProvisioningTransportHandlerAmqp.RegisterAsync(ProvisioningTransportRegisterMessage message, CancellationToken cancellationToken)
    >   at X509CertificateSimulatedDevice.ProvisioningDeviceLogic.RunAsync() in /Users/User/Documents/AZ-220/LabFiles/Program.cs:line 121
    >   at X509CertificateSimulatedDevice.Program.Main(String[] args) in /Users/User/Documents/AZ-220/LabFiles/Program.cs:line 55
    > ...
    > ```

1. When the **Simulated Device** application runs, the **Terminal** will display the Console output from the app. Notice the x.509 certificate was loaded, the device was registered with the Device Provisioning Service, it was assigned to connect to the **AZ-220-HUB-{YOUR-ID}** IoT Hub, and the Device Twin Desired Properties are loaded.

    ```text
    localmachine:LabFiles User$ dotnet run
    Found certificate: AFF851ED016CA5AEB71E5749BCBE3415F8CF4F37 CN=simulated-device1; PrivateKey: True
    Using certificate AFF851ED016CA5AEB71E5749BCBE3415F8CF4F37 CN=simulated-device1
    RegistrationID = simulated-device1
    ProvisioningClient RegisterAsync . . . Device Registration Status: Assigned
    ProvisioningClient AssignedHub: AZ-220-HUB-CP1119.azure-devices.net; DeviceID: simulated-device1
    Creating X509 DeviceClient authentication.
    Simulated Device. Ctrl-C to exit.
    DeviceClient OpenAsync.
    Connecting SetDesiredPropertyUpdateCallbackAsync event handler...
    Loading Device Twin Properties...
    Desired Twin Property Changed:
    {"$version":1}
    Reported Twin Properties:
    {"telemetryDelay":1}
    Start reading and sending device telemetry...
    ```

    To review the source code for the **Simulated Device**, open the `/LabFiles/Program.cs` source code file. Look for several `Console.WriteLine` statements that are used to output the messages seen to the console.

1. Once the **Simulated Device** starts executing, it will begin sending simulated sensor telemetry messages to Azure IoT Hub. Notice the output to the console that displays the JSON of the sensor readings that are being sent to Azure IoT Hub.

    Also, notice the delay, as defined by the `telemetryDelay` Device Twin Property, between each message sent to IoT Hub is currently delaying **1 second** between sending sensor telemetry messages.

    ```text
    Start reading and sending device telemetry...
    12/9/2019 5:47:00 PM > Sending message: {"temperature":24.047539159212047,"humidity":67.00504162675004,"pressure":1018.8478924248358,"latitude":40.129349260196875,"longitude":-98.42877188146265}
    12/9/2019 5:47:01 PM > Sending message: {"temperature":26.628804161040485,"humidity":68.09610794675355,"pressure":1014.6454375411363,"latitude":40.093269544242695,"longitude":-98.22227128174003}
    ```

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your Resource group tile, click **AZ-220-HUB-{YOUR-ID}** to navigate to the Azure IoT Hub.

1. On the **IoT Hub** blade, click the **IoT devices** link under the **Explorers** section.

1. On the **IoT devices** pane, the `simulated-devices` **Device ID** will now display in the list of devices registered within the Azure IoT Hub. This registration was created by the automatic enrollment of the Device Provisioning Service (DPS) when the Simulated Device connected the first time.

1. Click on the **simulated-devices** Device ID in the list.

1. On the device details pane, click the **Device Twin** button at the top.

1. The **Device twin** pane displays the JSON for the Device Twin state for the **simulated-devices** Device ID.

1. Locate the `properties.desired` node within the Device Twin JSON. Add, or update if it already exists, the `telemetryDelay` property to have the value of `"2"`. This will update the `telemetryDelay` of the Simulated Device to send sensor telemetry every **2 seconds**.

    The resulting JSON for this section of the Device Twin Desired Properties will look similar to the following:

    ```json
    "properties": {
        "desired": {
          "telemetryDelay": "2",
          "$metadata": {
            "$lastUpdated": "2019-12-09T22:48:05.9703541Z",
            "$lastUpdatedVersion": 2,
            "telemetryDelay": {
              "$lastUpdated": "2019-12-09T22:48:05.9703541Z",
              "$lastUpdatedVersion": 2
            }
          },
          "$version": 2
        },
    ```

    Leave the `$metadata` and `$version` value of the `properties.desired` node within the JSON. You should only update the `telemetryDelay` value to set the new Device Twin Desired Property value.

1. Click **Save** to set the new Device Twin Desired Properties for the device. Once saved, the updated **Device Twin Desired Properties** will automatically be sent to the **Simulated Device**.

1. Go back to the **Visual Studio Code Terminal** window, where the Simulated Device is running, and notice the application has been notified of the updated Device Twin `telemetryDelay` Desired Property setting.

    The application outputs to the Console some messages that display that the new **Device Twin Desired Properties** have been loaded, and the changes have been set and reported back to the Azure IoT Hub.

    ```text
    Desired Twin Property Changed:
    {"telemetryDelay":2,"$version":2}
    Reported Twin Properties:
    {"telemetryDelay":2}
    ```

1. Notice the simulated device sensor telemetry messages are now being sent to Azure IoT Hub every **2 seconds**, now that the updated **Device Twin Desired Properties** have been sent to the device and the device has updated it's internal state accordingly.

    ```text
    12/9/2019 5:48:06 PM > Sending message: {"temperature":33.89822140284731,"humidity":78.34939097908763,"pressure":1024.9467544610131,"latitude":40.020042418755764,"longitude":-98.41923808825841}
    12/9/2019 5:48:09 PM > Sending message: {"temperature":27.475786026323114,"humidity":64.4175510594703,"pressure":1020.6866468579678,"latitude":40.2089999240047,"longitude":-98.26223221770334}
    12/9/2019 5:48:11 PM > Sending message: {"temperature":34.63600901637041,"humidity":60.95207713588703,"pressure":1013.6262313688063,"latitude":40.25499096898331,"longitude":-98.51199886959347}
    ```

1. To exit the **Simulated Device** app within the Terminal window, press **Ctrl + C**.

## Exercise 7: Retire Group Enrollment

In this exercise, you will retire an Enrollment Group and it's devices from both the Device Provisioning Service and Azure IoT Hub.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your Resource group tile, click **AZ-220-DPS-{YOUR-ID}** to navigate to the Device Provisioning Service.

1. On the Device Provisioning Service settings pane on the left side, click **Manage enrollments**.

1. Click on the **simulated-devices** in the list of Group Enrollments.

1. On the **Enrollment Group Details** pane, locate the **Enable entry** option and set it to **Disable**, then click **Save**.

    Disabling the Group Enrollment within DPS allows you to temporarily disable devices within this Enrollment Group. This provides a temporary blacklist of the x.509 certificate used by these devices.

1. To permanently delete the Enrollment Group, you must delete the **Enrollment Group** from DPS. To do this, check the box next to the **simulated-devices** **Group Name** on the **Manage enrollments** pane, then click the **Delete** button at the top.

1. When prompted to confirm the action to **Remove enrollment**, click **Yes**. Once deleted, the Group Enrollment is completely removed from DPS, and would need to be recreated to add it back.

    > [!NOTE] If you delete an enrollment group for a certificate, devices that have the certificate in their certificate chain might still be able to enroll if a different, enabled Enrollment Group still exists for the root certificate or another intermediate certificate higher up in their certificate chain.

1. Once the **Group Enrollment** has been removed from the Device Provisioning Service (DPS), the device registration will still existing within Azure IoT Hub. To fully retire the devices, you will need to remove that registration as well.

1. Within the Azure portal, on your Resource group tile, click **AZ-220-HUB-{YOUR-ID}** to navigate to the **Azure IoT Hub**.

1. On the **IoT Hub** blade, click on the **IoT devices** link under the **Explorers** section.

1. Notice that the **simulated-devices** Device ID still exists within the Azure IoT Hub device registry.

1. To remove the  **Device ID**, check box next to it in the list, then click the **Delete** button at the top of the pane.

1. When prompted with "_Are you certain you wish to delete selected device(s)_", click **Yes** to confirm and perform the deletion.

1. With the **Group Enrollment** delete from the Device Provisioning Service, and the **Device ID** deleted from the Azure IoT Hub device registry, the device(s) have fully been removed from the solution.

1. Run the **Simulated Device** again executing the `dotnet run` command within the Visual Studio Code **Terminal** window again.

1. Now that the **Group Enrollment** and **Device ID** have been deleted, the **Simulated Device** will no longer be able to connect. When the application attempts to use the configured x.509 certificate to connect to DPS, it will return a `ProvisioningTransportException` error message.

    ```txt
    Found certificate: AFF851ED016CA5AEB71E5749BCBE3415F8CF4F37 CN=simulated-device1; PrivateKey: True
    Using certificate AFF851ED016CA5AEB71E5749BCBE3415F8CF4F37 CN=simulated-device1
    RegistrationID = simulated-device1
    ProvisioningClient RegisterAsync . . . Unhandled exception. Microsoft.Azure.Devices.Provisioning.Client.ProvisioningTransportException: {"errorCode":401002,"trackingId":"df969401-c766-49a4-bab7-e769cd3cb585","message":"Unauthorized","timestampUtc":"2019-12-20T21:30:46.6730046Z"}
       at Microsoft.Azure.Devices.Provisioning.Client.Transport.ProvisioningTransportHandlerAmqp.ValidateOutcome(Outcome outcome)
       at Microsoft.Azure.Devices.Provisioning.Client.Transport.ProvisioningTransportHandlerAmqp.RegisterDeviceAsync(AmqpClientConnection client, String correlationId, DeviceRegistration deviceRegistration)
       at Microsoft.Azure.Devices.Provisioning.Client.Transport.ProvisioningTransportHandlerAmqp.RegisterAsync(ProvisioningTransportRegisterMessage message, CancellationToken cancellationToken)
    ```

    You have completed the registration, configuration, and retirement as part of the IoT devices life cycle with Device Provisioning Service.
