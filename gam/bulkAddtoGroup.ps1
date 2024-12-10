#PowerShell script that invokes GAM
#Takes a CSV list of Google groups and adds a user to/removes a user from them all

 Import-Csv -Path "C:\Path\to\groups.csv"| ForEach-Object {
    $GroupEmail=$_."email" #refers to the header column titled "email" on csv
    $UsertoAdd = addme@domain.com #email of user to be added to all groups
    $UsertoRemove = removeme@domain.com #email of user to be removed from all groups
    gam update group $groupEmail add member $UsertoAdd
    gam update group $groupEmail delete user $UsertoRemove
}
