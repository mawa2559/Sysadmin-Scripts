#This script provides a given user account full control over the specified folder

$username = "admin1"
$folder = "C:\temp\MyFolder" 
$ACL = Get-ACL -Path $folder
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($username, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$ACL.SetAccessRule($AccessRule)
$ACL | Set-Acl -Path $folder
(Get-ACL -Path $folder).Access | Format-Table IdentityReference, FileSystemRights, AccessControlType, IsInherited, InheritanceFlags -AutoSize
Write-Host "`nPermission added!" -ForegroundColor Green
