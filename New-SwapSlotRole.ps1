
function New-SwapSlotRole {
    param (
        [Parameter(mandatory=$true)] [string]$subscriptionId
    )

    if (Get-AzRoleDefinition -Name "Web App Slot Change"){
        Write-Output "role with name Web App Slot Change already exists"
    }
    else {
        #get basic role to start with
        $role = Get-AzRoleDefinition "Virtual Machine Contributor"
        $role.Id = $null
        $role.IsCustom = $true
        $role.Name = "Web App Slot Change"
        $role.Description = "Custom role to be able to swap slots"
        $role.Actions.Clear()
        $role.Actions.Add("Microsoft.Web/sites/publishxml/Action")       
        $role.NotActions.Add("Microsoft.Authorization/*/Delete")
        $role.NotActions.Add("Microsoft.Authorization/*/Write")
        $role.NotActions.Add("Microsoft.Authorization/elevateAccess/Action")
        $role.NotActions.Add("Microsoft.Blueprint/blueprintAssignments/write")
        $role.NotActions.Add("Microsoft.Blueprint/blueprintAssignments/delete")
        $role.NotActions.Add("Microsoft.Compute/galleries/share/action")
        $role.AssignableScopes.Clear()
        $role.AssignableScopes.Add("/subscriptions/$subscriptionId")
        New-AzRoleDefinition -Role $role
        sleep 30
    }
}

