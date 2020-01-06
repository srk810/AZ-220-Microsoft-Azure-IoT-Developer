# Set up your Development Environment

In this unit, you will prepare the process to connect a real device to IoT Central. By "real" IoT Central understands that there is a remote app running - the app can be in a real device, taking input from real sensors, or running a simulation. Both options are treated as a connection to a real device.

The essential component for communication between a device and IoT Central is a connection string. There are some tools that make generating these strings easy. In this unit, you will access these tools in such as way that you can reuse them later on. To start with, you need some information on our real device.

## Add a Real Device

1. With your Refrigerated Truck app open in the [Azure IoT Central](https://apps.azureiotcentral.com/) portal, select **Devices** from the left-hand menu.

1. To add a real device, under the **RefrigeratedTruck (1.0.0)** title, in the toolbar, click the **+** dropdown and select **Real**.

    The **Create New Device** popup will be displayed.

1. In the **Create New Device** popup, under **Device ID**, note that a unique value has been supplied - leave this unchanged.

1. Under **Device Name**, note that a value has already been populated using the template name and the Device ID above - change this to be a more readable value by entering **RefrigeratedTruck - 1**.

1. To create the device, click **Create**.

    When the device is created, the **Device** page will be displayed. You will notice the phrase "Waiting for data" where the telemetry would normally be. Once the device starts transmitting data this phrase will change.

1. At the top-left of the screen you will find 3 buttons that perform actions on this device: **Block**, **Connect** and **Delete**. 

1. To view the **Device connection** details, click on the **Connect** button.

    The **Device connection** popup will be displayed.

1. As we will use the **Shared access signature (SAS)** attestation mechanism, under **Credentials** select  **Shared access signature (SAS)**.

1. Copy the **ID Scope**, **Device ID**, and **Primary Key**, to a text document, using an app such as Notepad or TextEdit.

1. Save the text file. You will be using these values after installing and running a few utilities to generate connection strings.

1. On the **Device connection** popup, click **Close**.

We are now ready to use these details to generate a connection string for the device.

## Generate a Connection String

All of the work to generate connection strings is handled through Azure Cloud Shell.

1. Open a new tab on your browser and navigate to the [Azure Cloud Shell](https://shell.azure.com/).

1. Login to you Azure Subscription (the same one you used for your IoT Central App) and if your account is a member of more than one directory, choose the directory you used for your IoT Central account.

    On first launch, Cloud Shell prompts to create a resource group, storage account, and Azure Files share on your behalf. Follow the steps to setup you Azure Cloud Shell. Choose to use a **bash** shell.

1. Once the shell has opened, verify you are using a **bash** shell by checking the dropdown in the top-left of the shell page - it will either display **Bash** or **Powershell**. If **Powershell** is displayed, select **Bash** and the current shell will close and a new one will open.

1. Once the bash shell is open, create** a **refrigerated-truck** folder, and navigate to it by entering the following commands:

    ```bash
    mkdir ~/refrigerated-truck
    cd ~/refrigerated-truck
    ```

1. To install the Device Provisioning System (DPS) key generator (*dps-keygen*) in the refrigerated-truck folder by using the Node Package Manager (npm) tool, enter the following command:

    ```bash
    npm install dps-keygen
    ```

    The `npm` tool is the package manager for the Node JavaScript platform. It puts modules in place so that node can find them, and manages dependency conflicts intelligently. You can learn more about the tool [here](https://docs.npmjs.com/cli/npm).

    > [!NOTE] You can review all of the tools installed with the Azure Cloud Shell [here](https://docs.microsoft.com/en-us/azure/cloud-shell/features#tools).

1. To install the DPS connection string utility (*dps-str*) from GitHub, enter the following command:

    ```bash
    wget https://github.com/Azure/dps-keygen/blob/ota/bin/linux/dps_cstr?raw=true -O dps_cstr
    ```

    The `wget` tool is used to download files from the web. You can learn more about the tool [here](http://www.gnu.org/software/wget/manual/wget.html). The command above will download the file and save it to the current directory and name it **dps_cstr**.

    > [!NOTE] You may have noticed in the above URL that you are downloading the Linux version of *dps-cstr*. This is needed to run in Azure Cloud Shell.

1. To give the **dps_cstr** utility the execute permission so we can run it, enter the following command:

    ```bash
    chmod +x dps_cstr
    ```

1. Remember that in the previous section you stored a **ID Scope**, **Device ID**, and **Primary Key**, for our device? Ifg it isn't already open, open it add the following string to the bottom of the file:

    ```bash
    ./dps_cstr {id-scope} {device-id} {primary-key} > connection1.txt
    ```

1. Update the above string, replacing **{id-scope}**, **{device-id}**, and **{primary-key}** with your own values. Using the text document enables you to create and validate the string before committing to running it.

1. Now copy this command from your text document into the command-line of the Azure Cloud Shell, and run it.

    This command runs for a few seconds and creates a new file called **connection1.txt** in the current directory.

1. To view the contents of the **connection1.txt** file, use the **{ }** icon in Azure Cloud Shell to open the **Cloud Editor**.

1. To open the **connection1.txt** file, you will probably have to expand the **refrigerated-truck** node in the **Files** list to locate it. Double-click on **connection1.txt** to open the file. Carefully copy all the contents to your local text tool.

    The file will look similar to:

    ```text
    ...
    Registration Information received from service: iotc-e9b1c47f-35a7-4041-8dab-928f140794cb.azure-devices.net!
    Connection String:
    [21;33m HostName=iotc-e9b1c47f-35a7-4041-8dab-928f140794cb.azure-devices.net;DeviceId=e6637e59-6753-4488-a441-a72a4a973d34;SharedAccessKey=+8BtlMccYXeHZNDDnb1wWhTTYdJIZrVeHsT6F4F5KnM [0m
    ```

1. Add the following line to the bottom of the text file:

    ```text
    HostName={hostname};DeviceId={device-id};SharedAccessKey={primary-key}
    ```

1. Update the above string, replacing **{hostname}** with the **HostName** value from the **connection1.txt** - yours will look similar to `iotc-e9b1c47f-35a7-4041-8dab-928f140794cb.azure-devices.net`. 

1. Continue to replace  **{device-id}**, and **{primary-key}** with your own values. 

1. You will use this connection string in your device app to connect to your IoT Central device.

1. Save the text file with all of this information.

You now have the all important connection string. The ID Scope identifies the app, the Device ID the real device, and the Primary Key gives you permission for the connection.

## Create a Free Azure Maps Account

If you do not already have an Azure Maps account, you will need to create one.

1. Navigate to [Azure Maps](https://azure.microsoft.com/services/azure-maps/).

1. To create an account, click **Start free>**.

    The **Azure Marketplace** will open, displaying the **Azure Maps** details.

1. On the left side of the page, click **GET IT NOW**.

1. When prompted, enter the email address of your Azure Subscription and click **Sign in**. If prompted, enter your password and complete the sign in process.

1. Once signed in, the **Create this app in Azure** popup will appear - click **Continue**.

    You will be redirected to the **Azure** portal. If prompted, login with your Azure Subscription. The **Create Azure Maps Account** page is displayed.

1. In the  **Subscription** dropdown, choose the subscription you wish to use.

1. In the **Resource group** dropdown, select an existing resource group **AZ-220-RG** or create a new one if you have deleted it.

1. Under **Account Details**, in the **Name** textbox, enter **AZ-220-Map**.

1. In the **Pricing tier** dropdown, choose **S0**.

1. Read the license and privacy statement, then check the box.

1. To create the **Azure Maps Account**, click **Create**.

1. Once the **Azure Maps Account** resource has been created, navigate to it and open the **Overview** pane.

1. After your account is successfully created, navigate to it.

1. In the left-hand navigation area, under **Settings**, click **Authentication** to view the primary and secondary keys for your Azure Maps account. Copy the **Primary Key** value to your local clipboard to use in the following section.

1. You can (optionally) verify your Azure Maps subscription key works. Save the following HTML to an .html file (after replacing the subscriptionKey entry with your own key) with any filename. Then, load the file in a web browser. Do you see a map of the world?

    ```html
    <!DOCTYPE html>
    <html>

    <head>
        <title>Map</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <!-- Add references to the Azure Maps Map control JavaScript and CSS files. -->
        <link rel="stylesheet" href="https://atlas.microsoft.com/sdk/javascript/mapcontrol/2/atlas.min.css" type="text/css">
        <script src="https://atlas.microsoft.com/sdk/javascript/mapcontrol/2/atlas.min.js"></script>

        <!-- Add a reference to the Azure Maps Services Module JavaScript file. -->
        <script src="https://atlas.microsoft.com/sdk/javascript/mapcontrol/2/atlas-service.min.js"></script>

        <script>
            function GetMap() {
                //Instantiate a map object
                var map = new atlas.Map("myMap", {
                    //Add your Azure Maps subscription key to the map SDK. Get an Azure Maps key at https://azure.com/maps
                    authOptions: {
                        authType: 'subscriptionKey',
                        subscriptionKey: '<your Azure Maps subscription primary key>'
                    }
                });
            }
        </script>
        <style>
            html,
            body {
                width: 100%;
                height: 100%;
                padding: 0;
                margin: 0;
            }

            #myMap {
                width: 100%;
                height: 100%;
            }
        </style>
    </head>

    <body onload="GetMap()">
        <div id="myMap"></div>
    </body>

    </html>
    ```

## Next Steps

You have now completed the preparatory steps of connecting your first IoT Central app to real devices. The next step is to use the connection string in a C# app.