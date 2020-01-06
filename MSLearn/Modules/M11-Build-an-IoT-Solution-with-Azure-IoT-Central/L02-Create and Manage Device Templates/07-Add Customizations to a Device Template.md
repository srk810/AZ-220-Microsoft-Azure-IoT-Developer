# Add Customizations to a Device Template

Use customizations when you need to modify an imported interface or add IoT Central-specific features to a capability. You can only customize fields that don't break interface compatibility. For example, you can:

* Customize the display name and units of a capability.
* Add a default color to use when the value appears on a chart.
* Specify initial, minimum, and maximum values for a property.

You can't customize the capability name or capability type. If there are changes you can't make in the Customize section, you'll need to version your device template and interface to modify the capability.

## Generate default views

Generating default views is a quick way to visualize your important device information. You have up to three default views generated for your device template:

* Commands provides a view with device commands, and allows your operator to dispatch them to your device.
* Overview provides a view with device telemetry, displaying charts and metrics.
* About provides a view with device information, displaying device properties.

After you've selected Generate default views, you see that they have been automatically added under the Views section of your device template.

---

**Instructor Notes**

[Tutorial: Define a new IoT device type in your Azure IoT Central application (preview features)](https://docs.microsoft.com/en-us/azure/iot-central/preview/tutorial-define-iot-device-type)
