#This script adds a csv list of Okta users to the specified Okta group
#Could easily be customized to map different user to different groups, or one user to mutiple groups.
 
$baseUrl = "https://your_domain.okta.com"
$authorizationToken = "API AUTH TOKEN HERE"
$headers = @{
    "Authorization" = "SSWS $authorizationToken"
    "Content-Type" = "application/json"
}

Import-Csv -Path "C:\Path\To\userIDs.csv" | ForEach-Object { #iterate over each row in the csv

    $groupID = "<Group ID>" #change this value to specify the group ID
    $userID = $_.ID  #references the column named ID on the csv containing Okta user IDs
    $endpoint = "/api/v1/groups/" + "$groupID" + "/users/" + "$userID"

    try {
        $url = $baseUrl + $endpoint
        $response = Invoke-RestMethod -Uri $url -Method Put -Headers $headers -ContentType "application/json"

        $response | out-host
    }
    catch {
        Read-Host "An error occurred: $($_.Exception.Message)."
        Throw $_
    }

}
