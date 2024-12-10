

Import-Csv -Path "C:\Users\mwalls\Downloads\Okta_BulkGroups_Rules.csv" | ForEach-Object {
    $GroupName = $_.GroupName
    $CostCenter = $_.CostCenterID
    $GroupRuleVal = "user.costCenter=='" + "$CostCenter" + "'"
    $GroupProfile = [PSCustomObject]@{
                name = $_.GroupName
                description = "Dynamic Assignment Group for Center Employees"
            }
    $NewGroup = Initialize-OktaGroup -VarProfile $GroupProfile

    $CreatedGroup = New-OktaGroup -Group $NewGroup

    echo $CreatedGroup

    $NewGroupRule = @{
    name = "Assign users to " + $_.GroupName
    type = "group_rule"
    actions = @{
        assignUserToGroups = @{
            groupIds = @($CreatedGroup.Id)
        }
    }  
    conditions = @{
        expression = @{
            type = "urn:okta:expression:1.0"
            value = $GroupRuleVal
        }
    }
}

$CreatedRule = New-OktaGroupRule -GroupRule $NewGroupRule -IncludeNullValues

Echo $CreatedRule

Invoke-OktaActivateGroupRule -RuleId $CreatedRule.Id   
}

