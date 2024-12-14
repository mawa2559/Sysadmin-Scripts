#A simple script for joining a windows machine to the domain. Reboot should be performed afterwards.
 
$domain = "domain.local" #Enter your AD domain
$password = "ENTER_PASSWORD_HERE" | ConvertTo-SecureString -asPlainText -Force #Enter a domain admin's password here (Account must have domnain join permission)
$username = "$domain\domain-Admin" #Enter a Domain Admin's username here
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential
