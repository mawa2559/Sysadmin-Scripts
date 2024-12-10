$count = 0
Import-Csv -Path "C:\Users\mwalls\Downloads\Failed_messages.csv" | ForEach-Object {
    $ID= "rfc822msgid:" + $_.message_id
    gam user ap@clearchoice.com forward message to AP.clearchoice@teamtag.com query "$ID" doit
    $count+=1
    }
