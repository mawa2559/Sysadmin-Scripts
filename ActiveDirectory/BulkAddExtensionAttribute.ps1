#This is in interactive script to filter our a list of AD users based on the value of AD attribute "Office", and add the specifid extension attribute to their accounts.
#This could be adapted for any AD attribute in need of being added
 
$officeUsers = Read-Host "Enter the current office attribute from AD"
$extAttributeValue = Read-Host "Enter the extendedAttribute2 value"
try {
    $userList = Get-ADUser -Filter "Office -eq '$officeUsers'" | Select sAMAccountName #Stores the list of users who all have the matching Office value specified previously to a variable
    $userList | out-host #Prints the user list
}
catch {
    Read-host "Error occurred: $($_.Exception.Message).`nPress enter to exit"
    Throw $_
}
Read-Host "The list above contains all users with the office attribute $officeUsers. Hit enter to set extensionAttribute2 as $extAttributeValue" #Allows operator to confirm the user list and extension attribute before executing
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
