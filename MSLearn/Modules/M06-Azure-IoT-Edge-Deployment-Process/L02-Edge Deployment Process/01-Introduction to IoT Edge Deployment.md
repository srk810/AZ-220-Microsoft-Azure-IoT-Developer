# Introduction to IoT Edge Deployment

Azure IoT Edge devices follow a device lifecycle that is similar to other types of IoT devices:

1. Provision new IoT Edge devices by imaging a device with an OS and installing the IoT Edge runtime.
1. Configure the devices to run IoT Edge modules, and then monitor their health. 
1. Finally, retire devices when they are replaced or become obsolete. 

The actions accomplished during the Edge deployment process are aligned primarily with the middle stage, where the modules that a device will be running are defined and where monitoring is implemented.

Azure IoT Edge provides two ways to configure the modules to run on IoT Edge devices:

* one for development and fast iterations on a single device
* one for managing large fleets of IoT Edge devices

Both approaches can be implemented either programmatically or by using the Azure portal. 

We use the term **IoT Edge automatic deployments** to refer to configuration and monitoring stages for fleets of devices. 

When targeting groups or a large number of devices, you can use tags in the device twins to specify which devices you'd like your modules deployed to.

At a high level, IoT Edge automatic deployments include the following:

1. An operator defines a deployment that describes a set of modules as well as the target devices. Each deployment has a deployment manifest that reflects this information. 
1. The IoT Hub service communicates with all targeted devices to configure them with the desired modules. 
1. The IoT Hub service retrieves status from the IoT Edge devices and makes them available to the operator. For example, an operator can see when an Edge device is not configured successfully or if a module fails during runtime. 
1. At any time, new IoT Edge devices that meet the targeting conditions are configured for the deployment. For example, a deployment that targets all IoT Edge devices in Washington State automatically configures a new IoT Edge device once it is provisioned and added to the Washington State device group. 

## Deployment

An IoT Edge automatic deployment assigns IoT Edge module images to run as instances on a targeted set of IoT Edge devices. It works by configuring an IoT Edge deployment manifest to include a list of modules with the corresponding initialization parameters. A deployment can be assigned to a single device (based on Device ID) or to a group of devices (based on tags). Once an IoT Edge device receives a deployment manifest, it downloads and installs the container images from the respective container repositories, and configures them accordingly. Once a deployment is created, an operator can monitor the deployment status to see whether targeted devices are correctly configured.

Only IoT Edge devices can be configured with a deployment. The following prerequisites must be on the device before it can receive the deployment:

* The base operating system
* A container management system, like Moby or Docker
* Provisioning of the IoT Edge runtime 

### Deployment manifest

A deployment manifest is a JSON document that describes the modules to be configured on the targeted IoT Edge devices. It contains the configuration metadata for all the modules, including the required system modules (specifically the IoT Edge agent and IoT Edge hub). 

The configuration metadata for each module includes: 

* Version 
* Type 
* Status (for example, running or stopped) 
* Restart policy 
* Image and container registry
* Routes for data input and output 

If the module image is stored in a private container registry, the IoT Edge agent holds the registry credentials.

### Target condition

The target condition is continuously evaluated throughout the lifetime of the deployment. Any new devices that meet the requirements are included, and any existing devices that no longer do are removed. The deployment is reactivated if the service detects any target condition change.

For instance, you have a deployment A with a target condition tags.environment = 'prod'. When you kick off the deployment, there are 10 production devices. The modules are successfully installed in these 10 devices. The IoT Edge Agent Status is shown as 10 total devices, 10 successful responses, 0 failure responses, and 0 pending responses. Now you add five more devices with tags.environment = 'prod'. The service detects the change and the IoT Edge Agent Status becomes 15 total devices, 10 successful responses, 0 failure responses, and 5 pending responses when it tries to deploy to the five new devices.

Use any Boolean condition on device twins tags or deviceId to select the target devices. If you want to use condition with tags, you need to add "tags":{} section in the device twin under the same level as properties.

