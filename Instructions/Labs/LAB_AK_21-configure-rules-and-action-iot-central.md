# Create your first Azure IoT Central app

## Scenario

Suppose you run a company that operates a fleet of refrigerated trucks.

You have a number of customers within a city, and a base that you operate from. You command each truck to take its contents and deliver it to any one customer. However, the cooling system may fail on any one of your trucks. If the contents do start to melt, you will need the option of instructing the truck to return to base and dump the contents. Alternatively, you can deliver the contents to another customer who might be nearer to the truck when you become aware the contents are melting.

In order to make these decisions, you will need an up-to-date picture of all that is going on with your trucks. You will need to know the location of each truck on a map, the state of the cooling system, and the state of the contents.

IoT Central provides all you need to handle this scenario.

In this lab you will:

* Create an Azure IoT Central custom app, using the IoT Central portal
* Create a device template for a custom device, using the IoT Central portal
* Add Node.js code to support simulated devices, with routes selected by Azure Maps
* Monitor and command the simulated devices, from an IoT Central dashboard

## Exercise 1: Create a custom IoT Central app

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



## Exercise 2: Create a Device Template

The data communicated between a remote device, and IoT Central, is specified in a device template. The device template specifies all the required details about the data, so that both the device and IoT Central have all they need to make sense of the communication.

In this unit, you will create a device template for a refrigerated truck. The IoT Central portal creates a simulated refrigerated truck device for you by default. This simulated device allows you to do some testing of the template before committing to real devices. In the unit that follows this one, you will examine this first level of testing.

## Create a Device Template

