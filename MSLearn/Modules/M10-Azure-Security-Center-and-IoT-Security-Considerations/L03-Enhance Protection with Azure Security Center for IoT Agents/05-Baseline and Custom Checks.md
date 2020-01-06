# Baseline and Custom Checks

A baseline establishes standard behavior for each device and makes it easier to establish unusual behavior or deviation from expected norms. Baseline custom checks establish a custom list of checks for each device baseline using the Module identity twin of the device.

## Setting baseline properties

1. In your IoT Hub, locate and select the device you wish to change.

1. Click on the device, and then click the azureiotsecurity module.

1. Click Module Identity Twin.

1. Upload the baseline custom checks file to the device.

1. Add baseline properties to the security module and click Save.

### Baseline custom check file example

To configure baseline custom checks:

```json
"desired": {
   "ms_iotn:urn_azureiot_Security_SecurityAgentConfiguration": {
     "baselineCustomChecksEnabled": {
       "value" : true
     },
     "baselineCustomChecksFilePath": {
       "value" : "/home/user/full_path.xml"
     },
     "baselineCustomChecksFileHash": {
       "value" : "#hashexample!"
     }
   }
 },
```

## Baseline custom check properties

|Name|Status|Valid values|Default values|Description|
|----|------|------------|--------------|-----------|
|baselineCustomChecksEnabled|Required: true|Valid values: Boolean|Default value: false|Max time interval before high priority messages is sent.|
|baselineCustomChecksFilePath|Required: true|Valid values: String, null|Default value: null|Full path of the baseline xml configuration|
|baselineCustomChecksFileHash|Required: true|Valid values: String, null|Default value: null|sha256sum of the xml configuration file. Use the sha256sum reference for additional information.|

---

**Instructor Notes**

[Azure Security Center for IoT baseline and custom checks](https://docs.microsoft.com/en-us/azure/asc-for-iot/concept-baseline)
