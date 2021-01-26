local awful = require("awful")

require('module.notifications')
require('module.notification-center')
require('module.double-border')
require('module.calendar')
awful.screen.connect_for_each_screen(require('module.exit-screen'))
awful.screen.connect_for_each_screen(require('module.control-center'))
awful.screen.connect_for_each_screen(require('module.bar'))