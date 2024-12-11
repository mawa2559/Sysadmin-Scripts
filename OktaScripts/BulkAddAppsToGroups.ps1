#This PowerShell script takes a CSV containing an appID column and an AppLabel column mapped to a GroupID column, and adds the application to each mapped group
#You can statically assign one app to the groups in the sheet, or reference more apps listed on the sheet. Lots of ways to customize this one
#rockstar extension used for exporting app and group info. See README for link

$baseUrl = "https://your_domain.okta.com"
$authorizationToken = "API AUTH TOKEN HERE"
$headers = @{
    "Authorization" = "SSWS $authorizationToken"
    "Content-Type" = "application/json"
}

Import-Csv -Path "C:\Path\To\file.csv" | ForEach-Object {

    $groupID = $_.GroupID #this could be set to a static group ID to assign multiple apps referenced on the CSV to a single group
    $appID = "<APP ID>"  #set this to $_.appID (or whatever you name the appID column) to reference the appID column of the CSV to assign different apps to different groups
    $endpoint = "/api/v1/apps/" + "$appID" + "/groups/" + "$groupID"

    try {
        $url = $baseUrl + $endpoint
        $response = Invoke-RestMethod -Uri $url -Method Put -Headers $headers -ContentType "application/json"

        $response | out-host
        Write-Host "$_.AppLabel added to group: $_.GroupName"
        Start-Sleep -Seconds 2 #Okta rate limits the API endpiont; sleeping keeps function from failing due to 429 error if your CSV is referencing a lot of groups/apps
    }
    catch {
        Read-Host "An error occurred: $($_.Exception.Message).`nPress Enter to Exit"
        Throw $_
    }

}
