#This script was used to bulk create service accounts for a project deployment with a specific naming scheme
#The script is using a CSV file containing a list of account information with the headers "LocationCode","LocationName",'AccountName', 'DeviceName'

$Users = Import-Csv -Path "C:\Path\To\file.csv" #import CSV and save to a variable
foreach ($User in $Users)
{
$Displayname = $User.'LocationCode'+' Deployment'
$UserFirstname = $User.'LocationCode'
$UserLastname = 'Deployment'
$OU = "OU=Users,OU=Locations,OU=Company,DC=domain,DC=local" #reference the desired OU where the created accounts will be dumped
$SAM = $User.'LocationCode' + '.Deployment' #creating the SamAccountName
$UPN = $SAM+'@domain.local' #set the UPN suffix to the desired domain
$Description = 'Service Account - '+ $User.'DeviceName' #set AD description
$Password = 'REPLACE_ME_WITH_A_PASSWORD' #This script sets the same default password for all of the accounts listed in the CSV
$office = $User.'LocationName' #Reference the "CenterName" value for each account from the CSV for use as the AD Office value
$mail = $User.'AccountName' #Reference the desired email address from the csv
New-ADUser -name "$Displayname" -DisplayName "$Displayname" -SamAccountName $SAM -UserPrincipalName $UPN -GivenName "$UserFirstname" -Surname "$UserLastname" -Description "$Description" -Office "$office" -EmailAddress "$mail" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -Path "$OU" -ChangePasswordAtLogon $false –PasswordNeverExpires $true
} #Create each account with assigned variables and set the pw to never expire, enable the account, and don't require a password change at logon
