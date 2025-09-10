//This function clears the contents of all sheets in a spreadsheet with data written to it
function clearContents() {
  try{
  var ss = SpreadsheetApp.openById("<spreadhsheet ID>");
  var allsheets = ss.getSheets(); //obtains a list of all sheets within the destination spreadsheet
    //iterate over each sheet in the list, selects rows 1-50 for column 1 and 2 on each sheet, and clears any data if present
    for(var s in allsheets){
      var sheet = allsheets[s];
      var sheetName = sheet.getName();
      var range = sheet.getRange(2,1,50,2); //specify the cell range to be cleared
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
