$userList = Get-ADGroupMember -Identity Coupa | Select-Object -ExpandProperty sAMAccountName
$userList | out-host
    foreach ($user in $userList) {
        Remove-ADGroupMember -Identity "Coupa" -Members $user -Confirm:$false
        }