IoTHubName=$1
DeviceID=$2

exists=$( az iot hub device-identity list  --hub-name $IoTHubName --query "[?contains(deviceId, '${DeviceID}')].deviceId" -o tsv )
if [ "${exists}" == "${DeviceID}" ]
then
    echo "Already exists"
else
    output=$( az iot hub device-identity create --hub-name $IoTHubName --device-id $DeviceID -o json >> build.log 2>&1 )
fi

DeviceConnectionString=$( az iot hub device-identity connection-string show --hub-name $IoTHubName --device-id $DeviceID -o tsv )

echo $1
echo $2
echo "{'DeviceConnectionString':'${DeviceConnectionString}'}" > $AZ_SCRIPTS_OUTPUT_PATH
