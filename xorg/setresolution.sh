#!/bin/bash
# sets a fixed resolution both in kernel parameters and Xorg (SLES11)

sax2 -rsa -b force_1024.sax
sed -i '/Display/,/EndSection/s@"default"@"1024x768"@g' /etc/X11/xorg.conf
sed -i '/Monitor/,/EndSection/s@VertRefresh.*@@g' /etc/X11/xorg.conf
sed -i '/Monitor/,/EndSection/s@HorizSync.*@@g' /etc/X11/xorg.conf
sed -i 's@ vga=.*@ video=1024x768-24\@60 @g' /boot/grub/menu.lst
sed -i 's@DISPLAYMANAGER_XSERVER=.*@DISPLAYMANAGER_XSERVER=\"Xorg\"@g' /etc/sysconfig/displaymanager


