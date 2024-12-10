#This script takes a CSV of user emails and makes a GET request to search for the user in Okta, returns specified profile attributes, and outputs the data to a CSV
#The GET request takes advantage of a search parameter to locate the user using the given emails
 
 $baseUrl = "https://your_domain.okta.com"
$authorizationToken = "API AUTH TOKEN HERE" #can be generated from the Okta Admin portal from the API tab
$headers = @{
    "Authorization" = "SSWS $authorizationToken"
    "Content-Type" = "application/json"
}

Import-Csv -Path "C:\Path\To\emails.csv" | ForEach-Object {
    
    $email= $_.email
    $endpoint = "/api/v1/users?search=profile.email%20eq%20%22" + "$email" + "%22"

    try {
        $url = $baseUrl + $endpoint
        $response = Invoke-RestMethod -Uri $url -Method GET -Headers $headers -ContentType "application/json" #Make the GET request and save the response data to a variable

        $userinfo = [PSCustomObject]@{ #save some of the user's attributes to a custom boject for export to a CSV later
            LastName = $response.profile.lastName
            centercode = $response.profile.centercode
            office = $response.profile.office
            ID = $response.id #this is their Okta unique user ID
            }
        $userinfo | Export-CSV -Path C:\Path\to\userIDs.csv -Append -NoTypeInformation

    }
    catch {
        Read-Host "An error occurred: $($_.Exception.Message).`nPress Enter to Exit"
        Throw $_
    }

} 