1. Within the [Azure IoT Central](https://apps.azureiotcentral.com/) portal (which you may still have open), select **Device Templates** from the menu on the left-hand side.

1. On the right-hand side of the screen, click **+** to create a new template.

1. You will next see a range of **New Template** options, select **Custom**.

    >**Tip:** Take note of the other options: **MXChip**, **Raspberry Pi**, and other hardware solutions. You may want to use those template options in a future project!

1. Enter the name for your template: "RefrigeratedTruck", then click **Create**.

1. You should now see a template **RefrigeratedTruck (1.0.0)**, and see that a template can consist of **Measurements**, **Settings**, **Properties**, **Commands**, **Rules**, and a **Dashboard**. Our refrigerated truck will need entries under most of these headings.

    > [!NOTE] You are creating this template with all you need for the units that follow this one. If the purpose of these entries is not immediately obvious, it should become clear as you work through this set of units. It is possible to complete a template, then come back to it and add more entries later, but this can involve managing multiple versions of a template, which is a small complexity, but one avoided in this Learn module. In the sections that follow, if an entry in the IoT Central portal is not mentioned in the text, it is safe to leave it at its default setting.

## Measurements

Measurements are data transmitted by the device, and cover four types of values: *Telemetry*, *State*, *Event*, and *Location*. Our scenario requires at least one of each of these types for the refrigerated truck. You need to go through the measurements carefully and enter all the required data. The most important entry is the **Field Name**. Make sure to enter this text accurately, as it is used when devices communicate values to the IoT Central app. When you write code in some of the following units, the reference in the code and the **Field Name** *must* be an exact match.

### Telemetry

Telemetry is the values transmitted by sensors. You only implemented one sensor in this scenario, the temperature of a truck's contents. The frequency with which this information is transmitted is determined by the device. In order for an operator to respond to an abnormal situation, the frequency of the transmission will need to be set appropriately.

Notice that minimum and maximum values are specified for a telemetry entry, these values are only used by a simulated device to mimic the values from a real device. A real device can transmit any value. The units of the telemetry are a text value to show on charts and tables, IoT Central does not have any inherent understanding of degrees Celsius, or any other possible physical unit.

1. On the "RefrigeratedTruck" device template page, ensure the **Measurements** option is underlined in blue.

1. To add a new telemetry item, click **+ New** and select **Telemetry** from the drop-down list.

    The **Create Telemetry** form will be displayed.

1. On the **Create Telemetry** form, under **Display Name**, enter **Contents temperature**.

1. Under **Field Name**, enter **temperature**.

1. Under **Units**, enter **degC**.

1. Under **Minimum Value**, enter **-20**.

1. Under **Maximum Value**, enter **20**.

1. Under **Decimal Places**, enter **1**.

1. At the top of the **Create Telemetry** form, click **Save**.

    The form will close.

    > [!NOTE] If you are warned you are leaving a page with unsaved changes, it often means you have neglected to click the **Save** icon.

You should now see a **Waiting for data** screen. This message is as it should be for a minute or so, but after a while you will start to see simulated values generated by IoT Central.

Let's add the rest of the template.

### State

States are important, they let the operator know what is going on. A state in IoT Central is a name associated with any number of values. In addition, you get to choose a color to associate with each value, which can make identifying what is going on (in particular, changes in state), much easier to identify in a visual display. It is easy to see why color is important, for example a "go" state might be a green color, a "failed" state a red or darker color, and so on.

1. To add a state for the truck's refrigerated contents, click **+ New** and select **State** from the drop-down list.

    The **Create State** form will be displayed.

1. On the **Create State** form, under **Display Name**, enter **Contents state**.

1. Under **Field Name**, enter **stateContents**.

1. To the right of **Values**, to add a value, click **+**.

1. In the **New Value** area, in the **Enter value** textbox, enter **empty**.

    As the **Display Name** is optional, you can leave that blank. Also, you can either accept the default color, or click the colored circle and choose an alternate color if you wish.

1. Repeat the previous two steps twice more, to add two more values for **full** and **melting**.

1. Once you have added the three values, at the top of the **Create State** form, click **Save**.

    The form will close.

To add some uncertainty to our simulation, let's add a failure state for the cooling system. If the cooling system fails, as you will see in the following units, the chances of the contents melting increase considerably!

1. To add a new state for the cooling system, click **+ New** and select **State** from the drop-down list.

    The **Create State** form will be displayed.

1. On the **Create State** form, under **Display Name**, enter **Cooling system**.

1. Under **Field Name**, enter **stateCoolingSystem**.

1. To the right of **Values**, to add a value, click **+**.

1. In the **New Value** area, in the **Enter value** textbox, enter **failed**.

    As the **Display Name** is optional, you can leave that blank. Also, you can either accept the default color, or click the colored circle and choose an alternate color if you wish.

1. Repeat the previous two steps twice more, to add two more values for **on** and **off**.

1. Once you have added the three values, at the top of the **Create State** form, click **Save**.

    The form will close.

A more complex state is the state of the truck itself. If all goes well, a truck's normal routing might be: ready, enroute, delivering, returning, loading, and back to ready again. However, you should add the dumping state to cater for when melted contents need to be disposed of! 

1. To add a new state for the truck, click **+ New** and select **State** from the drop-down list.

    The **Create State** form will be displayed.

1. On the **Create State** form, under **Display Name**, enter **Truck state**.

1. Under **Field Name**, enter **stateTruck**.

1. To the right of **Values**, to add a value, click **+**.

1. In the **New Value** area, in the **Enter value** textbox, enter **ready**.

    As the **Display Name** is optional, you can leave that blank. Also, you can either accept the default color, or click the colored circle and choose an alternate color if you wish.

1. Repeat the previous two steps five times more, to add two more values for **enroute**, **delivering**, **returning**, **loading** and **dumping**.

1. Once you have added the six values, at the top of the **Create State** form, click **Save**.

    The form will close.

### Event

Events are issues triggered by the device, and communicated to the IoT Central app. Events can be one of three types: *Error*, *Warning*, or *Informational*.

One possible event a device might trigger is a conflicting command. An example might be a truck is returning empty from a customer, but receives a command to deliver its contents to another customer. The conflict is caused by the device (the truck) being unable to act on the command. If a conflict occurs, it is a good idea for the device to trigger an event to warn the operator of the IoT Central app, with a *Warning* class of event.

1. To add a new warning event, click **+ New** and select **Event** from the drop-down list.

    The **Create Event** form will be displayed.

1. On the **Create Event** form, under **Display Name**, enter **Command conflict**.

1. Under **Field Name**, enter **eventConflict**.

1. Under **Default Severity**, select **Warning**.

1. To save the event, at the top of the **Create State** form, click **Save**.

    The form will close.

A second event that you will add is informational. When a truck receives a command to deliver to a customer, and the truck is able to perform the unit, the truck triggers a change-of-customer-ID event. Add this event now.

1. To add a new informational event, click **+ New** and select **Event** from the drop-down list.

    The **Create Event** form will be displayed.

1. On the **Create Event** form, under **Display Name**, enter **Customer change**.

1. Under **Field Name**, enter **eventCustomer**.

1. Under **Default Severity**, select **Information**.

    > [!NOTE] One reason you add this event is to keep track of which truck is going to which customer. In a later unit, you implement multiple trucks and a single dashboard to monitor them, and having this event helps provide a record of what is going on.

1. To save the event, at the top of the **Create State** form, click **Save**.

    The form will close.

### Location

A location is probably the most important, and yet one of the easiest measurements to add to a device template. Under the hood, it consists of a latitude, longitude, and an optional altitude, for the device.

1. To add a new location, click **+ New** and select **Location** from the drop-down list.

    The **Create Location** form will be displayed.

1. On the **Create Location** form, under **Display Name**, enter **Location**.

1. Under **Field Name**, enter **location**.

1. To save the location, at the top of the **Create Location** form, click **Save**.

    The form will close.

You should now have completed adding all the measurements you need. Validate the measurements you have created against the following list:

* Telemetry
  * Contents temperature
* State
  * Contents state
  * Colling system
  * Truck state
* Event
  * Command conflict
  * Customer change
* Location
  * Location

If you spot any mistakes, go back and address them before continuing.

## Settings

A Setting contains device configuration data. In our refrigerated truck example, you are going to define an optimal temperature for the contents as a setting. This optimal temperature might conceivably change with different types of content, different weather conditions, or whatever might be appropriate. A setting has an initial default value, which may not need to be changed, but the ability to change it easily and quickly is there, if needed.

A setting is a single value. If more complex sets of data need to be transmitted to a device, a Command (see below) might be the more appropriate way of handling it.

1. To add a setting, click on the **Settings** title (just to the right of **Measurements**) under the device template name.

1. To add a single setting to set an optimal contents temperature, under **Library**, click **Number**. 

    The **Configure Number** form is displayed.

1. On the **Configure Number** form, under **Display Name**, enter **Optimal temperature**.

1. Under **Field Name**, enter **optimalTemperature**.

1. Under **Unit of Measure**, enter **degC**.

1. Under **Number of Decimal Places**, enter **1**.

1. Under **Minimum Value**, enter **-20**.

1. Under **Maximum Value**, enter **20**.

1. Under **Initial Value**, enter **-5**.

    The **Description** field is optional and may be left blank.

1. To save the setting, at the top of the **Configure Number** form, click **Save**.

    The form will close and the new number setting will be displayed.

## Properties

Properties of a device are typically constant values, that are communicated to the IoT Central app once when communication is first initiated. In our refrigerated truck scenario, a good example of a property would be the license plate of the truck, or some similar unique truck ID.

1. To add a property, click on the **Properties** title (just to the right of **Settings**) under the device template name.

1. To add a single Text property to contain a truck ID, under **Library**, click **Text**.

    The **Configure Text** form will be displayed.

1. On the **Configure Text** form, under **Display Name**, enter **Truck ID**.

1. Under **Field Name**, enter **truckId**.

1. Under **Trim Leading Spaces**, select **Off**.

1. Under **Trim Trailing Spaces**, select **Off**.

1. Under **Case Sensitivity in Comparison**, select **On**.

1. Under **Case Sensitivity in Data Entry**, select **Mixed**.

1. Under **Minimum Length**, enter **0**.

1. Under **Maximum Length**, enter **100**.

1. Under **Initial Value**, leave it empty.

1. Under **Required**, select **Off**.

    **Description** is optional an may be left blank.

1. To save the property, at the top of the **Configure Text** form, click **Save**.

    The form will close and the new property will be displayed.

## Commands

Commands are sent by the operator of the IoT Central app to the remote devices. Commands are similar to settings, but a command can contain no, or multiple, input fields if necessary, whereas a setting is limited to a single value.

For refrigerated trucks, there are two commands you should add: a command to deliver the contents to a customer (identified by a customer ID), and a command to recall the truck to base.

1. To add a command, click on the **Commands** title (just to the right of **Properties**) under the device template name.

1. To add a command to send the truck to a customer, click **+ New Command**.

    The **Configure Command** form will be displayed.

1. On the **Configure Command** form, under **Display Name**, enter **Go to customer**.

1. Under **Field Name**, enter **cmdGoTo**.

1. To the right of the **Input Fields** title, to add an input field, click **+**.

1. On the **New Command Param** form, under **Display Name**, enter **Customer ID**.

1. Under **Field Name**, enter **customerId**.

1. Under **Data Type**, select **text**.

1. Under **Value**, leave blank.

1. To save the command and command parameter, at the top of the **Configure Command** form, click **Save**.

    The form will close and the new command will be displayed. You should see that the **Go to customer** command has a textbox to enter a Customer ID, a **Run** button as well as an area to display messages.

    >**Tip:**  If you move your mouse over lower-right corner of the box displaying the command, you can use the corner icon to stretch the bounding rectangle so that all elements of the command are displayed fully.


1. To add a command to recall the truck, click **+ New Command**.

    The **Configure Command** form will be displayed.

1. On the **Configure Command** form, under **Display Name**, enter **Recall**.

1. Under **Field Name**, enter **cmdRecall**.

    This command does not require a parameter.

1. To save the command, at the top of the **Configure Command** form, click **Save**.

    The form will close and the new command will be displayed. You should see that the **Recall** command just has a **Run** button and an area to display messages - as there are no parameters, there are no data entry fields.

As you have seen, preparing a device template does take some care and some time.

In the next unit, you can do some validation of our device template.



## Exercise 3: Monitor a Simulated Device

Even before a device template is complete, the automatically created simulated device will start sending data. As you entered the measurements, and other entries for the device template, you will probably have noticed values appearing in line and bar charts to the right of the screen.

## Validate the Device Template

Complete validation of the device template will not be possible until you have some real devices. However, the simulated device allows you both to check the completeness of what you have done so far, and to provide a helpful UI to learn the basics of managing devices through IoT Central.

1. Within the [Azure IoT Central](https://apps.azureiotcentral.com/) portal (which you may still have open), select **Devices** from the menu on the left-hand side.

    You will see a page with a list of devices on the left side, grouped into **Unassociated devices** (which is empty) and then a list of **Templates**. Under **Templates** you will see a single entry for the **RefrigeratedTruck (1.0.0)** template that was just created.

1. In the **Devices** list, under **Templates**, select **RefrigeratedTruck (1.0.0)**.

    You will see a details view that lists every device that uses the **RefrigeratedTruck (1.0.0)** template. At present, you will see just one - **RefrigeratedTruck-1**.

1. In the device list for **RefrigeratedTruck (1.0.0)** template, click **RefrigeratedTruck-1**.

    A page will open showing the **Measurements** for **RefrigeratedTruck-1**. On the left you will see a list that shows the *Telemetry*, *State*, *Event* and *Location* measurements for the device. On the right is the view pane. There are 3 views available: *chart*, *table* and *map*.

1. In the range of **Views**, if it is not already selected, click the *chart* entry (the left-most of the three view options).

1. This view shows the line chart of the telemetry, and bar charts for states and events. Note the list of measurements on the left contains a column of eye icons, determining whether the field is visible or not. Some of these icons may be light-gray (indicating the field is not visible), and if so, click the eye icons to turn the fields visible.

1. Notice that the temperature telemetry falls within the minimum (-20 degC), and the maximum (20 degC), you set when defining this field. Hover over any telemetry, or any state in the bar charts, for a little more information.

1. The event chart is a bit less obvious than the telemetry and states, but notice the diamond icons  at the bottom of the chart that represent an event that has been triggered. Clicking on any of these icons will give you more detail about the event. With the simulated device, this detail cannot be much more than that the event "occurred". With real devices, you can learn more about a real event.

1. In the range of **Views**, click the *table* entry (the second of the three view options).

1. The table view gives time slots, and a text description of the telemetry, state, or event. Again, click on the event link for some extra information. The table view is probably the least used of the three views, but is helpful in aligning what happened in any one time slot.

1. In the range of **Views**, click the *map* entry (the third of the three view options).

1. The map view is certainly a fun one, and you will probably be a bit surprised to see our "truck" has superpowers, and may even have ended up in the ocean after traveling directly to various random locations on land! The simulated device has no concept of anything other than a random location, but at least you have verified that location data is being transmitted, so has been set up correctly.

1. Clicking on any of the blue circles provides more location information.

## Create an Elementary Dashboard

In this final exercise for this unit, you create a dashboard to monitor a single device. Later on in this series of units, you are going to create a more specific dashboard for all devices. The two processes are similar, so the experience you gain here will be useful in creating any IoT dashboard.

1. In the left-hand menu, open **Device Templates**, then select the **RefrigeratedTruck** template.

1. Under the **RefrigeratedTruck (1.0.0)** title, click on **Dashboard** (not the one in the left-hand menu, the one to the right of **Rules**).

1. Under **Library**, click **Map**.

    The **Configure Map** form is displayed.

1. In the **Configure Map** form, under **Title**, enter **Map**.

1. Under **Location**, select **Location**.

1. Under **State Measurement**, select any one of the three truck states to be shown on the map.

1. Under **Show location history**, select **On**.

1. Under **Time range**, select **Past 30 minutes** - note the other time ranges available.

1. At the top of the **Configure Map** form, click **Save**.

1. If the displayed Map is too small, expand the map on the dashboard using the lower-right corner icon.

1. To add a KPI to the dashboard, under **Library**, click **KPI**.

    The **Configure KPI** form is displayed.

1. In the **Configure Map** KPI, under **Title**, enter **Temp (degC)**.

1. Under **Time range**, select **Past 30 minutes**.

1. Under **Measurement Type**, select **Telemetry** - note that you can *Events* can also be selected as a KPI.

1. Under **Measures**, ensure **Contents temperature** is selected and click the eye icon in the **Measures** box to make the value visible.

1. At the top of the **Configure KPI** form, click **Save**.

    A tile will be added to your dashboard, which will be set to a much smaller default size than the map. Note that you can drag the tiles around to change their position.

1. Add any other elements to the dashboard that pique your interest. The dashboard is an alternative  to the device views described earlier in this unit, for viewing device data in IoT Central.

1. Verify (by watching the dashboard) that your simulated truck is moving around on the dashboard map, albeit with superpowers. Verify too that the temperature of the contents is changing.

In the next unit, you will prepare the process to connect a real device to IoT Central.




## Exercise 4: Set up your Development Environment

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



## Exercise 5: Create a Real Device in C#




