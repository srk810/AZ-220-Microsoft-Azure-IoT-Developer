# Introduction to Rules

Rules in IoT Central serve as a customizable response tool that trigger on actively monitored events from connected devices.

## Select Target Devices

Rules are applied to specific devices. Use the target devices section to select the kind of devices that a rule will be applied to. Filters allow you to further refine what devices should be included. The filters use properties on the device template to filter down the set of devices. Filters themselves don't trigger an action. In the following screenshot, the devices that are being targeted are of device template type Refrigerator. The filter states that the rule should only include Refrigerators where the Manufactured State property equals Washington.

![IoT Central - target device filters](../../Linked_Image_Files/M11_L03-IoTCentral-Rules-target-device-filters.png)

## Use multiple conditions

Conditions are what rules trigger on. Currently, when you add multiple conditions to a rule, they're logically AND'd together. In other words, all conditions must be met for the rule to evaluate as true.

In the following screenshot, the conditions check when the temperature is greater than 90 and the humidity is less than 10. When both of these statements are true, the rule evaluates to true and triggers an action.

![IoT Central - multiple conditions](../../Linked_Image_Files/M11_L03-IoTCentral-Rules-conditions.png)

## Use aggregate windowing

Rules evaluate aggregate time windows as tumbling windows. In the screenshot below, the time window is five minutes. Every five minutes, the rule evaluates on the last five minutes of data. The data is only evaluated once in the window to which it corresponds.

![IoT Central - aggregate windowing and tumbling window](../../Linked_Image_Files/M11_L03-IoTCentral-Rules-aggregate-windowing-tumbling-window.png)

## Use rules with IoT Edge modules

A restriction applies to rules that are applied to IoT Edge modules. Rules on telemetry from different modules aren't evaluated as valid rules. Take the following as an example. The first condition of the rule is on a temperature telemetry from Module A. The second condition of the rule is on a humidity telemetry on Module B. Since the two conditions are from different modules, this is an invalid set of conditions. The rule isn't valid and will throw an error on trying to save the rule.

---

**Instructor Notes**

[Configure rules (preview features)](https://docs.microsoft.com/en-us/azure/iot-central/preview/howto-configure-rules)
