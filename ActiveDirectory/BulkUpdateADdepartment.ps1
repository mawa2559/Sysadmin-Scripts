$departmentUsers = Read-Host "Enter the current department attribute from AD"
$newDepartmentValue = Read-Host "Enter the new Department value (this will be applied to ALL users with the old department value)"
try {
    $userList = Get-ADGroupMember -Identity Ultipro | Select sAMAccountName
    $userList | out-host
}
catch {
    Read-host "Error occurred: $($_.Exception.Message).`nPress enter to exit"
    Throw $_
}
Read-Host "The list above contains all users with the Department attribute $departmentUsers. Hit enter to replace it with $newDepartmentValue"
try {
    foreach ($user in $userList){
         set-aduser -identity $user.sAMAccountName -department $newDepartmentValue
        }
    Write-host "Department Attribute Updated Successfully!"
}
catch {
    Read-host "Error occurred: $($_.Exception.Message).`nPress enter to exit"
    Throw $_
}
Read-Host "Press Enter to Exit"