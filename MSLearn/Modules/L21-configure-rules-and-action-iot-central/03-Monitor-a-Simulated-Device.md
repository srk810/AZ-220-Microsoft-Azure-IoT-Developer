# Monitor a Simulated Device

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