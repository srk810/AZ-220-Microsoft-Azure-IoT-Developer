# Subsystems of an IoT Architecture

At its core, an IoT solution consists of the following subsystems: 1) devices that have the ability to securely register with the cloud, and connectivity options for sending and receiving data with the cloud, 2) a cloud gateway service, or hub, to securely accept that data and provide device management capabilities, 3) stream processors that consume that data, integrate with business processes, and place the data into storage, and 4) a user interface to visualize telemetry data and facilitate device management.

These core subsystems can be aligned to the Things/Insights/Actions model that we discussed earlier.

![Azure IoT reference architecture](../../Linked_Image_Files/M01_L02_CoreSubsystemsOfAnIoTArchitecture.JPG)

**IoT Devices**: The physical devices where our data originates.

**Cloud Gateway**: The Cloud Gateway provides a cloud hub for secure connectivity, telemetry and event ingestion and device management (including command and control) capabilities.

**Stream Processing**: Processes large streams of data records and evaluates rules for those streams.

**Business Process Integration**:  Facilitates executing actions based on insights garnered from device telemetry data during stream processing. Integration could include storage of informational messages, alarms, sending email or SMS, integration with CRM, and more.

**Storage**: Storage can be divided into warm path (data that is required to be available for reporting and visualization immediately from devices), and cold path (data that is stored longer term and used for batch processing).

**User Interface and Reporting**: The user interface for an IoT application can be delivered on a wide array of device types, in native applications, and browsers.

## Optional Subsystems

In addition to the core subsystems many IoT applications will include subsystems for: 5) telemetry data transformation which allows restructuring, combination, or transformation of telemetry data sent from devices, 6) machine learning which allows predictive algorithms to be executed over historical telemetry data, enabling scenarios such as predictive maintenance, and 7) user management which allows splitting of functionality amongst different roles and users.

![Optional systems of IoT](../../Linked_Image_Files/M01_L02_AllSubsystemsOfAnIoTArchitecture.JPG "Optional Subsystems")

**Data transformation**: The manipulation or aggregation of the telemetry stream either before or after it is received by the cloud gateway service (the IoT Hub). Manipulation can include protocol transformation (e.g. converting binary streamed data to JSON), combining data points, and more.

**Machine Learning (ML) Subsystem**:  Enables systems to learn from data and experiences and to act without being explicitly programmed. Scenarios such as predictive maintenance are enabled through ML.

**User Management Subsystem**: Allows specification of different capabilities for users and groups to perform actions on devices (e.g. command and control such as upgrading firmware for a device) and capabilities for users in applications.

**Edge Devices**: These devices serve an active role in managing access and information flow. They may assist in device provisioning, data filtering, batching and aggregation, buffering of data, protocol translation, event rules processing, and more.

**Bulk Provisioning**: Facilitates provisioning of large numbers of devices.
