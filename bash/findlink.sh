#!/bin/bash

# some chipsets require that you actually forcefully up the link before it 
# shows the correct status!

while [ ! -e /sys/class/net/eth0 ]; do
        sleep 1
done

for f in /sys/class/net/eth*; do 
        IFNAME=$(basename $f); 
        ip link set $IFNAME up; 
done

sleep 5

for f in /sys/class/net/eth*; do 
        IFNAME=$(basename $f); 
        if [ "$(cat $f/carrier)" != "0" ]; then 
                MACADDR=$(cat $f/address)        
                echo "$IFNAME $MACADDR";
        fi; 
done

