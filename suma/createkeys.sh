#!/bin/bash
# Erico Mendonca <erico.mendonca@suse.com>
# apr/2014

# file containing all profiles and descriptions, separated by commas
PROFILES="group-profiles.txt"

# creation template for Activation Keys
TEMPLATE_AK="akeys_json.template"

# creation template for Configuration Channels
TEMPLATE_CC="cc_json.template"

# JSON output file for configuration channels
OUTFILE_CC="cc_all.json"

# JSON output file for activation keys
OUTFILE_AK="akeys_all.json"


# verifies the pre-requisites
if [ ! -f $PROFILES ] || [ ! -f $TEMPLATE_CC ] || [ ! -f $TEMPLATE_AK ]; then
	echo "One of more necessary files were not found."
	exit 1
fi

declare -a PROF
declare -a DESC

i=0

# start of file markers
echo "[" > $OUTFILE_AK
echo "[" > $OUTFILE_CC

while read line
do
	if [ "$line" == "" ]; then continue; fi
	PROF[$i]=`echo $line | cut -d, -f1`
	DESC[$i]=`echo $line | cut -d, -f2`
	if [ "$PROF[$i]" == "" ]; then continue; fi
	let i=i+1
done < $PROFILES

let LAST=${#PROF[@]}-1
for (( i=0; i < ${#PROF[@]}; i++ )); do
	if [ "$PROF[$i]" == "" ]; then continue; fi
	echo "Creating activation keys + configuration channels: ${PROF[$i]} [${DESC[$i]}]"
	cat $TEMPLATE_AK | sed -e "s@__ID__@$i@g; s@__DESCRIPTION__@${DESC[$i]}@g; s@__PROFILE__@${PROF[$i]}@g" >> $OUTFILE_AK
	if [ $i -lt ${LAST} ]; then echo "}," >> $OUTFILE_AK; else echo "}" >> $OUTFILE_AK; fi

	cat $TEMPLATE_CC | sed -e "s@__ID__@$i@g; s@__DESCRIPTION__@${DESC[$i]}@g; s@__PROFILE__@${PROF[$i]}@g" >> $OUTFILE_CC
	if [ $i -lt ${LAST} ]; then echo "}," >> $OUTFILE_CC; else echo "}" >> $OUTFILE_CC; fi
done

# end of file markers
echo "]" >> $OUTFILE_CC
echo "]" >> $OUTFILE_AK

echo "Use 'spacecmd activationkey_import $OUTFILE_AK' e 'spacecmd configchannel_import $OUTFILE_CC' to import the generated configs."
exit 0

