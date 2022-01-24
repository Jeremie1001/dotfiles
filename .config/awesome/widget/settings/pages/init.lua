local pages = {
  system = {
    about = require('widget.settings.pages.system.about'),
		display = require('widget.settings.pages.system.display'),
		sound = require('widget.settings.pages.system.sound'),
		power = require('widget.settings.pages.system.power'),
		battery = require('widget.settings.pages.system.battery'),
		storage = require('widget.settings.pages.system.storage'),
		notifications = require('widget.settings.pages.system.notifications')
  },
  devices = {
    bluetooth = require('widget.settings.pages.devices.bluetooth'),
		printers = require('widget.settings.pages.devices.printers'),
		usb = require('widget.settings.pages.devices.usb')
  },
  theme = {
    colors = require('widget.settings.pages.theme.colors'),
		controlCenter = require('widget.settings.pages.theme.controlCenter'),
		notifications = require('widget.settings.pages.theme.notifications'),
		bar = require('widget.settings.pages.theme.bar'),
		wallpaper = require('widget.settings.pages.theme.wallpaper'),
		general = require('widget.settings.pages.theme.general')
  },
  programs = {
    programs = require('widget.settings.pages.programs.programs'),
		defaults = require('widget.settings.pages.programs.defaults'),
		startup = require('widget.settings.pages.programs.startup')
  },
  timeLanguage = {
    dateTime = require('widget.settings.pages.timeLanguage.dateTime'),
		language = require('widget.settings.pages.timeLanguage.language')
  },
  network = {
    status = require('widget.settings.pages.network.status'),
		wifi = require('widget.settings.pages.network.wifi'),
		ethernet = require('widget.settings.pages.network.ethernet'),
		airplane = require('widget.settings.pages.network.airplane')
  },
}

return pages