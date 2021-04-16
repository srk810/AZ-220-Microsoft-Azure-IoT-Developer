# IoTHubName=$1
# DeviceID=$2

exists=$( az iot hub device-identity list  --hub-name $1 --query "[?contains(deviceId, '$2')].deviceId" -o tsv )
if [ "${exists}" == "${DeviceID}" ]
then
    echo "Already exists"
else
    output=$( az iot hub device-identity create --hub-name $1 --device-id $2-o json >> build.log 2>&1 )
fi

DeviceConnectionString=$( az iot hub device-identity connection-string show --hub-name $1 --device-id $2 -o tsv )

echo $1
echo $2
echo "{'DeviceConnectionString':'${DeviceConnectionString}', 'Arg1': '$1', 'Arg2': '$2'}" > $AZ_SCRIPTS_OUTPUT_PATH
