@description('Your unique ID - i.e. dm041221')
param yourID string
@description('Course ID - i.e. az220')
param courseID string

var location = resourceGroup().location
var iotHubName = 'iot-${courseID}-training-${yourID}'
module hub './iotHub.bicep' = {
  name: 'hubDeploy'
  params: {
    iotHubName: iotHubName
    location: location
  }
}

var deviceID = 'sensor-v-3000'

resource devices 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'createDevice'
  kind:'AzureCLI'
  location: location
  dependsOn: [
    hub
  ]
  properties: {
    azCliVersion: '2.20.0'
    retentionInterval: 'P1D'
    timeout: 'PT10M'
    cleanupPreference: 'OnExpiration'
    arguments: '${iotHubName} ${deviceID}'
    scriptContent: '''
    IoTHubName=$1
    DeviceID=$2

    az extension add --name azure-iot

    exists=$( az iot hub device-identity list  --hub-name $IoTHubName --query "[?contains(deviceId, '${DeviceID}')].deviceId" -o tsv )
    if [ "${exists}" == "${DeviceID}" ]
    then
        echo "Already exists"
    else
        output=$( az iot hub device-identity create --hub-name $IoTHubName --device-id $DeviceID -o json >> build.log 2>&1 )
    fi

    DeviceConnectionString=$( az iot hub device-identity connection-string show --hub-name $IoTHubName --device-id $DeviceID -o tsv )

    printf '{"DeviceConnectionString":"%s", "Arg1": "%s", "Arg2": "%s"}\n' $DeviceConnectionString $IoTHubName $DeviceID >  $AZ_SCRIPTS_OUTPUT_PATH
    '''
  }
}

output connectionString string = hub.outputs.connectionString
output deviceConnectionString object = reference('createDevice').outputs
