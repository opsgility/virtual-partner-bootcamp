![Microsoft Cloud Workshops](https://github.com/Microsoft/MCW-Template-Cloud-Workshop/raw/master/Media/ms-cloud-workshop.png "Microsoft Cloud Workshops")

<div class="MCWHeader1">
Managing and Monitoring Azure Workloads
</div>

<div class="MCWHeader2">
Whiteboard design session student guide
</div>

<div class="MCWHeader3">
May 2020
</div>

Information in this document, including URL and other Internet Web site references, is subject to change without notice. Unless otherwise noted, the example companies, organizations, products, domain names, e-mail addresses, logos, people, places, and events depicted herein are fictitious, and no association with any real company, organization, product, domain name, e-mail address, logo, person, place or event is intended or should be inferred. Complying with all applicable copyright laws is the responsibility of the user. Without limiting the rights under copyright, no part of this document may be reproduced, stored in or introduced into a retrieval system, or transmitted in any form or by any means (electronic, mechanical, photocopying, recording, or otherwise), or for any purpose, without the express written permission of Microsoft Corporation.

Microsoft may have patents, patent applications, trademarks, copyrights, or other intellectual property rights covering subject matter in this document. Except as expressly provided in any written license agreement from Microsoft, the furnishing of this document does not give you any license to these patents, trademarks, copyrights, or other intellectual property.

The names of manufacturers, products, or URLs are provided for informational purposes only and Microsoft makes no representations and warranties, either expressed, implied, or statutory, regarding these manufacturers or the use of the products with any Microsoft technologies. The inclusion of a manufacturer or product does not imply endorsement of Microsoft of the manufacturer or product. Links may be provided to third party sites. Such sites are not under the control of Microsoft and Microsoft is not responsible for the contents of any linked site or any link contained in a linked site, or any changes or updates to such sites. Microsoft is not responsible for webcasting or any other form of transmission received from any linked site. Microsoft is providing these links to you only as a convenience, and the inclusion of any link does not imply endorsement of Microsoft of the site or the products contained therein.

© 2020 Microsoft Corporation. All rights reserved.

Microsoft and the trademarks listed at https://www.microsoft.com/en-us/legal/intellectualproperty/Trademarks/Usage/General.aspx are trademarks of the Microsoft group of companies. All other trademarks are property of their respective owners.

**Contents**

<!-- TOC -->
\[**TODO:** Confirm lab name "Landing Zones"  \]
- [Landing Zones - Whiteboard Design Session Student Guide](#landing-zones---whiteboard-design-session-student-guide)
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

# Landing Zones - Whiteboard Design Session Student Guide

## Abstract and learning objectives 

\[**TODO:**  Define abstract and learning objectives  \]

In this whiteboard design session, you will look at how to design monitoring and management solutions in Azure. Your focus will be on a partner Managed Service Provider scenario, where management must be provided at scale across a large number of customers.

At the end of the workshop, you will be better able to design and use Azure monitoring and management tools, including Azure Monitor Workbooks, Log Analytics, Azure Alerts, and Azure Automation. You will also understand how to deploy these technologies across a large portfolio of customers using a variety of automation technologies. You will also better understand the challenges involved in managing Azure solutions at scale.

## Step 1: Review the customer case study 

**Outcome** 

Analyze your customer’s needs.

Timeframe: 15 minutes 

Directions: With all participants in the session, the facilitator/SME presents an overview of the customer case study along with technical tips. 

1.  Meet your table participants and trainer. 

2.  Read all of the directions for steps 1–3 in the student guide. 

3.  As a table team, review the following customer case study.
 
### Customer background

Contoso Excursions (CE) is a Microsoft client providing a personalized service for customers looking for vacation, business travel, and adventure packages.

Contoso was founded in Tampa in 2004, originally as Contoso Travel Services. The original business was started by former travel industry experts after the restructuring of the travel industry, providing high quality and optimized solutions for clientele. The personalized packaging services for affordable grouping saw welcomed growth and resurgence of people looking for good value and minimal details for international and unusual destinations with a personal touch and was expanded as an independent subsidiary as Contoso Travel Excursions.

The Founder and CEO of Contoso, Emma Fox, was quick to recognize that technology and online presence would be key for providing detailed, efficient, and personalized solutions for their customers from the beginning and built their solutions on the Microsoft stack. In 2018 she re-branded the company as Contoso Excursions and set in place a new business strategy offering cloud-based and hybrid cloud services. Given CE’s long history as a Microsoft client, Microsoft Azure was the natural choice as preferred public cloud provider.

CE has built a broad base of around key group of frequent travellers, as well as key international medium-sized businesses. More recently CE has also seen a growth via social media references and influencers, reflecting the company’s ongoing growth and success around personalized services.

### Technical background

The current CE application environment:
-   Legacy on-premises applications hosted in CE's datacenters with a remote co-location facility for disaster recovery. The hardware in these datacenters are aging and due for lease returns at the end of the year. The strategy is to migrate these solutions to cloud-based infrastructure before the hardware's end of life and then migrate to platform services to take advantage of scaling and features, and eventually minimizing all virtual solutions.
-   CE employees are based throughout the world and access the daily application and reports via a VPN connection to the primary data center.
-   CE customers access details via an IIS web server farm with a firewall
-   Infrastructure consists of 50 Hyper-V based production virtual machines as well as 4 physical servers consisting of two SQL clusters running SQL 2016 that run their core business applications and a data warehouse for reporting
-   The data warehouse is fully refreshed weekly with exports from the production database

CE has an Enterprise Agreement with Microsoft for their applications and would like to utilize as much of their existing agreement benefits as possible.

### Current situation

As Directory of Information Technology for Contoso Excursions, you are responsible for keeping all your in-house and customer applications & services healthy, secure and available 100% of the time. As your business grows, you need to scale your operations activities accordingly—but you can only use the resources your already have.

Currently, your team manages all technology equipment and customer connectivity--so as the number of customers grows, so does your workload.  Your hardware is already frequently maintaining 80% utilization during business hours and clients report sporadic timeouts at peak times.  The budgeted plan was only expected to refresh the hardware at the end of the year when the current lease ends.

Your challenge is to migrate your solution to the cloud to ensure reliable, dynamic growth and shrink depending on user demand. However, the estimated time frame to update the application is beyond the time for the pending hardware refresh. You need to create a reliable plan to migrate your infrastructure to the cloud while providing a development environment for the application refresh moves forward and execute the plan with minimal client interruption.

### Customer needs 

1. **Management Access** Access to resources must be limited to only the staff that is required and at the least privilege required. There should be options for third parties to have limited access to only those resources they need for support or development.

2. **Backup and Disaster recovery** All data and virtual machines need to be backed up on a daily basis.  In addition, the critical systems must be to continue in the event of a disaster within 12 hours (RTO) with no more than a 4 hours of data loss (RPO). 


3. **Growth and Expansion** The design of the infrastructure must allow for growth of capacity to process increase in demand of resources as well as expand storage for data as historical information is retained for long term storage. In addition, the design must allow for the transition of applications for IaaS to PaaS as they become available.

4. **Patch Management** All systems must have the ability to be patched and kept up to date with centralized reporting to security services for reporting and monitoring. 


5. **VM and Application Monitoring** The performance and availability of systems and applications must be monitored to ensure client experience is consistent. Also, trends and troubleshooting information should be available to support to help users and development group to improve features.


6. **Cost Management** As applications expand and grow, the costs to run those applications will often increase. The reporting of the costs should be able to tie back to the individual applications.


7. **Minimize Downtime** The migrations to the cloud should allow for minimum downtime to the applications as they transition between environments. More over, the solution should encompass enough redundancy to allow for planned patching, updating, and deployment without downtime.

### Customer objections 


1. Reliability is a concern as their business support people throughout the world. Service goals should look to achieve 99.95% SLA where possible.  In addition, the final application services should be optimized for performance regardless of where the user is in the world.

2. Cost is an ongoing concern for the enterprise. Solutions should not only be cost-efficient, but should be able to easily break down costs to individual regions for reports and parse application costs where possible. In addition, the final solution should be able to scale up and down depending on the current demand.

3. Security is a major concerns for the company. Users' personal identity information (PII) must be kept confidential and secure from both people outside the organization, as well as personnel within the company that do not need access for their work.


## Step 2: Design a proof of concept solution

**Outcome** 

Design a solution and prepare to present the solution to the target customer audience in a 15-minute chalk-talk format. 

Timeframe: 60 minutes

**Design**

\[**TODO:**  Update design  \]

Directions: With all participants in your group, respond to the following questions on a flip chart or (virtual) white board.

<!-- PREVIOUS EXAMPLE
1.  **Subscription access** Design a solution to allow the CCS operations team with access to customer subscriptions.
    - The solution should support role-based access control, so the customer has visibility and control over which permissions are granted to CCS.
    - The solution should support user groups, so changes to the CCS operations team do not require customer involvement.
    - There solution should support all subscription types (PAYG, CSP, EA, etc).

    Are there any Azure features which are not compatible with your proposed solution?

2.  **Backup configuration and monitoring** How can CCS monitor Azure Backup health? Design a solution that enables:
    - Visibility into backup health across all customers
    - Identify VMs without backup enabled
    - Raise alerts upon backup failure, across all customers
    - Ensure backup monitoring is correctly consistently applied to all Recovery Services Vaults

    Does your solution scale to the number of customers and subscriptions managed by CCS?

3.  **Patch management** What alternatives to System Center does Azure offer for patch management? Design an approach that offers:
    - Support for on-premises and cloud-based servers
    - Support for both Windows Server and Linux
    - Automatic on-boarding for Azure virtual machines and VM scale sets

    How does your solution scale patch management across the CCS customer base?

4.  **VM and server monitoring** Design a solution for monitoring Azure VMs and on-premises servers. Your solution should support:
    - Streamlined onboarding of all Azure VMs and selected on-premises servers
    - Support for dashboards and alerts based on both metrics and logs. 
    - Customer billing according to usage
    - Compliance with Enterprise customer security requirements that all logs remain within their subscription boundary

    How can you ensure your solution is deployed consistently across all CCS customers, for data gathering, alert configuration, and reporting?

    Can your solution deliver flexible and highly configurable dashboards of key performance data?
    
    Can your dashboards show data aggregated across the CCS customer base? What limitations apply?

5.  **Automation of manual tasks** How can CCS automate their manual configuration tasks? Your solution must support:
    - Automation of Azure resource configuration tasks (e.g. VM resize, disk encryption, network changes)
    - Automation of operations for Azure VMs (e.g. rotating passwords, installing or uninstalling software, auditing permissions)
    - Automation of operations for on-premises servers

    How can you deploy automation at scale across the CCS customer base?

    How can you review the success or failure of each automation task, on each resource?

    Automating common tasks is a substantial investment in IP. How can you protect the confidentiality of this investment?

6.  **PaaS monitoring** Design a solution for monitoring PaaS services, in particular Azure SQL Database and Azure Web Apps. Your solution should support:
    - Gathering key metrics and log data for alerting and investigation of incidents
    - Configuration of alerts in the event of performance degradation (e.g. increased latency), errors, or critical events.

    What can you do to make your monitoring more representative of the end-user experience?

    A customer raises a support ticket claiming their application is 'slow'. How can your monitoring help investigate the cause?

7.  **VM and server compliance**  Propose a solution that enables CCS to audit the compliance of their entire server estate - Windows and Linux, on-premises and cloud.

    Your solution should support a wide range of common OS configuration issues, such as members of the local administrator group, password complexity, installed applications, and trusted certificates. The solution should also be extensible to support new issues as required by CCS.

    Explain how this solution scales to all CCS customers.

8.  **Cost management** Explain how CCS can meet their cost management requirements. These include:
    - Visibility into current and historical spend, with the ability to segment the data by a variety of categories (such as location, resource type, or tags)
    - Forecast of future spend
    - Cost saving recommendations
    - Configuration of spending alerts, including alerting at 1-day granularity in case of a spike in spending

    Cost reports should be available to customers, including CSP customers. However, any CSP discounts should be confidential to CCS.

-->
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

\[**TODO:**  Update directions  \]

<!-- PREVIOUS EXAMPLE
Directions:
1.  Pair with another table.

2.  One table is the Microsoft team and the other table is the customer.

3.  The Microsoft team presents their proposed solution to the customer.

4.  The customer makes one of the objections from the list of objections.

5.  The Microsoft team responds to the objection.

6.  The customer team gives feedback to the Microsoft team. 

7.  Tables switch roles and repeat Steps 2–6.

 -->

##  Wrap-up 

Timeframe: 15 minutes

Directions: Tables reconvene with the larger group to hear the facilitator/SME share the preferred solution for the case study.

##  Additional references

\[**TODO:**  Update references  \]


|                                         |                                                                   |
|-----------------------------------------|:-----------------------------------------------------------------:|
| **Description**                         | **Links**                                                         |
| Microsoft Azure Reference Architectures | <https://docs.microsoft.com/azure/guidance/guidance-architecture> |
<!-- PREVIOUS EXAMPLES
| Azure Lighthouse                        | <https://docs.microsoft.com/azure/lighthouse/>                    |
| Azure Backup Explorer                   | <https://docs.microsoft.com/azure/backup/monitor-azure-backup-with-backup-explorer>                        |
| Azure Arc for Servers                   | <https://docs.microsoft.com/azure/azure-arc/servers/overview>     |
| VM Guest Policy                         | <https://docs.microsoft.com/azure/governance/policy/concepts/guest-configuration>     |
| Azure Monitor for VMs                   | <https://docs.microsoft.com/azure/azure-monitor/insights/vminsights-overview>   |
| Azure Automation                        | <https://docs.microsoft.com/azure/automation/automation-intro>   |
| Azure Update Management                 | <https://docs.microsoft.com/azure/automation/automation-update-management>  |
| Web App monitoring                      | <https://docs.microsoft.com/azure/architecture/reference-architectures/app-service-web-app/app-monitoring> |
| SQL Database monitoring                 | <https://docs.microsoft.com/azure/sql-database/sql-database-monitor-tune-overview>    |
| Azure Cost Management                   | <https://docs.microsoft.com/en-us/azure/cost-management-billing/ > |
|                                         |                                                                   |
 -->