#this script consumes a csv containing user emails and produces a CSV containing the Okta IDs

Import-Csv -Path "C:\Users\mwalls\Downloads\Accounting & Finance Team Names & emails - Sheet1.csv" | ForEach-Object {
    $baseUrl = "https://clearchoice.okta.com"
    $userlogin = $_.email
    $userlogin2 = $userlogin -replace "@clearchoice.com", "%40ccd.local"
    $authorizationToken = "00-ylCkicZm01N69YLX1KmpiDr0xCODCzJzvpKMJse"
    $endpoint = "/api/v1/users/" + $userlogin2
    $headers = @{
        "Authorization" = "SSWS $authorizationToken"
        "Content-Type" = "application/json"
}

try {
    $url = $baseUrl + $endpoint
    $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ContentType "application/json"

    [PsCustomObject]@{
        ID = $response.profile.
        username = $response.profile.email
        }
}
catch {
    Read-Host "An error occurred: $($_.Exception.Message).`nPress Enter to Exit"
    Throw $_
}
} | Export-Csv -Path "C:\Users\mwalls\Downloads\OktaUserIDs.csv" -NoTypeInformation
