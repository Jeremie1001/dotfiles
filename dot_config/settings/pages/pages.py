import gi

from pages.system import about
from pages.system import display 
from pages.system import sound 
from pages.system import power 
from pages.system import battery 
from pages.system import storage

from pages.devices import bluetooth
from pages.devices import printers 
from pages.devices import usb 

from pages.theme import colors
from pages.theme import controlCenter 
from pages.theme import notifications 
from pages.theme import bar 
from pages.theme import wallpaper 
from pages.theme import general

from pages.programs import programs
from pages.programs import defaults 
from pages.programs import startup 

from pages.timeLanguage import dateTime
from pages.timeLanguage import language

from pages.network import status
from pages.network import wifi 
from pages.network import ethernet 
from pages.network import airplane 

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk
from gi.repository import Gdk

bruv = Gtk.Label("controlCenter page")

pageList = [
            (about.about,display.display,sound.sound,power.power,battery.battery,storage.storage), 
            (bluetooth.bluetooth,printers.printers,usb.usb),
            (colors.colors,controlCenter.controlCenter,notifications.notifications,bar.bar,wallpaper.wallpaper,general.general), 
            (programs.programs,defaults.defaults,startup.startup),
            (dateTime.dateTime,language.language),
            (status.status,wifi.wifi,ethernet.ethernet,airplane.airplane),
        ]