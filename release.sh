#!/bin/bash

if [ $# -eq 2 ]; then
	# FORMAT=""
    FORMAT="pdf"
    INPUT_FILE=$1
	NEW_VERSION=$2
elif [ $# -eq 3 ]; then
    # FORMAT=$1
	FORMAT="pdf"
    INPUT_FILE=$2
	NEW_VERSION=$3
else
    PROG=`basename $0`
    echo "Usage: $PROG [<format>] <graffle file> <outputfile>"
    exit 1
fi

# Allow the user to specify the name of the OmniGraffle application in
# the GRAFFLE_APP environment variable.  If it is not set, then we
# must find a suitable default.  We determine this default by assuming
# that OmniGraffle is installed in /Applications, and use the
# Professional version if it exists.
if [ "x${GRAFFLE_APP}" == "x" ]; then
    APP=`ls -t /Applications | grep '^OmniGraffle Professional' | head -n 1`

    if [ "x${APP}" == "x" ]; then
        # Couldn't find a copy of OmniGraffle Pro.  Look for a copy of
        # Standard.

        APP=`ls -t /Applications | grep '^OmniGraffle' | head -n 1`

        if [ "x${APP}" == "x" ]; then
            # Couldn't find a copy of Standard, either.  That's an
            # error!

            echo <<EOF >&2
Couldn't find a copy of OmniGraffle (Pro or Standard) in
/Applications.  Please set the GRAFFLE_APP environment variable to the
name of OmniGraffle's application file.
EOF
            exit 1
        fi
    fi

    # If we fall through to here, $APP contains the directory name of
    # the OmniGraffle application.  We need to strip off the .app at
    # the end to get the application name.

    GRAFFLE_APP=`echo ${APP} | sed '/\.app$/s///'`
fi

if echo "$INPUT_FILE" | grep '^/'; then
    # The input filename starts with a slash, and is therefore an
    # absolute pathname.  There is no need to prepend $PWD.
    INPUT_PATH=$INPUT_FILE
	OUTPUT_PATH_STEM=${INPUT_PATH%/*}
	OUTPUT_PATH="$OUTPUT_PATH_STEM/Releases/"
else
    # The input filename does not start with a slash, and is therefore
    # a relative pathname.  We need to prepend $PWD to get an absolute
    # path.
    INPUT_PATH=$PWD/$INPUT_FILE
	OUTPUT_PATH_STEM=/${INPUT_PATH%/*}
	OUTPUT_PATH="$OUTPUT_PATH_STEM/Releases/"
fi

DIR=`dirname $0`

#echo Format = $FORMAT
#echo Input = $INPUT_PATH
#echo Output = $OUTPUT_PATH

# Extract the filename from the full path... 
OUTPUT_FILENAME=$(basename "$INPUT_FILE")
# Strip off the extension...
OUTPUT_FILESTEM="${OUTPUT_FILENAME%.*}"

# Get the 
osascript $DIR/close-graffle.scpt "${GRAFFLE_APP}" "$INPUT_PATH"
node $DIR/update-graffle-version "$INPUT_PATH" "$NEW_VERSION"
echo "INPUT_PATH = $INPUT_PATH" 
echo "OUTPUT_PATH = $OUTPUT_PATH"
echo "OUTPUT_FILESTEM = $OUTPUT_FILESTEM"
echo "OUTPUT_PATH_STEM = $OUTPUT_PATH_STEM"
osascript $DIR/export-graffle.scpt "${GRAFFLE_APP}" "$FORMAT" "$INPUT_PATH" "$OUTPUT_PATH""$OUTPUT_FILESTEM"-v"$NEW_VERSION"."$FORMAT"

