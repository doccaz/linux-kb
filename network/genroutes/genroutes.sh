#!/bin/bash
#
# Script for generating network configuration files automatically (multiple interfaces)
# 
# Autor: Erico Mendonca <emendonca@suse.com>
# Data: 11 Nov 2014
# Versao: 2.1
#

# Funcao para converter mascara em bits
mask2cidr() {
    nbits=0
    IFS=.
    for dec in $1 ; do
        case $dec in
            255) let nbits+=8;;
            254) let nbits+=7;;
            252) let nbits+=6;;
            248) let nbits+=5;;
            240) let nbits+=4;;
            224) let nbits+=3;;
            192) let nbits+=2;;
            128) let nbits+=1;;
            0);;
            *) echo "Error: $dec is not recognised"; exit 1
        esac
    done
}

if [ "$1" == "" ] | [ "$2" == "" ] | [ "$3" == "" ] | [ "$4" == "" ]; then
	echo "Uso: $0 <interface> <endereco ip> <mascara de rede> <gateway>"
	exit 1
fi

INTERFACE="$1"
IPADDR="$2"
NETMASK="$3"
GATEWAY="$4"

mask2cidr ${NETMASK}

NETWORK=`echo "$IPADDR" | cut -d. -f1-3`
PREFIX=`echo "$NETWORK" | tr -d .`

echo "Criando arquivos de configuracao para interface $INTERFACE (IP: ${IPADDR}, mascara: ${NETMASK} (/${nbits}), gateway: ${GATEWAY})"
sleep 3
# verifica se existem aliases de interface
ALIASESCOUNT=`cat /etc/sysconfig/network/ifcfg-${INTERFACE} | egrep -c '^IPADDR_|^LABEL_'`
if [ ${ALIASESCOUNT} -gt 0 ]; then
	ALIASES=`cat /etc/sysconfig/network/ifcfg-${INTERFACE} | egrep '^IPADDR_|^LABEL_'`
fi

# substitui variaveis no template (ifup-route.template e ifcfg.template) para gerar os arquivos definitivos
sed -e "s@__PREFIX__@${PREFIX}@g;s@__NETWORK__@${NETWORK}.0/${nbits}@g;s@__GATEWAY__@${GATEWAY}@g" /etc/sysconfig/network/ifup-route.template > /etc/sysconfig/network/scripts/ifup-route.${INTERFACE}
sed -e "s@__IPADDR__@${IPADDR}@g;s@__BITS__@${nbits}@g;s@__INTERFACE__@${INTERFACE}@g" /etc/sysconfig/network/ifcfg.template > /etc/sysconfig/network/ifcfg-${INTERFACE}

chmod +x /etc/sysconfig/network/scripts/ifup-route.${INTERFACE}

echo "${ALIASES}" >> /etc/sysconfig/network/ifcfg-${INTERFACE}

# remove tables with the same name as the route table file
echo "Erasing old routes..."
sed -i "/rede${PREFIX}/d" /etc/iproute2/rt_tables

# adds a new routing table
echo "Adding routing tables..."
echo "${PREFIX} rede${PREFIX}" >> /etc/iproute2/rt_tables

# clears the caches
echo "Erasing route cache..."
ip route flush cache
sleep 2
echo "Done. Restart the network services ASAP."

