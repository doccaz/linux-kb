#!/bin/sh

rm -rf cpu.rrd

rrdtool create cpu.rrd     \
     --start `date +%s`    \
     --step 1              \
     DS:cpu:GAUGE:5:0:100  \
     RRA:AVERAGE:0.5:1:3600   \

sleep 1
