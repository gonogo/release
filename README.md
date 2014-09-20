release
=======

Command line utility for teams to manage versioned Omnigraffle files and build numbered releases and changelogs. 

This utility is designed to help UXers manage formal version control when creating documents using Omnigraffle. The package assumes you use a separate repository for each deck of wireframes (a single graffle file) you wish to keep under version control.

To release a document, run the release script specifying the graffle file and the version number.

The script does the following:

* automatically closes the file if it's open in Omnigraffle
* edits the file to update the version number in the file (which can be used anywhere in the file with the <%version%> tag)
* exports the file to the Releases directory as a PDF appending the version number to the filename. This is a release.
* commits everything with a tag reflecting the version number specified. [not currently implemented]

# Work to do

* After exporting the file, the script should reopen the file and change the version to [version#]-Work-In-Progress. This covers cases when the user exports or prints from the working version (which may contain changes) and the document needs to show this is NOT the release document.
* After pushing the new release to the main Git repo, the file server (which also contains a clone of the repo needs to be updated automatically to prevent confusion.
* Check that the user isn't trying to do a release with a version number that is less than or equal to the most recently tagged commit.
* If someone else has made a commit to the main repo more recently than the last time the user updated their repo, the whole release process is aborted. The user should be able to download the conflicting, newer version of the file (should be saved as [filename].[hash].graffle)so that they can do an eyeball diff on the two files and create a file that they can commit which reflects the changes in both documents.
* Some kind of system for alerting users if they have opened a graffle file under version control which another user on their team already has open too. This is a nice-to-have, but ideally teams should co-ordinate to prevent this happening.

# Installation

This needs an installation script.

* Make sure you have node installed - suggest using Homebrew to do this.
* This will only work for Omnigraffle 5 and 6
* git clone into /usr/local/
* cd /usr/local/bin
* ln -s ../release/update-graffle-version.js update-graffle-version.js
* ln -s ../release/close-graffle.scpt close-graffle.scpt
* ln -s ../release/export-graffle.scpt export-graffle.scpt
* This package only works with FLAT OmniGraffle files. To always do this by default, run this: defaults write com.omnigroup.OmniGraffle PrivateGraffleFlatFile 0
* In the Document Inspector in Omnigraffle, turn off 'Compress on disk'.
* For each new document you work with, set Version to 0 in the Document Inspector Under 'Document Data'.
