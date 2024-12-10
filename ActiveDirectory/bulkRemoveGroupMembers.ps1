#This script removes all of the members of a given AD group

$userList = Get-ADGroupMember -Identity "Group_Name" | Select-Object -ExpandProperty sAMAccountName #get all of the current group members
$userList | out-host #output the list of group members
    foreach ($user in $userList) {
        Remove-ADGroupMember -Identity "Coupa" -Members $user -Confirm:$false #remove each user from the group
        }
