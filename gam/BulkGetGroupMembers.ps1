import-csv -Path "C:\Users\mwalls\Downloads\ccdGroupList.csv" | ForEach-Object {
    $groupname = $_."Google Group IDs"
    gam print group-members group $groupname fields group,email | Out-File -FilePath "C:\Users\mwalls\Downloads\groupmembers.csv" -Append
    }