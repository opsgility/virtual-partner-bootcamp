param($tenantId)

$appSecret = Get-AutomationVariable -Name 'SMUWebApplicationSecret'
$applicationId = Get-AutomationVariable -Name 'SMUWebApplicationID'
$refreshToken = Get-AutomationVariable -Name 'CSPRefreshToken'

$secpasswd = ConvertTo-SecureString $appSecret -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($applicationId, $secpasswd)

$azureToken = New-PartnerAccessToken -RefreshToken $refreshToken `
    -Scope 'https://management.azure.com/.default' `
    -Credential $credential -Tenant $tenantId -ApplicationId $applicationId `
    -ServicePrincipal

$graphToken =  New-PartnerAccessToken -RefreshToken $refreshToken 
    -Scope 'https://graph.microsoft.com/.default'   
    -Credential $credential -Tenant $tenantId -ApplicationId $applicationId     
    -ServicePrincipal

$azureAdToken = New-PartnerAccessToken -RefreshToken $refreshToken  
    -Scopes 'https://graph.windows.net/.default'    
    -Credential $credential -Tenant $tenantId -ApplicationId $applicationId     
    -ServicePrincipal

Disable-AzContextAutosave -Scope Process

Connect-AzAccount -AccessToken $azureToken.AccessToken `
    -GraphAccessToken $graphToken.AccessToken `
    -TenantId $tenantId -AccountId $applicationId 

Connect-AzureAD -AadAccessToken $azureAdToken.AccessToken `
    -MsAccessToken $graphToken.AccessToken  `
    -TenantId $tenantId -AccountId $applicationId 

# Now set context for default subscription and do whatever...

New-AzResourceGroup -Name Test -Location northeurope -Force

Get-AzureADUser