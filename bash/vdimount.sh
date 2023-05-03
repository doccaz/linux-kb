#!/bin/sh
###
#
# Project:      Automounting VirtualBox VDI raw images in GNU/Linux
#
# File name:    vdimount.sh
# Description:  This script automount any mountable filesystem inside
#               any primary partition of a VirtualBox VDI raw image on
#      GNU/Linux. HDD unit is accesible through a loop device
#               like /dev/loop[X]
#   
# author:       Norberto Fernandez (c) 2011.
# version:      0.1.1
#   
# see The GNU Public License (GPL)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#
###
#
# Usage: ./vdimount.sh <path-to-vdi-image> <mount-point> [partition-number]
#
###

vdifile="$1"
mountpoint="$2"

partition=1
if [ "$3" != "" ]; then
	partition=$3
fi

image_type=`od -j0x004C -N4 -i "$vdifile" | awk '{print $2}'`

if [ $image_type = 2 ]; then

	offset_data=`od -j0x0158 -N4 -tu4 "$vdifile" | awk '{print $2}'`
	disk_size=`od -j0x0170 -N8 -tu8 "$vdifile" | awk '{print $2}'`

	file_size=`ls -la "$vdifile" | awk '{print $5}'`
	header_size=`echo "scale=0;$file_size-$disk_size" | bc -l`

	if [ $offset_data = $header_size ]; then

		echo "VDI Image is Static and File Size match OK"
		echo "VDI Bytes Offset to HDD raw image is $offset_data"

		loop_device=`sudo losetup -f`
		sudo losetup $loop_device -o $offset_data "$vdifile"
		part_info=`sudo parted $loop_device unit s print | grep ^.$partition | sed 's/\([0-9]\+\)s/\1/g' | awk '{print $1,$2,$3,$4,$5,$6,$7}'`

		part_type=`echo $part_info | awk '{print $5}'`

		if [ $part_type = 'primary' ]; then

			filesystem=`echo $part_info | awk '{print $6}'`
			part_sect_off=`echo $part_info | awk '{print $2}'`
			part_offset=`echo "scale=0;$part_sect_off*512" | bc -l`

			if [ $part_offset != 0 ]; then

				total_offset=`echo "scale=0;$offset_data+$part_offset" | bc -l`

				echo "HDD Bytes Offset to Partition $partition is $part_offset"
				echo "VDI Bytes Offset to Partition $partition is $total_offset"

				echo "Partition $partition: Primary with Filesystem $filesystem,"
				echo "will be mounted on $loop_device loop device."

				sudo mount -t $filesystem -o offset=$part_offset $loop_device $mountpoint

				if [ $? = 0 ]; then
					echo "Partition $partition from VDI $vdifile was succesfully mounted on $mountpoint"
					exit 0
				fi
			fi
		fi
		sudo losetup -d $loop_device
	fi
fi
echo "Partition $partition from VDI $vdifile can't be mounted"
exit 1


