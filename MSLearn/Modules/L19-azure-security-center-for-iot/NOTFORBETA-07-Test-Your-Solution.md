# Test Your Solution

In this task, you will set up a custom alert that will let you know if there 


## Set up Custom Alert

1. On the Azure portal menu, click Dashboard and open your IoT Hub - **AZ-220-HUB-{YOUR-ID}**.

   You can also use the portal search bar by entering your IoT Hub name and then select your IoT Hub resource once it is listed.

1. Under **Security** menu on the left side, to onboard Azure Security Center for IoT Hub, click on any of the Security blades, such as **Custom Alerts**.

1. Click on **default** Device Security Group. 

1. Click on **+ Add a customer alert** to create a new custom alert in the **default** Device Security Group.

1. In the **Create custom alert rule** select **Number of failed local logins is not in allowed range** under **Customer Alert**.

1. Under **Required Properties** set the **Minimal Threshold** to **0** and the **Maximal Threshold** to **2**. Set the **Time Window Size** to 5 mins. Your custom alert rule should look like the image below. Click **Ok** when you are finished setting up the custom alert rule.

    ![Screenshot of Azure IoT Security Module](../../Linked_Image_files/MM99-L16-custom-alert.PNG)

1. Notice under **Name** there **Number of failed local logins is not in allowed range** is there. Click **Save** to save the alert.

## Test your solution

Now that your custom alert has been created, you can test to see it in action!

1. Navigate to your newly created virtual machine (**vm-01**)  within the Azure Portal.

1. On the **Overview** pane of the **Virtual machine** blade, click the **Connect** button at the top.

1. Within the **Connect to virtual machine** pane, select the **SSH** option, then copy the **Login using VM local account** value.

1. Open up the Azure Portal in a new tab, At the top of the Azure Portal click on the **Cloud Shell** icon to open up the **Azure Cloud Shell** within the Azure Portal. When the pane opens, choose the option for the **Bash** terminal within the Cloud Shell.

1. Within the Cloud Shell, paste in the `ssh` command that was copied, and press **Enter**.

1. Attempt to login in with the wrong password a couple times.

1. Now, log in to your virtual machine with the right password. Run a couple more commands to 

* Add a couple different new users to your virtual machine by running the following command. (Swap out <username> with a random name). This will simulate if there are 


Expected alert: Detected suspicious use of the useradd command.

    ```cmd/sh
    sudo useradd <username>
    ```
