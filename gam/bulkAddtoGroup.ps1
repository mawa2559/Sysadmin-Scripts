Import-Csv -Path "C:\Users\mwalls\Downloads\PECs (2).csv"| ForEach-Object {
    $email=$_."Email address"
    $group = "security.weavikextension.forcedallowed@clearchoice.com"
    gam update group $group add member $email
}