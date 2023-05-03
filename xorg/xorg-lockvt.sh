#!/bin/bash

if [ `grep -c DontVTSwitch /etc/X11/xorg.conf` -gt 0 ]; then

	sed -i 's@DontVTSwitch.*@DontVTSwitch"    "true"@1;s@DontZap.*@DontZap      "true"@1' /etc/X11/xorg.conf

else
	sed -i 's@\(Section.*\"ServerFlags\"\)@\1\n\tOption        "DontVTSwitch" "true"\n\tOption        "DontZap"   "true"\n@1' /etc/X11/xorg.conf
fi

