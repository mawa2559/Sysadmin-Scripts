//This function emails the form submitter a confirmation that they submitted the forms successfully using the built in MailApp.
function emailSubmitter(e) { 
  Utilities.sleep(250); //wait to retrieve the email
  var formResponse = e.response;
  var submitterEmail = formResponse.getRespondentEmail(); //Get the form submitter's email
  MailApp.sendEmail(submitterEmail, 'Request Received!', 'Success! Click the link to see more information.  https://docs.google.com/document/d/<Google Doc ID>/edit?usp=sharing.', { 
    name: 'Form Response: Do Not Reply',
    noReply: true,
    }); //MailApp sends email with the name specified above and with the noReply parameter. A link to a google doc is included in the reply.
  console.log("Emailed " + submitterEmail)
}
