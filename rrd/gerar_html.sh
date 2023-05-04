#! /bin/sh

dirs=`find . -type d | grep -v images`
    rrds=`find $i -type f -name '*.rrd' -maxdepth 1 | cut -c2-`
    for k in $rrds;
      do
          l=`echo $k | sed 's/.rrd//' | cut -c2-`
          html="/var/www/html/rrdtool/teste/$l.html"
	  echo "<html><body>" > $html
          j=`echo $i | cut -c3-`
          echo "Processing $html "
          m=`basename $k .rrd`
          echo "<img src=$m-min.png border=0>" >> $html
          echo "<img src=$m-hour.png border=0>" >> $html
          echo "<img src=$m-day.png border=0>" >> $html
          echo "<img src=$m-week.png border=0>" >> $html
          echo "<img src=$m-month.png border=0>" >> $html
          echo "<br>" >> $html
	  echo "</body></html>" >> $html
      done
