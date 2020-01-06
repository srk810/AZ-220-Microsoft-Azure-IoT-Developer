# Troubleshooting Guide for D2C Communication Issues

The following issue troubleshooting checklists give you some things to try before you file a support ticket.

## Cannot connect to your Azure IoT hub

If your device doesn't seem to be able to connect to your Azure IoT hub, here are a few things to verify:

1. Are your credentials correct? 

    * if you're using x509 certificates, double-check that the thumbprint in the registry matches the one of the certificate you're trying to use
    * if you're using a connection string with a shared access key, make sure it matches the device or a policy with the DeviceConnect capability.
    * if you're using a shared access signature, make sure the expiry is correct and that you're using the right shared access key to sign it.

1. Verify in your device registry (using the azure portal) that your device is enabled 

1. Can you get through the firewall? 

    * The easiest thing to try first is to run a tool that uses your device credentials and checks for a connection using all supported protocols. The iothub-diagnostics tool [https://github.com/azure/iothub-diagnostics](https://github.com/azure/iothub-diagnostics) is designed to do just that and provides the results in the form of a report.
    * if you cannot run iothub-diagnostics you can try to run through the same steps manually: 

        * ping a known website to verify name resolution and outbound traffic works
        * Change the transport used to instantiate the client (Amqp, AmqpWs, Mqtt, MqttWs, and Http).

1. Try running the default samples [https://github.com/Azure/azure-iot-sdk-node/tree/master/device/samples](https://github.com/Azure/azure-iot-sdk-node/tree/master/device/samples). 

    * If the samples can connect, try finding differences between how you instantiate the client and how the samples do. it might be a simple typo.
    * If the samples cannot connect and neither can iothub-diagnostics it's likely an issue with the credentials or your network.

## Not detecting disconnections

The hard thing about disconnections is that they often seem random and if the SDK is not firing an error, there's no way to know what's going on. Or is there?

1. Could the retry logic be just delaying things? 

    * Be default the retry logic will go on for 4 minutes. Have you waited that long?
    * If you don't want to wait, try disabling the retry logic by calling `client.setRetryPolicy(new NoRetry())`; 

1. Need detailed logs? The SDK uses the debug library for logging 

    * Set the `DEBUG` environment variable and re-run your application. a few good values for the `DEBUG` environment variable to get you started: 

        * `azure*` will log SDK activity but not the underlying transport library
        * `amqp10*` will log the low-level AMQP library activity
        * `*` will log everything

    * `debug` logs to `stderr` by default, and can be quite verbose especially if set to `*`.
    * If you're saving those logs in order to post them in an issue, be careful to scrape for confidential information!

## Failing to send some messages

That's another tricky one. It looks like some messages are being sent, but not all of them. What gives? The first question to ask is How do you know some messages aren't being sent?

1. If it's because the callback is called with an error, the error object might give you more clues than just a message. Pay attention to the type of the error itself: 

    * If it's a custom SDK type it should be pretty explicit, but if it's not enough, look at the properties of the error and try to see if there's a protocol-specific error in there.
    * If it's a generic Error it means the SDK failed to translate that error. Please file an issue and give us as many details as possible including the values of the error properties and the error stack.

1. If it's because you're not seeing the messages in your cloud application, try checking: 

    * On the device side, the arguments passed to the callback of the send operation.
    * Try using iothub-explorer [https://github.com/azure/iothub-explorer](https://github.com/azure/iothub-explorer) with the `monitor-events` subcommand to check if the messages show up on the event-hubs compatible endpoint of your IoT Hub. If they do, at least you know that the device is acting properly. If they don't, you know it's unlikely to be a service issue and can track down device-side issues

---

**Instructor Notes**

[Troubleshooting Guide - Devices](https://github.com/Azure/azure-iot-sdk-node/wiki/Troubleshooting-Guide-Devices)