Target condition examples:

* deviceId ='linuxprod1'
* tags.environment ='prod'
* tags.environment = 'prod' AND tags.location = 'westus'
* tags.environment = 'prod' OR tags.location = 'westus'
* tags.operator = 'John' AND tags.environment = 'prod' NOT deviceId = 'linuxprod1'

Here are some constrains when you construct a target condition:

* In device twin, you can only build a target condition using tags or deviceId.
* Double quotes aren't allowed in any portion of the target condition. Use single quotes.
* Single quotes represent the values of the target condition. Therefore, you must escape the single quote with another single quote if it's part of the device name. For example, to target a device called operator'sDevice, write deviceId='operator''sDevice'.
* Numbers, letters, and the following characters are allowed in target condition values: -:.+%_#*?!(),=@;$.

### Priority

A priority defines whether a deployment should be applied to a targeted device relative to other deployments. A deployment priority is a positive integer, with larger numbers denoting higher priority. If an IoT Edge device is targeted by more than one deployment, the deployment with the highest priority applies. Deployments with lower priorities are not applied, nor are they merged. If a device is targeted with two or more deployments with equal priority, the most recently created deployment (determined by the creation timestamp) applies.

### Labels

Labels are string key/value pairs that you can use to filter and group of deployments. A deployment may have multiple labels. Labels are optional and do no impact the actual configuration of IoT Edge devices. 

### Deployment status

A deployment can be monitored to determine whether it applied successfully for any targeted IoT Edge device. A targeted Edge device will appear in one or more of the following status categories: 

* **Target** shows the IoT Edge devices that match the Deployment targeting condition.
* **Actual** shows the targeted IoT Edge devices that are not targeted by another deployment of higher priority.
* **Healthy** shows the IoT Edge devices that have reported back to the service that the modules have been deployed successfully. 
* **Unhealthy** shows the IoT Edge devices have reported back to the service that one or modules have not been deployed successfully. To further investigate the error, connect remotely to those devices and view the log files.
* **Unknown** shows the IoT Edge devices that did not report any status pertaining this deployment. To further investigate, view service info and log files.

## Phased rollout

A phased rollout is an overall process whereby an operator deploys changes to a broadening set of IoT Edge devices. The goal is to make changes gradually to reduce the risk of making wide scale breaking changes. 

A phased rollout is executed in the following phases and steps: 

1. Establish a test environment of IoT Edge devices by provisioning them and setting a device twin tag like `tag.environment='test'`. The test environment should mirror the production environment that the deployment will eventually target. 

1. Create a deployment including the desired modules and configurations. The targeting condition should target the test IoT Edge device environment.   

1. Validate the new module configuration in the test environment.

1. Update the deployment to include a subset of production IoT Edge devices by adding a new tag to the targeting condition. Also, ensure that the priority for the deployment is higher than other deployments currently targeted to those devices 

1. Verify that the deployment succeeded on the targeted IoT Devices by viewing the deployment status.

1. Update the deployment to target all remaining production IoT Edge devices.

## Rollback

Deployments can be rolled back if you receive errors or misconfigurations. Because a deployment defines the absolute module configuration for an IoT Edge device, an additional deployment must also be targeted to the same device at a lower priority even if the goal is to remove all modules. 

Perform rollbacks in the following sequence: 

1. Confirm that a second deployment is also targeted at the same device set. If the goal of the rollback is to remove all modules, the second deployment should not include any modules. 

1. Modify or remove the target condition expression of the deployment you wish to roll back so that the devices no longer meet the targeting condition.

1. Verify that the rollback succeeded by viewing the deployment status. 

    * The rolled-back deployment should no longer show status for the devices that were rolled back.
    * The second deployment should now include deployment status for the devices that were rolled back.

---

**Instructor Notes**

[Understand IoT Edge automatic deployments for single devices or at scale](https://docs.microsoft.com/en-us/azure/iot-edge/module-deployment-monitoring)