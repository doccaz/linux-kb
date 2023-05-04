#!/bin/bash
# 
# Fetches information all multipath devices and outputs them as variables
#
# Autor: Erico Mendonca <emendonca@suse.com>
# Fev/2014
#

MPATHLINES=`multipath -l | grep -o '^mpath.*' | awk '{ print $1","$2}'`
PVSLINES=`pvs | sed -n '2,$p'`

declare -a MPATHS LUNS PVS

let i=0
for f in ${MPATHLINES}; do
	MPATHS[i]=`echo $f | cut -d\, -f1`
	LUNS[i]=`echo $f | cut -d\, -f2 | tr -d [:punct:]`
	LUNS[i]=${LUNS[i]:${#LUNS[i]}-4}
	let i=i+1
done


for (( i=0 ; i<${#MPATHS[@]}; i++ )) {
	PVS[i]=`echo $PVSLINES | grep ${MPATHS[i]} | cut -d\/ -f4- | awk '{print $1";"$2";"$5}'`
}


# resultado final

for (( i=0 ; i<${#MPATHS[@]}; i++ )) {
	echo "MPATH_$i=${PVS[i]};${LUNS[i]}"
}
