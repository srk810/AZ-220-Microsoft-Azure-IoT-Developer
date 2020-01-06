# Control Access to DPS

The provisioning service uses permissions to grant access to each endpoint. Permissions limit the access to a service instance based on functionality. For example, a backend app must include a token containing security credentials along with every message it sends to the service.

## Access control and permissions

You can grant permissions in the following ways:

* Shared access authorization policies. Shared access policies can grant any combination of permissions. You can define policies in the Azure portal, or programmatically by using the Device Provisioning Service REST APIs. A newly created provisioning service has the following default policy:
* provisioningserviceowner: Policy with all permissions.

## Authentication

Azure IoT Hub Device Provisioning Service grants access to endpoints by verifying a token against the shared access policies. Security credentials, such as symmetric keys, are never sent over the wire.

## Security tokens

The Device Provisioning Service uses security tokens to authenticate services to avoid sending keys on the wire. Additionally, security tokens are limited in time validity and scope. Azure IoT Device Provisioning Service SDKs automatically generate tokens without requiring any special configuration. Some scenarios do require you to generate and use security tokens directly. Such scenarios include the direct use of the HTTP surface.

### Security token structure

You use security tokens to grant time-bounded access for services to specific functionality in IoT Device Provisioning Service. To get authorization to connect to the provisioning service, services must send security tokens signed with either a shared access or symmetric key.

A token signed with a shared access key grants access to all the functionality associated with the shared access policy permissions.
The security token has the following format:

`SharedAccessSignature sig={signature}&se={expiry}&skn={policyName}&sr={URL-encoded-resourceURI}`

Here are the expected values:

|Value|Description|
|-----|-----------|
|{signature}|An HMAC-SHA256 signature string of the form: {URL-encoded-resourceURI} + "\\n" + expiry. **Important**: The key is decoded from base64 and used as key to perform the HMAC-SHA256 computation.|
|{expiry}|UTF8 strings for number of seconds since the epoch 00:00:00 UTC on 1 January 1970.|
|{URL-encoded-resourceURI}|Lower case URL-encoding of the lower case resource URI. URI prefix (by segment) of the endpoints that can be accessed with this token, starting with host name of the IoT Device Provisioning Service (no protocol). For example, mydps.azure-devices-provisioning.net.|
|{policyName}|The name of the shared access policy to which this token refers.|

**Note on prefix**: The URI prefix is computed by segment and not by character. For example `/a/b` is a prefix for `/a/b/c` but not for `/a/bc`.

The following Node.js snippet shows a function called **generateSasToken** that computes the token from the inputs `resourceUri, signingKey, policyName, expiresInMins`. The next sections detail how to initialize the different inputs for the different token use cases.

```javascript
var generateSasToken = function(resourceUri, signingKey, policyName, expiresInMins) {
    resourceUri = encodeURIComponent(resourceUri);

    // Set expiration in seconds
    var expires = (Date.now() / 1000) + expiresInMins * 60;
    expires = Math.ceil(expires);
    var toSign = resourceUri + '\n' + expires;

    // Use crypto
    var hmac = crypto.createHmac('sha256', new Buffer(signingKey, 'base64'));
    hmac.update(toSign);
    var base64UriEncoded = encodeURIComponent(hmac.digest('base64'));

    // Construct authorization string
    var token = "SharedAccessSignature sr=" + resourceUri + "&sig="
    + base64UriEncoded + "&se=" + expires + "&skn="+ policyName;
    return token;
};
```

As a comparison, the equivalent Python code to generate a security token is:

```python
from base64 import b64encode, b64decode
from hashlib import sha256
from time import time
from urllib import quote_plus, urlencode
from hmac import HMAC

def generate_sas_token(uri, key, policy_name, expiry=3600):
    ttl = time() + expiry
    sign_key = "%s\n%d" % ((quote_plus(uri)), int(ttl))
    print sign_key
    signature = b64encode(HMAC(b64decode(key), sign_key, sha256).digest())

    rawtoken = {
        'sr' :  uri,
        'sig': signature,
        'se' : str(int(ttl)),
        'skn' : policy_name
    }

    return 'SharedAccessSignature ' + urlencode(rawtoken)
```

### Use security tokens from service components

Service components can only generate security tokens using shared access policies granting the appropriate permissions as explained previously.

Here are the service functions exposed on the endpoints:

|Endpoint|Functionality|
|--------|-------------|
|{your-service}.azure-devices-provisioning.net/enrollments|Provides device enrollment operations with the Device Provisioning Service.|
|{your-service}.azure-devices-provisioning.net/enrollmentGroups|Provides operations for managing device enrollment groups.|
|{your-service}.azure-devices-provisioning.net/registrations/{id}|Provides operations for retrieving and managing the status of device registrations.|

As an example, a service generated using a pre-created shared access policy called **enrollmentread** would create a token with the following parameters:

* resource URI: `{mydps}.azure-devices-provisioning.net`,
* signing key: one of the keys of the `enrollmentread` policy,
* policy name: `enrollmentread`,
* an expiration time

```javascript
var endpoint ="mydps.azure-devices-provisioning.net";
var policyName = 'enrollmentread'; 
var policyKey = '...';

var token = generateSasToken(endpoint, policyKey, policyName, 60);
```

The result, which would grant access to read all enrollment records, would be:

```
SharedAccessSignature sr=mydps.azure-devices-
provisioning.net&sig=JdyscqTpXdEJs49elIUCcohw2DlFDR3zfH5KqGJo4r4%3D&se=1456973447&skn=enrollmentread
```

## Device Provisioning Service permissions

The following table lists the permissions you can use to control access to your IoT Device Provisioning Service.

|Permission|Notes|
|----------|-----|
|ServiceConfig|Grants access to change the service configurations. This permission is used by backend cloud services.|
|EnrollmentRead|Grants read access to the device enrollments and enrollment groups. This permission is used by backend cloud services.|
|EnrollmentWrite|Grants write access to the device enrollments and enrollment groups. This permission is used by backend cloud services.|
|RegistrationStatusRead|Grants read access to the device registration status. This permission is used by backend cloud services.|
|RegistrationStatusWrite|Grants delete access to the device registration status. This permission is used by backend cloud services.|

---

**Instructor Notes**

[Control access to Azure IoT Hub Device Provisioning Service](https://docs.microsoft.com/en-us/azure/iot-dps/how-to-control-access)
