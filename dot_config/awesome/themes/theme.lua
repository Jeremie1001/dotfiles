local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local colors = require('themes').colors
local settings = require("settings")


local theme = {}

theme.useless_gap   = dpi(settings.window_gaps)
theme.border_width  = dpi(settings.window_border_size)

theme.scheme = settings.theme

theme.color1 = require('themes.schemes.'..theme.scheme).color1
theme.color2 = require('themes.schemes.'..theme.scheme).color2
theme.color3 = require('themes.schemes.'..theme.scheme).color3
theme.color4 = require('themes.schemes.'..theme.scheme).color4
theme.color5 = require('themes.schemes.'..theme.scheme).color5
theme.color6 = require('themes.schemes.'..theme.scheme).color6
theme.color7 = require('themes.schemes.'..theme.scheme).color7
theme.color8 = require('themes.schemes.'..theme.scheme).color8
theme.colorA = require('themes.schemes.'..theme.scheme).colorA
theme.colorB = require('themes.schemes.'..theme.scheme).colorB

theme.hotkeys_bg = theme.colorB
theme.hotkeys_fg = theme.white
theme.hotkeys_modifiers_fg = theme.color2
theme.hotkeys_border_color = theme.color6
theme.hotkeys_group_margin = 10

client.shape_clip = 4

return theme
