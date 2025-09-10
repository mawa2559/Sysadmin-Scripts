//This script takes Form data, and adds it to a Google Sheet on each submission
//Triggers must be configured
//for more info on Google Apps Scripts, built in functions, apps, and triggers, refer to https://developers.google.com/apps-script

//Primary function is triggered each time a requester submits the form
function formSubmission(e) {
  try{
    Utilities.sleep(200); //sleep to allow form data time to process to avoid retrieval issues
    var formResponse = e.response; //get all form data from the submission
    const itemResponses = formResponse.getItemResponses(); //store each form item in an array
    var submitterEmail = formResponse.getRespondentEmail();
    var object_id = itemResponses[0].getResponse(); //get the response to the first form item in the array
    var ss = SpreadsheetApp.openById("<spreadsheet ID>"); //save destination spreadsheet as variable by referencing it's ID
    var sheet = itemResponses[1].getResponse(); //save the 2nd form item to a variable
    var object_list = ss.getSheetByName(sheet); //get a sheet with a name matching the selection by requester and save as variable
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
