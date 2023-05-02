#!/bin/bash
# finds the interface with an active link and creates the corresponding ifcfg/routes files

DEVICES=`find /sys/class/net -type l -printf "%f "`

for f in ${DEVICES}; do

	if [ `ethtool ${f} | grep -c "Link detected: yes"`  -gt 0 ] && [ ${f} != "lo" ]; then
		echo "Found link at ${f}, configuring..."
		CFGFILE="/etc/sysconfig/network/ifcfg-${f}"
		ROUTEFILE="/etc/sysconfig/network/routes"
		IPADDR=`ip addr show ${f} | grep inet\  | awk '{print $2}'`
		ROUTE=`route -n | grep ^0.0.0.0.*${f}$ | awk '{print $2}'`		
		echo "BOOTPROTO='static'" > ${CFGFILE}
		echo "IPADDR='${IPADDR}'" >> ${CFGFILE}
		echo "STARTMODE='auto'" >> ${CFGFILE}
		echo "USERCONTROL='no'" >> ${CFGFILE}

		echo "default ${ROUTE} - -" >> ${ROUTEFILE}
	fi

done
