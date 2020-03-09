---
lab:
    title: 'Lab 09: Integrate IoT Hub with Event Grid'
    module: 'Module 5: Insights and Business Integration'
---

# Integrate IoT Hub with Event Grid

## Lab Scenario

Contoso management is impressed with the prototype solutions that you've created using Azure IoT services, and they feel comfortable assigning additional budget the capabilities that you have already demonstrated. They are now asking that you explore the integration of certain operational support capabilities. Specifially, they would like to see how the Azure tools support sending alert notifications to the managers who are responsible for specific work areas. Alert criteria will be defined by the business area managers. The telemetry data arriving at IoT hub will be evaluated to generate the notifications.

You've identified a business manager, Nancy, that you've had success working with in the past. You'll work with her during the initial phase of your solution.

Nancy informs you that her team of facility technicians is responsible for installing the new connected thermostats that will be used to monitor temperature across different cheese caves. The thermostat devices function as IoT devices that can be connected to IoT hub. To get your project started, you agree to create an alert that will generate a notification when a new device has been implemented.

To generate an alert, you will push a device created event type to Event Grid when a new thermostat device is created in IoT Hub. You will create a Logic Apps instance that reacts to this event (on Event Grid) and which will send an email to alert facilities when a new device has been created, specifying the device ID and connection state.

## In This Lab

* Verify that the lab prerequisites are met (that you have the required Azure resources)
* Create a Logic App that sends an email
* Configure an Azure IoT Hub Event Subscription
* Create new devices to trigger the Logic App

### Exercise 1: Verify Lab Prerequisites

This lab assumes the following Azure resources are available:

| Resource Type  | Resource Name          |
|----------------|------------------------|
| :--            | :--                    |
| Resource Group | AZ-220-RG              |
| IoT Hub        | AZ-220-HUB-_{YOUR-ID}_ |

If these resources are not available, you will need to run the **lab09-setup.azcli** script as instructed below before moving on to Exercise 2. The script file is included in the GitHub repository that you cloned locally as part of the dev environment configuration (lab 3).

The **lab09-setup.azcli** script is written to run in a **bash** shell environment - the easiest way to execute this is in the Azure Cloud Shell.

