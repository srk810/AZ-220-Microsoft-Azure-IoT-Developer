# Security Recommendations

Azure Security Center for IoT scans your Azure resources and IoT devices and provides security recommendations to reduce your attack surface. Security recommendations are actionable and aim to aid customers in complying to security best practices.

## Recommendations for IoT devices

Device recommendations provide insights and suggestions to improve device security posture.

|Severity|Name|Data Source|Description|
|--------|----|-----------|-----------|
|Medium|Open Ports on device|Agent|A listening endpoint was found on the device .|
|Medium|Permissive firewall policy found in one of the chains.|Agent|Allowed firewall policy found (INPUT/OUTPUT). Firewall policy should deny all traffic by default, and define rules to allow necessary communication to/from the device.|
|Medium|Permissive firewall rule in the input chain was found|Agent|A rule in the firewall has been found that contains a permissive pattern for a wide range of IP addresses or ports.|
|Medium|Permissive firewall rule in the output chain was found|Agent|A rule in the firewall has been found that contains a permissive pattern for a wide range of IP addresses or ports.|
|Medium|Operation system baseline validation has failed|Agent|Device doesn't comply with CIS Linux benchmarks.|

## Operational recommendations for IoT devices

Operational recommendations provide insights and suggestions to improve security agent configuration.

|Severity|Name|Data Source|Description|
|--------|----|-----------|-----------|
|Low|Agent sends unutilized messages|Agent|10% or more of security messages were smaller than 4 KB during the last 24 hours.|
|Low|Security twin configuration not optimal|Agent|Security twin configuration is not optimal.|
|Low|Security twin configuration conflict|Agent|Conflicts were identified in the security twin configuration.|

## Recommendations for IoT Hub

Recommendation alerts provide insight and suggestions for actions to improve the security posture of your environment.

|Severity|Name|Data Source|Description|
|--------|----|-----------|-----------|
|High|Identical authentication credentials used by multiple devices|IoT Hub|IoT Hub authentication credentials are used by multiple devices. This may indicate an illegitimate device impersonating a legitimate device. Duplicate credential use increases the risk of device impersonation by a malicious actor.|
|Medium|Default IP filter policy should be deny|IoT Hub|IP filter configuration should have rules defined for allowed traffic, and should by default, deny all other traffic by default.|
|Medium|IP filter rule includes large IP range|IoT Hub|An allow IP filter rule source IP range is too large. Overly permissive rules can expose your IoT hub to malicious actors.|
|Low|Enable diagnostics logs in IoT Hub|IoT Hub|Enable logs and retain them for up to a year. Retaining logs enables you to recreate activity trails for investigation purposes when a security incident occurs or your network is compromised.|

---

**Instructor Notes**

[Security recommendations](https://docs.microsoft.com/en-us/azure/asc-for-iot/concept-recommendations)
