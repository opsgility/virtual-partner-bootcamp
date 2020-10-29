# Challenge Guide

## Operationalizing Azure Kubernetes Service

## Overview

A new customer, Fruit Smashers, has approached to you take on the management and operations of one or more containerized applications which are hosted in an existing Azure Kubernetes Service (AKS) cluster. Currently, a popular website for rating fruit smoothie flavors - Fruit Smoothies by Fruit Smashers - is deployed in the cluster and a new application will be coming online shortly to allow guests to Fruit Smashers corporate headquarters to leave messages about the favorite part of their visit. While the existing platform and underlying deployment(s) meet the needs of the business, Fruit Smashers plans to grow their online presence significantly as more customers move to online ordering exclusively. They need to update their platform and operations practices to meet these anticipated growth demands.

## Accessing Microsoft Azure

Launch a browser (Chrome or Edge) using incognito or in-private mode and navigate to the URL below. Your Azure Credentials are available by clicking the **View Lab Environment** tab.

```sh
https://portal.azure.com
```

This deployment was executed from the VM `challengeloader` in the `challengeloaderRG` resource group. This VM has all of the required tooling installed you will need for the completion of this challenge such as the Azure CLI and kubectl.

You can SSH to the VM using the following credentials:

- Username: **demouser**
- Password: **demo@pass123**

## Environment details

The current development team has authored a <a href="https://github.com/opsgility/lab-support-public/blob/master/akschallenge/ratingsapp/deploy.sh" target="_blank">script</a> which they use to assist them in their deployments. The script is responsible for the creation and deployment of:

- A new AKS cluster in a dedicated VNet
- An Azure Container Registry for storing container images for an API and the frontend website
- A MongoDB database hosted in Azure Cosmos DB
- The API and frontend website containers for the Fruit Smashers ratings application

For the API tier to connect to the database, a Kubernetes secret called `mongosecret` containing the database connection string is populated using the following:

```sh
COSMOS_KEY=$(az cosmosdb list-connection-strings --name $COSMOS_NAME --resource-group $RESOURCE_GROUP --query "connectionStrings[0].connectionString" -o tsv | sed -r "s/\?/ratingsdb\?/g")

kubectl create secret generic mongosecret --from-literal=MONGOCONNECTION="${COSMOS_KEY}"
```

Services are deployed using a series of standard Kubernetes YAML definitions:

```sh
echo "Deploying ratings-api..."
kubectl apply -f ratings-api-deployment.yaml

kubectl get deployment ratings-api

echo "Deploying ratings-api service..."
kubectl apply -f ratings-api-service.yaml

echo "Deploying ratings-web..."
kubectl apply -f ratings-web-deployment.yaml

echo "Deploying ratings-web service..."
kubectl apply -f ratings-web-service.yaml
```

The definitions can be found at <a href="https://github.com/opsgility/lab-support-public/tree/master/akschallenge/ratingsapp" target="_blank">lab-support-public/akschallenge/ratingsapp</a>.

Each of the deployments has a property `image:` which defines which ACR to pull images from on deployment. The deployment script dynamically updates these values and you should account for this in any new deployments. For example:

```sh
image: ACR_NAME.azurecr.io/ratings-api:v1 # IMPORTANT: update with your own repository
```

Becomes:

```sh
image: acr4144.azurecr.io/ratings-api:v1 # IMPORTANT: update with your own repository
```

A custom DNS name is associated with the public IP of the load balancer and is applied through an annotation in `ratings-web-service.yaml`:

```yaml
metadata:
  annotations:
    service.beta.kubernetes.io/azure-dns-label-name: RATINGS_WEB_DNS_NAME
  name: ratings-web
```

To find the final custom DNS, navigate to the resource group beginning with the name **MC_akschallengeRG_aks...** and select the public IP address resource named **kubernetes-...**. For example:

![Ratings Web DNS Name](images/ratings-web_dns_name.png)


## Challenge 1: Implementing AKS to meeting customer requirements

You customer has an existing AKS deployment with running containers and supporting infrastructure such as MongoDB (Cosmos DB) and Azure Container Registry. Over time, their needs have shifted with AKS and they now are ready to adopt the latest features of AKS to better position themselves for security and access to the latest features of AKS, starting with their Fruit Smoothie ratings application.

- The existing AKS cluster is not enabled for AAD authentication. This needs to be remedied, so existing AAD users and groups can be used to manage access.
- The existing deployment utilizes a single namespace (default) with the existing application and its supporting services deployed. As new applications are on-boarded, further isolation will be required.
- Existing developers have access to the `default` and `kube-system` namespaces. As new applications are on-boarded, each development team will need access to only their resources for deployment and service management. They would like to maintain their existing architecture, transitioning the existing application to a dedicated namespace for Fruit Smoothies. For example:

![Ratings architecture in dedicated namespace](images/ratings_architecture.png)

To meet this challenge, you will first need to enable your AKS cluster for AzureAD authentication, using the existing AAD security group **AKS Admin Group** as the admin group.

You will then need to migrate the existing application to a dedicated namespace named **ratingsapp**. Only the existing **Fruit Smashers Smooth Devs** security group should be granted access to this namespace. This should be implemented using Kubernetes RBAC, using a role named **ratingsappdeveloper** and a rolebinding named **ratingsappdeveloper-binding**. 

Once all application components have been migrated to the new namespace, any legacy components in the default namespace must be cleaned up.

> **Note:** The cluster should be registered to use Azure AD for authentication. It should **not** be registered to use Azure RBAC for Kubernetes Authorization. At the time of writing, this feature is still in Preview. Instead, Azure AD should be used for authentication only, and Kubernetes RBAC used for authorization. For more information, see the [Help Resources](#help-resources) below.

> **Note:** You should not have to deploy any new AKS clusters or nodes.

## Success criteria

-  The AKS cluster is enabled for Azure AD, with the **AKS Admin Group** as the admin group.

-  The **Fruit Smashers Smooth Devs** AAD group has access to administer the deployment in the **ratingsapp** namespace, but not the default namespace. This should be implemented using a Kubernetes role named **ratingsappdeveloper** and a rolebinding named **ratingsappdeveloper-binding**.

-  The ratings app is deployed to the **ratingsapp** namespace, and is working properly.

-  The previous deployment in the default namespace has been removed (this includes services, deployments, and secrets).

## Help Resources

- <a href="https://docs.microsoft.com/azure/aks/intro-kubernetes" target="_blank">Azure Kubernetes Service (AKS)</a>
- <a href="https://docs.microsoft.com/azure/aks/concepts-clusters-workloads" target="_blank">Kubernetes core concepts for Azure Kubernetes Service (AKS)</a>
- <a href="https://docs.microsoft.com/azure/aks/concepts-identity" target="_blank">Access and identity options for Azure Kubernetes Service (AKS)</a>
- <a href="https://docs.microsoft.com/azure/aks/managed-aad" target="_blank">AKS-managed Azure Active Directory integration</a>
- <a href="https://docs.microsoft.com/azure/aks/manage-azure-rbac" target="_blank">Use Azure RBAC for Kubernetes Authorization (preview)</a>
- <a href="https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/" target="_blank">Kubernetes namespaces</a>
