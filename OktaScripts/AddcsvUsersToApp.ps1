#00-ylCkicZm01N69YLX1KmpiDr0xCODCzJzvpKMJse
#change method to Delete to remove users from app
#change app ID in endpoint variable to specify app

Import-Csv -Path "C:\Users\mwalls\Downloads\group&ruledelete.csv" | ForEach-Object {
    $baseUrl = "https://clearchoice.okta.com"
    $RuleID = $_.RuleID
    $GroupID = $_.GroupID
    $RuleName=$_.RuleName
    $GroupName=$_.RuleName
    $authorizationToken = "00-ylCkicZm01N69YLX1KmpiDr0xCODCzJzvpKMJse"
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


    Write-Host "Reul: $RuleName Deleted, Group: $GroupName Deleted"
}
catch {
    write-Host "An error occurred: $($_.Exception.Message)."
    Write-Host "$_.email not added"
}
}

#"00u1lhmzswkH3nPEy0h8","Ckendys@clearchoice.com" "00u1mokn578srgF5a0h8","lice@clearchoice.com"

