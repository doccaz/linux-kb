#!/bin/bash
# 
# Fetches information all LVM devices and LUN paths associated with them
#
# Autor: Erico Mendonca <emendonca@suse.com>
# Fev/2014
#
declare -a PATHS STATUS DEVICES WWPN

DEVICES=`ls -1d /sys/bus/scsi/devices/[0-9]*`

let i=0
for f in $DEVICES; do
	if [ ! -e $f/block/sd* ]; then
		continue;
	fi
	LUNS[i]=`echo $f | rev | cut -d\/ -f1 | rev`
	DEVICES[i]=`ls -1 $f/block`
	STATUS[i]=`cat $f/state`
	WWPN[i]=`cat $f/wwpn`
	WWID[i]=`/lib/udev/scsi_id --page=0x83 --whitelisted --device=/dev/${DEVICES[i]}`
	let i=i+1
done


PATHLIST=""

for (( i = 0; i < ${#LUNS[@]}; i++ )) 
do
	if [ -z $PATHLIST ]; then
		PATHLIST="${LUNS[$i]};${DEVICES[$i]};${WWPN[$i]};${WWID[$i]};${STATUS[$i]}"
	else
		PATHLIST="${PATHLIST};${LUNS[$i]};${DEVICES[$i]};${WWPN[$i]};${WWID[$i]};${STATUS[$i]}"
	fi
done



PVSLIST=`pvs | sed -n '2,$p' | cut -d\/ -f4- | awk '{print $1";"$2";"$5}' | tr '\n' ',' | rev | cut -d\, -f2- | rev `

LVSLIST=`lvs | sed -n '2,$p' | awk '{print $1";"$2";"$4}' | tr '\n' ',' | rev | cut -d\, -f2- | rev`

VGSLIST=`vgs | sed -n '2,$p'| awk '{print $1";"$2";"$3";"$4}' | tr '\n' ',' | rev | cut -d\, -f2- | rev`

echo "PATHS=$PATHLIST"
echo "PVS=$PVSLIST" 
echo "LVS=$LVSLIST" 
echo "VGS=$VGSLIST" 
