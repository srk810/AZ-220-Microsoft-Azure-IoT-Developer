param(
    [Parameter(Mandatory)]
    [string] $ioTHubName,

    [Parameter(Mandatory)]
    [string] $deviceID
)

try {
    az iot hub device-identity create --hub-name $ioTHubName --device-id $deviceID
}
catch {
}
$DeviceConnectionString=$( az iot hub device-identity connection-string show --hub-name $ioTHubName --device-id $deviceID -o tsv )

$DeploymentScriptOutputs = @{}
$DeploymentScriptOutputs['deviceConnectionString'] = $DeviceConnectionString