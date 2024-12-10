#This script was used to bulk create service accounts for an android Zero Touch deployment with a specific naming scheme
#The script is using a CSV file containing a list of account information with the headers "CenterCode","CenterName",'AccountName'
$Users = Import-Csv -Path "C:\Path\To\file.csv" #import CSV and save to a variable
foreach ($User in $Users)
{
$Displayname = $User.'CenterCode'+' ZTandroid'
$UserFirstname = $User.'CenterCode'
$UserLastname = 'ZTandroid'
$OU = "OU=Users,OU=Centers,OU=example,DC=ccd,DC=local" #reference the desired OU where the created accounts will be dumped
$SAM = $User.'CenterCode' + '.ZTandroid' #creating the SamAccountName
$UPN = $SAM+'@domain.local' #set the UPN suffix to the desired domain
$Description = 'Android ZT Photo Account - '+ $User.'DeviceName'
$Password = 'REPLACE_ME_WITH_A_PASSWORD' #This script sets the same default pasdsword for all of the accounts listed in the CSV.
$office = $User.'CenterName' #Reference the "CenterName" value for each account from the CSV for use as the AD Office value
$mail = $User.'AccountName' #Reference the desired email address from the csv
$dept = 'EXAMPLE' #reference the desired department value
New-ADUser -name "$Displayname" -DisplayName "$Displayname" -SamAccountName $SAM -UserPrincipalName $UPN -GivenName "$UserFirstname" -Surname "$UserLastname" -Description "$Description" -Office "$office" -EmailAddress "$mail" -Department "$dept" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -Path "$OU" -ChangePasswordAtLogon $false –PasswordNeverExpires $true
}
