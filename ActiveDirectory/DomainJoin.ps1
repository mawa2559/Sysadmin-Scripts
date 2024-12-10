# A simple script for joining a windows machine to the domain. Reboot should be performed afterwards.
 
$domain = "domain.local" #Enter your comapny's domain
$password = "ENTER_PASSWORD_HERE" | ConvertTo-SecureString -asPlainText -Force #Enter the domain admin's password here
$username = "$domain\domain-Admin" #Enter the Domain Admin's username here
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential
