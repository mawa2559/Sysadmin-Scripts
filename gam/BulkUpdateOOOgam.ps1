$emails = import-csv "C:\Users\mwalls\Downloads\MioEmails.csv"

foreach ($user in $emails) {
$email = $user.primaryEmail
    gam user $email vacation on subject "Warning: You've sent an email to the wrong account!" message "This account ($email) is only for chat interoperability between Google Chat and Teams. Please search for this person in Workday to find their primary email address and use that address for all future communications." startdate 2024-11-11}