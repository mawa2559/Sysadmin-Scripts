import-csv -Path "C:\Users\mwalls\Downloads\365appuserexport.csv" | ForEach-Object {
if ($_.groupName -eq 'PowerBi') {
    $user = Get-ADUser -Identity $_.userName -Properties * | Select-Object title,department,office,samaccountname
    [PsCustomObject]@{
        Title = $user.title
        Department = $user.department
        Office = $user.office
        User = $user.samaccountname
        }
}} | export-csv -path C:\Users\mwalls\Downloads\Officeusers.csv -NoTypeInformation