// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// New Features:
//
// * New style of application - a back-end app that can connect to IoT Hub and
//   "listen" for telemetry. The app will be used to automate the control of the
//   temperature in the cheese cave

using System;
using System.Threading.Tasks;
using System.Text;
using System.Collections.Generic;
using System.Linq;

using Microsoft.Azure.EventHubs;
using Microsoft.Azure.Devices;
using Newtonsoft.Json;

namespace CheeseCaveOperator
{
    class Program
    {
        // Global variables.
        // Stores the URI for the IoT Hub built-in service-facing endpoint
        // (messages/events) that is compatible with Event Hubs
        private readonly static string eventHubsCompatibleEndpoint = "<your event hub endpoint>";

        // The path to the Event Hub entity.
        private readonly static string eventHubsCompatiblePath = "<your event hub path>";
        // The key for the shared access policy rule for the
        // namespace, or entity.
        private readonly static string iotHubSasKey = "<your event hub Sas key>";
        // The key name to the corresponding shared access policy rule for the
        // namespace, or entity.
        private readonly static string iotHubSasKeyName = "service";
        // The event hub client instance, which will be used to receive messages
        // from the IoT Hub.
        private static EventHubClient eventHubClient;
        // The service client instance that will be used to send messages from
        // the app to the IoT Hub (and from there, on to targeted devices, etc.).
        private static ServiceClient serviceClient;

        // The registry manager instance that facilitates querying the device
        // registry.
        private static RegistryManager registryManager;

        // Connection string for your IoT Hub.
        private readonly static string serviceConnectionString = "<your service connection string>";
        // the device ID used by the CheeseCaveDevice application.
        private readonly static string deviceId = "sensor-th-0055";

        // INSERT Main method below here
        public static async Task Main(string[] args)
        {
            ConsoleHelper.WriteColorMessage("Cheese Cave Operator\n", ConsoleColor.Yellow);

            // Create an EventHubClient instance to connect to the IoT Hub Event
            // Hubs-compatible endpoint. This is effectively a helper class that
            // concatenates the various values into the correct format.
            var connectionString = new EventHubsConnectionStringBuilder(
                new Uri(eventHubsCompatibleEndpoint),
                eventHubsCompatiblePath,
                iotHubSasKeyName,
                iotHubSasKey);

            eventHubClient = EventHubClient
                .CreateFromConnectionString(connectionString.ToString());

            // The eventHubClient is then used to retrieve the run time
            // information for the event hub. This information contains:
            // * CreatedAt - the Date / Time the Event Hub was created
            // * PartitionCount - the number of partitions(most IoT Hubs are
            //   configured with 4 partitions)
            // * PartitionIds - a string array containing the partition IDs
            // * Path - the event hub entity path
            var runtimeInfo = await eventHubClient.GetRuntimeInformationAsync();

            // An array of partition IDs is stored in d2cPartitions variable,
            // where it will be shortly used to create a list of tasks that will
            // receive messages from each partition.
            var d2cPartitions = runtimeInfo.PartitionIds;

            // A registry manager is used to access the digital twins.
            registryManager = RegistryManager
                .CreateFromConnectionString(serviceConnectionString);
            await SetTwinProperties();

            // Create a ServiceClient to communicate with service-facing endpoint
            // on your hub.
            serviceClient = ServiceClient
                .CreateFromConnectionString(serviceConnectionString);

            // Invokes a Direct Method on the device
            await InvokeMethod();

            // Create receivers to listen for messages.
            // As messages sent from devices to an IoT Hub may be handled by any
            // of the partitions, the app has to retrieve messages from each.
            // The next section of code creates a list of asynchronous tasks -
            // each task will receive messages from a specific partition.
            var tasks = new List<Task>();
            foreach (string partition in d2cPartitions)
            {
                tasks.Add(ReceiveMessagesFromDeviceAsync(partition));
            }

            // The final line will wait for all tasks to complete - as each task
            // is going to be in an infinite loop, this line prevents the
            // application from exiting.
            Task.WaitAll(tasks.ToArray());
        }

