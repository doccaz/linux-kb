#!/bin/bash

CPU=$(lscpu | grep model | head -1 | cut -d\: -f2 | xargs)
CPU=$(dmidecode -H 0x400 | grep Version | cut -d\: -f2 | xargs)
MEM=$(free -g | grep Mem | awk '{ print $2}')
DISKS=$(LANG=C fdisk -l | grep 'Disk /' | grep -v mapper)
MANUFACTURER=$(dmidecode -H 0x100 | grep Manufacturer | cut -d\: -f2)
PRODUCT=$(dmidecode -H 0x100 | grep Product | cut -d\: -f2)
BIOS_VENDOR=$(dmidecode -H 0x001 | grep Vendor | cut -d\: -f2)
BIOS_VERSION=$(dmidecode -H 0x001 | grep Version | cut -d\: -f2)
BIOS_DATE=$(dmidecode -H 0x001 | grep Date | cut -d\: -f2)


echo "Detectado:"
echo "CPU: ${CPU}"
echo "Memória: ${MEM} GB"
echo "Discos: ${DISKS}"
echo "Placa-mãe: ${MANUFACTURER} / ${PRODUCT}"
echo "BIOS: ${BIOS_VENDOR} / ${BIOS_VERSION} / ${BIOS_DATE}"


