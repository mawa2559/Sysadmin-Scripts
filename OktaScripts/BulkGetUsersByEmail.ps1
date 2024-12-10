$baseUrl = "https://clearchoice.okta.com"
$authorizationToken = "00R294J0IxFMRtzL7Q3lWeaaoj5qLY-WQ1iLyQzTM5"
$headers = @{
    "Authorization" = "SSWS $authorizationToken"
    "Content-Type" = "application/json"
}

Import-Csv -Path "C:\Users\mwalls\Downloads\Sprintrayusers.csv" | ForEach-Object {
    
    $email= $_.email
    $endpoint = "/api/v1/users?search=profile.email%20eq%20%22" + "$email" + "%22"

    try {
        $url = $baseUrl + $endpoint
        $response = Invoke-RestMethod -Uri $url -Method GET -Headers $headers -ContentType "application/json"

        $userinfo = [PSCustomObject]@{
            LastName = $response.profile.lastName
            centercode = $response.profile.centercode
            office = $response.profile.office
            ID = $response.id
            }
        $userinfo | Export-CSV -Path C:\Users\mwalls\Downloads\userIDs.csv -Append -NoTypeInformation

    }
    catch {
        Read-Host "An error occurred: $($_.Exception.Message).`nPress Enter to Exit"
        Throw $_
    }

} 

#00R294J0IxFMRtzL7Q3lWeaaoj5qLY-WQ1iLyQzTM5
#/api/v1/users?search=profile.email%20eq%20%22cboone@clearchoice.com%22