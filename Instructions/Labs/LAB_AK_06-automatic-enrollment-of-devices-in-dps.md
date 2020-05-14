---
lab:
    title: 'Lab 06: Automatically provision IoT devices securely and at scale with DPS'
    module: 'Module 3: Device Provisioning at Scale'
---

# Automatically provision IoT devices securely and at scale with DPS

## Lab Scenario

Your work to-date on Contoso's Asset Monitoring and Tracking Solution has enabled you to validate the device provisioning and de-provisioning process using an Individual Enrollment. The management team has now asked you to begin rolling out the process on a larger scale.

To keep the project moving forward you need to demonstrate that the Device Provisioning Service can be used to enroll larger numbers of devices automatically and securely using X.509 certificate authentication.

The following resources will be created:

![Lab 6 Architecture](media/LAB_AK_06-architecture.png)

## In This Lab

In this lab, you will complete the following activities:

* Verify that the lab prerequisites are met (that you have the required Azure resources)
* Generate and Configure X.509 CA Certificates using OpenSSL
* Create Group Enrollment in DPS
* Configure simulated device with X.509 Certificate
* Handle device twin desired property Changes
* Automatic Enrollment of simulated device
* Retire Group Enrollment of simulated device

## Lab Instructions

### Exercise 1: Verify Lab Prerequisites

This lab assumes that the following Azure resources are available:

| Resource Type | Resource Name |
| :-- | :-- |
| Resource Group | AZ-220-RG |
| IoT Hub | AZ-220-HUB-*{YOUR-ID}* |
| Device Provisioning Service | AZ-220-DPS-*{YOUR-ID}* |

If these resources are not available, you will need to run the **lab06-setup.azcli** script as instructed below before moving on to Exercise 2. The script file is included in the GitHub repository that you cloned locally as part of the dev environment configuration (lab 3).

The **lab06-setup.azcli** script is written to run in a **bash** shell environment - the easiest way to execute this is in the Azure Cloud Shell.

