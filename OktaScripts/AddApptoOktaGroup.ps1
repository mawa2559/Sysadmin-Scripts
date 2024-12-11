#This interactive powershell script uses a PUT request to assign an Okta application integration to an Okta group
 
$baseUrl = "https://your_domain.okta.com" #Enter your Okta org's base URL
$groupID = Read-Host "Enter the Okta group ID (seen in the URL when looking at the group from Okta Admin portal)" #you need to provide the ID of the Okta group
$authorizationToken = Read-Host "Enter the your Auth Token (generated in okta admin portal)" #available to generate under the API section of the Okta Admin portal
$endpoint = "/api/v1/apps/<APPLICATION ID>/groups/" + "$groupID" #This endpoint references the application ID of the app you'd like to assign to the group. Can be obtained from the URL of the page when viewing the app.
$headers = @{
    "Authorization" = "SSWS $authorizationToken"
    "Content-Type" = "application/json"
}

try {
    $url = $baseUrl + $endpoint
    $response = Invoke-RestMethod -Uri $url -Method Put -Headers $headers -ContentType "application/json"

    $response | out-host
    Write-Host "Application added to group!"
}
catch {
    Read-Host "An error occurred: $($_.Exception.Message).`nPress Enter to Exit"
    Throw $_
}
