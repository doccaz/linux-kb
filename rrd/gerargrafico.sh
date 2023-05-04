#!/bin/sh

a=0
while [ "$a" == 0 ]; do
  rrdtool graph cpu-min.png   -a PNG -s -1min --title="Consumo de CPU (min)" DEF:cpu=cpu.rrd:cpu:AVERAGE LINE1:cpu#0000FF:"Total CPU"  COMMENT:"\n" COMMENT:"Gerado em `date +\"%b %d %H:%M:%S %Y\"` \n" GPRINT:cpu:MAX:"Maximo %7.2lf" GPRINT:cpu:AVERAGE:"Media %7.2lf" GPRINT:cpu:LAST:"Atual %7.2lf"
  rrdtool graph cpu-hour.png  -a PNG -s -1h   --title="Consumo de CPU (hora)" DEF:cpu=cpu.rrd:cpu:AVERAGE LINE1:cpu#FF00FF:"Total CPU"  COMMENT:"\n" COMMENT:"Gerado em `date +\"%b %d %H:%M:%S %Y\"` \n" GPRINT:cpu:MAX:"Maximo %7.2lf" GPRINT:cpu:AVERAGE:"Media %7.2lf" GPRINT:cpu:LAST:"Atual %7.2lf"
  rrdtool graph cpu-day.png   -a PNG -s -1d   --title="Consumo de CPU (dia)" DEF:cpu=cpu.rrd:cpu:AVERAGE LINE1:cpu#1BFFFF:"Total CPU"  COMMENT:"\n" COMMENT:"Gerado em `date +\"%b %d %H:%M:%S %Y\"` \n" GPRINT:cpu:MAX:"Maximo %7.2lf" GPRINT:cpu:AVERAGE:"Media %7.2lf" GPRINT:cpu:LAST:"Atual %7.2lf"
  rrdtool graph cpu-week.png  -a PNG -s -1w   --title="Consumo de CPU (semana)" DEF:cpu=cpu.rrd:cpu:AVERAGE LINE1:cpu#AD7FFF:"Total CPU"  COMMENT:"\n" COMMENT:"Gerado em `date +\"%b %d %H:%M:%S %Y\"` \n" GPRINT:cpu:MAX:"Maximo %7.2lf" GPRINT:cpu:AVERAGE:"Media %7.2lf" GPRINT:cpu:LAST:"Atual %7.2lf"
  rrdtool graph cpu-month.png -a PNG -s -1m   --title="Consumo de CPU (mes)" DEF:cpu=cpu.rrd:cpu:AVERAGE LINE1:cpu#AFF5FF:"Total CPU"  COMMENT:"\n" COMMENT:"Gerado em `date +\"%b %d %H:%M:%S %Y\"` \n" GPRINT:cpu:MAX:"Maximo %7.2lf" GPRINT:cpu:AVERAGE:"Media %7.2lf" GPRINT:cpu:LAST:"Atual %7.2lf"
  sleep 15
done
