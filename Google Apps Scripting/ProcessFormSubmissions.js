//This script takes Form data, and adds it to a Google Sheet on each submission
//Triggers are tied to the two functions below - the triggers are owned by a service account and can only be edited by that account
//Execution logs can be viewed in the app script console - each function includes output logged to the console when successful, or if an error is encountered
//for more info on Google Apps Scripts, built in functions, apps, and triggers, refer to https://developers.google.com/apps-script

//Primary function is triggered each time a requester submits the form
function formSubmission(e) {
  try{
    Utilities.sleep(200); //sleep to allow form data time to process, otherwise there can be retrieval issues
    var formResponse = e.response; //get all form data from the submission
    const itemResponses = formResponse.getItemResponses(); //store each form item in an array
    var submitterEmail = formResponse.getRespondentEmail();
    var object_id = itemResponses[0].getResponse(); //get the response to the first form item in the array
    var ss = SpreadsheetApp.openById("<spreadsheet ID>"); //saving destination spreadsheet as variable by referencing it's ID
    var sheet = itemResponses[1].getResponse(); //saving the sheet selected by the requester on the form as a variable, 2nd form item
    var object_list = ss.getSheetByName(sheet); //get the sheet matching the selection by requester and save as variable
    var lastRowObjectID = object_list.getLastRow(); //get the last row with data from the desired sheet
      //function writeToSheet() below writes the object id and date to the next empty row in the corresponding sheet
      function writeToSheet1() {
        var currentDate = new Date(); //get current date
        var year = currentDate.getFullYear();
        var month = (currentDate.getMonth() + 1).toString().padStart(2, '0');
        var day = currentDate.getDate().toString().padStart(2, '0');
        var formattedDate = year + '-' + month + '-' + day; //save the desired date format to a variable
        object_list.getRange(lastRowObjectID + 1, 1) //get the empty row under the last row with data in column 1 on the sheet
                .setValue(object_id);
        object_list.getRange(lastRowObjectID + 1, 2) //get the empty row under the last row with data in column 2 on the sheet
                .setValue(formattedDate);
        console.log(submitterEmail + " wrote to " + sheet + "'s sheet: ID=" + object_id); //log the submitter, what sheet their data was written to, and the ID written to the console
    }
    writeToSheet1(); //call the function
  }
  catch(err){
    console.log(err);
  }
}

//This function emails the form submitter a confrimation that they submitted the forms successfully using the built in MailApp.
function emailSubmitter(e) { 
  Utilities.sleep(250);
  var formResponse = e.response;
  var submitterEmail = formResponse.getRespondentEmail(); //Get the form submitter's email
  MailApp.sendEmail(submitterEmail, 'Request Received! Take further action using the attached Guide', 'Success! Click on the link below for further instruction.  https://docs.google.com/document/d/<Google Doc ID>/edit?usp=sharing.', { 
    name: 'Form Response: Do Not Reply',
    noReply: true,
    }); //MailApp sends email with the name specified above and with the noReply parameter. A link to a document is included in the reply.
  console.log("Emailed " + submitterEmail)
}
//This function clears the contents of all sheets with data written to it - a trigger runs it each night between Midnight-1am.
function clearContentsOnly() {
  try{
  var ss = SpreadsheetApp.openById("<spreadhsheet ID>");
  var allsheets = ss.getSheets(); //obtains a list of all sheets within the destination spreadsheet
    //for statement below iterates over each sheet in the list, selects rows 1-50 for column 1 and 2, and clears any data if present
    for(var s in allsheets){
      var sheet = allsheets[s];
      var sheetName = sheet.getName();
      var range = sheet.getRange(2,1,50,2);
      var cell = range.getCell(1,1);
      if (cell.isBlank() == false) {
        range.clearContent();
        console.log("Data cleared from " + sheetName);
      }
    }
  }
  catch(err){
    console.log(err);    
  }
}
