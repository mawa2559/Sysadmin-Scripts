try {
    $location=$args[0]
    $region=$args[1]
    $user=$args[2]
    $csvFilePath = "C:\Temp\NewUserScript\office_to_code.csv"
    $csvData = Import-Csv -Path $csvFilePath | ForEach-Object {
        try {if ($_.Office -eq $location) {
                $props = @{
                    "extensionAttribute1"=$region
                    "extensionAttribute2"=$_.versatile_code}
                Set-ADUser -Identity $user -Add $props
                Write-Host "Extension Attribute Updated for user: $user"
                break
            }
        }
        catch {Write-Host "Error occurred for user $user $($_.Exception.Message)"
            }

    }

}
catch {
    Write-Host "Error occurred: $($_.Exception.Message)."
}