#!/bin/bash

CPU=$(lscpu | grep model | head -1 | cut -d\: -f2 | xargs)
CPU=$(dmidecode -H 0x400 | grep Version | cut -d\: -f2 | xargs)
MEM=$(free -g | grep Mem | awk '{ print $2}')
DISKS=$(LANG=C fdisk -l | grep 'Disk /' | grep -v mapper)
CHASSIS=$(dmidecode -H 0x100)
BIOS=$(dmidecode -H 0x001)



echo "Detectado:"
echo "CPU: ${CPU}"
echo "Memória: ${MEM} GB"
echo "Discos: ${DISKS}"
echo "Placa-mãe: ${CHASSIS}"
echo "BIOS: ${BIOS}"


