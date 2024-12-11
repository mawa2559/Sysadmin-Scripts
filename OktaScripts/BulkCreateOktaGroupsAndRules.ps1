#This Script uses Okta's official PowerShell Module integration and requires set up/authorization prior to running
#For instructions on setting up the Module, please refer to https://developer.okta.com/blog/2024/05/07/okta-powershell-module

#This script takes a CSV that contains two columns﻿; one column GroupName contains the desired name for our Okta groups, second column CostCenterID contains the cost center ID corresponding to membership for that group
#The CostCenterID is referenced as the criteria for dynamic Okta group membership via the Group Rule - for each group, if a user has the associated CostCenterID in their Okta profile, they will be added to the group
#Great for creating relatively simple groups and group rules where membership is determined by simple criteria, but can be expanded easily.

Import-Csv -Path "C:\Path\To\Okta_Groups_Rules.csv" | ForEach-Object { #iterate over all groups in the CSV and create the group, create the group rule, and activate the group rule
    $GroupName = $_.GroupName
    $CostCenter = $_.CostCenterID
    $GroupRuleVal = "user.costCenter=='" + "$CostCenter" + "'" #this variable contains the criteria which will determine who is a member of the group
    $GroupProfile = [PSCustomObject]@{ #Object that contains the name and description of the group as it will appear in the UI
                name = $_.GroupName
                description = "Dynamic Assignment Group for Location Employees"
            }
    $NewGroup = Initialize-OktaGroup -VarProfile $GroupProfile

    $CreatedGroup = New-OktaGroup -Group $NewGroup #store the new group's info in a variable, including the group's unique ID

    echo $CreatedGroup

    $NewGroupRule = @{ #define group rule
    name = "Assign users to " + $_.GroupName #set the group rule name
    type = "group_rule"
    actions = @{
        assignUserToGroups = @{
            groupIds = @($CreatedGroup.Id) #set the group rule to automatically assign anybody who matches the group rule to the associated group we just created
        }
    }  
    conditions = @{ #set criteria for the group rule to the value we assigned $GroupRuleVal above
        expression = @{
            type = "urn:okta:expression:1.0"
            value = $GroupRuleVal
        }
    }
}

$CreatedRule = New-OktaGroupRule -GroupRule $NewGroupRule -IncludeNullValues #store the newly created group rule's attributes in a varible

Echo $CreatedRule

Invoke-OktaActivateGroupRule -RuleId $CreatedRule.Id   #activate the group rule
}

