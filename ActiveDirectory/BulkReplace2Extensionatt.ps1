s#This script use a CSV with a list of AD office values mapped to two other values
#The script iterates through the CSV, generating a list of users associated with each Office value
#Then, the script updates the two extension attributes associated with the users who have that Office value

$csvFilePath = "C:\Path\To\file.csv"

$csvData = Import-Csv -Path $csvFilePath | ForEach-Object { #import CSV and iterate over each row
        try {
            $OfficeLocation=$_.office #set the AD Office value to filter AD users by
            $props = @{"extensionAttribute1"=$_.Region #get/store the value of "Region" from the csv
                       "extensionAttribute2"=$_.Code} #get/store the value of "Code" from the csv
            $userList = Get-ADUser -Filter "Office -eq '$OfficeLocation'" | Select sAMAccountName #generate a list of users who all have the current AD Office value
            foreach ($user in $userList){ #iterate over the user list found above
                Set-ADUser -Identity $user.sAmAccountname -replace $props #update each user
                Write-Host "Extension Attributes Updated for user: $user.samAccountname" #output a success message for each user updated
                }
        }
        catch {Write-Host "Error occurred for user $user $($_.Exception.Message)" #output any error
            }

    }

<#example of plaintext csv data to use with this code:

Office,Region,Code
Brooklyn,Northeast,BROO
Miami,Southeast,MIAM
#>
