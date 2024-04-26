#!/usr/bin/env python

# python3 .config/settings/settings.py

import gi
import os

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk
from gi.repository import Gdk

from pages.pages import pageList
from dev.luaProcess import parsedTable,settingFinder,settingSetter

class settingsWindow(Gtk.Window):
    def __init__(self):
        super().__init__(title="archdracula settings")
        unsavedChanges = False

        header = Gtk.HeaderBar()
        header.set_title("ArchDracula Settings")
        header.set_show_close_button(False)

        saveButton = Gtk.Button()
        saveButton.set_label("restart awesome")
        header.pack_end(saveButton)

        changedSettings = []

        saveButton.connect("clicked", self.saveRestart)

        self.set_titlebar(header)


        grid = Gtk.Grid()
        self.add(grid)

        submenu = Gtk.Stack()
        submenu.set_hexpand(False)
        submenu.set_vexpand(False)

        menu = Gtk.StackSidebar()
        menu.set_stack(submenu)

        menuList = [
            "system","devices","theme","programs","timeLanguage","network", 
        ]

        submenuList = [
            ("about","display","sound","power","battery","storage"), 
            ("bluetooth","printers","usb"),
            ("colors","controlCenter","notifications","bar","wallpaper","general"), 
            ("programs","defaults","startup"),
            ("dateTime","language"),
            ("status","wifi","ethernet","airplane"),
        ]        

        pageStack = Gtk.Stack()
        pageStack.set_hexpand(True)
        pageStack.set_vexpand(True)

        i=0
        for menuItem in menuList:
            menuBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=1)
            submenu.add_titled(menuBox, menuItem, menuItem)

            for submenuButtonItem in submenuList[i]:
                button = Gtk.Button(label=submenuButtonItem)
                button.connect("clicked", self.stackSelector, pageStack, submenuButtonItem)
                menuBox.pack_start(button, False, False, 0)
            i+=1
        

        for i in range(0, len(submenuList)):
            j=0
            for submenuItem in submenuList[i]:
                pageStack.add_titled(pageList[i][j], submenuItem, submenuItem)
                j+=1
            
        grid.attach(menu, 0, 0, 1, 1)
        grid.attach(Gtk.Separator(), 1, 0, 1, 1)
        grid.attach(submenu, 2, 0, 1, 1)
        grid.attach(Gtk.Separator(), 3, 0, 1, 1)
        grid.attach(pageStack, 4, 0, 1, 1)



    def stackSelector(self, widget, stack, submenu):
        stack.set_visible_child_name(submenu)

    def saveButton(self, widget, settings):
        print(settings)

    def saveRestart(self, widget):
        os.system("echo 'awesome.restart()' | awesome-client")


win = settingsWindow()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()