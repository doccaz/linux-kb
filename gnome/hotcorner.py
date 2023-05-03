import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk,Gio,GLib
from sys import argv

class SwitcherWindow(Gtk.Window):

    def __init__(self):
        
        extID = 'nohotcorner@azuri.free.fr'
        
        Gtk.Window.__init__(self, title="Hot Corner")
        self.set_border_width(10)

        hbox = Gtk.Box(spacing=6)
        self.add(hbox)
        
        switch = Gtk.Switch()
        switch.connect("notify::active", self.on_switch_activated)
        
        
        lblTitle = Gtk.Label("Habilita/desabilita hot corner")

        hbox.pack_start(lblTitle, True, True, 0)

        hbox.pack_start(switch, True, True, 0)

        gschema = Gio.Settings('org.gnome.shell')
        gvalues=gschema.get_value('enabled-extensions').unpack()
        if gvalues.index(extID) > 0:
            switch.set_active(True)
        else:
            switch.set_active(False)


    def on_switch_activated(self, switch, gparam):
        if switch.get_active():
            state = "on"
            gvalues.append(extID)
            # gsettings set org.gnome.shell enabled-extensions "['Panel_Favorites@rmy.pobox.com', 'minimizeall@scharlessantos.org', 'nohotcorner@azuri.free.fr']"
        else:
            state = "off"
            gvalues.remove(extID)
            # gsettings set org.gnome.shell enabled-extensions "['Panel_Favorites@rmy.pobox.com', 'minimizeall@scharlessantos.org']"
        print("Switch was turned", state)
        gschema.set_value('enabled-extensions', GLib.Variant('as', gvalues))
        gschema.apply()
        

win = SwitcherWindow()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()
