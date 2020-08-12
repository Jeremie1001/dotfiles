pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- when client with a matching name is opened:
require('startup')

require("layout")

beautiful.init("/home/jeremie1001/.config/awesome/themes/dracula/theme.lua")


require('config.client')

_G.root.keys(require('config.keys.global'))

require('module.exit-screen')
require('module.volume')
