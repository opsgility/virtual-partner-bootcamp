$subscriptionId = '41811f87-4f0d-44d0-bec9-a9b162257403'

$rgName = 'TestRG'
$aaName = 'aaTest'
$runbookName = 'MyChildPSRunbook'

$params = @{ 'text'='bananas' }

# Need to be authenticated to Azure with correct RBAC to start new AA job
Disable-AzContextAutosave –Scope Process
$Conn = Get-AutomationConnection -Name AzureRunAsConnection
Connect-AzAccount -ServicePrincipal `
    -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID `
    -CertificateThumbprint $Conn.CertificateThumbprint `
    -Subscription $subscriptionId

Write-Output "Starting child runbook"

$out = Start-AzAutomationRunbook `
    -Name $runbookName `
    -ResourceGroupName $rgName `
    -AutomationAccountName $aaName `
    -Parameters $params `
    -Wait

Write-Output "Child Runbook finished, output: " $out