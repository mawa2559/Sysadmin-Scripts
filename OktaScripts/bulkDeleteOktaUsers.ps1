#This script takes a CSV containing an export of Okta usernames and deletes them all. Okta does not natively provide a bulk delete in their UI
#This is useful in sandbox environments for removing bulk test data
#this action is IRREVERSIBLE so be sure you want to delete these accounts
#The easiest way to export datas is by using the rockstar Okta browser extension. Linked in the README

 
Import-Csv -Path "C:\Path\To\Users.csv" | ForEach-Object {
    $baseUrl = "https://yourdomain.okta.com/api/v1/users/" #update to your okta tenant url
    $userlogin = $_.Username #the CSV imported has all of the usersnames to be deleted in a column with a header "Username"
    $authorizationToken = "API AUTH TOKEN HERE"
    $deactivateEndpoint = $userlogin + "/lifecycle/deactivate" #Okta user must first be deactivated before they can be deleted, so both delete and deactivate endpoints are called
    $deleteEndpoint = $userlogin
    $headers = @{
        "Authorization" = "SSWS $authorizationToken"
        "Content-Type" = "application/json"
}

try {
    $deactivateURL = $baseUrl + $deactivateEndpoint
    $deleteURL = $baseUrl + $deleteEndpoint
    Invoke-RestMethod -Uri $deactivateURL -Method POST -Headers $headers -ContentType "application/json" -ErrorAction Continue | out-null #deactivating the account is required first
    Invoke-RestMethod -Uri $deleteURL -Method DELETE -Headers $headers -ContentType "application/json" -ErrorAction Continue | out-null #then delete the account
    write-host "$userlogin deleted"
}
catch {
    Write-Host "An error occurred: $($_.Exception.Message)"
}
}