1. Using a browser, open the [Azure Shell](https://shell.azure.com/) and login with the Azure subscription you are using for this course.

1. Verify that the Azure Cloud Shell is using **Bash**.

    The dropdown in the top-left corner of the Azure Cloud Shell page is used to select the environment. Verify that the selected dropdown value is **Bash**.

1. To upload the setup script, in the Azure Shell toolbar, click **Upload/Download files** (fourth button from the right).

1. On the Azure Shell toolbar, click **Upload/Download files** (fourth button from the right).

1. In the dropdown, click **Upload**.

1. In the file selection dialog, navigate to the folder location of the GitHub lab files that you downloaded when you configured your development environment.

    In _Lab 3: Setup the Development Environment_, you cloned the GitHub repository containing lab resources by downloading a ZIP file and extracting the contents locally. The extracted folder structure includes the following folder path:

    * Allfiles
        * Labs
            * Lab 09: Integrate IoT Hub with Event Grid
                * Setup

    The lab09-setup.azcli script file is located in the Setup folder for lab 9.

1. Select the **lab09-setup.azcli** file, and then click **Open**.

    A notification will appear when the file upload has completed.

1. To verify that the correct file has uploaded in Azure Cloud Shell, enter the following command:

    ```bash
    ls
    ```

    The `ls` command lists the content of the current directory. You should see the lab09-setup.azcli file listed.

1. To create a directory for this lab that contains the setup script and then move into that directory, enter the following Bash commands:

    ```bash
    mkdir lab9
    mv lab09-setup.azcli lab9
    cd lab9
    ```

1. To ensure that **lab09-setup.azcli** has the execute permission, enter the following command:

    ```bash
    chmod +x lab09-setup.azcli
    ```

1. On the Cloud Shell toolbar, to edit the lab09-setup.azcli file, click **Open Editor** (second button from the right - **{ }**).

1. In the **FILES** list, to expand the lab9 folder and open the script file, click **lab9**, and then click **lab09-setup.azcli**.

    The editor will now show the contents of the **lab09-setup.azcli** file.

1. In the editor, update the `{YOUR-ID}` and `{YOUR-LOCATION}` assigned values.

    In the reference sample below, you need to set `{YOUR-ID}` to the Unique ID you created at the start of this course - i.e. **CAH191211**, and set `{YOUR-LOCATION}` to the location that makes sense for your resources.

    ```bash
    #!/bin/bash

    YourID="{YOUR-ID}"
    RGName="AZ-220-RG"
    IoTHubName="AZ-220-HUB-$YourID"

    Location="{YOUR-LOCATION}"
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

1. To create a resource group named **AZ-220-RG** and an IoT Hub named **AZ-220-HUB-{YourID}** enter the following command:

    ```bash
    ./lab09-setup.azcli
    ```

    This will take a few minutes to run. You will see JSON output as each step completes.

### Exercise 2: Create HTTP Web Hook Logic App that sends an email

Azure Logic Apps is a cloud service that helps you schedule, automate, and orchestrate tasks, business processes, and workflows when you need to integrate apps, data, systems, and services across enterprises or organizations.

In this exercise, you will create a new Azure Logic App that will be triggered via an HTTP Web Hook, then send an email using an Outlook.com email address.

#### Task 1: Create a Logic App resource in the Azure portal

1. If necessary, log in to the [Azure portal](https://portal.azure.com) using the Azure account credentials that you are using for this course.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On the Azure portal menu, click **+ Create a resource**.

1. On the **New** blade, in the **Search the Marketplace** box, enter **logic app**

1. In the search results, click **Logic App**.

1. On the **Logic App** blade, click **Create**.

1. On the **Basics** tab, under **Project details**, select the **Subscription** that you are using for this course.

1. In the **Resource group** dropdown, under **Select existing**, click **AZ-220-RG**.

1. Under **Instance details**, in the **Name** field, enter **AZ-220-LogicApp-_{YOUR-ID}_**

    For example: **AZ-220-LogicApp-CP191218**

    The name of your Azure Logic App must be globally unique because it is a publicly accessible resource that you must be able to access from any IP connected device.

1. In the **Location** dropdown, select the same Azure region that was used for the resource group.

1. Leave **Log Analytics** set to **Off**.

1. Click **Review + create**.

1. On the **Review + create** tab, click **Create**.

    > **Note**:  It will take a minute or two for the Logic App deployment to complete.

1. Navigate back to your Azure portal Dashboard.

#### Task 2: Configure Your Logic App 

1. On your resource group tile, click the link to the Logic App resource that was just deployed.

    If the **AZ-220-LogicApp-_{YOUR-ID}_** Logic app is not displayed, refresh the resource group tile.

    When navigating to the **Logic App** for the first time, the **Logic Apps Designer** pane will be displayed.

    If this doesn't come up automatically, click on the **Logic app designer** link under the **Development Tools** section on the **Logic App** blade.

1. Select the **When a HTTP request is received** trigger under the **Start with a common trigger** section.

1. The **Logic Apps Designer** will open with the visual designer displayed, and with the **When a HTTP request is received** trigger selected.

1. On the **When a HTTP request is received** trigger, under the **Request Body JSON Schema** textbox, click the **Use sample payload to generate schema** link.

1. When prompted, paste in the following sample JSON into the textbox and click **Done**.

    ```json
    [{
      "id": "56afc886-767b-d359-d59e-0da7877166b2",
      "topic": "/SUBSCRIPTIONS/<subscription ID>/RESOURCEGROUPS/<resource group name>/PROVIDERS/MICROSOFT.DEVICES/IOTHUBS/<hub name>",
      "subject": "devices/LogicAppTestDevice",
      "eventType": "Microsoft.Devices.DeviceCreated",
      "eventTime": "2018-01-02T19:17:44.4383997Z",
      "data": {
        "twin": {
          "deviceId": "LogicAppTestDevice",
          "etag": "AAAAAAAAAAE=",
          "deviceEtag": "null",
          "status": "enabled",
          "statusUpdateTime": "0001-01-01T00:00:00",
          "connectionState": "Disconnected",
          "lastActivityTime": "0001-01-01T00:00:00",
          "cloudToDeviceMessageCount": 0,
          "authenticationType": "sas",
          "x509Thumbprint": {
            "primaryThumbprint": null,
            "secondaryThumbprint": null
          },
          "version": 2,
          "properties": {
            "desired": {
              "$metadata": {
                "$lastUpdated": "2018-01-02T19:17:44.4383997Z"
              },
              "$version": 1
            },
            "reported": {
              "$metadata": {
                "$lastUpdated": "2018-01-02T19:17:44.4383997Z"
              },
              "$version": 1
            }
          }
        },
        "hubName": "egtesthub1",
        "deviceId": "LogicAppTestDevice"
      },
      "dataVersion": "1",
      "metadataVersion": "1"
    }]
    ```

    This sample JSON is an example of the JSON that Event Grid will POST to the Web Hook endpoint for the Logic App once it's created. This sample includes the IoT Hub Message Telemetry properties for the IoT Device that will be sending telemetry messages.

1. Notice the **Request Body JSON Schema** box is now populated with a JSON schema that was automatically generated based on the sample JSON that was pasted in.

1. Below the **When a HTTP request is received** trigger, click the **+ New step** button.

1. Enter `Outlook.com` into the search box, then locate and select the **Send an email (V2) (Preview)** action for the **Outlook.com** connector.

    > **Note**:  These instructions walk through configuring the Logic App to send an email using an **Outlook.com** email address. Alternatively, the Logic App can also be configured to send email using the Office 365 Outlook or Gmail connectors as well.

1. On the **Outlook.com** Connector, click the **Sign in** button, and follow the prompts to authenticate with an existing Outlook.com account.

1. If prompted to **Let this app access your info**, click **Yes**.

1. In the **Send an email (V2) (Preview)** action, on the **To** field, enter an email address to send email messages to.

    Enter an email address where you can receive emails; such as the Outlook.com account used for this connector.

    The Outlook.com account that was authenticated will be used to send the emails from that account. You can actually enter any email address you want to send the notifications to.

1. For the **Subject**, fill in `IoT Hub alert:`.

1. Next, begin work on the **Body**.  Your desired conent is the following:
   `This is an automated email to inform you that: {eventType} occurred at {eventTime} IoT Hub: {hubName} Device ID: {deviceID} Connection state: {connectionState}`
   Each curly-braces entry should be dynamic content.  If you can't see the Dynamic content, select the **Add dynamic content** hyperlink under the **Body** text box. If it doesn't show you the fields you want, click *more* in the Dynamic content screen to include the fields from the previous action.
   When you add the first dynamic content value, because the input data schema is for an array, the Logic Apps Designer will automatically change the e-mail action to be nested inside of a **For each** action.  When this happens, the **Send an email (V2) (Preview)** action will collapse; simply click on it to open it up again and continue editing the body.

    ![Fill out email information](./Media//LAB_AK_09-email_content.png)

1. Click **Save** at the top of the designer to save all changes to the Logic App Workflow.

1. Expand the **When a HTTP request is received** trigger, copy the value for the **HTTP POST URL** that is displayed, and save it for future reference. This is the _web hook_ endpoint URL for the Logic App that will be used by Event Grid to trigger the execution of the Logic App workflow.

    ![HTTP request info](./Media/LAB_AK_09-http_post.png)

    The **HTTP POST URL** will be similar to the following:

    ```text
    https://prod-87.eastus.logic.azure.com:443/workflows/b16b5556cbc54c97b063479ed55b2669/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=ZGqYl-R5JKTugLG3GR5Ir1FuM0zIpCrMw4Q2WycJRiM
    ```

    This URL is the Web Hook endpoint to call the Logic App trigger via HTTPS. Notice the **sig** query string parameter and it's value. The **sig** parameter contains the shared access key that is used to authenticate requests to the Web Hook endpoint.

### Exercise 3: Configure Azure IoT Hub Event Subscription

Azure IoT Hub integrates with Azure Event Grid so that you can send event notifications to other services and trigger downstream processes. You can configure business applications to listen for IoT Hub events so that you can react to critical events in a reliable, scalable, and secure manner. For example, build an application that updates a database, creates a work ticket, and delivers an email notification every time a new IoT device is registered to your IoT hub.

In this exercise, you will create an Event Subscription within Azure IoT Hub to setup Event Grid integration that will trigger a Logic App to send an alert email.

1. Navigate back to your Azure Portal dashboard.

1. On your resource group tile, click **AZ-220-HUB-_{YOUR-ID}_** to navigate to your Azure IoT Hub.

1. On the **IoT Hub** blade, on the left side, click the **Events** link.

1. On the **Events** pane, at the top, click the **+ Event Subscription** button.

1. Create the event subscription with the following values:

   * **EVENT SUBSCRIPTION DETAILS**
     * **Name**: `MyDeviceCreateEvent`
     * **EventSchema**: **Event Grid Schema**

   * **TOPIC DETAILS**: will be informational and read-only
  
   * **EVENT TYPES**
     * **Filter to Event Types**: Uncheck all of the choices except **Device Created**.

       ![subscription event types](./Media/LAB_AK_09-subscription-event-types.png)

   * **ENDPOINT DETAILS**:
     * **Endpoint Type**: **Web Hook**
     * Click **Select an endpoint**, and then, in the **Select Web Hook** pane, under **Subscriber Endpoint**, paste the URL that you copied from your logic app, then click **Confirm Selection**.
  
    *Do not yet click Create!*
  
    When you're done, the pane should look like the following example:

    ![Sample event subscription form](./Media/LAB_AK_09-subscription-form.png)

1. You could save the event subscription here, and receive notifications for every device that is created in your IoT hub. For this tutorial, though, let's use the optional fields to filter for specific devices. Select **Filters** at the top of the pane.

1. At the bottom of the pane, select **Add new filter**. Fill in the fields with these values:

   * **Key**: Enter `Subject`.

   * **Operator**: Select `String begins with`.

   * **Value**:  Enter `devices/CheeseCave1_` to filter for device events in building 1.
  
1. Add another filter with these values:

   * **Key**: Enter `Subject`.

   * **Operator**: Select `String ends with`.

   * **Value**: Enter `_Thermostat` to filter for device events related to temperature.

   The **Filters** tab of your event subscription should now look similar to this image:

1. Select **Create** to save the event subscription.

### Exercise 4: Test Your Logic App with New Devices

Test your logic app by creating a new device to trigger an event notification email.

1. From your IoT hub, on the left side, under **Explorers**, select **IoT Devices**.

2. At the top, select **+ New**.

3. For **Device ID**, enter `CheeseCave1_Building1_Thermostat`.

4. Leave all other fields at the defaults, and select **Save**.

5. You can add multiple devices with different device IDs to test the event subscription filters. Try these other examples:

   * `CheeseCave1_Building1_Light`
   * `CheeseCave2_Building1_Thermostat`
   * `CheeseCave2_Building2_Light`

   If you added the four examples total, your list of IoT devices should look like the following image:

   ![IoT Hub device list](./Media/LAB_AK_09-iot-hub-device-list.png)

6. Once you've added a few devices to your IoT hub, check your email to see which ones triggered the logic app.
