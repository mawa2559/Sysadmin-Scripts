
Import-Csv -Path "C:\Users\mwalls\Downloads\Untitled spreadsheet - sandboxUsers.csv" | ForEach-Object {
    $baseUrl = "https://clearchoice.oktapreview.com/api/v1/users/"
    $userlogin = $_.Username
    $authorizationToken = "000GcxqPftis_9pB_gW8NDanemou4WwPLCcvB2YPFj"
    $deactivateEndpoint = $userlogin + "/lifecycle/deactivate"
    $deleteEndpoint = $userlogin
    $headers = @{
        "Authorization" = "SSWS $authorizationToken"
        "Content-Type" = "application/json"
}

try {
    $deactivateURL = $baseUrl + $deactivateEndpoint
    $deleteURL = $baseUrl + $deleteEndpoint
    Invoke-RestMethod -Uri $deactivateURL -Method POST -Headers $headers -ContentType "application/json" -ErrorAction Continue
    Invoke-RestMethod -Uri $deleteURL -Method DELETE -Headers $headers -ContentType "application/json" -ErrorAction Continue
}
catch {
    Write-Host "An error occurred: $($_.Exception.Message)"
}
}

