#A simple one-liner to get the computer account owner for an AD Computer object
 
(Get-ADComputer "PC_Name" -Properties NTSecurityDescriptor).NTSecurityDescriptor.owner #Replace the value in quotes with the computer hostname


<# Example output:

DOMAIN\admin1

#>
