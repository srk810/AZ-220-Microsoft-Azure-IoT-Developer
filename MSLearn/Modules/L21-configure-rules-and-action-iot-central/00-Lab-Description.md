# Create your first Azure IoT Central app

## Scenario

Suppose you run a company that operates a fleet of refrigerated trucks.

You have a number of customers within a city, and a base that you operate from. You command each truck to take its contents and deliver it to any one customer. However, the cooling system may fail on any one of your trucks. If the contents do start to melt, you will need the option of instructing the truck to return to base and dump the contents. Alternatively, you can deliver the contents to another customer who might be nearer to the truck when you become aware the contents are melting.

In order to make these decisions, you will need an up-to-date picture of all that is going on with your trucks. You will need to know the location of each truck on a map, the state of the cooling system, and the state of the contents.

IoT Central provides all you need to handle this scenario.

In this lab you will:

* Create an Azure IoT Central custom app, using the IoT Central portal
* Create a device template for a custom device, using the IoT Central portal
* Add Node.js code to support simulated devices, with routes selected by Azure Maps
* Monitor and command the simulated devices, from an IoT Central dashboard

## Links

* [What is Azure ioT Central](https://docs.microsoft.com/en-us/azure/iot-central/core/overview-iot-central)

## Prerequisites

* An introductory knowledge of the purpose of Azure IoT
* Ability to navigate Azure IoT portal
* Ability to use Node.js, at the beginner level
* Experience using Visual Studio, or Visual Studio Code, at the beginner level
* Must have, or be able to open, an Azure Maps account

## Steps

1. Create a device template
1. Monitor a simulated device
1. Set up your development environment
1. Create a real device in Node.js
1. Test your IoT Central device
1. Add multiple devices
1. Create a device set dashboard
