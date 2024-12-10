$noGPOpath = "OU=Computers - NO GPO FOR APP INSTALLATION,DC=ccd,DC=local"

$PCname = Read-Host "Enter the Computer name (ROS38)"

$currentOU = Get-ADComputer -Identity $PCname | Select-Object -ExpandProperty DistinguishedName
Write-Host "Current OU: $currentOU"

    try {
        Get-ADComputer -Identity $PCname | Move-ADObject -TargetPath $noGPOpath
        Write-Host Moving Computer to NO GPO
        $Choice = Read-Host -Prompt 'Move successful. Type "y" Run the script again.'
    }
    Catch {
        Write-Warning -Message $_.exception.message
        $Choice = Read-Host -Prompt 'Move unsuccessful. Type "y" Run the script again.'
    }

if ($Choice -eq 'y'){
    C:\Users\mwalls\Documents\WindowsPowerShell\Scripts\ActiveDirectory\MovetoNoGPO.ps1
    } Else {
    Write-Host "Goodbye"}