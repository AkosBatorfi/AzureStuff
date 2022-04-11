# AzureStuff

- Start-Stop workflow I made because Azure was too slow stopping and starting VMs in the morning. This makes a parallel startup of VMs possible.
- Formatdisk.ps1 I made to format a disk from an ARM template
- New-ContributorSP.ps1 is a script to create a service principal and giving it contributor rights.



- Get-ASRDetails.ps1 is a script that makes an API call to Azure to retrieve all Azure Site Recovery details (much more than regular PowerShell modules give).

```powershell
#Get all vaults, collect them all in a single variable, then see all VMs, RPO times, and whether the mobility agent needs updating.

$vaults = Get-AzRecoveryServicesVault

foreach ($vault in $vaults){
    $ASRDetails = Get-ASRDetails -ResourceGroup $($vault.ResourceGroupName) -RecoveryVaultname $($vault.Name)
    $AllASR += $ASRDetails
}

$AllASR | select @{Name = 'Name'; Expression = {$($_.properties.friendlyname)}},
@{Name = 'rpoInSeconds'; Expression = {$($_.properties.providerSpecificDetails.rpoInSeconds)}},
@{Name = 'ReplicationAgentUpdateRequired'; Expression = {$($_.properties.providerSpecificDetails.isReplicationAgentUpdateRequired)}},
@{Name = 'AgentCertificateUpdateRequired'; Expression = {$($_.properties.providerSpecificDetails.isReplicationAgentCertificateUpdateRequired)}}
```



