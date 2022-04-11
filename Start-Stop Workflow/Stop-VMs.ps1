#Workflow in Azure Automation to stop multiple VMs in parallel
#Schedule this daily at whatever time you want to stop the VMs
#I made this because stopping and starting 7 VMs took me several hours, so I did not want to do it in sequence.

workflow Stop-VMs
{
    $Conn = Get-AutomationConnection -Name AzureRunAsConnection
    $resourceManagerContext = Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint
 
    $collection = @(Get-AzureRmResource | Where-Object { $_.ResourceType -like "Microsoft.*/virtualMachines" -and $_.ResourceGroupName -eq 'RG-DTA' })
    foreach -parallel ($item in $collection) {
        If ((Get-Date).DayOfWeek -eq 'Saturday' -or (Get-Date).DayOfWeek -eq 'Sunday') {
            Write-Output "No action needed in the weekend"
        }
        else {
            $item | Stop-AzureRMVM -Force
        }
    }
}