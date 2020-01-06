# Introduction to Device Groups

A device group is a list of devices that are grouped together because they match some specified criteria. Device groups help you manage, visualize, and analyze devices at scale by grouping devices into smaller, logical groups. For example, you can create a device group to list all the air conditioner devices in Seattle to enable a technician to find the devices for which they're responsible.

## To Create a Device Group

1. Choose Device Groups on the left pane.

1. Select **+ New**.

1. Give your device group a name.

    You can also add a description for the device group. 

    **Note**: A device group can only contain devices from a single device template.

1. Create a query to identify the devices that will belong to the device group.

    You can add multiple queries and devices that meet all the criteria are placed in the device group. The device group you create is accessible to anyone who has access to the application, so anyone can view, modify, or delete the device group.

    **Note**: The device group is a dynamic query. Every time you view the list of devices, there may be different devices in the list. The list depends on which devices currently meet the criteria of the query.

1. Click **Save**.

## Analytics on a Device Group

You can use Analytics with a device group to analyze the telemetry from the devices in the group.

To analyze the telemetry for a device group:

1. Choose Analytics on the left pane.

1. Select a device group, and then select desired telemetry types.

    You can specify an aggregation type for telemetry values. The default aggregation type is **Average**. You can use **Split by** to change how the aggregate data is shown. For example, if you split by device ID you see a plot for each device when you select Analyze.

1. Select **Analyze** to view a plot of the specified telemetry values.

---

**Instructor Notes**

[Tutorial: Use device groups to analyze device telemetry (preview features)](https://docs.microsoft.com/en-us/azure/iot-central/preview/tutorial-use-device-groups)
