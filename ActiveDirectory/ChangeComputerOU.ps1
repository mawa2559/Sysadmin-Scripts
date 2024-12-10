#this interactive script gets the current OU for a given PC name, and then moves it to the specified OU
#it gives the option to run the script again in case of success or failure to move mutiple PCs
 
$DestinationOU = "OU=Computers,DC=domain,DC=local"

$PCname = Read-Host "Enter the Computer name"

$currentOU = Get-ADComputer -Identity $PCname | Select-Object -ExpandProperty DistinguishedName
Write-Host "Current OU: $currentOU"

    try {
        Get-ADComputer -Identity $PCname | Move-ADObject -TargetPath $DestinationOU
        Write-Host Moving Computer to new OU
        $Choice = Read-Host -Prompt 'Move successful. Type "y" to run the script again.'
    }
    Catch {
        Write-Warning -Message $_.exception.message
        $Choice = Read-Host -Prompt 'Move unsuccessful. Type "y" Run the script again.'
    }

if ($Choice -eq 'y'){
    C:\Path\To\ChangeComputerOU.ps1 #specify the path to this script
    } Else {
    Write-Host "Goodbye"}
