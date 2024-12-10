#point URL to a csv mapping of all locations and their codes, or a csv with just the locations/codes you'd like to update
#you can export a full csv from the OfficeValueMaps custom object in Freshservice - make sure it is up to date
    $csvFilePath = "C:\Users\mwalls\Downloads\UserData.csv"
    $csvData = Import-Csv -Path $csvFilePath | ForEach-Object {
        try {
            $SAN=$_.samaccountname
            $EMPid=$_."Employee D"
            $props = @{"employeeID"=$EMPid}
            Set-ADUser -Identity $SAN -replace $props -ErrorAction Continue
            Write-Host "Extension Attribute Updated for user: $SAN"
        }
        catch {Write-Host "Error occurred for user $SAN $($_.Exception.Message)"
              $SAN | Export-csv -Append -Path "C:\Users\mwalls\Downloads\badUsers.csv"
            }

    }