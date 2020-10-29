# Install Preview module for WhatIf support
Install-Module Az.Resources -RequiredVersion 1.12.1-preview -AllowPrerelease -Scope CurrentUser

# Environment
$templateFolder =  "C:\repos\virtual-partner-bootcamp\Azure Infrastructure\Day 3 - IaC\Advanced Automation with ARM Templates\Demo\WhatIf"
$rgName = 'WhatIfRG'
New-AzResourceGroup -Name $rgName -Location northEurope -Force

# Initial deployment
New-AzResourceGroupDeployment -Name 'deploy1' `
    -ResourceGroupName $rgname `
    -TemplateFile "$templateFolder\whatif1.json" 

# Modified template - WhatIf (incremental mode)
New-AzResourceGroupDeployment -Name 'deploy2' `
    -ResourceGroupName $rgname `
    -TemplateFile "$templateFolder\whatif2.json" `
    -Mode Incremental `
    -WhatIf

# Modified template - WhatIf (complete mode)
New-AzResourceGroupDeployment -Name 'deploy2' `
-ResourceGroupName $rgname `
-TemplateFile "$templateFolder\whatif2.json" `
-Mode Complete `
-WhatIf

# Modified template - programmatic results
$result = Get-AzResourceGroupDeploymentWhatIfResult -Name 'deploy3' `
    -ResourceGroupName $rgname `
    -TemplateFile "$templateFolder\whatif2.json"

# Modified template - confirm deployment
New-AzResourceGroupDeployment -Name 'deploy4' `
    -ResourceGroupName $rgname `
    -TemplateFile "$templateFolder\whatif2.json" `
    -Confirm