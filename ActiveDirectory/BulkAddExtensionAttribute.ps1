$officeUsers = Read-Host "Enter the current office attribute from AD"
$extAttributeValue = Read-Host "Enter the extendedAttribute2 value"
try {
    $userList = Get-ADUser -Filter "Office -eq '$officeUsers'" | Select sAMAccountName
    $userList | out-host
}
catch {
    Read-host "Error occurred: $($_.Exception.Message).`nPress enter to exit"
    Throw $_
}
Read-Host "The list above contains all users with the office attribute $officeUsers. Hit enter to set extensionAttribute2 as $extAttributeValue"
try {
    foreach ($user in $userList){
         set-aduser -identity $user.sAMAccountName -add @{"extensionattribute2"="$extAttributeValue"}
        }
    Write-host "Extension Attribute Updated Successfully!"
}
catch {
    Read-host "Error occurred: $($_.Exception.Message).`nPress enter to exit"
    Throw $_
}
Read-Host "Press Enter to Exit"