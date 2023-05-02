#!/bin/bash



cleanup() {
	echo "Removendo aliases from interface $DEVICE"
	ip addr del ${ROUTER}/${BITS} dev $DEVICE	
	echo "Finalized." 
}

IPADDR=$1
DEVICE="eth0" 

if [ -z $IPADDR ]; then
	echo "Usage: $0 <IP/CIDR>"
	exit 1
fi
trap cleanup SIGTERM SIGINT

BITS=$(echo $IPADDR | rev | cut -d\/ -f1 | rev)
ROUTER="$(echo $IPADDR | rev | cut -d\. -f2- | rev).254" 

echo "Simulating traffic every 2 seconds for $ROUTER/${BITS} on $DEVICE" 
echo "---> Press CTRL+C to stop" 

ip addr add ${ROUTER}/${BITS} dev $DEVICE

trafgen -o $DEVICE -t 2000 "{ ipv4(sa=$ROUTER, da[0]=dinc()), tcp() }"

