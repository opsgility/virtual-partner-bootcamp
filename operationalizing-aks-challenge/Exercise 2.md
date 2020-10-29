# Challenge Guide

## Operationalizing Azure Kubernetes Service

## Challenge 2: Isolating workloads with multiple node pools

With the Fruit Smoothies application deployed and stabilized, Fruit Smashers would like to onboard a new application that allows visitors to their corporate headquarters to leave messages about the favorite part of their visit. As with the Fruit Smoothies application, Fruit Smashers wants to maintain the isolation of their applications with namespaces. They also recognize that the compute needs of their new application will be far less than their popular ratings app and don't want to impact the existing configuration.

The developers of the guestbook messaging application have identified the `Standard_B1ms` as a good target size for a two-node pool. They feel it meets not only their baseline CPU and memory needs from their testing, but they also fee that the B-series VMs are ideal for their workload as it does not need the full performance of the CPU continuously.

Your challenge is to configure a new node pool called **guestbook** with two nodes and deploy the Guestbook application into a dedicated namespace, also called **guestbook**.  Only members of the **Fruit Smashers Better Devs** security group have access to the namespace.

You must ensure that the Guestbook application is deployed to its dedicated nodepool, and that the existing ratings application does not use this new nodepool. Keep in mind the existing Fruit Smoothies application is currently in production and should not be impacted by the deployment of this new application.

### Guestbook application details

The Guestbook is composed of a Redis master, several Redis slaves, and a frontend website where guests can log their messages. The application deployment files can be found at <a href="https://github.com/opsgility/lab-support-public/tree/master/akschallenge/guestbook" target="_blank">lab-support-public/akschallenge/guestbook</a>.


## Success criteria

-  The **Fruit Smashers Better Devs** AAD group has access to administer the deployment in the **guestbook** namespace, but not the default namespace. This should be implemented using a Kubernetes role named **guestbookdeveloper** and a rolebinding named **guestbookdeveloper-binding**.

-  There is a new nodepool named **guestbook** containing **2 nodes** of size **Standard_B1ms**.

-  The guestbook app is deployed to the **guestbook** namespace, and is working properly.
  
-  The guestbook deployment uses the guestbook node pool, and the ratings application does not use the guestbook node pool.

> Note: You will recieve the challenge completion badge for completing this challenge. The next challenge is optional.

## Help Resources

- <a href="https://docs.microsoft.com/azure/aks/operator-best-practices-advanced-scheduler" target="_blank">Best practices for advanced scheduler features in Azure Kubernetes Service (AKS)</a>
- <a href="https://docs.microsoft.com/azure/aks/operator-best-practices-multi-region" target="_blank">Best practices for business continuity and disaster recovery in Azure Kubernetes Service (AKS)</a>
- <a href="https://docs.microsoft.com/azure/aks/use-multiple-node-pools" target="_blank">Create and manage multiple node pools for a cluster in Azure Kubernetes Service (AKS)</a>
- <a href="https://kubernetes.io/docs/tutorials/stateless-application/guestbook/" target="_blank">Example: Deploying PHP Guestbook application with Redis</a>
- <a href="https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/" target="_blank">Taints and Tolerations</a>
