#!/usr/bin/env python

import dbus
import dbus.service
import dbus.mainloop.glib
import gi.repository.GLib
import sys
import json

class StatusObject(dbus.service.Object):
    @dbus.service.signal('no.innovationgarage.elcheapoais')
    def manhole(self, status, errno):
        pass

dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)

session_bus = dbus.SessionBus()
name = dbus.service.BusName('no.innovationgarage.elcheapoais.manhole', session_bus)
status_object = StatusObject(session_bus, '/no/innovationgarage/elcheapoais/manhole')

def emit():
    status_object.manhole(json.loads(sys.argv[1]), json.loads(sys.argv[2]))
    sys.exit(1)
gi.repository.GLib.timeout_add(0, emit)

loop = gi.repository.GLib.MainLoop()
loop.run()
