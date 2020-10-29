$templateFolder = "C:\repos\virtual-partner-bootcamp\Azure Infrastructure\Day 3 - IaC\Advanced Automation with ARM Templates\Demo\ScopedDeployments"

# Note: Deploying to tenant root scope requires permissions at root scope
# E.g. have AAD Global Admin enable 'elevated access' and run 
# New-AzRoleAssignment -SignInName <you> -Scope '/' -RoleDefinitionName 'Owner'
New-AzTenantDeployment `
    -Name 'demoTenantDeployment' `
    -Location "northeurope" `
    -TemplateFile "$templateFolder\tenantScope.json"

# Deploy policy definition and assignment at MG scope
$mg = Get-AzManagementGroup | Where-Object { $_.DisplayName -like '*child*'}
New-AzManagementGroupDeployment `
    -Name 'demoMGDeployment'  `
    -Location 'northeurope' `
    -TemplateFile "$templateFolder\managementGroupScope.json" `
    -ManagementGroupId $mg.Name `
    -policyDefinitionName 'demoPolicy1' `
    -policyAssignmentName 'demoAssign1' `
    -mgScope $mg.Id