1. Using a browser, open the [Azure Cloud Shell](https://shell.azure.com/) and login with the Azure subscription you are using for this course.

    If you are prompted about setting up storage for Cloud Shell, accept the defaults.

1. Verify that the Azure Cloud Shell is using **Bash**.

    The dropdown in the top-left corner of the Azure Cloud Shell page is used to select the environment. Verify that the selected dropdown value is **Bash**.

1. On the Azure Shell toolbar, click **Upload/Download files** (fourth button from the right).

1. In the dropdown, click **Upload**.

1. In the file selection dialog, navigate to the folder location of the GitHub lab files that you downloaded when you configured your development environment.

    In _Lab 3: Setup the Development Environment_, you cloned the GitHub repository containing lab resources by downloading a ZIP file and extracting the contents locally. The extracted folder structure includes the following folder path:

    * Allfiles
      * Labs
          * 06-Automatic Enrollment of Devices in DPS
            * Setup

    The lab06-setup.azcli script file is located in the Setup folder for lab 6.

1. Select the **lab06-setup.azcli** file, and then click **Open**.

    A notification will appear when the file upload has completed.

1. To verify that the correct file has uploaded in Azure Cloud Shell, enter the following command:

    ```bash
    ls
    ```

    The `ls` command lists the content of the current directory. You should see the lab06-setup.azcli file listed.

1. To create a directory for this lab that contains the setup script and then move into that directory, enter the following Bash commands:

    ```bash
    mkdir lab6
    mv lab06-setup.azcli lab6
    cd lab6
    ```

1. To ensure the **lab06-setup.azcli** script has the execute permission, enter the following command:

    ```bash
    chmod +x lab06-setup.azcli
    ```

1. On the Cloud Shell toolbar, to edit the lab06-setup.azcli file, click **Open Editor** (second button from the right - **{ }**).

1. In the **Files** list, to expand the lab6 folder and open the script file, click **lab6**, and then click **lab06-setup.azcli**.

    The editor will now show the contents of the **lab06-setup.azcli** file.

1. In the editor, update the values of the `{YOUR-ID}` and `{YOUR-LOCATION}` variables.

    Referencing the sample below as an example, you need to set `{YOUR-ID}` to the Unique ID you created at the start of this course - i.e. **CAH191211**, and set `{YOUR-LOCATION}` to the location that makes sense for your resources.

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
    ./lab06-setup.azcli
    ```

    This will take a few minutes to run. You will see JSON output as each step completes.

    Once the script has completed, you will be ready to continue with the lab.

### Exercise 2: Generate and Configure X.509 CA Certificates using OpenSSL

In this exercise, you will generate an X.509 CA Certificate using OpenSSL within the Azure Cloud Shell. This certificate will be used to configure the Group Enrollment within the Device Provisioning Service (DPS).

#### Task 1: Generate the certificates

1. If necessary, log in to the [Azure portal](https://portal.azure.com) using the Azure account credentials that you are using for this course.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. In the top right of the portal window, to open the Azure Cloud Shell, click **Cloud Shell**.

    The Cloud Shell button has an icon that appears to represent a command prompt - **`>_`**.

    A Cloud Shell window will open near the bottom of the display screen.

1. In the upper left corner of the Cloud Shell window, ensure that **Bash** is selected as the environment option.

    > **Note**:  Both *Bash* and *PowerShell* interfaces for the Azure Cloud Shell support the use of **OpenSSL**. In this Exercise you will be using some helper scripts written for the *Bash* shell.

1. At the Cloud Shell command prompt, to download the Azure IoT helper scripts that you will be using, enter the following commands:

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

    The helper script and supporting files are being downloaded from the `Azure/azure-iot-sdk-c` open source project hosted on Github. This is an open source project that's a part of the Azure IoT SDK. The `certGen.sh` helper script will help demonstrate the purpose of CA Certificates without diving into the specifics of OpenSSL configuration that's outside the scope of this lab.

    For additional instructions on using this helper script, and for instructions on how to use PowerShell instead of Bash, please see this link: [https://github.com/Azure/azure-iot-sdk-c/blob/master/tools/CACertificates/CACertificateOverview.md](https://github.com/Azure/azure-iot-sdk-c/blob/master/tools/CACertificates/CACertificateOverview.md)

    > **WARNING**: Certificates created by this helper script **MUST NOT** be used for Production. They contain hard-coded passwords ("*1234*"), expire after 30 days, and most importantly are provided for demonstration purposes to help you quickly understand CA Certificates. When building products against CA Certificates, you'll need to use your own security best practices for certificate creation and lifetime management.

    If you are interested, you can quickly scan the contents of the script file that you downloaded by using the editor that's built-in to the Cloud Shell.

    * In the Cloud Shell, to open the editor, click **`{}`**.
    * In the FILES list, click **certificates**, and then click **certGen.sh**

    > **Note**: If you are experienced with other text file viewing tools in the Bash environment, such as the `more` or `vi` commands, you could also use those tools.

    The next step will be to use the script to create your root and intermediate certificates.

1. To generate the root and intermediate certificates, enter the following command:

    ```sh
    ./certGen.sh create_root_and_intermediate
    ```

    Notice that you ran the script with the `create_root_and_intermediate` option. This command assumes that you are running the script from within the `~/certificates` directory.

    This command generated a Root CA Certificate named `azure-iot-test-only.root.ca.cert.pem` and placed it within a `./certs` directory (under the certificates directory that you created).

1. To download the root certificate to your local machine (so it can be uploaded to DPS), enter the following command

    ```sh
    download ~/certificates/certs/azure-iot-test-only.root.ca.cert.pem
    ```

    You will be prompted to save the file to your local machine. Make a note of where the file is being saved, you will need it in the next task.

#### Task 2: Configure DPS to trust the root certificate

1. In your Azure portal, open your Device Provisioning Service.

    This is the Device Provisioning Service name `AZ-220-DPS-{YOUR-ID}`.

1. On the left side of the **Device Provisioning Service** blade, in the **Settings** section, click **Certificates**.

1. On the **Certificates** pane, at the top of the pane, click **+ Add**.  

    Clicking **+ Add** will start the process of uploading the X.509 CA Certificate to the DPS service.

1. On the **Add Certificate** pane, under **Certificate Name**, enter **root-ca-cert**.

    It is important to provide a name that enables you to differentiate between certificates, such as your root certificate and intermediate certificate, or multiple certificates at the hierarchy level within the chain.

    > **Note**: The root certificate name that you entered could be the same as the name of the certificate file, or something different. The name that you provided is a logical name that has no correlation to the _Common Name_ that is embedded within the contents X.509 CA Certificate.

1. Under **Certificate .pem or .cer file.**, to the right of the _Select a file_ text box, click **Open**.

    Clicking the **Open** button to the right of the text field will open an OPen file dialog that enables you to navigate to the `azure-iot-test-only.root.ca.cert.pem` CA Certificate that you downloaded earlier.

1. At the bottom of the pane, click **Save**.

    Once the X.509 CA Certificate has been uploaded, the _Certificates_ pane will display the certificate with the _Status_ of _Unverified_. Before this CA Certificate can be used to authenticate devices to DPS, you will need to verify **Proof of Possession** of the certificate.

1. To start the process of verifying **Proof of Possession** of the certificate, click **root-ca-cert**.

1. On the **Certificate Details** pane, click **Generate Verification Code**.

    You may need to scroll down to see the **Generate Verification Code** button.

    When you click the button it will place the generated code ino the Verification Code filed.

1. To the right of **Verification Code**, click **Copy to clipboard**.

    _Proof of Possession_ of the CA certificate is provided to DPS by uploading a certificate generated from the CA certificate with the verification code that was just generated within DPS. This is how you provide proof that you actually own the CA Certificate.

    > **IMPORTANT**: You will need to leave the **Certificate Details** pane open while you generate the verification certificate. If you close the pane, you will invalidate the verification code, and will need to generate a new one.

1. Open the **Azure Cloud Shell**, if it's not still open from earlier, and navigate to the `~/certificates` directory.

1. To create the verification certificate, enter the following command:

    ```sh
    ./certGen.sh create_verification_certificate <verification-code>
    ```

    Be sure to replace the `<verification-code>` placeholder with the **Verification Code** generated by the Azure portal.

    For example, the command that you run will look similar to the following:

    ```sh
    ./certGen.sh create_verification_certificate 49C900C30C78D916C46AE9D9C124E9CFFD5FCE124696FAEA
    ```

    This generates a _verification certificate_ that is chained to the CA certificate. The subject of the certificate is the verification code. The generated Verification Certificate named `verification-code.cert.pem` is located within the `./certs` directory of the Azure Cloud Shell.

    The next step is to download the verification certificate to your local machine (similar to what we did with the root certificate earlier), so that you can then upload it to DPS.

1. To download the verification certificate to your local machine, enter the following command:

    ```sh
    download ~/certificates/certs/verification-code.cert.pem
    ```

    > **Note**: Depending on the web browser, you may be prompted to allow multiple downloads at this point. If there appears to be no response to your download command, make sure there's not a prompt elsewhere on the screen asking for permission to allow the download.

1. Go back to the **Certificate Details** pane.

    If you recall, we had you leave this pane open in the Azure portal while you were working on the CA certificate within DPS.

1. At the bottom the **Certificate Details** pane, to the right of **Verification Certificate .pem or .cer file.**, click **Open**.

1. In the Open file dialog, navigate to your downloads folder, click **verification-code.cert.pem**, and then click **Open**.

1. At the bottom the **Certificate Details** pane, click **Verify**.

1. On the **Certificates** pane, verify that the **Status** for the certificate is now displayed as _Verified_.

    You may need to use the **Refresh** button at the top of the pane (to the right of the **Add** button) to see this change.

### Exercise 3: Create Group Enrollment (X.509 Certificate) in DPS

In this exercise, you will create a new enrollment group within the Device Provisioning Service (DPS) that uses _certificate attestation_.

#### Task 1: Create the enrollment

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your resource group tile, click **AZ-220-DPS-*{YOUR-ID}***.

1. On the left side of the Device Provisioning Service blade, under **Settings**, click **Manage enrollments**.

1. At the top of the blade, click **Add enrollment group**.

    Recall that an enrollment group is basically a record of the devices that may register through auto-provisioning.

1. On the **Add Enrollment Group** blade, for **Group name**, enter **simulated-devices**

1. Ensure that the **Attestation Type** is set to **Certificate**.

1. Ensure the **Certificate Type** field is set to **CA Certificate**.

1. In the **Primary Certificate** dropdown, select the CA certificate that was uploaded to DPS previously, likely **root-ca-cert**.

1. Leave the **Secondary Certificate** dropdown set to **No certificate selected**.

    The secondary certificate is generally used for certificate rotation, to accommodate expiring certificates or certificates that have been compromised. You can find more information on rolling certificates here: [https://docs.microsoft.com/en-us/azure/iot-dps/how-to-roll-certificates](https://docs.microsoft.com/en-us/azure/iot-dps/how-to-roll-certificates)

1. Leave **Select how you want to assign devices to hubs** as **Evenly weighted distribution**.

   In large environments where you have multiple distributed hubs, this setting will control how to choose what IoT Hub should receive this device enrollment. You will have a single IoT Hub associated with the enrollment in this lab, so how you assign devices to IoT hubs doesn't really apply within this lab scenario. 

1. Leave **Select how you want device data to be handled on re-provisioning** as the default value of **Re-provision and migrate data**.

    This field gives you high-level control over the re-provisioning behavior, where the same device (as indicated through the same Registration ID) submits a later provisioning request after already being provisioned successfully at least once.

1. Notice the **Select the IoT hubs this group can be assigned to** dropdown has the **AZ-220-HUB-*{YOUR-ID}*** IoT Hub selected.

    This will ensure when the device is provisioned, it gets added to this IoT Hub.

1. In the **Initial Device Twin State** field, modify the JSON object as follows:

    ```json
    {
        "tags": {},
        "properties": {
            "desired": {
                "telemetryDelay": "1"
            }
        }
    }
    ```

    This JSON data represents the initial configuration of device twin desired properties for any device that participates in this enrollment group.

    The Device will use the `properties.desired.telemetryDelay` property to set the time delay for reading and sending telemetry to IoT Hub.

1. Leave **Enable entry** set to **Enable**.

    Generally, you'll want to enable new enrollment entries and keep them enabled.

1. At the top of the **Add Enrollment** blade, click **Save**.

#### Task 2: Validate the enrollment

1. Verify that the **Enrollment Groups** tab is displayed and that your new enrollment group is listed.

    If your enrollment group is not listed, click **Refresh** at the top of the blade.

1. In the Group Name list, click **simulated-devices**.

1. In the **Enrollment Group Details** blade, verify the following:

    * **Certificate Type** is set to **CA Certificate**
    * **Primary Certificate** is set to **root-ca-cert**
    * **Secondary Certificate** is set to **No certificate selected**
    * **Select how you want to assign devices to hubs** is set to **Evenly weighted distribution**
    * **Select the IoT hubs this group can be assigned to:** is set to **AZ-220-HUB-{YOUR-ID}.azure-devices.net**
    * **Initial device Twin State** contains the `telemetryDelay` property set to the value of `"1"`

1. After you have verified the Enrollment Group settings, close the **Enrollment Group Details** blade.

### Exercise 4: Configure simulated device with X.509 certificate

In this exercise, you will configure a simulated device written in C# to connect to your Azure IoT Hub via your Device Provisioning Service (DPS) using an X.509 certificate. This exercise will also introduce you to the workflow within the **simulated device** source code, and how it works to authenticate with DPS and send messages to IoT Hub.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On the Toolbar at the top of the Azure portal window, click **Cloud Shell**

    Verify that the **Bash** shell option is selected in the upper left corner of the Cloud Shell.

1. Within the **Cloud Shell**, navigate to the `~/certificates` directory by running the following command:

    ```sh
    cd ~/certificates
    ```

    The `~/certificates` directory is where the `certGen.sh` helper scripts were downloaded. You used them to generate the CA Certificate for DPS previously. This helper script will also be used to generate a device certificate within the CA Certificate chain.

1. To generate an _X.509 device certificate_ within the CA certificate chain, enter the following command:

    ```sh
    ./certGen.sh create_device_certificate simulated-device1
    ```

    This command will create a new X.509 certificate that's signed by the CA certificate that was generated previously. Notice that the device id (`simulated-device1`) is passed to the `create_device_certificate` command of the `certGen.sh` script. This device id will be set within the _common name_, or `CN=`, value of the device certificate. This certificate will generate a leaf device X.509 certificate for your simulated device, and will be used to authenticate the device with the Device Provisioning Service (DPS).

    Once the `create_device_certificate` command has completed, the generated X.509 device certificate will be named `new-device.cert.pfx`, and will be located within the `/certs` sub-directory.

    > **Note**: This command overwrites any existing device certificate in the `/certs` sub-directory. If you want to create a certificate for multiple devices, ensure that you save a copy of the `new-device.cert.pfx` each time you run the command.

1. To download the generated X.509 device certificate from the Cloud Shell to your local machine, enter the following command:

    ```sh
    download ~/certificates/certs/new-device.cert.pfx
    ```

    The simulated device will be configured to use this X.509 device certificate to authenticate with the Device Provisioning Service.

1. Within the Azure portal, navigate to the **Device Provisioning Service** blade, and the **Overview** pane.

1. On the **Overview** pane, copy the **ID Scope** for the Device Provisioning Service, and save it for reference later.

    There is a copy button to the right of the value that will appear when you hover over the value.

    The **ID Scope** will be similar to this value: `0ne0004E52G`

1. Open Windows File Explorer, and then navigate to the folder where `new-device.cert.pfx` was downloaded.

1. Use File Explorer to create a copy of the `new-device.cert.pfx` file.

1. In File Explorer, navigate to the Starter folder for lab 6 (Automatic Enrollment of Devices in DPS).

    In _Lab 3: Setup the Development Environment_, you cloned the GitHub repository containing lab resources by downloading a ZIP file and extracting the contents locally. The extracted folder structure includes the following folder path:

    * Allfiles
      * Labs
          * 06-Automatic Enrollment of Devices in DPS
            * Starter

1. Paste the `new-device.cert.pfx` file into the Starter folder.

    The root directory of the Lab 6 Starter folder includes the `Program.cs` file. The **simulated device** project will need to access this certificate file when authenticating to the Device Provisioning Service.

1. Open **Visual Studio Code**.

1. On the **File** menu, click **Open Folder**

1. In the Open Folder dialog, navigate to the **06-Automatic Enrollment of Devices in DPS** folder.

1. Click **Starter**, and then click **Select Folder**.

    You should see the following files listed in the EXPLORER pane of Visual Studio Code:

    * new-device.cert.pfx
    * Program.cs
    * SimulatedDevice.csproj

1. Open the `SimulatedDevice.csproj` file.

1. In the `SimulatedDevice.csproj` file, ensure that the `<ItemGroup>` tag includes the following: 

    ```xml
        <None Update="new-device.cert.pfx" CopyToOutputDirectory="PreserveNewest" />
    ```

    If it's not there, add it. When you are done, the `<ItemGroup>` tag should look similar to the following:

    ```xml
            <ItemGroup>
                <None Update="new-device.cert.pfx" CopyToOutputDirectory="PreserveNewest" />
                <PackageReference Include="Microsoft.Azure.Devices.Client" Version="1.21.1" />
                <PackageReference Include="Microsoft.Azure.Devices.Provisioning.Transport.Mqtt" Version="1.1.8" />
                <PackageReference Include="Microsoft.Azure.Devices.Provisioning.Transport.Amqp" Version="1.1.9" />
                <PackageReference Include="Microsoft.Azure.Devices.Provisioning.Transport.Http" Version="1.1.6" />
            </ItemGroup>
        </Project>
    ```

    This configuration ensures that the `new-device.cert.pfx` certificate file is copied to the build folder when the C# code is compiled, and made available for the program to access when it executes.

    > **Note**: The exact `PackageReference` entries may be a bit different, depending on the exact version of the lab code you are using.

1. On the Visual Studio Code **File** menu, click **Save**.

1. Open the `Program.cs` file.

1. Locate the `GlobalDeviceEndpoint` variable, and notice that its value is set to the Global Device Endpoint for the Azure Device Provisioning Service (`global.azure-devices-provisioning.net`). 

    Within the Public Azure Cloud, `global.azure-devices-provisioning.net` is the Global Device Endpoint for the Device Provisioning Service (DPS). All devices connecting to Azure DPS will be configured with this Global Device Endpoint DNS name. You should see code that is similar to the following:

    ```csharp
    private const string GlobalDeviceEndpoint = "global.azure-devices-provisioning.net";
    ```

1. Locate the `dpsIdScope` variable, and replace the assigned value with the **ID Scope** that you copied from the Overview pane of the Device Provisioning Service.

    When you have updated your code, it should look similar to the following:

    ```csharp
    private static string dpsIdScope = "0ne000CBD6C";
    ```

1. Locate the `s_certificateFileName` variable, and notice that its value is set to the device certificate file that you generated (`new-device.cert.pfx`).

    The `new-device.cert.pfx` file is the X.509 device certificate file that you generated using the `certGen.sh` helper script within the Cloud Shell. This variable tells the device code which file contains the X.509 device certificate that it will use when authenticating with the Device Provisioning Service.

1. Locate the `s_certificatePassword` variable, and notice that its value is set to the default password for the `certGen.sh` script.

    The `s_certificatePassword` variable contains the password for the X.509 device certificate. It's set to `1234`, as this is the default password used by the `certGen.sh` helper script when generating the X.509 certificates.

    > **Note**: For the purpose of this lab, the password is hard coded. In a _production_ scenario, the password will need to be stored in a more secure manner, such as in an Azure Key Vault. Additionally, the certificate file (PFX) should be stored securely on a production device using a Hardware Security Module (HSM).
    >
    > An HSM (Hardware Security Module), is used for secure, hardware-based storage of device secrets, and is the most secure form of secret storage. Both X.509 certificates and SAS tokens can be stored in the HSM. HSMs can be used with all attestation mechanisms the provisioning service supports.

1. Locate the `public static int Main` method, and then take a minute to review the code. 

    The Main method is the entry point for the simulated device app. Notice that the first thing it does is to call the `LoadProvisioningCertificate` method, which returns an `X509Certificate2` object.

1. Scroll down to locate the `LoadProvisioningCertificate` method, and then take a minute to review the code used to generate the `X509Certificate2` object.

    Notice that `LoadProvisioningCertificate` uses `s_certificateFileName` to load the X.509 device certificate (from the `new-device.cert.pfx` file).

1. Scroll back up to the `public static int Main` method, and then take a minute to review the code inside the nested `using` statements.

    Notice that this code initiates a `security` `SecurityProviderX509Certificate` object for the X.509 Device Certificate, and that it creates a `transport` `ProvisioningTransportHandlerAmqp` object which defines that the simulated device will be using AMQP as the communications protocol when connecting to Azure IoT Hub.

    Notice that the `security` and `transport` objects, along with the DPS ID scope and DPS global device endpoint, are passed to `ProvisioningDeviceClient.Create` method. The ProvisioningDeviceClient object, `provClient`, will be used to register the device with the Device Provisioning Service.

    Notice that `ProvisioningDeviceLogic` is instantiated by passing it the `provClient` and `security` objects. The `ProvisioningDeviceLogic` class is used to define the logic for the device (simulated device). It contains the code for simulating a running device by reading from the simulated device sensors and sending device-to-cloud messages to Azure IoT Hub. It will also be modified later to include code that updates the device according to changes to device twin desired properties that are sent to the device from the cloud.

1. Scroll down to the `ProvisioningDeviceLogic` class, and then locate the `RunAsync` method.

    We will take a minute to review the `RunAsync` method, pointing out some of the key points.

1. Within the `RunAsync` method, notice the code containing ProvisioningDeviceClient.RegisterAsync method (shown below).

    ```csharp
    DeviceRegistrationResult result = await _provClient.RegisterAsync().ConfigureAwait(false);
    ```

    The RegisterAsync method is used to register the device using the Device Provisioning Service and assign it to an Azure IoT Hub.

1. Notice the code that instantiates a new `DeviceAuthenticationWithX509Certificate` object (shown below). 

    ```csharp
    var auth = new DeviceAuthenticationWithX509Certificate(result.DeviceId, (_security as SecurityProviderX509).GetAuthenticationCertificate());
    ```

    This is a Device Authentication object that will be used to authenticate the simulated device to Azure IoT Hub using the X.509 Device Certificate. The constructor is being passed the device ID for the device that was registered in DPS, as well as the X.509 device certificate to authenticate the device.

1. Notice the code that calls the `DeviceClient.Create` method.

    ```csharp
    using (iotClient = DeviceClient.Create(result.AssignedHub, auth, TransportType.Amqp))
    {
    ```

    The `DeviceClient.Create` method is used to create a new IoT `DeviceClient` object, which will be used to communicate with the Azure IoT Hub service. Notice that this code passes the value of `TransportType.Amqp`, telling the `DeviceClient` to communicate with the Azure IoT Hub using the AMQP protocol. Alternatively, Azure IoT Hub can be connected to and communicated with using the MQTT or HTTP protocols, depending on network architecture, device requirements, etc.

1. Notice the call to the `SendDeviceToCloudMessagesAsync` method. 

    ```csharp
    await SendDeviceToCloudMessagesAsync(iotClient);
    ```

    The `SendDeviceToCloudMessagesAsync` method is a separate method that is defined further done in the code. This method contains the code that is used to read from simulated sensors and to send device-to-cloud messages to Azure IoT Hub. This method also contains a loop that continues to execute while the simulated device is running.

1. Still within the RunAsync method, notice the call to the `DeviceClient.CloseAsync` method.

    ```csharp
    await iotClient.CloseAsync().ConfigureAwait(false);
    ```

    This method closes the `DeviceClient` object, thus closing the connection with Azure IoT Hub. This is the last line of code executed when the simulated device shuts down.

1. Scroll down to locate the `SendDeviceToCloudMessagesAsync` method.

    Again, we will point out a few key details.

1. Notice the code that generates simulated sensor readings (shown below).

    ```csharp
    double currentTemperature = minTemperature + rand.NextDouble() * 15;
    double currentHumidity = minHumidity + rand.NextDouble() * 20;
    double currentPressure = minPressure + rand.NextDouble() * 12;
    double currentLatitude = minLatitude + rand.NextDouble() * 0.5;
    double currentLongitude = minLongitude + rand.NextDouble() * 0.5;
    ```

    For each sensor type, a random value is added to a min sensor value within the while loop. The min value is initialized outside the loop. This creates a range of sensor value readings that can be reported to your IoT hub.

1. Notice the code used to combined sensor readings into a JSON object:

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

    IoT hub requires a properly formatted message.

1. Notice the line of code that adds a `temperatureAlert` property to the device-to-cloud `Message`.

    ```csharp
    message.Properties.Add("temperatureAlert", (currentTemperature > 30) ? "true" : "false");
    ```

    The value of the `temperatureAlert` property is being set to a `boolean` value representing whether the _temperature_ sensor reading is greater than 30. Since we are generating temperature readings that range from 20 to 35, temperatureAlert should be "true" about one-third of the time. 

    This code is a simple example of how to add properties to the `Message` object before sending it to the Azure IoT Hub. This can be used to add additional metadata to the messages that are being sent, in addition to the message body content.

1. Notice the call to the `DeviceClient.SendEventAsync` method.

    ```csharp
    await deviceClient.SendEventAsync(message);
    ```

    The `SendEventAsync` method accepts our generated `message` to send as a parameter, then does the work of sending the device-to-cloud message to Azure IoT Hub.

1. Notice the call to the `Delay` method that is used to set the time between Device-to-Cloud telemetry messages.

    This simple delay uses the `_telemetryDelay` variable to define how many seconds to wait until sending the next simulated sensor reading. In the next exercise we will use a device twin property to control the delay time.

### Exercise 5: Handle device twin desired property Changes

Device twins are JSON documents that store device state information including metadata, configurations, and conditions. Azure IoT Hub maintains a device twin for each device that you connect to IoT Hub.

The Device Provisioning Service (DPS) contains the initial device twin desired properties for devices that are registered using Group Enrollment. Once the devices are registered they are created within IoT Hub using this initial device twin configuration from DPS. After registration, the Azure IoT Hub maintains a device twin (and its properties) for each device within the IoT Hub Device Registry.

When the device twin desired properties are updated for a device within Azure IoT Hub, the desired changes are sent to the IoT device using the `DesiredPropertyUpdateCallback` event that is included in IoT SDKs (the C# SDK in this case). Handling this event within device code enables the device's configuration and properties to be updated as desired by easily managing the Device Twin state for the device (with IoT Hub providing access).

In this exercise, you will modify the simulated device source code to include an event handler that updates the device configuration based on device twin desired property changes that are sent to the device from Azure IoT Hub.

> **Note**: The set of steps used here are very similar to steps in earlier labs when working with a simulated device because the concepts and processes are the same.  The method used for authentication within the provisioning process doesn't change the handling of device twin property changes once the device is provisioned.

1. Using **Visual Studio Code**, open the **Starter** folder for lab 6.

    If you have the code project open from the previous exercise, continue working in the same code files.

1. Open the `Program.cs` file.

1. Locate the `ProvisioningDeviceLogic` class, and then scroll down to the `RunAsync` method.

   This is the method that connects the simulated device to Azure IoT Hub using a `DeviceClient` object. You will be adding code that integrates an `DesiredPropertyUpdateCallback` event handler for the device to receive to device twin desired property changes. This code will run immediately after the device connects to Azure IoT Hub. 

1. Locate the `// TODO 1` comment, and then paste in the following code:

    ```csharp
    // TODO 1: Setup OnDesiredPropertyChanged Event Handling to receive Desired Properties changes
    Console.WriteLine("Connecting SetDesiredPropertyUpdateCallbackAsync event handler...");
    await iotClient.SetDesiredPropertyUpdateCallbackAsync(OnDesiredPropertyChanged, null).ConfigureAwait(false);
    ```

    The `iotClient` object is an instance of `DeviceClient`. The `SetDesiredPropertyUpdateCallbackAsync` method is used to set up the `DesiredPropertyUpdateCallback` event handler to receive device twin desired property changes. This code configures `iotClient` to call a method named `OnDesiredPropertyChanged` when a device twin property change event is received.

    Now that the `SetDesiredPropertyUpdateCallbackAsync` method is in place to set up the event handler, we need to create the `OnDesiredPropertyChanged` method that it calls.

1. Position the cursor on a blank code line just below the `RunAsync` method.

1. To define the `OnDesiredPropertyChanged` method, paste in the following code:

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

    Notice that the `OnDesiredPropertyChanged` event handler accepts a `desiredProperties` parameter of type `TwinCollection`. 

    Notice that `if` the value of the `desiredProperties` parameter contains `telemetryDelay` (a device twin desired property), the code will assign the value of the device twin property to the `this._telemetryDelay` variable. You may recall that the `SendDeviceToCloudMessagesAsync` method include a `Task.Delay` call that uses the `this._telemetryDelay` variable to set the delay time between messages sent to IoT hub.

    Notice the next block of code is used to report the current state of the device back up to Azure IoT Hub. This code calls the `DeviceClient.UpdateReportedPropertiesAsync` method and passes it a **TwinCollection** that contains the current state of the device properties. This is how the device reports back to IoT Hub that it received the device twin desired properties changed event, and has now updated its configuration accordingly. Note that it reports what the properties are now set to, not an echo of the desired properties. In the case where the reported properties sent from the device are different than the desired state that the device received, IoT Hub will maintain an accurate Device Twin that reflects the state of the device.

    Now that the device can receive updates to the device twin desired properties from Azure IoT Hub, it also needs to be coded to configure its initial setup when the device starts up. To do this the device will need to load the current device twin desired properties from Azure IoT Hub, and configure itself accordingly. 

1. Locate the `// TODO 2` comment within the `RunAsync` method.

1. To implement code that runs the `OnDesiredPropertyChanged` method on device start-up, enter the following code:

    ```csharp
    // TODO 2: Load Device Twin Properties since device is just starting up
    Console.WriteLine("Loading Device Twin Properties...");
    var twin = await iotClient.GetTwinAsync().ConfigureAwait(false);
    // Use OnDesiredPropertyChanged event handler to set the loaded Device Twin Properties (re-use!)
    await OnDesiredPropertyChanged(twin.Properties.Desired, null);
    ```

    Notice the call to the `DeviceClient.GetTwinAsync` method. This method can be used by the device to retrieve the current Device Twin state at any time. It's used in this case so the device can configure itself to match the device twin desired properties when the device first starts execution.

    In this case, the `OnDesiredPropertyChanged` event handler method is being reused to keep the configuration of the `telemetryDelay` property based on the device twin desired properties to a single place. This will help make the code easier to maintain over time.

1. On the Visual Studio Code **File** menu, click **Save**.

### Exercise 6: Test the Simulated Device

In this exercise, you will run the simulated device. When the device is started for the first time, it will connect to the Device Provisioning Service (DPS) and automatically be enrolled using the configured group enrollment. Once enrolled into the DPS group enrollment, the device will be automatically registered within the Azure IoT Hub device registry. Once enrolled and registered, the device will begin communicating with Azure IoT Hub securely using the configured X.509 certificate authentication.

#### Task 1: Build and run the device

1. Using **Visual Studio Code**, open the **Starter** folder for lab 6.

    If you have the code project open from the previous exercise, continue working in the same code files.

1. On the Visual Studio Code **View** menu, click **Terminal**.

    This will open the integrated Terminal at the bottom of the Visual Studio Code window.

1. At the Terminal command prompt, ensure that the current directory path is set to the `/Starter` folder.

    You should see something similar to the following:

    `Allfiles\Labs\06-Automatic Enrollment of Devices in DPS\Starter>`

1. To build and run the **SimulatedDevice** project, enter the following command:

    ```cmd/sh
    dotnet run
    ```

    > **Note**:  When running `dotnet run` for the simulated device, if a `ProvisioningTransportException` exception is displayed, the most common cause is an _Invalid certificate_ error. If this happens, ensure the CA Certificate in DPS, and the Device Certificate for the simulated device application are configured correctly.
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

1. Notice the Console outputs from the simulated device app that are displayed in Terminal window.

    When the simulated device application runs, the **Terminal** will display the Console output from the app. 

    Scroll up to the top of the information displayed in the Terminal window.

    Notice the X.509 certificate was loaded, the device was registered with the Device Provisioning Service, it was assigned to connect to the **AZ-220-HUB-*{YOUR-ID}*** IoT Hub, and the device twin desired properties are loaded.

    ```text
    localmachine:LabFiles User$ dotnet run
    Found certificate: AFF851ED016CA5AEB71E5749BCBE3415F8CF4F37 CN=simulated-device1; PrivateKey: True
    Using certificate AFF851ED016CA5AEB71E5749BCBE3415F8CF4F37 CN=simulated-device1
    RegistrationID = simulated-device1
    ProvisioningClient RegisterAsync . . . Device Registration Status: Assigned
    ProvisioningClient AssignedHub: AZ-220-HUB-CP1119.azure-devices.net; DeviceID: simulated-device1
    Creating X509 DeviceClient authentication.
    simulated device. Ctrl-C to exit.
    DeviceClient OpenAsync.
    Connecting SetDesiredPropertyUpdateCallbackAsync event handler...
    Loading Device Twin Properties...
    Desired Twin Property Changed:
    {"$version":1}
    Reported Twin Properties:
    {"telemetryDelay":1}
    Start reading and sending device telemetry...
    ```

    To review the source code for the simulated device, open the `Program.cs` source code file. Look for several `Console.WriteLine` statements that are used to output the messages seen to the console.

1. Notice that JSON formatted telemetry messages are being sent to Azure IoT Hub.

    ```text
    Start reading and sending device telemetry...
    12/9/2019 5:47:00 PM > Sending message: {"temperature":24.047539159212047,"humidity":67.00504162675004,"pressure":1018.8478924248358,"latitude":40.129349260196875,"longitude":-98.42877188146265}
    12/9/2019 5:47:01 PM > Sending message: {"temperature":26.628804161040485,"humidity":68.09610794675355,"pressure":1014.6454375411363,"latitude":40.093269544242695,"longitude":-98.22227128174003}
    ```

    Once the simulated device has passed through the initial start up, it will begin sending simulated sensor telemetry messages to Azure IoT Hub.

    Notice that the delay, as defined by the `telemetryDelay` Device Twin Property, between each message sent to IoT Hub is currently delaying **1 second** between sending sensor telemetry messages.

    Keep the simulated device running for the next task.

#### Task 2: Change the device configuration through its twin

With the simulated device running, the `telemetryDelay` configuration can be updated by editing the device twin Desired State within Azure IoT Hub. This can be done by configuring the Device in the Azure IoT Hub within the Azure portal.

1. Open the **Azure portal** , and then navigate to your **Azure IoT Hub** service.

1. On the IoT Hub blade, on the left side of the blade, under the **Explorers** section, click on **IoT devices**.

1. Within the list of IoT devices, click **simulated-device1**.

    > **IMPORTANT**: Make sure you select the device from this lab. You may also see a device named _SimulatedDevice1_ that was created during a previous lab.

1. On the device blade, at the top of the blade, click **Device Twin**.

    Within the **Device twin** blade, there is an editor with the full JSON for the device twin. This enables you to view and/or edit the device twin state directly within the Azure portal.

1. Locate the `properties.desired` node within the Device Twin JSON. Update the `telemetryDelay` property to have the value of `"2"`. Once saved, this will update the `telemetryDelay` of the simulated device to send sensor telemetry every **2 seconds**.

    The resulting JSON for this section of the device twin desired properties will look similar to the following:

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

    Leave the `$metadata` and `$version` value of the `properties.desired` node within the JSON. You should only update the `telemetryDelay` value to set the new device twin desired property value.

1. At the top of the blade, to set the new device twin desired properties for the device, click **Save**. 

    Once saved, the updated device twin desired properties will automatically be sent to the simulated device.

1. Go back to the **Visual Studio Code Terminal** window, where the simulated device is running, and notice the application has been notified of the updated device twin `telemetryDelay` desired property setting.

    The application outputs messages to the Console that show that the new device twin desired properties have been loaded, and the changes have been set and reported back to the Azure IoT Hub.

    ```text
    Desired Twin Property Changed:
    {"telemetryDelay":2,"$version":2}
    Reported Twin Properties:
    {"telemetryDelay":2}
    ```

1. Notice the simulated device sensor telemetry messages are now being sent to Azure IoT Hub every _2_ seconds.

    ```text
    12/9/2019 5:48:06 PM > Sending message: {"temperature":33.89822140284731,"humidity":78.34939097908763,"pressure":1024.9467544610131,"latitude":40.020042418755764,"longitude":-98.41923808825841}
    12/9/2019 5:48:09 PM > Sending message: {"temperature":27.475786026323114,"humidity":64.4175510594703,"pressure":1020.6866468579678,"latitude":40.2089999240047,"longitude":-98.26223221770334}
    12/9/2019 5:48:11 PM > Sending message: {"temperature":34.63600901637041,"humidity":60.95207713588703,"pressure":1013.6262313688063,"latitude":40.25499096898331,"longitude":-98.51199886959347}
    ```

1. Within the **Terminal** window, to exit the simulated device app, press **Ctrl-C**.

1. In the Azure Portal, close the **Device twin** blade.

1. Still in the Azure Portal, on the simulated-device1 blade, click **Device Twin**.

1. Scroll down to locate the JSON for the `properties.reported` object.

    This contains the state reported by the device. Notice the `telemetryDelay` property exists here as well, and is also set to `2`.  There is also a `$metadata` value that shows you when the value was reported data was last updated and when the specific reported value was last updated.

1. Again close the **Device twin** blade.

1. Close the simulated-device1 blade, and then navigate back to your Azure portal Dashboard.

### Exercise 7: Retire Group Enrollment

In this exercise, you will retire the enrollment group and its devices from both the Device Provisioning Service and Azure IoT Hub.

#### Task 1: Retire the enrollment group from the DPS

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your resource group tile, to navigate to the Device Provisioning Service, click **AZ-220-DPS-*{YOUR-ID}***.

1. On the left side menu, under **Settings**, click **Manage enrollments**.

1. In the list of **Enrollment Groups**, click **simulated-devices**.

1. On the **Enrollment Group Details** blade, scroll down to locate the **Enable entry** field, and then click **Disable**.

    Disabling the Group Enrollment within DPS allows you to temporarily disable devices within this Enrollment Group. This provides a temporary blacklist of the X.509 certificate used by these devices.

1. At the top of the blade, click **Save**.

    To permanently delete the Enrollment Group, you must delete the enrollment group from DPS. 

1. On the **Manage enrollments** pane, under **GROUP NAME**, select the check box to the left of **simulated-devices**.

    If the check box to the left of **simulated-devices** was already checked, leave it checked.

1. At the top of the **Manage enrollments** pane, click **Delete**.

1. When prompted to confirm the action to **Remove enrollment**, click **Yes**.

   Once deleted, the Group Enrollment is completely removed from DPS, and would need to be recreated to add it back.

    > **Note**:  If you delete an enrollment group for a certificate, devices that have the certificate in their certificate chain might still be able to enroll if a different, enabled enrollment group still exists for the root certificate or another intermediate certificate higher up in their certificate chain.

1. Navigate back to your Azure portal Dashboard

#### Task 2: Retire the device from the IoT Hub

Once the enrollment group has been removed from the Device Provisioning Service (DPS), the device registration will still exist within Azure IoT Hub. To fully retire the devices, you will need to remove that registration as well.

1. Within the Azure portal, on your resource group tile, click **AZ-220-HUB-*{YOUR-ID}***.

1. On the left side of the **IoT Hub** blade, under **Explorers**, click **IoT devices**.

1. Notice that the **simulated-device1** device ID still exists within the Azure IoT Hub device registry.

1. To remove the device, select the check box to the left of **simulated-device1**, then click **Delete**.

    The **Delete** button located at the top of the blade will be enabled once a device (check box) is selected.

1. When prompted with "_Are you certain you wish to delete selected device(s)_", click **Yes**.

#### Task 3: Verify the retirement

With the group enrollment deleted from the Device Provisioning Service, and the device deleted from the Azure IoT Hub device registry, the device(s) have fully been removed from the solution.

1. Switch to the Visual Studio Code window containing your SimulatedDevice code project.

    If you closed Visual Studio Code after the previous exercise, use Visual Studio Code to open the lab 6 Starter folder.

1. On the Visual Studio Code **View** menu, click **Terminal**.

1. Ensure that the command prompt is locate at the **Starter** folder location

1. To begin running the simulated device app, enter the following command:

    ```cmd/sh
    dotnet run
    ```

1. Notice the exceptions listed when the device attempts to provision.

    Now that the group enrollment and registered device have been deleted, the simulated device will no longer be able to provision nor connect. When the application attempts to use the configured X.509 certificate to connect to DPS, it will return a `ProvisioningTransportException` error message.

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
