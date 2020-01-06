#!/bin/bash

# Variables for resource creation - update for your needs
rg=AZ220-Instructor
location=centralus
uniqueid=DM12052019
iothub1name=AZ220-HUB01-$uniqueid
iothub2name=AZ220-HUB02-$uniqueid

# functions
reportStatus() {
    if [ -z "$1" ]
    then
        return
    fi
    echo "Create type: $(echo $1 | jq '.type'), name: $(echo $1 | jq '.name'), status: $(echo $1 | jq '.properties.provisioningState')"
}

ensureExtension() {
    ext=$(az extension list --query "[?name == '$1']" | jq '.[].name' -r)
    if [ '$ext' = '$1' ]
    then
        echo "The $1 extension is installed."
    else
        echo "This script requires the $1 extension."
        az extension add --name "$1"
    fi
}

ensureJQ() {
    hash jq 2>/dev/null || { echo >&2 "JQ tool (https://stedolan.github.io/jq/) is required but not found.  Aborting."; exit 1; }
}

# start of script

# ensure that the JSON Query tool is installed
ensureJQ

# ensure extension is loaded
ensureExtension "azure-cli-iot-ext"

# Create a resource group.
output=$(az group create --name $rg --location $location)
reportStatus "$output"

# Create two IoT Hubs for demo
output=$(az iot hub create --resource-group $rg --name $iothub1name --sku S1 --location $location --partition-count 4)
reportStatus "$output"

output=$(az iot hub create --resource-group $rg --name $iothub2name --sku S1 --location $location --partition-count 4)
reportStatus "$output"

# Create 10 devices on IoT Hub 2
for i in {1..10}
do
    device=$(az iot hub device-identity create -n $iothub2name -d azdev$i)
    if [ -z "$device" ]
    then
        echo 'do nothing' > /dev/null
    else
        echo "Create deviceId: $(echo $device|jq '.deviceId'), primaryKey: $(echo $device|jq '.authentication.symmetricKey.primaryKey')"
    fi
done