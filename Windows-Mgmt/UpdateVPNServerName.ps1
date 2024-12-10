#This script updates an existing Windows VPN setup to point to a new server name.
#If this were to be deployed to client devices from an mdm, script assumes the VPN installed on client devices is named the same across the environment

$PathState = (Test-Path -Path "C:\ProgramData\Microsoft\Network\Connections\Pbk\rasphone.pbk" -PathType Leaf) #Verify a Windows VPN is in use


if ($PathState)
{
    $vpnName = "Company VPN"
    $vpn = Get-VpnConnection -alluserconnection -Name $vpnName #gets the config for the existing VPN connection named "Company VPN". An error is outputted if it doesn't exist
    Set-VpnConnection -AllUserConnection -Name "Company VPN" -ServerAddress "New.FQDN.com" -EncryptionLevel Optional -force #sets a specific server address as the VPN endpoint. Encyption setting is environment dependent and an example used here
    ((Get-Content -path "C:\ProgramData\Microsoft\Network\Connections\Pbk\rasphone.pbk") -replace 'DataEncryption=8', 'DataEncryption=256') | Set-Content -path "C:\ProgramData\Microsoft\Network\Connections\Pbk\rasphone.pbk" #Update the pbk file with a specific attribute related to encryption parameters
    $result = "The VPN name was updated and encryption level set to required"
}

elseif (!$PathState)
{
    $result = "This PC isn't set up to use the VPN - no changes made"
}


$result #output the success message if successful and no change message if VPN not set up.
