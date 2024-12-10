#PowerShell script that invokes GAM
#This script takes a CSV containing a list of emails and sets their gmail Vacation Responder to automatically reply with a default message beginning on the referenced date
#The message is customize for each user to display their email in the auto reply, and further customization using variables is simple
 
$emails = import-csv "C:\Path\To\Emails.csv"

foreach ($user in $emails) {
    $email = $user.primaryEmail #references a column in the csv with the header "primaryEmail"
    gam user $email vacation on subject "Out of Office" message "This account ($email) is no longer active. Please email user@company.com for assistance." startdate 2024-12-10
    }
