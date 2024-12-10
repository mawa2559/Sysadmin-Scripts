#This script takes a CSV with a list of Okta Group IDs/Names and Group Rule IDs/names, and deletes them in bulk via an http DELETE request

Import-Csv -Path "C:\Path\To\file.csv" | ForEach-Object {
    $baseUrl = "https://your_domain.okta.com"
    $RuleID = $_.RuleID
    $GroupID = $_.GroupID
    $RuleName=$_.RuleName
    $GroupName=$_.GroupName
    $authorizationToken = "<API AUTH TOKEN GOES HERE>"
    $RuleEndpoint = "/api/v1/groups/rules/" + $RuleID
    $GroupEndpoint = "/api/v1/groups/" + $GroupID
    $headers = @{
        "Authorization" = "SSWS $authorizationToken"
        "Content-Type" = "application/json"
}

try {
    $DeleteRuleUrl = $baseUrl + $RuleEndpoint
    $DeleteGroupUrl = $baseUrl + $GroupEndpoint
    Invoke-RestMethod -Uri $DeleteRuleUrl -Method delete -Headers $headers -ContentType "application/json" -ErrorAction Continue
    Invoke-RestMethod -Uri $DeleteGroupUrl -Method delete -Headers $headers -ContentType "application/json" -ErrorAction Continue


    Write-Host "Rule: $RuleName Deleted, Group: $GroupName Deleted"
}
catch {
    write-Host "An error occurred: $($_.Exception.Message)."
    Write-Host "$_.email not added"
}
}
