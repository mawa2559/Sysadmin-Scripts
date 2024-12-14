#This script removes all of the members of a given AD group

$Groupname = "AD_Group_1'
$userList = Get-ADGroupMember -Identity $Groupname | Select-Object -ExpandProperty sAMAccountName #get the SAN all of the current group members
$userList | out-host #output the list of group members for review (optional)
    foreach ($user in $userList) {
        Remove-ADGroupMember -Identity $Groupname -Members $user -Confirm:$false #remove each user from the group, do not allow powershell to prompt for confirmation
        }
