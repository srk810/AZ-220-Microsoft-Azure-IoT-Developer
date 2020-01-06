# Azure CLI Tools

The Azure command-line interface (CLI) is Microsoft's cross-platform command-line experience for managing Azure resources. The Azure CLI is designed to be easy to learn and get started with, but powerful enough to be a great tool for building custom automation to use Azure resources. 

From a purely IoT perspective, Azure CLI enables you to manage Azure IoT Hub resources, Device Provisioning service instances, and linked-hubs out of the box. The IoT extension enriches Azure CLI with features such as device management and full IoT Edge capability.

You can access the full list of Azure CLI resources from the Microsoft Docs site here: [https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)

## Command-line Tools

Azure CLI commands can be run from within a large number of command-line environments available for Windows, Linux, and the MacOS. 

**Note**: In scripts and on the Microsoft documentation site, Azure CLI examples are written for the bash shell. One-line examples will run on any platform. Longer examples which include line continuations (`\`) or variable assignment need to be modified to work on other shells, including PowerShell.

When running in a Windows environment, two convenient options for running Azure CLI commands are:

* Azure Cloud Shell
* Windows Command Prompt app

**Note**: You need administrator privileges to run Azure CLI commands from within a Windows Command Prompt window, so select **Run as administrator** when you open the Command Prompt app.

## Install or run in Azure Cloud Shell

Instructions for installing Azure CLI on your local machine can be found here: [https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

The Azure Cloud Shell environment, which is accessible through the Azure portal, is perhaps the easiest way to get started with Azure CLI. To learn about Cloud Shell, try out the following Quickstart activity: [https://docs.microsoft.com/en-us/azure/cloud-shell/quickstart](https://docs.microsoft.com/en-us/azure/cloud-shell/quickstart).

After installing the CLI for the first time, check that it's installed and you've got the correct version by running az --version.

## Sign in

Before using any CLI commands with a local install, you need to sign in with the `az login` command. For security reasons, there are a couple steps that you will need to complete.

1. At the command prompt, enter the `login` command:

    ``` bash
    az login
    ```

    If the CLI can open your default browser, it will do so and load an Azure sign-in page.

    Otherwise, open a browser page at [https://aka.ms/devicelogin](https://aka.ms/devicelogin) and enter the authorization code displayed in your terminal.

1. In the browser, follow the on-screen instructions to sign in with your account credentials.

    After logging in, you see a list of subscriptions associated with your Azure account. The subscription information with isDefault: true is the currently activated subscription after logging in. 

    To select a different subscription, use the `az account set` command with the subscription ID for the subscription that you want to switch to. For more information about subscription selection, see [https://docs.microsoft.com/en-us/cli/azure/manage-azure-subscriptions-azure-cli?view=azure-cli-latest](https://docs.microsoft.com/en-us/cli/azure/manage-azure-subscriptions-azure-cli?view=azure-cli-latest).

## Extensions

The Azure CLI offers the capability to load extensions. Extensions are Python wheels that aren't shipped as part of the CLI but run as CLI commands. With extensions, you gain access to experimental and pre-release commands along with the ability to write your own CLI interfaces. This article covers how to manage extensions and answers common questions about their use.

### Find extensions

To see the extensions provided and maintained by Microsoft, use the `az extension list-available` command.

```
az extension list-available --output table
```

### Install extensions

Once you have found an extension to install, use az extension add to get it. If the extension is listed in az extension list-available, you can install the extension by name.

```
az extension add --name <extension-name>
```

To install the extension for IoT, use the following command:

```
az extension add --name azure-cli-iot-ext
```

### Update extensions

If an extension was installed by name, update it using `az extension update`.

```
az extension update --name <extension-name>
```

### Uninstall extensions

If you no longer need an extension, remove it with az extension remove.


---

**Instructor Notes**

[The Azure Command-Line Interface](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)

[Quickstart for Bash in Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/quickstart)

[Use multiple Azure subscriptions](https://docs.microsoft.com/en-us/cli/azure/manage-azure-subscriptions-azure-cli?view=azure-cli-latest)

[Use extensions with Azure CLI](https://docs.microsoft.com/en-us/cli/azure/azure-cli-extensions-overview?view=azure-cli-latest)

[Microsoft Azure IoT extension for Azure CLI](https://github.com/azure/azure-iot-cli-extension)
