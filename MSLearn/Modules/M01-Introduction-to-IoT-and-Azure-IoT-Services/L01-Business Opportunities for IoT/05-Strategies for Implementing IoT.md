# Strategies for Implementing IoT

As with most technology, an enterprise may adopt IoT to solve specific business problems or to take advantage of new opportunities. In either case, the process starts with a project plan that defines how the technology will be used to meet the goals of the business.

Stephanie Jernigan and Sam Ransbotham in an article for MIT Sloan Management Review [offer the following guidance](https://sloanreview.mit.edu/article/getting-started-with-iot/) for getting an IoT solution off the ground.

1. **Keep the initial scope small**. Since an IoT solution involves devices as well as cloud services, doing small experiments with an initially low-cost investment gives business the ability to try things and adjust quickly without spending too much capital on the front side. They write, "The result of such an approach is that future phases aren’t saddled with large compatibility requirements from the first phase. Low investments mean lower sunk costs for replacement (if necessary). And fewer relationships mean fewer affected systems in other organizations."

2. **Think about the short- and long-term value of IoT**. Companies may have an initial set of metrics they want to meet or goals they want to achieve with an IoT solution. But the authors advise that businesses should stay open to possibilities that they may not conceive of at the beginning of a project. In other words, it may be best to think of implementing an IoT _solution_ and think of IoT as an on-going experiment.

3. **Consider Alternatives**. A good way to figure out what an IoT implementation ought to do is to think about other ways you might get the data you need. If implementing IoT is the _best_ way to get that data, then its more likely that the project will be successful.

## IoT Governance

As you plan an IoT solution, engineering and deploying the solution are just the beginning of the solution as a whole. Given the complexities of an IoT solution, planning for how an IoT solution will be maintained and monitored is essential to make the project successful. This topic is often referred to as IoT Governance, and is a topic that Microsoft and others have worked on to provide guidance.

Microsoft's cloud offering, Azure, has been built from the ground up to align with the needs of the Enterprise and has created a documentation hub, the [Azure Architecture Center](https://docs.microsoft.com/en-us/azure/architecture/), which provides access to resources that provide general guidelines and best practices for governance strategies.

Let's look at the major aspects of IoT governance in turn.

### Develop an IoT technical strategy

Similar to the MIT Sloan Review guidance, a successful IoT deployment will include a robust planning phase that will define all aspects of the solution. IBM recommends focusing on business objectives and the team members you'll need to not only build and deploy the solution but to maintain the hardware, software, and cloud services as well as analyze and act on the data.  

Microsoft's guidance stresses the importance of identifying the key stakeholders and managing cross-team buy-in at this early stage. This helps to ensure that the essential business goals are identified and on-going sponsorship is maintained though the project lifecycle. Of course, prototyping and experimentation are important in this "Proof of Value" phase as are the operational aspects of the deployment including automation and fine-tuning the solution.

In order to accelerate the Proof of Value phase, Microsoft has provided [Azure IoT Central](https://azure.microsoft.com/en-us/services/iot-central/) - a "Software as a Service" IoT Offering, as well as a number of [preconfigured solution accelerators](https://www.azureiotsolutions.com/Accelerators) that can be used as the basis of custom solutions:

* [Remote Monitoring](https://www.azureiotsolutions.com/Accelerators#description/remote-monitoring)
* [Connected Factory](https://www.azureiotsolutions.com/Accelerators#description/connected-factory)
* [Predictive Maintenance](https://www.azureiotsolutions.com/Accelerators#description/predictive-maintenance)
* [Device Simulation](https://www.azureiotsolutions.com/Accelerators#description/device-simulation)

### Define an IoT reference architecture

A reference architecture is a guide against which all IoT implementations will be based. By using a reference architecture, you can ensure that when an IoT solution is being developed for your organization, each implementation is doing things in generally the same way. It also helps ensure that best practices are being followed and that reusable elements are being shared across implementations. The governance policy should enforce that the reference architecture includes all the elements and best practices that you want to be used across IoT implementations. To support the development of a governance strategy, Microsoft has a [dedicated documentation hub for governance](https://docs.microsoft.com/en-us/azure/governance/) that provides a collection of concepts and services that are designed to enable management of various Azure resources at scale.

Throughout this course, we'll be referring to Microsoft's own reference architecture document as a guide for how to implement an IoT solution based on Microsoft's software and services. As the [Azure IoT Reference Architecture document](https://aka.ms/iotrefarchitecture) states:

> Every organization has unique skills and experience and every IoT application has unique needs and considerations.

So while the reference document can be a good start for your own reference architecture document, the reference architecture and technology choices recommended should be modified as needed for each.

A key aspect of any reference architecture is security. As Microsoft states:

> When designing a system, it is important to understand the potential threats to that system, and add appropriate defenses accordingly, as the system is designed and architected. It is important to design the product from the start with security in mind because understanding how an attacker might be able to compromise a system helps make sure appropriate mitigations are in place from the beginning.

The Azure IoT Reference Architecture has been designed to incorporate many of the foundational governance and security guiding principals:

* [Governance Design](https://docs.microsoft.com/en-us/azure/architecture/cloud-adoption/governance/governance-multiple-teams)
* [Prescriptive subscription governance](https://docs.microsoft.com/en-us/azure/architecture/cloud-adoption/appendix/azure-scaffold)
* [Internet of Things (IoT) security architecture](https://docs.microsoft.com/en-us/azure/iot-fundamentals/iot-security-architecture)

### Acquire the right roles or skills on the development team

Because of the complexity of developing and maintaining IoT solutions, IBM recommends specific roles for building the team you'll need for the entire development and support life cycle of the solution. Specifically, they recommend the solution include:

* **IoT architect** role that defines the entire solution including the strategy, integration approach, and best practices.
* **IoT developer** who is focused on implementation and definition for the technical implementation of the solution.
* **Data analyst** role which focuses on all aspects of the data collection, modeling, and analysis and reporting strategy.
* **IoT tester** who manages quality control for the entire solution and ensures the system is secure.
* **Device SME** (subject matter expert) who defines the device specifications and works with the other roles to ensure the right devices are in place and how those devices should be managed over the life cycle of the solution.
* **Security Architect**. IBM calls this out as a distinct role for good reason. Security should be thought of as a solution, according to IBM, and not merely a feature of the system. The security architect defines all aspects of the security of the solution including data collection and analysis, network operation, and governance practices (among others).

In addition to the development team, IBM recommends forming an IoT "Center of Excellence" which essentially is a governance board (or person depending on the size of the project) that is responsible for defining and governing everything from the business side of the solution to the operational side. The CoE would work with the solution architect (who most likely would be a key member) and help create the reference architecture. IBM defines a number of other roles for the CoE including analyzing the solution for reuse opportunities, promoting the adoption of best practices, and working with vendors device and platform vendors that will develop key aspects of the solution.

### Define your IoT governance processes and policies

All of the above would fall under IoT governance and requires written policies and processes that should be "followed, applied, and enforced" to make the IoT solution successful and secure.
