#This interactive script obtains a list of AD user who all have a given value set for Department
#then, it iterates over that list of users and sets Department to a new value
#this script can be adapted to update any AD profile value
 
$departmentUsers = Read-Host "Enter the current department attribute from AD"
$newDepartmentValue = Read-Host "Enter the new Department value (this will be applied to ALL users with the old department value)"
try {
    $userList = Get-ADUser -Filter "Department -eq '$departmentUsers'" | Select sAMAccountName #obtain list of users who have the specified department value
    $userList | out-host
}
catch {
    Read-host "Error occurred: $($_.Exception.Message).`nPress enter to exit"
    Throw $_
}
Read-Host "The list above contains all users with the Department attribute $departmentUsers. Hit enter to replace it with $newDepartmentValue" #Provide an opportunity to review the user list and the future Department value before executing change
try {
    foreach ($user in $userList){
         set-aduser -identity $user.sAMAccountName -department $newDepartmentValue #update the Department value
        }
    Write-host "Department Attribute Updated Successfully!" #output a success message for each user
}
catch {
    Read-host "Error occurred: $($_.Exception.Message).`nPress enter to exit"
    Throw $_
}
Read-Host "Press Enter to Exit"
