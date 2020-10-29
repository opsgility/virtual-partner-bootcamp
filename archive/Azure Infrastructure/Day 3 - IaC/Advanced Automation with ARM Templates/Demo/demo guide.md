# Advanced Automation with ARM Templates - Demo Guide

## Scoped Deployments

**Preparation**

-  You need to OWN the AAD tenant. Don't use Opsgility. Use Azure Pass
-  Set yourself up as elevated access via AAD
-  Assign 'Owner' at tenant root scope `New-AzRoleAssignment -SignInName <you> -Scope '/' -RoleDefinitionName 'Owner'`

**Demo**

*Tenant Root scope template*

- Explain permissions required

- Walk through template. Call out:
    - You can create child MGs under parent MGs
    - Use of tenantResourceId()

- Show the deployment PS script

- Show it works - MGs are created in parent/child relationship

*Management Group scope template*

-  Show the **managementGroupScope.json** template. Call out:
   -  Can create both policy definition and assignment
   -  Use of `extensionResourceId()` to get ID of definition to reference in assignment
   -  No equivalent of resourceGroup() or subscription() to get deployment scope. Had to pass it in as mgScope parameter(!!!)

-  Show the script

-  Show it works. Show the deployment record in the MG and the policy assignments in place.


*Subscription scope*

Explain we'll demo this as part of a later demo (User Defined Functions / peering demo)

*Resource Group scope*

Skip, it's routine.

## What If

**Preparation**

Use the first part of the **azuredeploy.ps1** script to install the preview module and make the initial **WhatIf1.json** deployment

**Demo**

Best to do from VS Code since this shows colours. Using PS ISE does not.

Show the PS script. Explain

-  What has been deployed already (no need for super details about the template)
-  Show the WhatIf (incremental mode). Explain each change
   -  New/removed/modified items
   -  Call our that properties that were filled in by default values are shown as removed (e.g. value of dynamic private IP)
   -  At top, show feedback link (results aren't perfect)
-  Show the WhatIf (complete mode), call out differences    
   -  Call out potential delete of implicitly-created OS disks
-  Show the programmatic results
   -  $result.Changes object
   -  Nice how $result on its own converts to formatted string
-  Show the Confirm option

## User-Defined Functions

This demo uses a template to peer to virtual networks.

**Preparation**

 - Create two virtual networks, **Hub-VNET** and **Spoke-VNET** with non-overlapping IP ranges and different RGs
 - Update the **azuredeploy.ps1** script with the correct RG names, template folder path, etc
 - Log in to Azure in PS environment

**Demo**

1.  Explain environment, show VNets in separate RGs, not peered.

2.  Walk through the **peering.json** template. Call out:

    -  Peering is a child resource of each VNet. The VNets may be in different RGs. Hence the template uses two nested deployments in two different RGs. And hence the template itself is subscription-level.
    -  Functions to extract RG name, resource name from resource ID
    -  Function to construct peering name. Unfortunately, functions can't call functions so this repeats the resource name logic

3.  Deploy the template via PS using the **azuredeploy.ps1** script.

4.  Show the template worked - peering is in place.

## Deployment Scripts

**Preparation**

None.

**Demo**

1.  Walk through the template, explain each line
2.  Deploy using the PS script. Explain about the MI setup.
3.  View the results
    -  Deployment script object, inc inputs and outputs
    -  Storage account and ACI. Show shared folder but no need to open files. Explain these resources can also be cleaned up automatically.