#This script checks if a user is a member of the local admin group of a PC and if not, it adds them

$domainUser = "domain\Admin1" #User account to be added with domain prefix
$localadmins = get-localgroupmember -Group Administrators | Select-Object -ExpandProperty name #enumerate list of users in local admin group
if ($localadmins -contains $domainUser) {
    write-host 'Confirmed $domainUser is a local admin!' -ForegroundColor Green
    }
Else {
  Add-LocalGroupMember -Group "Administrators" -Member $domainUser
  Write-Host "$domainUser added to local admin group!" -ForegroundColor Green
    }
