#A two part script to create a list of groups
gam config csv_output_row_filter "whoCanJoin:text=ALL_IN_DOMAIN_CAN_JOIN" print groups emailmatchpattern not '<Text>.+' settings fields whoCanJoin todrive
 Import-Csv -Path "C:\Users\mwalls\Downloads\PECs (2).csv"| ForEach-Object {
    $email=$_."email"
    $group = "security.weavikextension.forcedallowed@clearchoice.com"
    gam update group $group add member $email
}
