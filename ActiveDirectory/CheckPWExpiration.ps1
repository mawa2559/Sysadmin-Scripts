#This interactive script outputs the date when the password for the AD account specified will expire
#Handy for setting a reminder to reset before expiry

$ADAccount = Read-Host "Enter your username"
Get-ADUser -identity $ADAccount –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | Out-Host

<# Example output
Enter your username: myusername

Displayname      ExpiryDate          
-----------      ----------          
Test Account     1/19/2025 7:06:11 AM
#>
