# Configure a Dashboard

The Dashboard is the page that loads when users who have access to the application navigate to the application's URL. If you created your application from one of the Application Templates, your application will have a pre-defined dashboard to start. If you created your application from the Custom Application application template, your dashboard will be blank to start.

**Note**: Users can create multiple dashboards in addition to the default application dashboard. These dashboards can be personal to the user only, or shared across all users of the application.

## Add Tiles

Open your Dashboard page from the left pane of the IoT Central application. To begin customizing the default dashboard for your application, select **Edit** at the top-left of the Dashboard page. Selecting Edit opens the dashboard library panel. The library contains the tiles and dashboard primitives that you can use to customize the dashboard.

For example, if you want to configure a dashboard that will be used to monitor the environment in an office space, you can add a Telemetry tile for the current temperature of a device. To do so:

1. Select a Device Template.

1. Select a Device Instance for the device you want to see on a dashboard tile. 

    You will see a list of the device's properties that can be used on the tile.

1. To create the tile on the dashboard, click on telemetry property and drag it to the dashboard area. 

    For the office environment scenario, you would drag Temperature to the dashboard area. You could also click the checkbox next to Temperature, and then click Combine.

    The screenshot below helps to illustrate the process un the UI.

1. Select **Save** in the top left to save the tile to the dashboard.

![IoT Central - device details tile](../../Linked_Image_Files/M11_L03-IoTCentral-Dashboard-Tile-device-details.png)

Now when an operator views the default application dashboard, they see the new tile with the Temperature for the device. Each tile has a pre-selected graph, chart, etc. that will be displayed when the tile is created. However, users can choose to edit and change this visualization.

## Edit Tiles

To edit a tile on the dashboard, first click **Edit** at the top left of the page, which will open edit mode for the dashboard and all its tiles.

Then click the **Gear** icon in the top-right corner of the tile you wish to edit. Here you can edit aspects of the tile including its title, its visualization, aggregation, etc.

![IoT Central - aggregation settings tile](../../Linked_Image_Files/M11_L03-IoTCentral-Dashboard-Tile-aggregation-settings.png)

You can also change the chart visualization by clicking the Ruler icon on the tile.

![IoT Central - visualization settings tile](../../Linked_Image_Files/M11_L03-IoTCentral-Dashboard-Tile-visualization-settings.png)

## Tile Types

The following table summarizes the usage of tiles in Azure IoT Central:

|Tile|Dashboard|Description|
|----|---------|-----------|
|Content|Application and device set dashboards|Markdown supported tiles are clickable tiles that display heading and description text. You can also use this tile as a link tile to enable a user to navigate to a URL related to your application.|
|Image|Application and device set dashboards|Image tiles display a custom image and can be clickable. Use an image tile to add graphics to a dashboard and optionally enable a user to navigate to a URL relevant to your application.|
|Label|Application dashboards|Label tiles display custom text on a dashboard. You can choose the size of the text. Use a label tile to add relevant information to the dashboard such descriptions, contact details, or help.|
|Map|Application and device set dashboards|Map tiles display the location and state of a device on a map. For example, you can display where a device is and whether its fan is switched on.|
|Line Chart|Application and device dashboards|Line chart tiles display a chart of aggregate measurement for a device for a time period. For example, you can display a line chart that shows the average temperature and pressure of a device for the last hour.|
|Bar Chart|Application and device dashboards|Bar chart tiles display a chart of aggregate measurements for a device for a time period. For example, you can display a bar chart that shows the average temperature and pressure of a device for the last hour.|
|Pie Chart|Application and device set dashboards|Pie chart tiles display a chart of aggregate measurements for a device for a time period.|
|Heat Map|Application and device set dashboards|Heat Map tiles display information about the device set, represented as colors.|
|Event History|Application and device dashboards|Event History tiles display the events for a device over a time period. For example, you can use it to show all the temperature changes for a device during the last hour.|
|State History|Application and device dashboards|State history tiles display the measurement values for a time period. For example, you can use it to show the temperature values for a device during the last hour.|
|KPI|Application and device dashboards|KPI tiles display an aggregate telemetry or event measurement for a time period. For example, you can use it to show the maximum temperature reached for a device during the last hour.|
|Last Known Value|Application and device dashboards|Last known value tiles display the latest value for a telemetry or state measurement. For example, you can use this tile to display the most recent measurements of temperature, pressure and humidity for a device.|

---

**Instructor Notes**

[Configure the application dashboard](https://docs.microsoft.com/en-us/azure/iot-central/core/howto-add-tiles-to-your-dashboard?toc=/azure/iot-central/preview/toc.json&bc=/azure/iot-central/preview/breadcrumb/toc.json)
