# Manage Devices at Scale using Jobs

You can use Microsoft Azure IoT Central to manage your connected devices at scale using jobs. Jobs let you do bulk updates to device properties, settings, and commands. This article walks you through how to get started using jobs in your own application.

**Note**: Jobs for Azure IoT Edge devices is currently not supported.

## Create and run a job

1. Navigate to **Jobs** from the navigation pane.

1. Select **+ New** to create a new job.

1. Enter a name and description to identify the job you're creating.

1. Select the device set you want your job to apply to. 

    After selecting the device set, you see the right-hand side populate with the devices in the device set. If you select a broken device set, no devices display and you see a message that your device set is broken.

1. Choose the **Job type** that you want to define

    The options are Settings, Properties, or Commands.  

1. Select **+** next to the type of job selected, and then add the job operations.

1. On the right-hand side, choose the devices you’d like to run the job on.

    By selecting the top check box, all devices are selected in the entire device set. By selecting the check box near Name, all devices on the current page are selected.

    The following screenshot illustrates the process in the UI:

    * We select a Settings job type, and then define an operation to set the fan speed for a refrigerated vending machine.
    * Then, on the right-hand side, we select all of the available refrigerator devices
 
    ![IoT Central - Jobs Configuration](../../Linked_Image_Files/M11_L03-IoTCentral-Jobs-configurejob.png

1. After selecting your devices, choose **Run** or **Save**.

    The job now appears on your main Jobs page. On this view, you can see your currently running job and the history of any previously run jobs. Your running job always shows up at the top of the list. Your saved job can be opened again at any time to continue editing or to run.

## Review Job Information

To see an overview of your jobs, select a job from the list on your Jobs page. This overview contains the job details, devices, and device status values. From this overview, you can also select Download Job Details to download a .csv file of your job details, including the devices and their status values. 

This information can be useful for troubleshooting.

### View the Job Status

After a job is created, the Status column updates with the latest status message of the job. The following table lists the possible status values:

|Status message|Status meaning|
|--------------|--------------|
|Completed|This job has been executed on all devices.|
|Failed|This job has failed and not fully executed on devices.|
|Pending|This job hasn't yet begun executing on devices.|
|Running|This job is currently executing on devices.|
|Stopped|This job has been manually stopped by a user.|

The status message is followed by an overview of the devices in the job. The following table lists the possible device status values:

|Status message|Status meaning|
|--------------|--------------|
|Succeeded|The number of devices that the job successfully executed on.|
|Failed|The number of devices that the job has failed to execute on.|

### View the Device Status

To view the status of the job and all the affected devices, select the job. To download a .csv file that includes the job details, including the list of devices and their status values, select Download job details. Next to each device name, you see one of the following status messages:

|Status message|Status meaning|
|--------------|--------------|
|Completed|The job has been executed on this device.|
|Failed|The job has failed to execute on this device. The error message shows more information.|
|Pending|The job hasn't yet executed on this device.|
 
**Note**: If a device has been deleted, you can't select the device and it displays as deleted with the device ID.

## Running and Stopping Jobs

To stop a running job, select it and choose Stop on the panel. The job status changes to reflect the job is stopped.

To run a job that's currently stopped, select the stopped job. Choose Run on the panel. The job status changes to reflect the job is now running again.

## Copy a Job

To copy an existing job you've created, select it from the main jobs page and select Copy. A new copy of the job configuration opens for you to edit. You can save or run the new job. If any changes have been made to your selected device set, they're reflected in this copied job for you to edit.

---

**Instructor Notes**

[Create and run a job in your Azure IoT Central application](https://docs.microsoft.com/en-us/azure/iot-central/core/howto-run-a-job?toc=/azure/iot-central/preview/toc.json&bc=/azure/iot-central/preview/breadcrumb/toc.json)
