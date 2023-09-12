#!/bin/bash

echo "Colecting and processing SAR data..."
for f in /var/log/sa/sa[0-9]???????; do 
	echo "Processando file: ${f}"
	S_TIME_FORMAT=ISO sar -A -f $f > /tmp/$(basename ${f})_$(uname -n).txt; 
done

tar cvzf /tmp/$(uname -n).tar.gz /tmp/sa[0-9]*$(uname -n).txt

echo "Data collected at /tmp/$(uname -n).tar.gz"



