# Demo - Azure CLI

## Prerequisites

* `jq` json query tool [https://stedolan.github.io/jq/](https://stedolan.github.io/jq/)
  * Note: already installed on Azure Cloud Shell (bash).
* Install az iot extensions (script will do this for you if needed)
  * `az extension add --name azure-cli-iot-ext`
* Create a two IoT Hubs
* Add 10 devices to the second hub

Execute `09-demo-setup.azcli`

## Install Azure CLI

1. Open your browser, and then navigate to the Azure CLI 2.0 tools download page: [Install Azure CLI 2.0](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest "Azure CLI 2.0 Install")

1. On the Install Azure CLI 2.0 page, select the install option for your OS, and then follow the on-screen instructions to install the Azure CLI tool.

    We will be providing detailed instructions for using the Azure CLI 2.0 tools during the labs in this course, but if you want more information now, see [Get started with Azure CLI 2.0](https://docs.microsoft.com/en-us/cli/azure/get-started-with-azure-cli?view=azure-cli-latest)

## Azure CLI help

1. At the command prompt, to view the general help, enter the following command:

    ```bash
    az --help
    ```

    This will list all of the sub-groups and commands available at this top level.

1. To view the help for the iot sub-group, enter the following command:

    ```bash
    az iot --help
    ```

    Note that the list of available sub-groups are now scoped to the iot group.

## Login to Azure

1. At the command prompt, enter the `login` command:

    ``` bash
    az login
    ```

    If the CLI can open your default browser, it will do so and load an Azure sign-in page.

    Otherwise, open a browser page at [https://aka.ms/devicelogin](https://aka.ms/devicelogin) and enter the authorization code displayed in your terminal.

2. In the browser, follow the on-screen instructions to sign in with your account credentials.

    After logging in, you see a list of subscriptions associated with your Azure account. The subscription information with isDefault: true is the currently activated subscription after logging in. 

    To select a different subscription, use the `az account set` command with the subscription ID for the subscription that you want to switch to. For more information about subscription selection, see [https://docs.microsoft.com/en-us/cli/azure/manage-azure-subscriptions-azure-cli?view=azure-cli-latest](https://docs.microsoft.com/en-us/cli/azure/manage-azure-subscriptions-azure-cli?view=azure-cli-latest).

## Managing Subscriptions

It is possible to have more than one subscription associated with a single account, so it is important to understand how to list the subscriptions, choose the current active subscription and to change the default subscription.

1. At the command prompt, to list the available subscriptions, enter the following command:

    ```bash
    az account list --output table

    Name                      CloudName    SubscriptionId                        State    IsDefault
    ------------------------  -----------  ------------------------------------  -------  -----------
    Subscription1             AzureCloud   aa1122bb-4bd0-462b-8449-a1002aa2233a  Enabled  True
    Subscription2             AzureCloud   aa1122bb-4bd0-462b-8449-a1002aa2233b  Enabled  False
    Azure Pass - Sponsorship  AzureCloud   aa1122bb-4bd0-462b-8449-a1002aa2233c  Enabled  False
    ```

    As you can see, the **Azure Pass - Sponsorship** in use for the course is listed, but is not set to the default subscription.

1. To view the currently active subscription, enter the following command:

    ```bash
    az account show -o table

    EnvironmentName    IsDefault    Name           State    TenantId
    -----------------  -----------  -------------  -------  ------------------------------------
    AzureCloud         True         Subscription1  Enabled  aa1122bb-4bd0-462b-8449-a1002aa2233a
    ```

1. To change the default subscription to the **Azure Pass - Sponsorship**, enter the following command:

    ```bash
    az account set --subscription "Azure Pass - Sponsorship"
    ```

    You can confirm the change by reentering the following command:

    ```bash
    az account show -o table

    EnvironmentName    IsDefault    Name                      State    TenantId
    -----------------  -----------  ------------------------  -------  ------------------------------------
    AzureCloud         True         Azure Pass - Sponsorship  Enabled  aa1122bb-4bd0-462b-8449-a1002aa2233c
    ```

This subscription will now be used whenever you create resources, etc.

>**Important:** Remind the students to change back when they have completed the course!

## List Existing Hubs

1. At the command prompt, to list the available IoT Hubs, enter the following command:

    ``` bash
    az iot hub list
    ```

    Notice that the output is displayed in JSON by default, which can be difficult to read, especially if the output is long. There are a number of output format options:

    |--output|Description|
    |-------|------------|
    |json|JSON string. This setting is the default.|
    |jsonc|Colorized JSON.|
    |yaml|YAML, a machine-readable alternative to JSON.|
    |table|ASCII table with keys as column headings.|
    |tsv|Tab-separated values, with no keys|

1. To display the output in a tabular format, enter the following command: 

    ```bash
    az iot hub list --output table
    ```

    ```text
    Location    Name                    Resourcegroup     Subscriptionid
    ----------  ----------------------  ----------------  ------------------------------------
    centralus   AZ220-HUB01-DM12052019  AZ220-Instructor  ae82ff3b-4bd0-462b-8449-d713dd18e11e
    centralus   AZ220-HUB02-DM12052019  AZ220-Instructor  ae82ff3b-4bd0-462b-8449-d713dd18e11e
    ```

    Notice that only a few columns, and no nested objects, are included in the output. The output can be customized by using the `--query` option.

1. To choose the columns used in the output, enter the following command:

    ```bash
    az iot hub list --query '[].{Name:name, Location:location, SKU:sku.name, Partitions:properties.eventHubEndpoints.events.partitionCount}' --output table
    ```

    ```text
    Name                    Location    SKU    Partitions
    ----------------------  ----------  -----  ------------
    AZ220-HUB01-DM12052019  centralus   S1     4
    AZ220-HUB02-DM12052019  centralus   S1     4
    ```

    This query can be broken into two parts:

    * `[]` - iterates through the array of returned objects
    * `{key:value, key:value, ...}` - generates a dictionary. The `key` is used as the column title in a table output, and the `value` is the path to the property (note how some properties are nested).

1. To list the devices registered with a particular hub, enter the following command:

    ```bash
    az iot hub device-identity list -n AZ220-HUB02-DM12052019 -o table
    ```

    >**Note:** Change the hub name above to match the name you used.