#!/bin/sh

a=0
while [ "$a" == 0 ]; do
  rrdtool graph cpu-min.png   -a PNG -s -1min --title="CPU Usage (min)" DEF:cpu=cpu.rrd:cpu:AVERAGE LINE1:cpu#0000FF:"Total CPU"  COMMENT:"\n" COMMENT:"Generated at `date +\"%b %d %H:%M:%S %Y\"` \n" GPRINT:cpu:MAX:"Maximum %7.2lf" GPRINT:cpu:AVERAGE:"Average %7.2lf" GPRINT:cpu:LAST:"Atual %7.2lf"
  rrdtool graph cpu-hour.png  -a PNG -s -1h   --title="CPU Usage (hour)" DEF:cpu=cpu.rrd:cpu:AVERAGE LINE1:cpu#FF00FF:"Total CPU"  COMMENT:"\n" COMMENT:"Generated at `date +\"%b %d %H:%M:%S %Y\"` \n" GPRINT:cpu:MAX:"Maximum %7.2lf" GPRINT:cpu:AVERAGE:"Average %7.2lf" GPRINT:cpu:LAST:"Atual %7.2lf"
  rrdtool graph cpu-day.png   -a PNG -s -1d   --title="CPU Usage (day)" DEF:cpu=cpu.rrd:cpu:AVERAGE LINE1:cpu#1BFFFF:"Total CPU"  COMMENT:"\n" COMMENT:"Generated at `date +\"%b %d %H:%M:%S %Y\"` \n" GPRINT:cpu:MAX:"Maximum %7.2lf" GPRINT:cpu:AVERAGE:"Average %7.2lf" GPRINT:cpu:LAST:"Atual %7.2lf"
  rrdtool graph cpu-week.png  -a PNG -s -1w   --title="CPU Usage (week)" DEF:cpu=cpu.rrd:cpu:AVERAGE LINE1:cpu#AD7FFF:"Total CPU"  COMMENT:"\n" COMMENT:"Generated at `date +\"%b %d %H:%M:%S %Y\"` \n" GPRINT:cpu:MAX:"Maximum %7.2lf" GPRINT:cpu:AVERAGE:"Average %7.2lf" GPRINT:cpu:LAST:"Atual %7.2lf"
  rrdtool graph cpu-month.png -a PNG -s -1m   --title="CPU Usage (month)" DEF:cpu=cpu.rrd:cpu:AVERAGE LINE1:cpu#AFF5FF:"Total CPU"  COMMENT:"\n" COMMENT:"Generated at `date +\"%b %d %H:%M:%S %Y\"` \n" GPRINT:cpu:MAX:"Maximum %7.2lf" GPRINT:cpu:AVERAGE:"Average %7.2lf" GPRINT:cpu:LAST:"Atual %7.2lf"
  sleep 15
done
