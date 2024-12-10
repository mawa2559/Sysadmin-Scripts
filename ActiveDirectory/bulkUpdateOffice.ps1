$officeUsers = Read-Host "Enter the current department attribute from AD"
$newOfficeValue = Read-Host "Enter the new Department value (this will be applied to ALL users with the old department value)"
try {
    $userList = Get-ADUser -Filter {office -eq $officeUsers} | Select sAMAccountName
    $userList | out-host
}
catch {
    Read-host "Error occurred: $($_.Exception.Message).`nPress enter to exit"
    Throw $_
}
Read-Host "The list above contains all users with the office attribute $officeUsers. Hit enter to replace it with $newofficeValue"
try {
    foreach ($user in $userList){
         set-aduser -identity $user.sAMAccountName -office $newOfficeValue
        }
    Write-host "Office Attribute Updated Successfully!"
}
catch {
    Read-host "Error occurred: $($_.Exception.Message).`nPress enter to exit"
    Throw $_
}
Read-Host "Press Enter to Exit"