        // Asynchronously create a PartitionReceiver for a partition and then
        // start reading any messages sent from the simulated client.
        // As you can see, this method is supplied with an argument that defines
        // the target partition. Recall that for the default configuration where
        // 4 partitions are specified, this method is called 4 times, each
        // running asynchronously and in parallel, one for each partition.
        private static async Task ReceiveMessagesFromDeviceAsync(string partition)
        {
            // The first part of this method creates an event hub receiver. The
            // code specifies that the $Default consumer group is used,
            // (although it is common to create a custom consumer group), the
            // partition, and finally at what position in the event partition's
            // data to start receiving from. In this case, the receiver will
            // only be interested in messages enqueued from the current time
            // onwards - there are other options that allow the start of the
            // data stream, the end of the data stream, or a specific offset to
            // be provided.
            var eventHubReceiver = eventHubClient.CreateReceiver(
                "$Default",
                partition,
                EventPosition.FromEnqueuedTime(DateTime.Now));

            Console.WriteLine("Created receiver on partition: " + partition);

            // Once the receiver is created, the app enters an infinite loop and
            // waits to receive events.
            while (true)
            {
                // Check for EventData - this methods times out if there is
                // nothing to retrieve.
                // The eventHubReceiver.ReceiveAsync(100) code specifies the
                // maximum number of events that can be received in one go,
                // however, it does not wait for that many - it will return as
                // soon as at least one is available.
                var events = await eventHubReceiver.ReceiveAsync(100);

                // If no events are returned (due to a timeout), then the loop
                // continues and the code waits for more events.
                if (events == null) continue;

                // If there is data in the batch, process it
                foreach (EventData eventData in events)
                {
                    // Each event data body is converted from a byte array to a
                    // string and written to the console for logging purposes.
                    string data = Encoding.UTF8.GetString(eventData.Body.Array);

                    ConsoleHelper.WriteGreenMessage("Telemetry received: " + data);

                    // The event data properties are then iterated and, in this
                    // case, checked to see if a value is true - in the current
                    // scenario, this represents an alert. Should an alert be
                    // found, it is written to the console.
                    foreach (var prop in eventData.Properties)
                    {
                        if (prop.Value.ToString() == "true")
                        {
                            ConsoleHelper.WriteRedMessage(prop.Key);
                        }
                    }
                    Console.WriteLine();
                }
            }
        }

        // INSERT InvokeMethod method below here
        // Handle invoking a direct method.
        private static async Task InvokeMethod()
        {
            try
            {
                var methodInvocation = new CloudToDeviceMethod("SetFanState") { ResponseTimeout = TimeSpan.FromSeconds(30) };
                string payload = JsonConvert.SerializeObject("On");

                methodInvocation.SetPayloadJson(payload);

                // Invoke the direct method asynchronously and get the response from the simulated device.
                var response = await serviceClient.InvokeDeviceMethodAsync(deviceId, methodInvocation);

                if (response.Status == 200)
                {
                    ConsoleHelper.WriteGreenMessage("Direct method invoked: " + response.GetPayloadAsJson());
                }
                else
                {
                    ConsoleHelper.WriteRedMessage("Direct method failed: " + response.GetPayloadAsJson());
                }
            }
            catch
            {
                ConsoleHelper.WriteRedMessage("Direct method failed: timed-out");
            }
        }

        // INSERT Device twins section below here
        private static async Task SetTwinProperties()
        {
            var twin = await registryManager.GetTwinAsync(deviceId);
            var patch =
                @"{
                tags: {
                    customerID: 'Customer1',
                    cheeseCave: 'CheeseCave1'
                },
                properties: {
                    desired: {
                        patchId: 'set values',
                        temperature: '50',
                        humidity: '85'
                    }
                }
            }";
            await registryManager.UpdateTwinAsync(twin.DeviceId, patch, twin.ETag);

            var query = registryManager.CreateQuery(
                "SELECT * FROM devices WHERE tags.cheeseCave = 'CheeseCave1'", 100);
            var twinsInCheeseCave1 = await query.GetNextAsTwinAsync();
            Console.WriteLine("Devices in CheeseCave1: {0}",
                string.Join(", ", twinsInCheeseCave1.Select(t => t.DeviceId)));
        }
    }

    internal static class ConsoleHelper
    {
        internal static void WriteColorMessage(string text, ConsoleColor clr)
        {
            Console.ForegroundColor = clr;
            Console.WriteLine(text);
            Console.ResetColor();
        }
        internal static void WriteGreenMessage(string text)
        {
            WriteColorMessage(text, ConsoleColor.Green);
        }

        internal static void WriteRedMessage(string text)
        {
            WriteColorMessage(text, ConsoleColor.Red);
        }
    }
}