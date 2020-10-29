# Leveraging Runbooks to Automate Tasks - Demo Guide

## Preparation

**BE SURE TO PRACTICE!!**

### Demo 1 Preparation

-  For Lighthouse:
   -  Create 2 AAD tenants / Azure subscriptions (use Azure Pass). E.g. Fabrikam and Contoso
   -  Set up AA in Contoso, load the 'LighthouseDemo' Runbook
   -  get the RunAs account SP Object ID
   -  Set up delegation from Fabrikam to Contoso using Lighthouse. Delegate Contributor permissions to the RunAs account

-  For CSP AOBO
   -  This requires you to use the Opsgility PRODUCTION tenant (!)
      -  You need access to execute runbooks in the CloudSandboxAutomation AA.
   -  Spin up a lab shortly beforehand, get the tenant ID.
      -  Any lab will do, choose one that's fast to start and runs for a long time.

### Demo 2 Preparation
-  Create Automation account **aaTest** in resource group **TestRG** (you can use other names but will have to edit scripts)
-  Import all the runbooks from the **ChildRunbooks** folder and publish.
   -  Be sure to publish child runbooks before parents (necessary for inline execution).


## Demo 1

### Lighthouse

-  Log into to Contoso, show delegation from Fabrikam (from 'My Customers'). Show delegated permissions in Service Principal
-  From Automation Account, show the runbook, explain what it does
   -  Get-AzSubscription will show all subscriptions but you can't tell which tenant
   -  Using latest API version via Invoke-RestMethod reveals tenant info
-  Run it, show it works.

### CSP AOBO

 - From the Opsgility ProductionCloudSandboxAutomation account, navigate to the Jonathan-Test runbook
 - Walk through/explain what it does
 - Show the variables in the AA
 - Run the runbook, show output
 - From the lab, show the 'Test' RG has been created (it worked)


## Demo 2 - Child Runbooks

### Inline, PowerShell
1.  Show **MyChildPSRunbook**, execute it
2.  Show **MyParentPSRunbook**, show how it calls child, show it works

### Inline, PowerShell Workflow
1.  Show **MyChildPSWRunbook**, execute it
2.  Show **MyParentPSWRunbook**, show how it calls child (call out differences), show it works

### Cmdlet, Synchronous

1.  Show **MyParentPSRunbook2**. Call out
    - Connecting to Azure account 
    - Use of '-Wait'
    - Output returned directly
    - Imported modules Az.Accounts and Az.Automation

2. Show it works
    
### Cmdlet, Asynchronous

1.  Show **MyParentPSRunbook3**. Call out
    - Connect to Azure account
    - Polling status based on JobId
    - Get output - specify which stream
    - Access ouput - reference 'Summary' property 

2.  Show it works