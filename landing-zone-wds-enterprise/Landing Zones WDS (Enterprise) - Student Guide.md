![Microsoft Cloud Workshops](https://github.com/Microsoft/MCW-Template-Cloud-Workshop/raw/master/Media/ms-cloud-workshop.png "Microsoft Cloud Workshops")

<div class="MCWHeader1">
Landing Zones (Enterprise)
</div>

<div class="MCWHeader2">
Whiteboard design session student guide
</div>

<div class="MCWHeader3">
Nov 2020
</div>

Information in this document, including URL and other Internet Web site references, is subject to change without notice. Unless otherwise noted, the example companies, organizations, products, domain names, e-mail addresses, logos, people, places, and events depicted herein are fictitious, and no association with any real company, organization, product, domain name, e-mail address, logo, person, place or event is intended or should be inferred. Complying with all applicable copyright laws is the responsibility of the user. Without limiting the rights under copyright, no part of this document may be reproduced, stored in or introduced into a retrieval system, or transmitted in any form or by any means (electronic, mechanical, photocopying, recording, or otherwise), or for any purpose, without the express written permission of Microsoft Corporation.

Microsoft may have patents, patent applications, trademarks, copyrights, or other intellectual property rights covering subject matter in this document. Except as expressly provided in any written license agreement from Microsoft, the furnishing of this document does not give you any license to these patents, trademarks, copyrights, or other intellectual property.

The names of manufacturers, products, or URLs are provided for informational purposes only and Microsoft makes no representations and warranties, either expressed, implied, or statutory, regarding these manufacturers or the use of the products with any Microsoft technologies. The inclusion of a manufacturer or product does not imply endorsement of Microsoft of the manufacturer or product. Links may be provided to third party sites. Such sites are not under the control of Microsoft and Microsoft is not responsible for the contents of any linked site or any link contained in a linked site, or any changes or updates to such sites. Microsoft is not responsible for webcasting or any other form of transmission received from any linked site. Microsoft is providing these links to you only as a convenience, and the inclusion of any link does not imply endorsement of Microsoft of the site or the products contained therein.

© 2020 Microsoft Corporation. All rights reserved.

Microsoft and the trademarks listed at https://www.microsoft.com/en-us/legal/intellectualproperty/Trademarks/Usage/General.aspx are trademarks of the Microsoft group of companies. All other trademarks are property of their respective owners.

**Contents**

<!-- TOC -->
- [Landing Zones (Enterprise) - Whiteboard Design Session Student Guide](#landing-zones-enterprise---whiteboard-design-session-student-guide)
  - [Abstract and learning objectives](#abstract-and-learning-objectives)
  - [Step 1: Review the customer case study](#step-1-review-the-customer-case-study)
    - [Customer background](#customer-background)
    - [Technical background](#technical-background)
    - [Current situation](#current-situation)
    - [Customer needs](#customer-needs)
    - [Customer objections](#customer-objections)
  - [Step 2: Design a proof of concept solution](#step-2-design-a-proof-of-concept-solution)
  - [Step 3: Present the solution](#step-3-present-the-solution)
  - [Wrap-up](#wrap-up)
  - [Additional references](#additional-references)

<!-- /TOC -->

# Landing Zones (Enterprise) - Whiteboard Design Session Student Guide

## Abstract and learning objectives 

In this whiteboard design session, you will look at how to design landing zones for Azure at an enterprise-scale. Your focus will be on a globally distributed enterprise scenario, where management is centralized but must systems must be distributed and administered globally for performance and geographical needs.

At the end of the workshop, you will be better able to design and use enterprise-scale design principals for landing zones with Azure, including enrollment, identity & access management, management group and subscription organization, network topology, management and monitoring, business continuity and disaster recovery, and security governance and compliance. You will also understand how to utilize Azure resources and best practices as well as better understand the challenges involved in managing Azure solutions at scale.


## Step 1: Review the customer case study 

**Outcome** 

Analyze your customer’s needs.

Timeframe: 15 minutes 

Directions: With all participants in the session, the facilitator/SME presents an overview of the customer case study along with technical tips. 

1.  Meet your table participants and trainer. 

2.  Read all of the directions for steps 1–3 in the student guide. 

3.  As a table team, review the following customer case study.
 
### Customer background

Contoso Logistics (CL) is a Microsoft client providing a shipping, warehousing, and distribution solutions for various manufactures of consumer products with relationships to thousands of retail chains throughout the world.

Contoso was founded in St. Louis in 1997, originally as Contoso Shipping. The original business was started as a trucking company providing on-time and reliable delivery services across the country. The success of efficient and consistent services to their clients continued to increase their business and alow them to expand beyond the continental US.  The international services were coordinated under a new subdivision as Contoso Shipping Logistics.

The Founder of Contoso, Hugo Fisher, was quick to recognize that technology was a key piece of their services to ensure a reliable and on going service with their clients and have been quick to adopt technology solutions as they become available. In 2014 he re-branded the company as Contoso Logistics and set in place a new business strategy focusing on coordinating with partners and other shipping companies to track and optimizing customer inventories as a multimodal shipping provider. As the company has continued to expand international, their technology footprint and has continued to expand physically and requires many different compliance standards with different state entities. As these costs continue to expand, CL needs to find a way to reduce their physical footprint, work with a partner to ensure compliance & security evolving standards, and optimize costs & performance.  To satisfy these needs, they are looking to move as many services to the cloud as possible. Given CL’s long history as a Microsoft client, Microsoft Azure was the natural choice as preferred public cloud provider.

CL has evolved to work with multiple different shipping and warehousing partners to connect manufactures with retail services for distributing their products. More recently CE has also seen a growth clients interested in their live tracking of products via a well defined API published securely with their partners, reflecting the company’s ongoing growth and success around transparent and reliable services.

### Technical background

The current CL portfolio of applications comprises:
-   Web based application for tracking current location of inventory for manufactures and purchased equipment for their customers
-   Legacy application for optimizing placement of physical equipment in modal containers for log distance shipping
-   Due to different state based regulations, details of shipping and billing information is housed in separate application instances and databases in key countries
-   Centralized tracking and core company details are housed in three redundant data centers geographically separated in the continental US: St. Louis (MO), Seattle (WA), and Richmond (VA)
-   CL customers access details via Web Server farm based on .NET Framework and distributed behind F5 appliances
-   Infrastructure consists of:
    -   Each data center has 40 VM hosts and running 300 virtual machine guests
    -   Datacenters are connected via an MPLS network
    -   50 deployments of their key applications on 15 VMware virtual machines and 3 SQL servers
    -   Each of the international locations connect back to the US datacenters via VPN connections utilizing Juniper devices
-   Sales and remote users connect to the US data centers via VPN to access report and legacy inventory application
-   Sales and coordinators access the legacy application via VPN to their local country's application

![Contoso Corporate Data Locations](images/wds-lze-corporate-world-map-01.png)
*Contoso Logistics data center and server locations*


CL has an Enterprise Agreement with Microsoft for their applications and would like to utilize as much of their existing agreement benefits as possible.

### Current situation

As head of Infrastructure Operations for Contoso Logistics, you are responsible for keeping all your in-house and customer applications & data, secure and available 100% of the time, as well as ensuring all of your security comply with all relevant standards and regulations. As your business grows, you need to scale your operations activities accordingly—but you must minimize costs and staffing needs.

Currently, your teams and equipment distributed through out multiple countries with minimal consistency of hardware types and versions due to rapid growth and minimal staff to deal with local equipment. As your company continues to grow, hardware is purchased as needed and multiple different calendars are needed to maintain various life cycles of the hardware. In addition, a large amount of your team's time is focused on monitoring and responding to physical and network reliability that is often out of their direct management (ie: ISP or unreliable data centers) rather than supporting the performance of the application or end users.

Your challenge is to redesign your operations for consistent, reliable communications regardless of their locality and move away from revolving hardware costs while allowing for dynamic growth for variety of solutions and applications. You need to create efficient processes that enable your team to repeat the same process for any environment and allow for centralized management and reporting around a single platform.

### Customer needs 

1. **Follow Best Practices** The solution chosen for this deployment should follow well-known best practices and be repeatable for future needs. Also, utilizing pre-built solutions should be utilized to ensure deployment in the tight time frame. Furthermore, it should be easy to understand for future staff brought on through growth or augmentation.

2. **Management Access** Access to resources must be limited between different jurisdictions and managed through a central, agreed-upon authority. This must be monitored and have the ability to be reported on regularly for periodic audits.  This should also be a consistent structure for all environments.

3. **Backup and Disaster recovery** All data and virtual machines need to be backed up on a daily basis.  In addition, the critical systems must be to continue in the event of a disaster within 8 hours (RTO) with no more than a 2 hours of data loss (RPO). 


4. **Growth and Expansion** The design of the infrastructure must allow for growth of capacity to process increase in demand of resources as well as expand storage for data as historical information is retained for long term storage.

5. **Patch Management** All systems must have the ability to be patched and kept up to date with centralized reporting to security services for reporting and monitoring. 


6. **VM and Application Monitoring** The performance and availability of systems and applications must be monitored to ensure client experience is consistent. Also, trends and troubleshooting information should be available to support to help users and development group to improve features.


7. **Cost Management** As applications expand and grow, the costs to run those applications will often increase. The reporting of the applications should be able to tie back to the individual countries as well as applications.


8. **Consistent Design** The solutions proposed should provide a consistent and reliable design for all remote environments to minimize complexity and ease demands on the support team to ensure consistency of knowledge between areas..  The central environments should all mirror each other in design for disaster recovery purposes.

### Customer objections 

1. Reliability is a major concern as their business runs globally 24/7.  Service goals should look to achieve 99.95% SLA where possible.  In addition, the services should be optimized for performance regardless of where the user is in the world.


2. Cost is an ongoing concern for the enterprise. Solutions should not only be cost-efficient, but should be able to easily break down costs to individual regions for reports and parse application costs where possible.

3. Security and compliance are major concerns for the company. There are multiple different jurisdictional standards they must adhere to, but they must also ensure that their is standard baseline across all environments.


## Step 2: Design a proof of concept solution

**Outcome** 

Design a solution and prepare to present the solution to the target customer audience in a 15-minute chalk-talk format. 

Timeframe: 60 minutes

**Design**

Directions: With all participants in your group, respond to the following questions on a flip chart or (virtual) white board.

1. **Management Access** Design a solution to allow CL operation team with access to the divisional subscriptions.
   - The solution should support role-based access control to ensure consistent and reportable access across the environments
   - The solution should support user groups so as staff changes, access remains consistent and does not require redeployment
   - The solutions should also follow an inheritance structure where possible to allow for top-down distribution of rights

2. **Backup and Disaster recovery** All data and virtual machines need to be backed up regularly and critical systems continue in a disaster.
   - The solution must provide for the ability to backup and retain their data daily and have standard configurations for maintaining company standards
   - The solution must also ensure that critical systems continue to function in the event that there is a major disaster in a geographical area 
   - The solution must also ensure their critical systems are down for no more than 8 hours and loose no more than 2 hours worth of running data
   - The solution should also be able to be monitored and report if there are any issues or inconsistencies.
   - The solution should allow for reporting of systems that are not configured for protection

3. **Growth and Expansion** The design of the infrastructure must allow for growth of capacity of both compute and storage.
    - Virtual machines and applications should be able to grow or expand dynamically based on load
    - Storage of data should be available to retain legacy data for longer periods at a reduced rate
    - Storage of sensitive, or regulated data, should be kept within the local regions to ensure proper jurisdictional oversight
    - Structure of the data containers should be consistent across environments to allow for easier retrieval

4. **Patch Management** All systems must have the ability to be patched and kept up to date
   - Patch management must be maintained across all systems
   - Reports should be available centrally to allow for monitoring and compliance
   - Local administrators should be alerted to any systems not included in management

5. **VM and Application Monitoring** The performance and availability of systems and applications must be monitored to ensure client experience is consistent.
   - Local administrators should be alerted to any critical events and be able to respond appropriately
   - Reports of trends and status should be available to support to help users
   - Development group should be able to have access detailed logs only in the event of an escalation


6. **Cost Management** Reporting of costs should be made available to track and monitor expenses within the environment.
   - Reports must be available within each region and available to centralized management
   - Filtering of costs should be available by categorization of applications or other metadata
   - Certain data must be included on all resources relating to its purpose to allow for categorization


7. **Consistent Design** The solutions proposed should provide a consistent and reliable design for all remote environments.
   - There should be a standard, central designed that is repeated in each environment
   - The application is consistent around each environment, so the structure must be the same in each environment
   - Updates to the infrastructure should be possible without interruption and minimal affect to the existing environment
   - Rapid deployments for critical or security updates should be available from a central system across all environments


**Prepare**

Directions: With all participants at your table: 

1.  Identify any customer needs that are not addressed with the proposed solution.

2.  Identify the benefits of your solution.

3.  Determine how you will respond to the customer’s objections.

## Step 3: Present the solution

**Outcome**
 
Present a solution to the target customer audience in a 15-minute chalk-talk format.

Timeframe: 30 minutes

**Presentation** 

Directions:
1.  Pair with another table.

2.  One table is the Microsoft team and the other table is the customer.

3.  The Microsoft team presents their proposed solution to the customer.

4.  The customer makes one of the objections from the list of objections.

5.  The Microsoft team responds to the objection.

6.  The customer team gives feedback to the Microsoft team. 

7.  Tables switch roles and repeat Steps 2–6.

##  Wrap-up 

Timeframe: 15 minutes

Directions: Tables reconvene with the larger group to hear the facilitator/SME share the preferred solution for the case study.

##  Additional references


|                                         |                                                                   |
|-----------------------------------------|:-----------------------------------------------------------------:|
| **Description**                         | **Links**                                                         |
| Microsoft Azure Reference Architectures | <https://docs.microsoft.com/azure/guidance/guidance-architecture> |
| Azure Landing Zones                        | <https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/>                    |
| Azure Cloud Adoption Framework (CAF)                   | <https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/>                        |
|                                         |                                                                   |

