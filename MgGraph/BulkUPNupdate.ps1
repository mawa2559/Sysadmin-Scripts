#connect to graph api
Connect-MgGraph -Scopes user.readwrite.all

# Define  tenant's onmicrosoft.com domain
$NewDomain = "NewDomain.io"
 
# Load user list from CSV
$users = Import-Csv -Path "C:\Temp\M365_UserExport.csv"
 
foreach ($user in $users) {
    $oldUPN = $user.UserPrincipalName
    $username = $oldUPN.Split("@")[0]
    $newUPN = "$username@$NewDomain"
 
    # Change UPN to admi.io domain
    try {
        update-MgUser -UserId $oldUPN -UserPrincipalName $newUPN
        Write-Host "Successfully changed $oldUPN to $newUPN" -ForegroundColor Green
    } catch {
        Write-Host "Failed to change $oldUPN : $_" -ForegroundColor Red
    }
}
