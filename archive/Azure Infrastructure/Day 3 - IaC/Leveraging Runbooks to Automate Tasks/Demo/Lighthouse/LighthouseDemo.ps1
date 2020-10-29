
Disable-AzContextAutosave –Scope Process

$Conn = Get-AutomationConnection -Name AzureRunAsConnection
Connect-AzAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

Write-Output "Listing subscriptions with Get-Subscription"
Write-Output "Uses old API version and doesn't show homeTenantID"
Get-AzSubscription

Write-Output "Now list subscriptions using latest API"
$uri = 'https://management.azure.com/subscriptions?api-version=2020-01-01'

# Get access token
$currentAzureContext = Get-AzContext
$azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
$profileClient = New-Object Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient($azProfile)
$token = ($profileClient.AcquireAccessToken($currentAzureContext.Tenant.TenantId)).AccessToken

$headers = @{}
$headers['authorization'] = "Bearer $token"

$subscriptions = (Invoke-RestMethod -Uri $uri -Method Get -UseBasicParsing -Headers $headers).value
Write-Output $subscriptions