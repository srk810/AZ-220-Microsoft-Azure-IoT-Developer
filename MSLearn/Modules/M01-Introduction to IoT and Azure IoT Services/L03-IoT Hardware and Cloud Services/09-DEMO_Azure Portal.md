# Demo - Azure Portal

**TODO - Review**

## Prerequisites

* Azure Subscription

## Required For

* DEMO - Create a Device

## Demo Steps

* Portal navigation
* Subscription selection
* Create resource group
* Create IoT Hub

---

**Instructor Notes**

Need to help students with:

* accounts and subscriptions
* navigation within the portal
* costs and other considerations for this course

(MCB) We should consider explicitly calling out demoing whatever will be seen in the lab if possible, and calling out what takes time to create and thus should be pre-staged in "cooking show" format vs. what can be waited on.  There's also the risk of students not knowing basic Azure stuff like resource groups and getting bogged down here on that.  It's a big problematic to demo IoT Hub creation though when the tiers are explained later.

---

## Portal Navigation

>**Note:** Prior to starting this demo, logout of any Windows/Azure accounts to demo the login experience.

1. In your Web browser, to open your Azure portal, navigate to the [portal.azure.com](http://portal.azure.com).

    When you log into Azure you will arrive at the Azure portal. The Azure portal provides you with a customizable UI that you can use to access your Azure resources.

1. In the upper left corner of the portal window, to open the portal menu, click the hamburger menu icon.

    At the top of the portal menu, you should see a section containing four menu options:

    * The **Create a resource** button opens a page displaying the services available through the Azure Marketplace, many of which provide free options. Notice that services are grouped by technology, including "Internet of Things", and that a search box is provided.
    * The **Home** button opens a customized page that displays links to Azure services, your recently accessed services, and other tools.
    * The **Dashboard** button opens a page displaying your default (or most recently used) dashboard. You will be creating a dashboard later in this lab.

    * The **All services** button opens a page similar to the **Create a resource** button described above.

    The bottom section of the portal menu is a **FAVORITES** section that can be customized to show your favorite, or most commonly used, resources. Later in this lab, you will learn how to customize this default list of common services to make it a list of your own favorites.

1. On the portal menu, to display the **Home** page, click **Home**.

1. On the home page, to display a map of data center regions, under **Azure services**, click **Service Health**.

    When you subscribe to a resource in Azure you'll pick a region to deploy it to. Azure is supported by a series of regions placed all around the world.

    This map shows the current status of regions associated with your subscription(s). A green circle is used to indicate that services are running normally at that region.

    With any cloud vendor (Azure, AWS, Google Cloud, etc.), services will go down from time to time. If you see a blue 'i' next to a region on the Service Health map, it means the region is experiencing a problem with one or more services. Azure mitigates these issues by running multiple copies of your application in different regions (a practice referred to as *Geo-redundancy*). If a region experiences an issue with a particular service, those requests will roll over to another region to fulfill the request. This is one of the big advantages of hosting apps in the Azure cloud. Azure deals with the issues, so you don't have to.

1. In the upper-left corner of your Azure portal, to navigate back to your home page, click **Microsoft Azure**.

    You can also use the portal menu to perform some simple navigation. You will have a chance to try out some options for portal navigation shortly.

1. Open the portal menu, and then click **All services**.

    The _All services_ page provides you with a few different viewing options and access to all of the services that Azure offers in both PaaS and IaaS. The first time that you open the _All services_ page, you will see the _Overview_ page. This view is accessible from the left side menu.

    >**Definitions:** The term **PaaS** is an acronym for **Platform as a Service**, and the term **IaaS** is an acronym for **Infrastructure as a Service**

1. On the _All services_ page, under _Categories_, click **All**.

    This view displays all of the services organized into groups corresponding to each Category. The Search box at the top can be very helpful.

1. On the left side of the _All services_ page, under _Categories_, click **Internet of Things**.

    The list of services is now limited to the services directly related to an IoT solution.

    Service/Resource pages on the Azure portal are sometimes referred to as _blades_. When you opened the Service Health page a couple of steps back, you opened a Service Health blade.

    The Azure portal uses blades as a kind of navigation pattern, opening new blades to the right as you drill deeper and deeper into a service. This gives you a form of breadcrumb navigation as you navigate horizontally.

1. Hover your mouse pointer over **IoT Hub**.

    A dialog box is displayed. In the top-right corner, notice the "star" shape. When the star shape is filled-in, the service is selected as a favorite. Favorites will appear on the list of your favorite services on the left navigation menu of the portal window. This makes it easier to access the services that you use most often. You can customize your favorites list by selecting the services that you use most.

1. In the top-right corner of the _IoT Hub_ dialog, to add IoT Hub to the list of your favorite services, click the star shaped icon.

    The star should now appear filled. If the star is shown as an outline, click the star icon again.

    >**Tip:** When you add a new item to your list of favorites, it is placed at the bottom of the favorites list on the Azure portal menu. You can rearrange your favorites into the order that you want by using a drag-and-drop operation.

    Use the same process to add the following services to your favorites: **Device Provisioning Services**, **Function App**, **Stream Analytics jobs**, and **Azure Cosmos DB**.

    > [!NOTE] You can remove a service from the list of your favorite services by clicking the star of a selected service.

1. On the left side of the _All services_ page, under _Categories_, click **General**.

1. Ensure that the following services are selected as favorites:

    * **Subscriptions**
    * **Resource groups**

    The favorites that you've added are enough to get you started, but you can use the _Internet of Things_ category to add additional favorites to the portal menu if you want.

1. Notice the toolbar at the top of the portal that runs the full width of the window.

    In addition to the hamburger menu icon on the far left of this toolbar, there several items that you will find helpful.

    First, notice that you have a _Search resources_ tool that can be used to quickly find a particular resource.

    To the right of the search tool are several buttons that provide access to common tools. You can hover the mouse pointer over a button to display the button name.

    * The _Cloud Shell_ button opens an interactive, authenticated shell right in the portal window that you can use to manage Azure resources. The Azure Cloud Shell supports Bash and PowerShell.
    * The _Directory + Subscriptions_ button opens a pane that you can use to manage your Azure subscriptions and account directory (the Azure Active Directory authentication mechanism).
    * The _Notifications_ button that opens a notifications pane. The notifications pane is useful when working with a long running process. You will be monitoring notifications when you create and configure resources throughout this course.
    * There are also buttons for *Settings*, *Feedback*, and *Help*. The *Help* button contains links to help documents and a list of useful keyboard shortcuts.

    On the far right is a button for your account information, providing you with access to things like your account password and billing information.

1. On the toolbar, click **Help**, and then click **Help + support**

1. On the _Help + support_ blade, notice the four Tiles for _Getting started_, _Documentation_, _Learn about billing_, and _Support plans_.

    The _Help + support_ blade gives you access to lots of great resources. You may want to come back to this later for further exploration.

1. On the _Help + support_ blade, click **Learn about billing**

1. On the _Azure Documentation_ page, in the _Filter by title_ textbox, type **Prevent unexpected costs**

1. Just below the filter textbox, click **Prevent unexpected costs**

    If *you* are using a paid Azure subscription and you are responsible for billing (you are the Account Administrator), you can use these instructions to set up billing alerts.

## Create an Azure Dashboard and Resource Group

1. In a Web browser, navigate to your Azure portal.

    You can use the following link to open the Azure portal: [Azure portal](https://portal.azure.com)

1. On the portal menu, click **Dashboard**.

1. On the _Dashboard_ page, click **+ New dashboard**

    We are going to create a custom dashboard to organize the resources that we use in this course.

1. To name your new dashboard, replace **My Dashboard** with **AZ-220**

    In the upcoming steps you will be adding a tile to your dashboard manually. Another option would be to use drag-and-drop operations to add tiles from the Tile gallery to the space provided.

1. At the top of the dashboard editor, click **Done customizing**

    You should see an empty dashboard at this point.

1. On the portal menu, click **Resource groups**

    This blade displays all of the resource groups that you have created using your Azure subscription(s). If you are just getting started with Azure, you probably don't have any resource groups yet.

1. On the _Resource groups_ blade, on the top menu, click **+ Add**

    This will open a new blade named _Create a resource group_.

1. Take a moment to review the contents of the _Create a resource group_ blade.

    Notice that the resource group is associated with a Subscription and a Region. Consider the following:

    * How might associating a subscription with your resource group be helpful?
    * How might associating a region with your resource group affect what you include in your resource group?

1. In the **Subscription** dropdown, select the Azure subscription that you are using for this course.

1. In the **Resource group** textbox, enter **AZ-220-RG**

    The name of the resource group must be **unique** within your subscription. A green check mark will appear if the name that you enter has not already been used and confirms to resource group naming rules.

    >**Tip:** The Azure documentation describes all Azure [naming rules and restrictions](https://docs.microsoft.com/en-us/azure/architecture/best-practices/resource-naming).


1. In the **Region** dropdown, select a region that is near you.  You should check with your instructor as well, [as not all regions offer all services](https://azure.microsoft.com/en-us/global-infrastructure/services/).

    You need to provide a location for the resource group because the resource group stores metadata about the resources and acts as the default location for where new resources in the resource group will be created. For compliance reasons, you may want to specify where that metadata is stored. In general, we recommend that you specify a location where most of your resources will reside. Using the same location can simplify the template used to manage your resources.

1. At the bottom of the _Create a resource group_ blade, click **Review + create**.

    You should see a message informing you that the settings for your resource group have been validated successfully.

1. To create your resource group, click **Create**.

1. On the top menu of the _Resource groups_ blade, to see your new resource group, click **Refresh**

    You will learn more about managing your resources as you continue through this course.

1. In the list of named resource groups, click the box to the left of the **AZ-220-RG** resource group that your just created.

    > [!NOTE] You don't want to open the resource group in a new blade, you just want to select it (check mark on the left).

1. On the right side of the screen, click the ellipsis (...) corresponding to your resource group, and then click **Pin to dashboard**

1. Close your _Resource groups_ blade.

    Your dashboard should now contain an empty Resources tile, but don't worry, we fill it up soon enough.

## Create an IoT Hub

1. Login to [portal.azure.com](https://portal.azure.com) using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.  You may find it easiest to use an InPrivate / Incognito browser session to avoid accidentally using the wrong account.

1. Notice that the AZ-220 dashboard that you created in the previous task has been loaded.

    You will be adding resources to your dashboard as the course continues.

1. On the portal menu, click **+ Create a resource**.

    The Azure Marketplace is a collection of all the resources you can create in Azure. The marketplace contains resources from both Microsoft and the community.

1. In the Search textbox, type **IoT Hub** and then press **Enter**.

1. On the search results blade, click **IoT Hub**.

    Notice the list of _Useful Links_ displayed on this blade.

1. In the list of links, click **Documentation** to open a new browser tab.

    The _IoT Hub Documentation_ page is the root page for IoT Hub resources and documentation. You can use this page to explore current documentation and find tutorials and other resources that will help you to explore activities that are outside the scope of this course. We will refer you to the docs.microsoft.com site throughout this course for additional reading on specific topics.

1. Use your browser to close the documentation tab and navigate back to the Azure portal tab.

1. To begin the process of creating your new IoT Hub, click **Create**.

    >**Tip:** In the future, there are two other ways to get to the _Create_ experience of any Azure resource type:
        1. If you have the service in your Favorites, you can click the service to navigate to the list of instances, then click the _+ Add_ button at the top.
        2. You can search for the service name in the _Search_ box at the top of the portal to get to the list of instances, then click the _+ Add_ button at the top.

    Next, you need to specify information about the Hub and your subscription. The following steps walk you through the settings, explaining each of the fields as you fill them in.

1. On the _IoT hub_ blade, on the _Basics_ tab, ensure that the Azure **Subscription** that you intend to use for this course is selected.

1. To the right of **Resource Group**, open the **Select existing** dropdown, and then click **AZ-220-RG**

    This is the resource group that you created in the previous lab. We will be grouping the resources that we create for this course together in the same resource group. This should help you to clean up your resources when you have completed the course.

1. To the right of **Region**, open the drop-down list and select the same region as your resource group.  Make sure it supports Event Grid.

    As we saw previously, Azure is supported by a series of datacenters that are placed in regions all around the world. When you create something in Azure, you deploy it to one of these datacenter locations.

    > [!NOTE] For the current list of regions that support Event Grid, see the following link: [Products available by region](https://azure.microsoft.com/en-us/global-infrastructure/services/?products=event-grid&regions=all)
    
    > [!NOTE] When picking a region to host your app, keep in mind that picking a region close to your end users will decrease load/response times. If you are on the other side of the world from your end users, you should not be picking the region nearest you.

1.  To the right of **IoT Hub Name**, enter a globally unique name for your IoT Hub.

    To provide a globally unique name, enter **AZ-220-HUB-_{YOUR-ID}_** (remember to replace **_{YOUR-ID}_** with the unique ID you created in Lab 1.).

    For example: **AZ-220-HUB-CAH191021**

    The name of your IoT Hub must be globally unique because it is a publicly accessible resource that you must be able to access from any IP connected device.

    Consider the following when you specify a unique name for your new IoT Hub:

    * The value that you apply to _IoT Hub Name_ must be unique across all of Azure. This is true because the value assigned to the name will be used in the IoT Hub's connection string. Since Azure enables you to connect devices from anywhere in the world to your hub, it makes sense that all Azure hubs must be accessible from the Internet using the connection string and that connection strings must therefore be unique. We'll explore connection strings later in this lab.

    * The value that you assign to _IoT Hub Name_ cannot be changed once the app service has been created. If you do need to change the name, you'll need to create a new IoT Hub, re-register your devices to it, and delete your old IoT Hub.

    * The _IoT Hub Name_ field is a required field.

    > [!NOTE] Azure will ensure that the name you enter is unique. If the name that you enter is not unique, Azure will display an asterisk at the end of the name field as a warning. You can append the name suggested above with '**-01**' or '**-02**' as necessary to achieve a globally unique name.

1. At the top of the blade, click **Size and scale**.

    Take a minute to review the information presented on this blade.

1. To the right of Pricing and scale tier, open the dropdown and then select **S1: Standard tier** if it is not already selected.

    You can choose from several tier options depending on how many features you want and how many messages you send through your solution per day. The _S1_ tier that we are using in this course allows a total of 400,000 messages per unit per day and provides the all of the services that are required in this training. We won't actually need 400,000 messages per unit per day, but we will be using features provided at this tier level, such as _Cloud-to-device commands_, _Device management_, and _IoT Edge_. IoT Hub also offers a free tier that is meant for testing and evaluation. It has all the capabilities of the standard tier, but limited messaging allowances. However, you cannot upgrade from the free tier to either basic or standard. The free tier is intended for testing and evaluation. It allows 500 devices to be connected to the IoT hub and up to 8,000 messages per day. Each Azure subscription can create one IoT Hub in the free tier.

    > [!NOTE] The _S1 - Standard_ tier has a cost of $25.00 USD per month per unit. We will be specifying 1 unit. For details about the other tier options, see [Choosing the right IoT Hub tier for your solution](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-scaling).

1. To the right of **Number of S1 IoT Hub units**, ensure that **1** is selected.

    As mentioned above, the pricing tier that you choose establishes the number of messages that your hub can process per unit per day. To increase the number of messages that you hub can process without moving to a higher pricing tier, you can increase the number of units. For example, if you want the IoT hub to support ingress of 700,000 messages, you choose *two* S1 tier units. For the IoT courses created by Microsoft we will be using just 1 unit.

1. Under _Advanced Settings_, ensure that **Device-to-cloud partitions** is set to **4**.

    The number of partitions relates the device-to-cloud messages to the number of simultaneous readers of these messages. Most IoT hubs will only need four partitions, which is the default value. For this course we will create our IoT Hub using the default number of partitions.

1. At the top of the blade, click **Review + create**.

1. At the bottom of the blade, to finalize the creation of your IoT Hub, click **Create**.

    Deployment can take a minute or more to complete. You can open the Azure portal Notification pane to monitor progress.

1. Notice that after a couple of minutes you receive a notification stating that your IoT Hub was successfully deployed to your **AZ-220-RG** resource group.

1. On the portal menu, click **Dashboard**, and then click **Refresh**.

    You should see that your resource group tile lists your new IoT Hub.
