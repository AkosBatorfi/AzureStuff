#Workflow in Azure Automation to start multiple VMs in parallel
#Schedule this to run on a daily task at whatever time.

workflow Start-VMs {
    $Conn = Get-AutomationConnection -Name AzureRunAsConnection
    $resourceManagerContext = Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint
 
    $collection = @(Get-AzureRmResource | Where-Object { $_.ResourceType -like "Microsoft.*/virtualMachines" -and $_.ResourceGroupName -eq 'RG-DTA' })
    foreach -parallel ($item in $collection) {
        If ((Get-Date).DayOfWeek -eq 'Saturday' -or (Get-Date).DayOfWeek -eq 'Sunday') {
            Write-Output "No action needed in the weekend"
        }
        else {
            $item | Start-AzureRMVM
        }
    }
}