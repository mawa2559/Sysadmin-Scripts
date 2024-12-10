$baseUrl = "https://clearchoice.okta.com"
$authorizationToken = "00R294J0IxFMRtzL7Q3lWeaaoj5qLY-WQ1iLyQzTM5"
$headers = @{
    "Authorization" = "SSWS $authorizationToken"
    "Content-Type" = "application/json"
}

Import-Csv -Path "C:\Users\mwalls\Downloads\Nextgen - update smile book apps_center groups - Smile Drive CSV.csv" | ForEach-Object {

    $groupID = $_.GroupID
    $appID = "0oa1xep2jbw4EKCUI0h8"  #set this $_.appID to reference the appID column of the CSV
    $endpoint = "/api/v1/apps/" + "$appID" + "/groups/" + "$groupID"

    try {
        $url = $baseUrl + $endpoint
        $response = Invoke-RestMethod -Uri $url -Method Put -Headers $headers -ContentType "application/json"

        $response | out-host
        Write-Host "$_.AppLabel added to group: $_.GroupName"
        Start-Sleep -Seconds 2 #okta rate limits the API endpiont; sleeping keeps function from failing due to 429 error
    }
    catch {
        Read-Host "An error occurred: $($_.Exception.Message).`nPress Enter to Exit"
        Throw $_
    }

}

#00R294J0IxFMRtzL7Q3lWeaaoj5qLY-WQ1iLyQzTM5