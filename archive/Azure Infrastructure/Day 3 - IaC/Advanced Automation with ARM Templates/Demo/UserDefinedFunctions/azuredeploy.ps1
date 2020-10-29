$templateFolder =  "C:\repos\virtual-partner-bootcamp\Azure Infrastructure\Day 3 - IaC\Advanced Automation with ARM Templates\Demo\UserDefinedFunctions"
$templateFile = "$templateFolder\peering.json"

$hubVnet = Get-AzVirtualNetwork -Name 'Hub-VNET' -ResourceGroupName 'HubRG'
$spokeVnet = Get-AzVirtualNetwork -Name 'Spoke-VNET' -ResourceGroupName 'SpokeRG'

New-AzSubscriptionDeployment -Name PeeringDeployment `
    -Location NorthEurope `
    -TemplateFile $templateFile `
    -hubVnetId $hubVnet.Id `
    -spokeVnetId $spokeVnet.Id
