#!/bin/bash
# Erico Mendonca <erico.mendonca@suse.com>
# apr/2014

# file containing all the profiles and descriptions, separated by commas
PROFILES="group-profiles.txt"

OUTFILE="systemgroups.txt"

declare -a PROF
declare -a DESC

i=1

rm -f $OUTFILE
while read line
do
	if [ "$line" == "" ]; then continue; fi
	PROF[$i]=`echo $line | cut -d, -f1`
	DESC[$i]=`echo $line | cut -d, -f2`
	echo "Creating system group: ${PROF[$i]} [${DESC[$i]}]"
	echo "group_create \"profile-${PROF[$i]}\" \"${DESC[$i]}\"" >> $OUTFILE
	let i=i+1
done < $PROFILES

echo "Criando groups: ${PROF[@]} ..."
read

spacecmd  < systemgroups.txt

