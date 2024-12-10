# Prompt for Center Name, store a spaceless version, prompt for desired UPN
$centerName = Read-Host "Enter the Center Name"
$CenternameNoSpace = $centerName -replace '\s', ''
$upn = Read-Host "Enter the IT User UPN (ituser@ccd.local)"

# Set the distinguished name for the parent OU
$parentOU = "OU=Centers,OU=ClearChoice,DC=ccd,DC=local"

# Get the parent OU object
$parentOUPath = "LDAP://$parentOU"
$parentOUObject = [ADSI]$parentOUPath

# Create the Center OU
$centerOU = $parentOUObject.Create("OrganizationalUnit", "OU=$centerName")
$centerOU.SetInfo()

# Create OUs inside the Center OU
$computersOU = $centerOU.Create("OrganizationalUnit", "OU=Computers")
$groupsOU = $centerOU.Create("OrganizationalUnit", "OU=Groups")
$serversOU = $centerOU.Create("OrganizationalUnit", "OU=Servers")
$usersOU = $centerOU.Create("OrganizationalUnit", "OU=Users")
$computersOU.SetInfo()
$groupsOU.SetInfo()
$serversOU.SetInfo()
$usersOU.SetInfo()

# Create a user object
$firstName = $centerName
$lastName = "IT User"
$userPath = "LDAP://CN=$firstName $lastName,$($usersOU.Path)"
$userObject = $usersOU.Create("user", "CN=$firstName $lastName")
$userObject.SetInfo()

# Set userPrincipalName and sAMAccountName attributes
$userObject.Put("userPrincipalName", $upn)
$userObject.Put("sAMAccountName", $upn.Split("@")[0])
$userObject.SetInfo()

# Set IT user attributes
Set-ADUser -Identity $upn.Split("@")[0] -GivenName $firstName -Surname $lastName -Department $centerName -Office $centerName -Description "Enable for Testing Only" -Title "IT User Account" -Enabled $true -ChangePasswordAtLogon $false

# Create groups inside the Groups OU
$lgAllGroupName = "${CenternameNoSpace}_LG_All"
$wgLocalAdminGroupName = "${CenternameNoSpace}_WG_LocalAdmin"

$lgAllGroup = $groupsOU.Create("group", "CN=$lgAllGroupName")
$wgLocalAdminGroup = $groupsOU.Create("group", "CN=$wgLocalAdminGroupName")
$lgAllGroup.SetInfo()
$wgLocalAdminGroup.SetInfo()

# Set the group attributes
Set-ADGroup -Identity "CN=$lgAllGroupName,OU=Groups,OU=$centerName,OU=Centers,OU=ClearChoice,DC=ccd,DC=local" -Description "Local Group - All $centerName users" -DisplayName $lgAllGroupName -SamAccountName $lgAllGroupName
Set-ADGroup -Identity "CN=$wgLocalAdminGroupName,OU=Groups,OU=$centerName,OU=Centers,OU=ClearChoice,DC=ccd,DC=local" -Description "Workstation Group - $centerName workstation Local Admin" -DisplayName $wgLocalAdminGroupName -SamAccountName $wgLocalAdminGroupName

# Add cms admin group as a member of localAdmin group
Add-ADGroupMember -Identity $wgLocalAdminGroupName -Members CMS_WG_LocalAdmin

#add travler group to LG_All group
add-adGroupMember -Identity $lgAllGroupName -Members CORP_LG_Traveler


Write-Host "Active Directory OU structure and objects have been created successfully."
