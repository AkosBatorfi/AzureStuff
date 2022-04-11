function Get-ASRDetails{
    [CmdletBinding()]
      Param
          (
              [Parameter(Mandatory=$true)]
              $ResourceGroup,
              [Parameter(Mandatory=$true)]
              $RecoveryVaultname
          ) 
      
      # Getting Azure connection context for the signed in user
      $currentContext = Get-AzContext
  
      # fetching bearer token
      $azureRmProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
      $profileClient = [Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient]::new($azureRmProfile)
      $token = $profileClient.AcquireAccessToken($currentContext.Subscription.TenantId)
      
      $date = Get-date
      $datebefore = (Get-date).AddDays(-$daysago)
      $restCommand = @{
          Uri = "https://management.azure.com/subscriptions/$($currentContext.Subscription.id)/resourceGroups/$ResourceGroup/providers/Microsoft.RecoveryServices/vaults/$RecoveryVaultname/replicationProtectedItems?api-version=2021-08-01"
          Headers = @{
              Authorization = "Bearer $($token.AccessToken)"
              'Content-Type' = 'application/json'
          }
          Method = 'GET'
      }
      $output = Invoke-RestMethod @restCommand
      return $output.value
  }
  