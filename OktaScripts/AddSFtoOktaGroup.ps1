$baseUrl = "https://clearchoice.okta.com"
$groupID = Read-Host "Enter the Okta group ID (seen in the URL when looking at the group from Okta Admin portal)"
$authorizationToken = Read-Host "Enter the your Auth Token (generated in okta admin portal)"
$endpoint = "/api/v1/apps/0oa1i7jjgxixhCEXP0h8/groups/" + "$groupID"
$headers = @{
    "Authorization" = "SSWS $authorizationToken"
    "Content-Type" = "application/json"
}

try {
    $url = $baseUrl + $endpoint
    $response = Invoke-RestMethod -Uri $url -Method Put -Headers $headers -ContentType "application/json"

    $response | out-host
    Write-Host "Salesforce added to group!"
}
catch {
    Read-Host "An error occurred: $($_.Exception.Message).`nPress Enter to Exit"
    Throw $_
}

Read-Host "Press Enter to exit"

#00dDZwwaUfPDUgj7WeK-yxP3sroZZxPbZeuCraAor0