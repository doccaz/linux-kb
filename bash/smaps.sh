#!/bin/ksh
#
# Returns total memory used by process $1 in kb.
#
# See /proc/NNNN/smaps if you want to do something
# more interesting.
#

IFS=$'\n'

for line in $(</proc/$1/smaps)
do
	   [[ $line =~ ^Size:\s+(\S+) ]] && ((kb += ${.sh.match[1]}))
   done

   print $kb


