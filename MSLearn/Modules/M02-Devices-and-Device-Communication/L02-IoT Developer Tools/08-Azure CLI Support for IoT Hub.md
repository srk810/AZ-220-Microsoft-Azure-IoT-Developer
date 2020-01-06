# Azure CLI Support for IoT Hub

Azure CLI commands can be used to accomplish many of the tasks associated with managing devices and the Azure IoT Hub service.

## Azure CLI Commands for IoT Hub

Azure CLI commands for the IoT Hub service include commands that work directly on the hub, as well as commands that work on a subgroup of the hub.

### Hub Commands

The following commands can be used to complete a task associated with an IoT Hub.

|IoT Hub Commands|Command Description|
|----------------|-------------------|
|create|Create an Azure IoT hub.|
|delete|Delete an IoT hub.|
|generate-sas-token|Generate a SAS token for a target IoT Hub, device or module.|
|invoke-device-method|Invoke a device method.|
|invoke-module-method|Invoke an Edge module method.|
|list|List IoT hubs.|
|list-skus|List available pricing tiers.|
|manual-failover|Initiate a manual failover for the IoT Hub to the geo-paired disaster recovery region.|
|monitor-events|Monitor device telemetry & messages sent to an IoT Hub.|
|monitor-feedback|Monitor feedback sent by devices to acknowledge cloud-to-device (C2D) messages.|
|query|Query an IoT Hub using a powerful SQL-like language.|
|show|Get the details of an IoT hub.|
|show-connection-string|Show the connection strings for an IoT hub.|
|show-quota-metrics|Get the quota metrics for an IoT hub.|
|show-stats|Get the statistics for an IoT hub.|
|update|Update metadata for an IoT hub.|

#### Command Usage

For usage and help content for any command, append the `--help` parameter to the name of the command as follows:

```
az iot hub <command name> --help
```

For example, to see the usage instruction for the `create` command, enter the following:

```
az iot hub create --help
```

When you run the above command, you will see a message displayed that is similar to the following:

```
Command
    az iot hub create : Create an Azure IoT hub.
        For an introduction to Azure IoT Hub, see https://docs.microsoft.com/azure/iot-hub/.

Arguments
    --name -n                               [Required] : IoT Hub name.
    --resource-group -g                     [Required] : Name of resource group. You can configure
                                                         the default group using `az configure
                                                         --defaults group=<name>`.
    --c2d-max-delivery-count --cdd                     : The number of times the IoT hub will
                                                         attempt to deliver a cloud-to-device
                                                         message to a device, between 1 and 100.
                                                         Default: 10.
    --c2d-ttl --ct                                     : The amount of time a message is available
                                                         for the device to consume before it is
                                                         expired by IoT Hub, between 1 and 48 hours.
                                                         Default: 1.
    --fc --fileupload-storage-container-name           : The name of the root container where you
                                                         upload files. The container need not exist
                                                         but should be creatable using the
                                                         connectionString specified.
    --fcs --fileupload-storage-connectionstring        : The connection string for the Azure Storage
                                                         account to which files are uploaded.
    --fd --feedback-max-delivery-count                 : The number of times the IoT hub attempts to
                                                         deliver a message on the feedback queue,
                                                         between 1 and 100.  Default: 10.
    --feedback-lock-duration --fld                     : The lock duration for the feedback queue,
                                                         between 5 and 300 seconds.  Default: 5.
    --feedback-ttl --ft                                : The period of time for which the IoT hub
                                                         will maintain the feedback for expiration
                                                         or delivery of cloud-to-device messages,
                                                         between 1 and 48 hours.  Default: 1.
    --fileupload-notification-max-delivery-count --fnd : The number of times the IoT hub will
                                                         attempt to deliver a file notification
                                                         message, between 1 and 100.  Default: 10.
    --fileupload-notification-ttl --fnt                : The amount of time a file upload
                                                         notification is available for the service
                                                         to consume before it is expired by IoT Hub,
                                                         between 1 and 48 hours.  Default: 1.
    --fileupload-notifications --fn                    : A boolean indicating whether to log
                                                         information about uploaded files to the
                                                         messages/servicebound/filenotifications IoT
                                                         Hub endpoint.  Allowed values: false, true.
    --fileupload-sas-ttl --fst                         : The amount of time a SAS URI generated by
                                                         IoT Hub is valid before it expires, between
                                                         1 and 24 hours.  Default: 1.
    --location -l                                      : Location of your IoT Hub. Default is the
                                                         location of target resource group.
    --partition-count                                  : The number of partitions of the backing
                                                         Event Hub for device-to-cloud messages.
                                                         Default: 2.
    --rd --retention-day                               : Specifies how long this IoT hub will
                                                         maintain device-to-cloud events, between 1
                                                         and 7 days.  Default: 1.
    --sku                                              : Pricing tier for Azure IoT Hub. Default
                                                         value is F1, which is free. Note that only
                                                         one free IoT hub instance is allowed in
                                                         each subscription. Exception will be thrown
                                                         if free instances exceed one.  Allowed
                                                         values: B1, B2, B3, F1, S1, S2, S3.
                                                         Default: F1.
    --unit                                             : Units in your IoT Hub.  Default: 1.

Global Arguments
    --debug                                            : Increase logging verbosity to show all
                                                         debug logs.
    --help -h                                          : Show this help message and exit.
    --output -o                                        : Output format.  Allowed values: json,
                                                         jsonc, none, table, tsv, yaml.  Default:
                                                         json.
    --query                                            : JMESPath query string. See
                                                         http://jmespath.org/ for more information
                                                         and examples.
    --subscription                                     : Name or ID of subscription. You can
                                                         configure the default subscription using
                                                         `az account set -s NAME_OR_ID`.
    --verbose                                          : Increase logging verbosity. Use --debug for
                                                         full debug logs.

Examples
    Create an IoT Hub with the free pricing tier F1, in the region of the resource group.
        az iot hub create --resource-group MyResourceGroup --name MyIotHub


    Create an IoT Hub with the standard pricing tier S1 and 4 partitions, in the 'westus' region.
        az iot hub create --resource-group MyResourceGroup --name MyIotHub --sku S1 --location
        westus --partition-count 4

For more specific examples, use: az find "az iot hub create"
```

