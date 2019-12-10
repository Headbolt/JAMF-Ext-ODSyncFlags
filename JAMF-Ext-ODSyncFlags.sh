#!/bin/bash
#
###############################################################################################################################################
#
#   This Script is designed for use in JAMF as an Extension Attribute
#
#   - This script will ...
#       Look at the users OneDrive For Business and check for the latest Error Log by TimeStamp.
#		Then check the last line in the Log and find the Error Flags and report them.
#
###############################################################################################################################################
#
# HISTORY
#
#   Version: 1.0 - 10/12/2019
#
#   - 10/12/2019 - V1.0 - Created by Headbolt
#
###############################################################################################################################################
#
#   DEFINE VARIABLES & READ IN PARAMETERS
#
###############################################################################################################################################
#
USER=$(stat -f%Su /dev/console) # Get Current User Name.
LOGPATH="/Users/$USER/Library/Logs/OneDrive/Business1"
#
###############################################################################################################################################
# 
# Begin Processing
#
###############################################################################################################################################
#
if [ "$USER" != "root" ] # Check for Username being "root" ie Nobody is Logged in.
	then
		HIGHWATER=0
		for FILENAME in $(ls $LOGPATH/OneDrive-ERR*)
			do
				STAMP=$(date -r "$FILENAME" +%s) 
				if [[ "$STAMP" > "$HIGHWATER" ]]
					then
						HIGHWATER=$STAMP
						CURRENTLOG=$FILENAME
				fi
			done
		#
		LASTLINE=$(tail -1 $CURRENTLOG)
		IFS=","
		FLAGS=$(echo $LASTLINE | awk '{print $9}' | cut -c 7-)
		unset IFS
	else
		FLAGS="No User Logged In"
fi
#
# Output Results
/bin/echo "<result>$FLAGS</result>"
