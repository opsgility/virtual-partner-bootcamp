# Operationalizing Azure Kubernetes Service Challenge - Instructor Guide

This guide provides teaching notes and example solutions for each exercise in the Operationalizing Azure Kubernetes Service Challenge Lab.

## General

The environment is pre-deployed with an AKS cluster with a web and api tier running, as well as a Cosmos DB database which houses the database used by the API service. As attendees progress through the challenge, they will be building a new cluster, so this cluster will be mostly for demonstration.

## Challenge 1: Implementing AKS to meeting customer requirements

To understand the environment deployment, view the script at <https://github.com/opsgility/lab-support-public/blob/master/akschallenge/ratingsapp/deploy.sh>.

**Challenge criteria**

- Your initial challenge is to configure the existing application in a dedicated namespace
- Allow only the **Fruit Smashers Smooth Devs** security group access to the namespace

**Challenge solution**

AKS supports two mechanisms for integrating with AAD, [legacy](https://docs.microsoft.com/azure/aks/azure-ad-integration-cli) and [current](https://docs.microsoft.com/en-us/azure/aks/managed-aad). We will focus on the latter. This has the advantage of being simpler, since the AKS resource provider handles the AAD client and server applications, rather than you having to handle them yourself. It also allows the existing AKS cluster to be upgraded to support AAD integration, rather than requiring a new cluster to be deployed.

1.  To get started, open an SSH connection to the ```challengeloader``` virtual machine, using the following credentials

    -  Username: **demouser**
    -  Password: **demo@pass123**

2.  Next, log in to your Azure subscription, using your lab credentials

    ```sh
    # Log in with lab credentials
    az login 
    ```

3.  Get the ID of the **AKS Admin Group** in AAD. This is used as the admin group when the AKS cluster is enabled for AAD authentication.

    ```sh
    # Get ID of admin group
    ADMIN_GROUP="AKS Admin Group"
    ADMIN_GROUP_ID=$(az ad group show --group "$ADMIN_GROUP" --query objectId -o tsv)
    ```

4.  Get the name of the AKS cluster, and connect to AKS
  
    ```sh
    # Connect to AKS
    RESOURCE_GROUP=akschallengeRG
    AKS_CLUSTER_NAME=$(az aks list -g $RESOURCE_GROUP --query [0].name -o tsv)
    az aks get-credentials -g $RESOURCE_GROUP -n $AKS_CLUSTER_NAME --overwrite-existing
    ```

5.  Upgrade the AKS cluster to use AAD authentication

    ```sh
    # Upgrade AKS cluster to AAD authentication
    az aks update -g $RESOURCE_GROUP -n $AKS_CLUSTER_NAME --enable-aad --aad-admin-group-object-ids $ADMIN_GROUP_ID
    ```

6.  Create the namespace for the 'ratings' application

    ```sh
    # Create namespace
    kubectl create namespace ratingsapp
    ```

Next, you need to grant Kubernetes RBAC permissions over the ```ratingsapp``` namespace to the **Fruit Smashers Smooth Devs** security group. This is done in two stages, first by creating a role, and second a rolebinding.

7.  Get the objectId of the **Fruit Smashers Smooth Devs** security group

    ```sh
    GROUP_ID=$(az ad group show -g "Fruit Smashers Smooth Devs" --query objectId -o tsv)
    echo $GROUP_ID    
    ```

8.  Create the YAML file for the role. Type ```nano newrole.yaml``` to open the nano editor, **paste** in the text below, and fix any formatting issues so it matches TO DO**save** the file and **exit**.

    ```sh
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      namespace: ratingsapp
      name: ratingsappdeveloper
    rules:
    - apiGroups: ["","apps"] # "" indicates the core API group
      resources: ["deployments", "replicasets", "services", "endpoints", "pods"]
      verbs: ["*"]
    ```

    **Alternatively**, you can download the file using

    ```sh
    wget https://opsgilitylabs.blob.core.windows.net/public/validated-challenge-aks-operations/newrole.yaml
    ```

9.  Create the YAML file for the rolebinding. Type ```nano newrolebinding.yaml``` to open the nano editor, **paste** in the text below, and **replace** ```GROUP_ID``` with the value from step 7. **Save** the file and **exit**.

    ```sh
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      namespace: ratingsapp
      name: ratingsappdeveloper-binding
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: Role
      name: ratingsappdeveloper
    subjects:
    - apiGroup: rbac.authorization.k8s.io
      kind: Group
      name: "<GROUP_ID>"
    ```

    **Alternatively**, you can download and update the file using

    ```sh
    wget https://opsgilitylabs.blob.core.windows.net/public/validated-challenge-aks-operations/newrolebinding.yaml
    sed -i "s/<GROUP_ID>/${GROUP_ID}/g" newrolebinding.yaml
    ```


10. Apply the role and the rolebinding to the cluster

    ```sh
    kubectl apply -f newrole.yaml
    kubectl apply -f newrolebinding.yaml
    ```

11. The **Fruit Smashers Smooth Devs** group also needs some Azure RBAC permissions so users can see the ACR and AKS resources, and log in to AKS.

    ```sh
    az role assignment create --role "Azure Kubernetes Service Cluster User Role" --assignee $GROUP_ID -g $RESOURCE_GROUP
    az role assignment create --role "Reader" --assignee $GROUP_ID -g $RESOURCE_GROUP
    ```

The ```ratingsapp``` namespace is now set up. Next you must re-deploy the Fruit Smashers ratings application to the ```ratingsapp``` namespace. As a first step, the Kubernetes secret containing the connection string used to access the database must be recreated under the new namespace. Note that the role defined above does not include permission to manage secrets, so we create the secret using the current (admin) user

12. Execute the following commands to retrieve the connection string and save as a Kubernetes secret:

    ```sh
    # Get the connection string
    COSMOS_NAME=$(az cosmosdb list -g $RESOURCE_GROUP --query [0].name -o tsv)
    COSMOS_KEY=$(az cosmosdb keys list --type connection-strings --name $COSMOS_NAME --resource-group $RESOURCE_GROUP --query "connectionStrings[0].connectionString" -o tsv | sed -r "s/\?/ratingsdb\?/g")

    # Re-create mongosecret in new namespace
    kubectl create secret generic mongosecret -n ratingsapp --from-literal=MONGOCONNECTION="${COSMOS_KEY}"
    ```

Next, the application itself must be migrated to the new namespace. There are several ways to do this---it could be migrated using Velero or exported and re-imported. The instructions below make a new deployment using the existing images in ACR. While these could be executed using the current (admin) user, we will instead log in as a member of the **Fruit Smashers Smooth Devs** group, to verify the group permissions are working.

13. Log out of the current Azure user account, and log in as the **demouser1** account, which is a member of the **Fruit Smashers Smooth Devs** security group.

    ```sh
    DOMAIN=$(az ad signed-in-user show --query userPrincipalName -o tsv  | sed -r "s/.*@//g")
    az logout
    az login -u demouser1@$DOMAIN -p demo@pass123
    ```

14. Re-authenticate to AKS under this new role

    ```sh
    # Connect to AKS
    az aks get-credentials -g $RESOURCE_GROUP -n $AKS_CLUSTER_NAME --overwrite-existing
    ```

    > **NOTE:** You may also be asked to authenticate to AKS when you first access the cluster using ```kubectl```.

15. The ratings application comprises an API tier and a Web tier. Each tier is defined using two YAML files, one for the deployment, and another for the service. First, download the files used by the earlier deployment

    ```sh
    # Get YAML definitions
    BASE_URI=https://raw.githubusercontent.com/opsgility/lab-support-public/master/akschallenge/ratingsapp/
    wget ${BASE_URI}ratings-api-deployment.yaml
    wget ${BASE_URI}ratings-api-service.yaml
    wget ${BASE_URI}ratings-web-deployment.yaml
    wget ${BASE_URI}ratings-web-service.yaml
    ```

    > **NOTE:** The 'service' files use the core API group, whereas the 'deployment' files use the 'apps' API group. Both API groups were included in the role definition created earlier.

16. Some placeholders in these YAML files need to be updated with values from your environment. To do this, execute the following commands. The first three are taken directly from the original deployment script. **The last one is new---it is required to make sure the Web tier talks to the new API tier in the ratingsapp namespace, not the old API in the default namespace.**

    ```sh
    # Set up variables
    ACR_NAME=$(az acr list -g $RESOURCE_GROUP --query [0].name -o tsv)
    CURRENT_RANDOM=$(($RANDOM%9000+1000))
    RATINGS_WEB_DNS_NAME="ratingsweb$CURRENT_RANDOM"

    # Update YAML definitions
    # First three are same as for the initial deployment
    sed -i "s/ACR_NAME/${ACR_NAME}/g" ratings-api-deployment.yaml
    sed -i "s/ACR_NAME/${ACR_NAME}/g" ratings-web-deployment.yaml
    sed -i "s/RATINGS_WEB_DNS_NAME/${RATINGS_WEB_DNS_NAME}/g" ratings-web-service.yaml
    # This last one is new, so the web tier talks to the API in the new namespace
    sed -i "s/default.svc.cluster.local/ratingsapp.svc.cluster.local/g" ratings-web-deployment.yaml
    ```

17. You're now ready to deploy both tiers to the new namespace.

    ```sh
    # Deploy the ratings app to the new namespace
    kubectl apply -n ratingsapp -f ratings-api-deployment.yaml
    kubectl apply -n ratingsapp -f ratings-api-service.yaml
    kubectl apply -n ratingsapp -f ratings-web-deployment.yaml
    kubectl apply -n ratingsapp -f ratings-web-service.yaml
    ```

18. Finally, clean up the old deployment from the default namespace. You can't do this from the current **demouser1** account, since it only has access to the **ratingsapp** namespace, and not the **default** namespace. You'll need to logout and login as the lab user again (recall this user is a member of the AKS admin group).

    ```sh
    az logout
    az login # Log in with lab user credentials
    az aks get-credentials -g $RESOURCE_GROUP -n $AKS_CLUSTER_NAME --overwrite-existing --admin

    # Clean up old deployment from the default namespace
    kubectl delete service    -n default ratings-web
    kubectl delete deployment -n default ratings-web
    kubectl delete service    -n default ratings-api
    kubectl delete deployment -n default ratings-api
    kubectl delete secret     -n default mongosecret
    ```

19. You should now see a new public IP address named **kubernetes-...** in the **MC_akschallengeRG_...** resource group. Copy the DNS name and open in a new browser tab, and verify the ratings application is working.


## Challenge 2: Isolating workloads with multiple node pools

**Challenge criteria**

- Configure a new node pool with two nodes and deploy the Guestbook application into a dedicated namespace
- Ensure that the Guestbook application can be deployed to only its dedicated pool members
- Keep in mind the existing Fruit Smoothies application is currently in production and should not be impacted by the deployment of this new application and its associated services
- Only members of the **Fruit Smashers Better Devs** security group have access to the namespace

**Challenge solution**

1.  Open an SSH session to the **challengeloader** virtual machine. Log in to the Azure CLI and AKS cluster. Instructions are the same as for the previous challenge.

2.  Next, you need to set up the **guestbook** namespace and enable it for the **Fruit Smashers Better Devs** security group. This uses the same steps as for the 'ratingsapp' namespace in Challenge 1. The following script will complete this task (it assumes the ```newrole.yaml``` and ```newrolebinding.yaml``` files are already in place from Challenge 1.)

    ```sh
    # Create namespace
    kubectl create namespace guestbook

    # Update pre-existing role and rolebinding YAML files to replace namespace name
    sed -i "s/ratingsapp/guestbook/g" newrole.yaml
    sed -i "s/ratingsapp/guestbook/g" newrolebinding.yaml

    # Update the group objectId in the rolebinding YAML file
    RATINGSAPP_GROUP_ID=$(az ad group show -g "Fruit Smashers Smooth Devs" --query objectId -o tsv)
    GUESTBOOK_GROUP_ID=$(az ad group show -g "Fruit Smashers Better Devs" --query objectId -o tsv)
    sed -i "s/$RATINGSAPP_GROUP_ID/$GUESTBOOK_GROUP_ID/g" newrolebinding.yaml

    # Create the role and rolebinding
    kubectl apply -f newrole.yaml
    kubectl apply -f newrolebinding.yaml

    # Add Azure RBAC role assignments for access to AKS and ACR
    az role assignment create --role "Azure Kubernetes Service Cluster User Role" --assignee $GUESTBOOK_GROUP_ID -g $RESOURCE_GROUP
    az role assignment create --role "Reader" --assignee $GUESTBOOK_GROUP_ID -g $RESOURCE_GROUP
    ```

> **Note:** The guestbook app must run on separate nodes from the ratings app. To do this, we will deploy a new nodepool. To keep the applications separate, two separate Kubernetes mechamisms will be used.
>
> -  To force the guestbook app to run on the guestbook nodes, a **label** will be added to the guestbook nodepool, and a matching **selector** added to the guestbook deployments
> -  To force the ratingsapp to **not** run on the guestbook nodepool, a **taint** will be addded to the guestbook nodepool. To allow the guestbook deployments to run on the guestbook nodepool despite the presence of this taint, a matching **toleration** will be added to the guestbook deployments.
>
> The **label** and **taint** will be applied to the nodepool using the ```az``` CLI when the nodepool is created. This way they are automatically applied to all nodes in the nodepool. This must be done when the nodepool is created, AKS does not support adding labels and taints to nodepools after creation.
> 
> You could alternatively label and taint individual nodes using ```kubectl```, but this approach does not automatically extend to all nodes in the nodepool, and is therefore not recommended.

1.  The **guestbook** application must be deployed to a new node pool. Add a new node pool to the existing cluster and apply a label and a taint on the node pool, so we can target this node pool with the **guestbook** deployment.

    ```sh
    # Set up variables
    RESOURCE_GROUP=akschallengeRG
    AKS_CLUSTER_NAME=$(az aks list -g $RESOURCE_GROUP --query [0].name -o tsv)

    # Create new node pool
    az aks nodepool add \
        --cluster-name $AKS_CLUSTER_NAME \
        --name guestbook \
        --resource-group $RESOURCE_GROUP \
        --mode User \
        --node-count 2 \
        --os-type Linux \
        --node-vm-size Standard_B1ms \
        --labels app=guestbook \
        --node-taints pool=guestbook:NoSchedule
    ```

2.  To prove that the **Fruit Smashers Better Devs** have the necessary access, you can log out of the admin account and log in as **demouser2**, which is a member of **Fruit Smashers Better Devs** security group.

    ```sh
    # Log in as demouser2
    DOMAIN=$(az ad signed-in-user show --query userPrincipalName -o tsv  | sed -r "s/.*@//g")
    az logout
    az login -u demouser2@$DOMAIN -p demo@pass123

    # Connect to AKS
    az aks get-credentials -g $RESOURCE_GROUP -n $AKS_CLUSTER_NAME --overwrite-existing
    ```

    > **NOTE:** You may also be asked to authenticate to AKS when you first access the cluster using ```kubectl```.

3.  Download the manifest files for the **guestbook** application

    ```sh
    BASE_URI=https://raw.githubusercontent.com/opsgility/lab-support-public/master/akschallenge/guestbook/
    wget ${BASE_URI}redis-master-deployment.yaml
    wget ${BASE_URI}redis-master-service.yaml
    wget ${BASE_URI}redis-slave-deployment.yaml
    wget ${BASE_URI}redis-slave-service.yaml
    wget ${BASE_URI}frontend-deployment.yaml
    wget ${BASE_URI}frontend-service.yaml
    ```

The new nodepool has a **label** and a **taint**. These allow us to control which deployments can and cannot use this pool. The 3 deployment manifests must be updated with a corresponding **nodeSelector** and **toleration** so they can be deployed to this nodepool. This keeps the guestbook and ratings applications on separate nodes.

6.  Enter ```nano redis-master-deployment.yaml``` and add the nodeSelector and toleration as shown below. Then **save** and **exit**.

    ```yaml
    apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
    kind: Deployment
    metadata:
    name: redis-master
    labels:
      app: redis
    spec:
    selector:
      matchLabels:
      app: redis
      role: master
      tier: backend
    replicas: 1
    template:
      metadata:
      labels:
        app: redis
        role: master
        tier: backend
      spec:
        containers:
        - name: master
          image: k8s.gcr.io/redis:e2e  # or just image: redis
          resources:
            requests:
              cpu: 100m
              memory: 100Mi
            ports:
            - containerPort: 6379
        nodeSelector:
            app: guestbook
        tolerations:
          - key: "pool"
            operator: "Equal"
            value: "guestbook"
            effect: "NoSchedule"
    ```

7.  Repeat the above step for the other 2 deployment manifests, ```redis-slave-deployment.yaml``` and ```frontend-deployment.yaml```.

8.  Deploy the application

    ```sh
    kubectl apply -n guestbook -f redis-master-deployment.yaml
    kubectl apply -n guestbook -f redis-master-service.yaml
    kubectl apply -n guestbook -f redis-slave-deployment.yaml
    kubectl apply -n guestbook -f redis-slave-service.yaml
    kubectl apply -n guestbook -f frontend-deployment.yaml
    kubectl apply -n guestbook -f frontend-service.yaml
    ```

9.  Review the nodes used by the guestbook and ratingsapp applications, to verify they are using separate nodepools.

    ```sh
    kubectl get pods -n guestbook -o wide
    kubectl get pods -n ratingsapp -o wide
    ```

10. Once the deployment is complete, you should find a new public IP address in the **MC_akschallengeRG_...** resource group. Browse to this IP and verify that the guestbook application is working.

## Challenge 3: Monitoring containerized workloads

**Challenge criteria**

Implement:

- A dedicated dashboard for each application team which shows them common AKS performance metrics such as:
    - Overall cluster health
    - CPU consumption per node
    - Pod health
- A dedicated workbook for their own Ops team which allows for filtering by:
    - Node pool in the AKS cluster
        - For each node pool, the pods that are running on the node should be displayed

**Challenge solution**

- Create a new Azure Monitor workbook or dashboard for each application
- A new workbook will need to be created for the Ops team to meet the filtering criteria
