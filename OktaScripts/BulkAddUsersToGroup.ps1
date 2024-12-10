$baseUrl = "https://clearchoice.okta.com"
$authorizationToken = "00R294J0IxFMRtzL7Q3lWeaaoj5qLY-WQ1iLyQzTM5"
$headers = @{
    "Authorization" = "SSWS $authorizationToken"
    "Content-Type" = "application/json"
}

Import-Csv -Path "C:\Users\mwalls\Downloads\userIDs.csv" | ForEach-Object {

    $groupID = "00g1uve51s4BG4n2I0h8" #change this value to specify the group
    $userID = $_.ID 
    $endpoint = "/api/v1/groups/" + "$groupID" + "/users/" + "$userID"

    try {
        $url = $baseUrl + $endpoint
        $response = Invoke-RestMethod -Uri $url -Method Put -Headers $headers -ContentType "application/json"

        $response | out-host
    }
    catch {
        Read-Host "An error occurred: $($_.Exception.Message).`nPress Enter to Exit"
        Throw $_
    }

}

#00R294J0IxFMRtzL7Q3lWeaaoj5qLY-WQ1iLyQzTM5