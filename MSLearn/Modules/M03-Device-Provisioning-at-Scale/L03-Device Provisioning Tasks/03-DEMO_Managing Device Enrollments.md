# DEMO - Managing Device Enrollments

**TODO**: the demo steps below need to be tested and cleaned up

---

## Create a Group Enrollment in the Portal

Create an enrollment group in the portal for a group of devices using the following steps:

1. Log in to the Azure portal and click All resources from the left-hand menu.

1. Click the Device Provisioning service you want to enroll your device to from the list of resources.

    Your provisioning service will open on a new blade.

1. On the Device Provisioning Service blade, click **Manage enrollments**

1. To select the Enrollment Groups tab, click **Enrollment Groups**.

1. On the Enrollment Groups tab, near the top, click **Add**.

    The "Add Enrollment Group" panel will open.

1. On the Add Enrollment Group panel, enter the information for the enrollment list entry. 

    This step requires the following:

    * You must provide a Group name. This is a required field. 
    * For Certificate type, select "CA or Intermediate" 
    * Upload the root Primary certificate for the group of devices.

1. To complete the process, click **Save**. 

    On successful creation of your enrollment group, you should see the group name appear under the Enrollment Groups tab.

---

## Create a Individual Enrollment in the Portal

Create an individual enrollment in the portal using the following steps:

1. Log in to the Azure portal and click All resources from the left-hand menu.

1. Click the Device Provisioning service you want to enroll your device to from the list of resources.

1. Click **Manage enrollments**.

1. To select the Individual Enrollments tab, click **Individual Enrollments**.

1. On the Individual Enrollments tab, near the top, click **Add**.

    After a moment, the "Add Enrollment" panel will open
 
1. On the "Add Enrollment" panel, enter the information for the enrollment list entry. 

    First select the attestation Mechanism for the device (X.509 or TPM). 

    * X.509 attestation requires you to upload the leaf Primary certificate for the device. 
    * TPM requires you to enter the Attestation Key and Registration ID for the device.

1. To complete the process, click **Save**. 

    On successful creation of your enrollment group, you should see your device appear under the Individual Enrollments tab.

---

## Update an enrollment entry

Update an existing enrollment entry in the portal using the following steps:

1. Open your Device Provisioning service in the Azure portal

1. Click **Manage Enrollments**.

1. Open the enrollment entry you want to modify. 

    This opens a summary information about your device enrollment. You can use this page to modify items other than the security type and credentials, such as the IoT hub the device should be linked to, as well as the device ID. You may also modify the initial device twin state.

1. To update your device enrollment, click **Save**.

---

## Remove a device enrollment

In cases where your device(s) do not need to be provisioned to any IoT hub, you can remove the related enrollment entry.

Remove an enrollment entry in the portal using the following steps:

1. Open your Device Provisioning service in the Azure portal.

1. Click **Manage Enrollments**.

1. Navigate to and select the enrollment entry you want to remove.

1. At the top of the page, click **Delete**, and then, when prompted to confirm, click **Yes**.

    Once the action is completed, you will see your entry removed from the list of device enrollments.


---

[How to manage device enrollments with Azure Portal](https://docs.microsoft.com/en-us/azure/iot-dps/how-to-manage-enrollments)
