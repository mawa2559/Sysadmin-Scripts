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
#This script uses an example structure. Many parts could be removed, changed etc. to suit.
 
 # Prompt for Center Name, store a version of the name without spaces, prompt for desired UPN
$centerName = Read-Host "Enter the Center Name"
$CenternameNoSpace = $centerName -replace '\s', ''
$upn = Read-Host "Enter the IT User UPN (Centerituser@domain.local)" #UPN for the user account

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
$AllGroupName = "${CenternameNoSpace}_ALL"
$AdminsGroupName = "${CenternameNoSpace}_Admins"

$AllGroup = $groupsOU.Create("group", "CN=$AllGroupName")
$AdminsGroup = $groupsOU.Create("group", "CN=$AdminsGroupName")
$AllGroup.SetInfo()
$AdminsGroup.SetInfo()

# Set the group attributes
Set-ADGroup -Identity "CN=$AllGroupName,OU=Groups,OU=$centerName,OU=Centers,OU=ClearChoice,DC=domain,DC=local" -Description "Local Group - All $centerName users" -DisplayName $AllGroupName -SamAccountName $AllGroupName
Set-ADGroup -Identity "CN=$AdminsGroupName,OU=Groups,OU=$centerName,OU=Centers,OU=ClearChoice,DC=domain,DC=local" -Description "Workstation Group - $centerName workstation Local Admin" -DisplayName $AdminsGroupName -SamAccountName $AdminsGroupName

# Add an existing group as a member of localAdmin group
Add-ADGroupMember -Identity $AdminsGroupName -Members domain_localAdmin

Write-Host "Active Directory OU structure and objects have been created successfully."
