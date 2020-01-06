# Develop Custom Modules with VS Code

Visual Studio Code and the Azure IoT Tools can be used to create an IoT Edge module in your preferred development language (including Azure Functions, written in C#). You start by creating a solution, and then generating the first module in that solution. Each solution can contain multiple modules.

## Create a new solution template

1. Open VS Code

1. Select View > Command Palette.

1. In the command palette, enter and run the command Azure IoT Edge: New IoT Edge Solution.

    ![Custom Edge Modules with VS Code - New Solution](../../Linked_Image_Files/M07_L01-EdgeModulesAndContainers-CreateCustomModule-new-solution.png)

1. Browse to the folder where you want to create the new solution and then select Select folder.

1. Enter a name for your solution.

1. Select a module template for your preferred development language to be the first module in the solution.

1. Enter a name for your module. Choose a name that's unique within your container registry.

1. Provide the name of the module's image repository. Visual Studio Code autopopulates the module name with `localhost:5000/<your module name>`. Replace it with your own registry information. If you use a local Docker registry for testing, then `localhost` is fine. If you use Azure Container Registry, then use the login server from your registry's settings. The login server looks like `<registry name>.azurecr.io`. Only replace the `localhost:5000` part of the string so that the final result looks like `<registry name>.azurecr.io/<your module name>`.

    ![Custom Edge Modules with VS Code - Specify Image Repository Name](../../Linked_Image_Files/M07_L01-EdgeModulesAndContainers-CreateCustomModule-repository.png)

Visual Studio Code takes the information you provided, creates an IoT Edge solution, and then loads it in a new window.

There are four items within the solution:

* A .vscode folder contains debug configurations.
* A modules folder has subfolders for each module. Within the folder for each module there is a file, module.json, that controls how modules are built and deployed. This file would need to be modified to change the module deployment container registry from localhost to a remote registry. At this point, you only have one module. But you can add more in the command palette with the command Azure IoT Edge: Add IoT Edge Module.
* An .env file lists your environment variables. If Azure Container Registry is your registry, you'll have an Azure Container Registry username and password in it.

    * **Note**: The environment file is only created if you provide an image repository for the module. If you accepted the localhost defaults to test and debug locally, then you don't need to declare environment variables.

* A deployment.template.json file lists your new module along with a sample SimulatedTemperatureSensor module that simulates data you can use for testing.

## Add additional modules

To add additional modules to your solution, run the command Azure IoT Edge: Add IoT Edge Module from the command palette. You can also right-click the modules folder or the deployment.template.json file in the Visual Studio Code Explorer view and then select Add IoT Edge Module.

## Develop your module

The default module code that comes with the solution is located at the following location:

* Azure Function (C#): modules \> \<your module name\> \> \<your module name\>.cs
* C#: modules \> \<your module name\> \> Program.cs
* Python: modules \> \<your module name\> \> main.py
* Node.js: modules \> \<your module name\> \> app.js
* Java: modules \> \<your module name\> \> src \> main \> java \> com \> edgemodulemodules \> App.java
* C: modules \> \<your module name\> \> main.c

The module and the deployment.template.json file are set up so that you can build the solution, push it to your container registry, and deploy it to a device to start testing without touching any code. The module is built to simply take input from a source (in this case, the SimulatedTemperatureSensor module that simulates data) and pipe it to IoT Hub.

When you're ready to customize the template with your own code, use the Azure IoT Hub SDKs to build modules that address the key needs for IoT solutions such as security, device management, and reliability.

---

**Instructor Notes**

[Use Visual Studio Code to develop and debug modules for Azure IoT Edge](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-vs-code-develop-module)

Maybe have a demo for [Quickstart: Deploy your first IoT Edge module to a virtual Windows device](https://docs.microsoft.com/en-us/azure/iot-edge/quickstart).
