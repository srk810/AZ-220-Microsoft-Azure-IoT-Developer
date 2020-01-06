# Create a custom IoT Central app

Azure IoT Central enables the easy monitoring and management of a fleet of remote devices.

Azure IoT Central encompasses a range of underlying technologies that work great, but can be complicated to implement when many technologies are needed. These technologies include Azure IoT Hub, the Azure Device Provisioning System (DPS), Azure Maps, Azure Time Series Insights, Azure IoT Edge, and others. It's only necessary to use these technologies directly, if more granularity is needed than available through IoT Central.

One of the purposes of this lab is to help you decide if there is enough features in IoT Central to support the scenarios you are likely to need. So, let's investigate what IoT Central can do with a fun and involved scenario.

## Create a custom IoT Central app

In this task you will create an Azure IoT Central custom app, using the IoT Central portal.

1. In your browser, to open Azure IoT Central, Navigate to [Azure IoT Central](https://apps.azureiotcentral.com/).

    > [!NOTE] It is a good idea to bookmark this URL, as it is the home for all your IoT Central apps.

1. In the left-hand menu, click on **Build**, then select **Custom app**.

    If prompted, login with your Azure Subscription account.

1. Enter "Refrigerated Trucks" for the **Application name**.

1. Add your own unique ID to the end of the **URL** entry.

    > **Important:** Your **Application name** can be any friendly name. However, the **URL** *must* be unique. For example, `refrigerated-trucks-<your id>`, replacing `<your id>` with appropriate text. A good unique ID would be your initials, followed by today's date: `cah091219`.

1. Change the **Application template** to **Legacy application (2018)**.

   Setting the **Application template** is an important step. The default **Preview application** will enable preview features that are not used in this module.

1. Click the **7 day free trial** switch, so that the **Billing info** goes away, and is replaced by **Contact info**.

    Seven days gives you plenty of time to complete, and evaluate, the scenario.

1. Fill in your contact information.

1. Click **Create**, and wait a few seconds whilst the app resource is built.

    You should now see a **Dashboard** with a few default links.

The next time you visit your Azure central home page, select **My apps** in the left-hand menu, and an icon for your **Refrigerated Trucks** app should appear.

You've now created the app. The next task is to specify a *device template*.