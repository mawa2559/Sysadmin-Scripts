#Powershell script that invokes GAM
#References a CSV containing a list of Google groups, iterates over each group and prints the associated members, exports to a csv file
 
 import-csv -Path "C:\Path\To\GroupList.csv" | ForEach-Object {
    $groupname = $_."Google Group IDs"
    gam print group-members group $groupname fields group,email | Out-File -FilePath "C:\Path\To\Export\groupmembers.csv" -Append
    }
