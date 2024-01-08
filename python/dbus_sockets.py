#!/usr/bin/env python3
# Print processes which have system bus connections
# Copyright 2013 Colin Walters <walters@verbum.org>
# jan/2024: porting to python 3 <erico.mendonca@suse.com>
# Licensed under the new-BSD license (http://www.opensource.org/licenses/bsd-license.php)

import os
from gi.repository import GObject
from gi.repository import GLib
import dbus
import dbus.mainloop.glib

dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
loop = GLib.MainLoop()

bus = dbus.SystemBus()
driver = dbus.Interface(bus.get_object('org.freedesktop.DBus', '/org/freedesktop/DBus'), 'org.freedesktop.DBus')
connections = driver.ListNames()
pid_to_count = {}
for name in connections:
    if not name.startswith(':'): continue
    try:
        ownerpid = driver.GetConnectionUnixProcessID(name)
        count = pid_to_count.get(ownerpid, 0)
        pid_to_count[ownerpid] = count + 1
    except:
        continue

for pid in sorted(pid_to_count.keys()):
    try:
        cmdline = os.readlink('/proc/%d/exe' % (pid, ))
    except:
        cmdline = '(unknown)'
    print("%s (%d): %d connections" % (cmdline, pid, pid_to_count[pid]))

