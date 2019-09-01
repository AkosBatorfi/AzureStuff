function New-ContributorSP{
    param
    (
        [Parameter(Mandatory=$true, HelpMessage="Provide a unique display name for SPN application")]
        [string] $appDisplayName,

        [Parameter(Mandatory=$true, HelpMessage="Provide a password for SPN application")]
        [string] $appPassword
    )

    Write-Output "Verifying App is unique ($appDisplayName)" -Verbose
    $existingApplication = Get-AzADApplication -IdentifierUri "http://$($appDisplayName)"
    if ($existingApplication -ne $null) {
            $appId = $existingApplication.ApplicationId
            Write-Output "An AAD Application already exists with App URI $($appDisplayName). Choose a different app display name"  -Verbose
            return
    }


    $secPassword = ConvertTo-SecureString -AsPlainText -Force -String $appPassword
    try{
        $myApp = New-AzADApplication -DisplayName $appDisplayName -IdentifierUris "http://$($appDisplayName)" -Password $secPassword
        $sp = New-AzADServicePrincipal -ApplicationId $myApp.ApplicationId
    }
    catch{
        Write-Output "Oops, something went wrong"
        return
    }
    Write-Output "AppID to use   : $($sp.ApplicationId)"
    Write-Output "ObjectID to use: $($sp.Id)"
    Write-Output "Waiting for App to register in AAD"
    sleep 10
    Write-Output "Granting $($appDisplayName) Contributor role"
    New-AzRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $sp.ServicePrincipalNames[0]
}
