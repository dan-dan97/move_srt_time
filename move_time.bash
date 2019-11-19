#!/bin/bash

OUTPUT_DIR="subs_$1"

function process_file {
	SRC_FILE=$(cat $1)

	RESULT=""

	IFS=$'\n'
	for LINE in $SRC_FILE
	do
		if [[ $LINE =~ ^[0-9]{2}:[0-9]{2}:[0-9]{2}[\,\.][0-9]{3}[[:space:]]--\>[[:space:]][0-9]{2}:[0-9]{2}:[0-9]{2}[\,\.][0-9]{3}.$ ]]
		then
			FIRST_TIME=${LINE% --> *}
			SECOND_TIME=${LINE#* --> }
			FIRST_TIME=$(date -d "$FIRST_TIME today + $2 seconds" +'%H:%M:%S,%3N')
			SECOND_TIME=$(date -d "$SECOND_TIME today + $2 seconds" +'%H:%M:%S,%3N')
			LINE="$FIRST_TIME --> $SECOND_TIME"
		fi
		RESULT="$RESULT""$LINE"$'\n'
	done

	echo "${RESULT}"	
}

if [ -d $OUTPUT_DIR ] ; then rm -R $OUTPUT_DIR; fi
mkdir $OUTPUT_DIR

IFS=$'\n'

for FILE in "${@:2}"
do
  process_file $FILE $1 > $OUTPUT_DIR/${FILE##*/}
done
