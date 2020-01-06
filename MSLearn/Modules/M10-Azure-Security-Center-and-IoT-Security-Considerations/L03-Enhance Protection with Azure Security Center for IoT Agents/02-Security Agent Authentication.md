# Security Agent Authentication

Azure Security Center for IoT provides reference architecture for security agents that log, process, aggregate, and send security data through IoT Hub.

Security agents are designed to work in a constrained IoT environment, and are highly customizable in terms of values they provide when compared to the resources they consume.

Security agents support the following features:

* Collect raw security events from the underlying Operating System (Linux, Windows).
* Aggregate raw security events into messages sent through IoT Hub.
* Authenticate with existing device identity, or a dedicated module identity.
* Configure remotely through use of the **azureiotsecurity** module twin.

A security module is required for each device onboarded to Azure Security Center for IoT in the IoT Hub. To authenticate the device, Azure Security Center for IoT can use one of two methods:

* SecurityModule option
* Device option

## Authentication methods

You can use the following information to help you choose between the two methods for authentication:

* SecurityModule authentication mode

    The agent is authenticated using the security module identity independently of the device identity. Use this authentication type if you would like the security agent to use a dedicated authentication method through security module (symmetric key only).

* Device authentication mode

    In this method, the security agent first authenticates with the device identity. After the initial authentication, the Azure Security Center for IoT agent performs a REST call to the IoT Hub using the REST API with the authentication data of the device. The Azure Security Center for IoT agent then requests the security module authentication method and data from the IoT Hub. In the final step, the Azure Security Center for IoT agent performs an authentication against the Azure Security Center for IoT module.

    Use this authentication type if you would like the security agent to reuse an existing device authentication method (self-signed certificate or symmetric key).

## Authentication methods known limitations

SecurityModule authentication mode only supports symmetric key authentication.

CA-Signed certificate is not supported by Device authentication mode.

## Security agent installation parameters

When deploying a security agent, authentication details must be provided as arguments. These arguments are documented in the following table.

|Linux Parameter Name|Windows Parameter Name|Shorthand Parameter|Description|Options|
|--------------------|----------------------|-------------------|-----------|-------|
|authentication-identity|AuthenticationIdentity|aui|Authentication identity|**SecurityModule** or **Device**|
|authentication-method|AuthenticationMethod|aum|Authentication method|**SymmetricKey** or **SelfSignedCertificate**|
|file-path|FilePath|f|Absolute full path for the file containing the certificate or the symmetric key|     |
|host-name|HostName|hn|FQDN of the IoT Hub|Example: ContosoIotHub.azure-devices.net|
|device-id|DeviceId|di|Device ID|Example: MyDevice1|
|certificate-location-kind|CertificateLocationKind|cl|Certificate storage location|**LocalFile** or **Store**|

When using the install security agent script, the following configuration is performed automatically. To edit the security agent authentication manually, edit the config file.

## Change authentication method after deployment

When deploying a security agent with an installation script, a configuration file is automatically created.

To change authentication methods after deployment, manual editing of the configuration file is required.

### C#-based security agent

Edit _Authentication.config_ with the following parameters:

```xml
<Authentication>
  <add key="deviceId" value=""/>
  <add key="gatewayHostname" value=""/>
  <add key="filePath" value=""/>
  <add key="type" value=""/>
  <add key="identity" value=""/>
  <add key="certificateLocationKind" value="" />
</Authentication>
```

### C-based security agent

Edit _LocalConfiguration.json_ with the following parameters:

```json
"Authentication" : {
	"Identity" : "",
	"AuthenticationMethod" : "",
	"FilePath" : "",
	"DeviceId" : "",
	"HostName" : ""
}
```

---

**Instructor Notes**

[Security agent reference architecture](https://docs.microsoft.com/en-us/azure/asc-for-iot/security-agent-architecture)

[Security agent authentication methods](https://docs.microsoft.com/en-us/azure/asc-for-iot/concept-security-agent-authentication-methods)
