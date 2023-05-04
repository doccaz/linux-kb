#!/bin/sh

a=0
while [ "$a" == 0 ]; do
  ocupacao=`vmstat -n 1 3| tail -1 | awk '{print $13+$14+$16}'`
  rrdtool update cpu.rrd N:$ocupacao
  echo "atualizado ocupacao " $ocupacao  
  sleep 1
done
