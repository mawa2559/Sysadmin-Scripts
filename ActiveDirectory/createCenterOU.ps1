#This interactive script creates a default nested AD object structure as shown below:
<#
domain.local
  |
  Company
    |
    Centers
      |
      "Center Name"__________________
        |          |       |        |
        Computers  Groups  Servers  Users
                   |    |            |
                Group1 Group2       ituser
#>

#The script creates the "Center Name" ou and the computer, groups, servers, users OU, two groups, and 1 user account INSIDE of an existing OU=Centers,OU=Company,DC=domain,DC=local structure
#This script is very specific to business needs as far as the configuration of the OUs, groups, and user account. Many parts could be removed, changed etc. to suit.
 
 # Prompt for Center Name, store a spaceless version, prompt for desired UPN
$centerName = Read-Host "Enter the Center Name"
$CenternameNoSpace = $centerName -replace '\s', ''
$upn = Read-Host "Enter the IT User UPN (exampleituser@domain.local)" #UPN for the user account

# Set the distinguished name for the parent OU (this structure already exists)
$parentOU = "OU=Centers,OU=Company,DC=domain,DC=local"

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
Set-ADGroup -Identity "CN=$lgAllGroupName,OU=Groups,OU=$centerName,OU=Centers,OU=ClearChoice,DC=domain,DC=local" -Description "Local Group - All $centerName users" -DisplayName $lgAllGroupName -SamAccountName $lgAllGroupName
Set-ADGroup -Identity "CN=$wgLocalAdminGroupName,OU=Groups,OU=$centerName,OU=Centers,OU=ClearChoice,DC=domain,DC=local" -Description "Workstation Group - $centerName workstation Local Admin" -DisplayName $wgLocalAdminGroupName -SamAccountName $wgLocalAdminGroupName

# Add an existing group as a member of localAdmin group
Add-ADGroupMember -Identity $wgLocalAdminGroupName -Members domain_localAdmin

#add a different existing group to LG_All group
add-adGroupMember -Identity $lgAllGroupName -Members domain_LG_traveler


Write-Host "Active Directory OU structure and objects have been created successfully."
