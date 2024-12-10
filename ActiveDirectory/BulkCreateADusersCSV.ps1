#"CenterCode","CenterName",'AccountName'
$Users = Import-Csv -Path "C:\Users\mwalls\Downloads\Center Mobile Devices - Smile Design - Sheet3.csv"
foreach ($User in $Users)
{
$Displayname = $User.'CenterCode'+' ZTandroid'
$UserFirstname = $User.'CenterCode'
$UserLastname = 'ZTandroid'
$OU = "OU=Users,OU=Centers,OU=ClearChoice,DC=ccd,DC=local"
$SAM = $User.'CenterCode' + '.ZTandroid'
$UPN = $SAM+'@ccd.local'
$Description = 'Android ZT Photo Account - '+ $User.'DeviceName'
$Password = 'ClearChoice24.@!'
$office = $User.'CenterName'
$mail = $User.'AccountName'
$dept = 'CCSA'
New-ADUser -name "$Displayname" -DisplayName "$Displayname" -SamAccountName $SAM -UserPrincipalName $UPN -GivenName "$UserFirstname" -Surname "$UserLastname" -Description "$Description" -Office "$office" -EmailAddress "$mail" -Department "$dept" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -Path "$OU" -ChangePasswordAtLogon $false –PasswordNeverExpires $true
}