#!/bin/sh

a=0
while [ "$a" == 0 ]; do
  usage=`vmstat -n 1 3| tail -1 | awk '{print $13+$14+$16}'`
  rrdtool update cpu.rrd N:$usage
  echo "updated usage " $usage  
  sleep 1
done
