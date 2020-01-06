# DEMO - Set Up DPS using Azure CLI

Azure CLI enables you to manage Azure IoT Hub resources, Device Provisioning service instances, and linked-hubs out of the box. The IoT extension enriches Azure CLI with features such as device management and full IoT Edge capability.

To set up DPS with Azure CLI, you will complete the following steps:

1. Log in to your Azure account
1. Create a resource group
1. Create a Device Provisioning Service
1. Create an IoT Hub
1. Link your IoT Hub to the Device Provisioning Service

## Azure CLI Commands

To get started, open a Windows Command Prompt window. You will need administrator level access to run the Azure CLI commands shown below, so select **Run as administrator** when you open the Command Prompt app.

**TODO - update the demo steps to use the Azure Cloud shell instead of the Command Propt window**

Using the Command Prompt window, enter the following commands to set up DPS:

1. To log in to your Azure account, enter the following command:

    `az login`

    When you enter this command, you will be prompted to open [https://microsoft.com/devicelogin](https://microsoft.com/devicelogin) in a browser and enter the code provided. You will be redirected to a secure Azure sign-in page where you can enter your credentials. Follow the on-screen instructions.

    The Command window will update once your credentials have been verified.

    **Note**: If you have multiple Azure subscriptions associated with your account, you may need to specify the subscription that you want to use.

1. To create a resource group, enter the following command:

    `az group create -l eastus -n myDPSdemoRG`

    This command specifies that the resource group will be created using the `eastus` datacenter location (aka US East), and the resource group will be named `myDPSdemoRG`.

    The command window will update with a "succeeded" message once provisioning is complete.

1. To create a new DPS in your resource group, enter the following command:

    `az iot dps create --name demodps --resource-group myDPSdemoRG --location eastus`

    This command will create a DPS named "demodps" in the resource group that you created above and using the US East location.

    Once provisioning is complete, the command window will update to display the properties for your new DPS and will show a state of "Active".

1. To create an IoT Hub in your resource group, enter the following command:

    **Note**: In the command below, replace `<your name>` with your name (no spaces) and replace `<date>` with the date (such as Nov072019). The name of your IoT Hub must be globally unique, so hopefully including your name and the date will satisfy this requirement.

    `az iot hub create --name <your name>-hub-<date> --resource-group myDPSdemoRG --location eastus`

    for example: `az iot hub create --name chris-hub-Nov072019 --resource-group myDPSdemoRG --location eastus`

    If the name you provide is not globally uniqueYou will receive a message telling you that the name is not available . If necessary, modify the name as required.

1. To display the connection string for your IoT Hub, enter the  following command:

    `az iot hub show-connection-string --name <your name>-hub-<date>`

    for example: `az iot hub show-connection-string --name chris-hub-Nov072019`

    **Note**: You will need the connection string to create the link between your DPS and IoT Hub.

1. To link your IoT Hub to your Device Provisioning Service, enter the following command:

    **Note**: In the command below, replace `<connection string>` with the connection string from your IoT Hub. Include the opening and closing quotes `"`.

    `az iot dps linked-hub create --resource-group myDPSdemoRG --dps-name demodps --connection-string <connection string> --location eastus`

---

**Instructor Notes**

[How to use Azure CLI and the IoT extension to manage the IoT Hub Device Provisioning Service](https://docs.microsoft.com/en-us/azure/iot-dps/how-to-manage-dps-with-cli)

(MCB) There's a todo on this but I want to emphasize that Cloud Shell is the right way to go for all demos if possible.  It's one less thing to have to think about here for a presenter or as a student.