$templateFolder = "C:\repos\virtual-partner-bootcamp\Azure Infrastructure\Day 3 - IaC\Advanced Automation with ARM Templates\Demo\DeploymentScripts"
$rgName = "ScriptRG"

New-AzResourceGroup -Name $rgName -Location northeurope -Force

# Create User-Assigned Managed Identity and assign permissions
$mi = New-AzUserAssignedIdentity -Name MyMI959 -ResourceGroupName $rgName
Start-Sleep 10
New-AzRoleAssignment -ObjectId $mi.PrincipalId -RoleDefinitionName 'Contributor'

# Deploy template with embedded script
New-AzResourceGroupDeployment -Name 'deploy1' `
    -ResourceGroupName $rgName `
    -TemplateFile "$templateFolder\scriptTemplate.json" `
    -mi $mi.Id `
    -testName 'George'