### IoT Hub Subgroups

The following IoT Hub subgroups can be used to complete tasks that are associated with the subgroup.

|IoT Hub Subgroups|Subgroup Description|
|-----------------|--------------------|
|certificate|Manage IoT Hub certificates.|
|configuration|Manage IoT device configurations at scale.|
|consumer-group|Manage the event hub consumer groups of an IoT hub.|
|device-identity|Manage IoT devices.|
|device-twin|Manage IoT device twin configuration.|
|devicestream|Manage device streams of an IoT hub.|
|distributed-tracing [Preview]|Manage distributed settings per-device.|
|job|Manage jobs in an IoT hub.|
|message-enrichment|Manage message enrichments for endpoints of an IoT Hub.|
|module-identity|Manage IoT device modules.|
|module-twin|Manage IoT device module twin configuration.|
|policy|Manage shared access policies of an IoT hub.|
|route|Manage routes of an IoT hub.|
|routing-endpoint|Manage custom endpoints of an IoT hub.|

The commands available by accessing each of these subgroup categories can be viewed by running a command that appends `--help` to the subgroup name as follows:

`az iot hub <subgroup name> --help`

For example, if you run the command above for the `device-identity` subgroup, you will see a message displayed that is similar to the following:

```
    az iot hub device-identity : Manage IoT devices.

Commands:
    add-children           : Add specified comma-separated list of non edge device ids as children
                             of specified edge device.
    create                 : Create a device in an IoT Hub.
    delete                 : Delete an IoT Hub device.
    export                 : Export all device identities from an IoT Hub to an Azure Storage blob
                             container.
    get-parent             : Get the parent device of the specified device.
    import                 : Import device identities to an IoT Hub from a blob.
    list                   : List devices in an IoT Hub.
    list-children          : Print comma-separated list of assigned child devices.
    remove-children        : Remove non edge devices as children from specified edge device.
    set-parent             : Set the parent device of the specified non-edge device.
    show                   : Get the details of an IoT Hub device.
    show-connection-string : Show a given IoT Hub device connection string.
    update                 : Update an IoT Hub device.
```

---

**Instructor Notes**

[Microsoft Azure IoT extension for Azure CLI](https://github.com/azure/azure-iot-cli-extension)

[az iot](https://docs.microsoft.com/en-us/cli/azure/iot?view=azure-cli-latest)

[az iot device](https://docs.microsoft.com/en-us/cli/azure/ext/azure-cli-iot-ext/iot/device?view=azure-cli-latest)

[az iot device simulate](https://docs.microsoft.com/en-us/cli/azure/ext/azure-cli-iot-ext/iot/device?view=azure-cli-latest#ext-azure-cli-iot-ext-az-iot-device-simulate)

[az iot hub](https://docs.microsoft.com/en-us/cli/azure/ext/azure-cli-iot-ext/iot/hub?view=azure-cli-latest)

[az iot hub device-identity](https://docs.microsoft.com/en-us/cli/azure/ext/azure-cli-iot-ext/iot/hub/device-identity?view=azure-cli-latest)

