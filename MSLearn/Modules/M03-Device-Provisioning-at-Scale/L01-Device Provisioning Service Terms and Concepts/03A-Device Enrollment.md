# Device Enrollment

A device enrollment creates a record of a single device or a group of devices that may at some point register with the Azure IoT Hub Device Provisioning Service. The enrollment record contains the initial desired configuration for the device(s) as part of that enrollment, including the desired IoT hub. 

## Enrollment Types

There are two ways you can enroll your devices with the provisioning service:

* Group Enrollments: An Enrollment group is an entry for a group of devices that share a common attestation mechanism of X.509 certificates, signed by the same signing certificate, which can be the root certificate or the intermediate certificate, used to produce device certificate on physical device. Microsoft recommends using an enrollment group for a large number of devices which share a desired initial configuration, or for devices all going to the same tenant. Note that you can only enroll devices that use the X.509 attestation mechanism as enrollment groups.

* Individual Enrollments: An Individual enrollment is an entry for a single device that may register. Individual enrollments may use either x509 certificates or SAS tokens (from a physical or virtual TPM) as attestation mechanisms. We recommend using individual enrollments for devices which require unique initial configurations, or for devices which can only use SAS tokens via TPM or virtual TPM as the attestation mechanism. Individual enrollments may have the desired IoT hub device ID specified.

---

**Instructor Notes**
