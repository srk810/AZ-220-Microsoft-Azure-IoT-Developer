# Create HTTP Web Hook Logic App that sends an email

In this unit, you will create a new Azure Logic App that will be triggered via an HTTP Web Hook, then send an email using an Outlook.com email address.

1. Login to [portal.azure.com](https://portal.azure.com) using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. In the Azure Portal, click **+Create a resource** to open the Azure Marketplace.

1. On the **New** blade, in the **Search the Marketplace** box, type in and search for **Logic App**.

1. In the search results, select the **Logic App** item.

1. On the **Logic App** item, click **Create**.

1. On the **Create Logic App** blade, enter a globally unique name in the Registry **name** field.

    To provide a globally unique name, enter **AZ-220-LogicApp-{YOUR-ID}**.

    For example: **AZ-220-LogicApp-CP121819**

    The name of your Azure Logic App must be globally unique because it is a publicly accessible resource that you must be able to access from any IP connected device.

1. In the **Resource group** dropdown, select **Use Existing**, then select the **AZ-220-RG** resource group.

1. In the **Location** dropdown, choose the same Azure region that was used for the resource group.

1. Click **Create**.

    > [!NOTE] It will take a minute or two for the Logic App deployment to complete.

1. Navigate to the **Logic App** resource that was just deployed.

1. When navigating to the **Logic App** for the first time, the **Logic Apps Designer** pane will be displayed.

    If this doesn't come up automatically, click on the **Logic app designer** link under the **Development Tools** section on the **Logic App** blade.

1. Select the **When a HTTP request is received** trigger under the **Start with a common trigger** section.

1. The **Logic Apps Designer** will open with the visual designer displayed, and with the **When a HTTP request is received** trigger selected.

1. On the **When a HTTP request is received** trigger, click the **Use sample payload to generate schema** link.

1. When prompted, paste in the following sample JSON into the textbox and click **Done**.

    ```json
        {
            "headers": {
                "Connection": "Keep-Alive",
                "Accept-Encoding": "gzip,deflate",
                "Host": "prod-87.eastus.logic.azure.com",
                "origin": "eventgrid.azure.net",
                "aeg-subscription-name": "THERMOSTATALERT",
                "aeg-delivery-count": "0",
                "aeg-data-version": "",
                "aeg-metadata-version": "1",
                "aeg-event-type": "Notification",
                "Content-Length": "882",
                "Content-Type": "application/cloudevents+json; charset=utf-8"
            },
            "body": {
                "id": "05ae2c06-d9f6-ef8f-d994-0dcbb8d1879e",
                "source": "/SUBSCRIPTIONS/XXXXXXXX-{YOUR-ID}-{YOUR-ID}-{YOUR-ID}-XXXXXXXXXXXX/RESOURCEGROUPS/AZ-220-RG/PROVIDERS/MICROSOFT.DEVICES/IOTHUBS/AZ-220-HUB-CP1119",
                "specversion": "1.0",
                "type": "Microsoft.Devices.DeviceTelemetry",
                "dataschema": "#",
                "subject": "devices/SimulatedThermostat",
                "time": "2019-12-18T23:27:22.272Z",
                "data": {
                    "properties": {
                        "temperatureAlert": "false"
                    },
                    "systemProperties": {
                        "iothub-content-type": "application/json",
                        "iothub-content-encoding": "UTF-8",
                        "iothub-connection-device-id": "SimulatedThermostat",
                        "iothub-connection-auth-method": "{\"scope\":\"device\",\"type\":\"sas\",\"issuer\":\"iothub\",\"acceptingIpFilterRule\":null}",
                        "iothub-connection-auth-generation-id": "637123016160268927",
                        "iothub-enqueuedtime": "2019-12-18T23:27:22.272Z",
                        "iothub-message-source": "Telemetry"
                    },
                    "body": {
                        "temperature": 24.679108131527485,
                        "humidity": 70.52756003594378
                    }
                }
            }
        }
    ```

    This sample JSON is an example of the JSON that Event Grid will POST to the Web Hook endpoint for the Logic App once it's created. This sample includes the IoT Hub Message Telemetry properties for the IoT Device that will be sending telemetry messages.

1. Notice the **Request Body JSON Schema** box is now populated with a JSON Schema that was automatically generated base don the Sample JSON that was pasted in.

1. Click the **+New step** button below the **When a HTTP request is received** trigger.

1. Enter "**Outlook.com**" into the search box, then locate and select the **Send an email** action for the **Outlook.com** connector.

    > [!NOTE] These instructions walk through configuring the Logic App to send an email using an **Outlook.com** email address. Alternatively, the Logic App can also be configured to send email using the Office 365 Outlook or GMail connectors as well.

1. On the **Outlook.com Connector**, click the **Sign in** button, and follow the prompts to authenticate with an existing Outlook.com account.

1. In the **To** field, on the **Send an email** action, enter an email address to send email messages to.

    Enter an email address where you can receive emails; such as the Outlook.com Account used for this connector.

    The Outlook.com Account that was authenticated will be used to send the emails from that account. You can actually enter any email address you want to send the notifications to.

1. In the **Subject** field, enter `IoT Alert`.

1. Click on the **Body** field to enter the text `Current Temperature: ` into the field, then select the `temperature` content option from the **Dynamic content** popup.

    > [!NOTE] If the `temperature` content option is not listed, then click the **See more** link to expand the list.

1. Click **Save** to save all changes to the Logic App Workflow.

1. Expand the **When a HTTP request is received** trigger, copy the value for the **HTTP POST URL** that is displayed, and save it for future referent. This is the Web Hook endpoint URL for the Logic App that will be used by Event Grid to trigger the execution of the Logic App workflow.

    The **HTTP POST URL** will be similar to the following:

    ```text
    https://prod-87.eastus.logic.azure.com:443/workflows/b16b5556cbc54c97b063479ed55b2669/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=ZGqYl-R5JKTugLG3GR5Ir1FuM0zIpCrMw4Q2WycJRiM
    ```

    This URL is the Web Hook endpoint to call the Logic App trigger via HTTPS. Notice the **sig** query string parameter and it's value. The **sig** parameter contains the shared access key that is used to authenticate requests to the Web Hook endpoint.
