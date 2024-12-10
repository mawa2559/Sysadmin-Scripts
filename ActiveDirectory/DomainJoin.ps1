$domain = "ccd.local"
$password = "" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\mwalls-a" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential