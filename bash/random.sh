#!/bin/bash

# primera opçào: arquivo contendo os relays, um por linha
RELAYFILE="/var/opt/BESClient/relays.txt"
if [ ! -f "$RELAYFILE" ]; then 
	echo "não achei arquivo de relays, usando lista interna"
	RELAYS=("pxl1aca00112" "pvmliemtop014" "pxl1aca00067" "pxl1aca00047")
else
	RELAYS=()
	while read -r line
	do
		RELAYS+=($line)
	done < "$RELAYFILE"
fi

# sorteia um relay
SEL=$(( ( RANDOM % ${#RELAYS[@]} ) ))
SERVIDOR="${RELAYS[${SEL}]}.dispositivos.bb.com.br"

# altera o arquivo de configuração
sed -i "/FailoverRelayList/,/effective/s@value.*@value                          = ${SERVIDOR}@g" /var/opt/BESClient/besclient.config

echo "Failover relay definido para $SERVIDOR"





