var fs = require('fs');
var plist = require('plist-native');
var fileName = process.argv[2];
var newVersionNumber = process.argv[3];
// Load the file and parse it into an object
console.log("Updating version number in graffle file...");
var obj = plist.parse(fs.readFileSync(fileName));
// Update the version number in the object
obj.UserInfo.kMDItemVersion = newVersionNumber;
// Turn the object back into a PList again
var output = plist.buildString(obj);
// Write the Plist back to the file
fs.writeFileSync(fileName, output);
console.log("Updated " + fileName + " to Version " + newVersionNumber);
