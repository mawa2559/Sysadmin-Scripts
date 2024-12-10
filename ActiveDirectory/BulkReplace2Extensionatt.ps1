#point URL to a csv mapping of office location, region and code, or a csv with just the locations/regions/codes you'd like to update
#you can export a full csv from the OfficeValueMaps custom object in Freshservice - make sure it is up to date

$csvFilePath = "C:\Users\mwalls\Downloads\Office_to_code.csv"

$csvData = Import-Csv -Path $csvFilePath | ForEach-Object {
        try {
            $OfficeLocation=$_.office
            $props = @{"extensionAttribute1"=$_.Region
                       "extensionAttribute2"=$_.Code}
            $userList = Get-ADUser -Filter "Office -eq '$OfficeLocation'" | Select sAMAccountName
            foreach ($user in $userList){
                Set-ADUser -Identity $user.sAmAccountname -replace $props
                Write-Host "Extension Attributes Updated for user: $user.samAccountname"
                }
        }
        catch {Write-Host "Error occurred for user $user $($_.Exception.Message)"
            }

    }

<#example of plaintext csv to use with this code:

Office,Region,Code
Brooklyn,Northeast,NYBRO

#>