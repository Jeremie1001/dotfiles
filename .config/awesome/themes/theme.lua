local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local colors = require('themes').colors
local settings = require("settings")


local theme = {}

theme.useless_gap   = dpi(settings.window_gaps)
theme.border_width  = dpi(settings.window_border_size)

theme.hotkeys_bg = colors.colorB
theme.hotkeys_fg = colors.white
theme.hotkeys_modifiers_fg = colors.color2
theme.hotkeys_border_color = colors.color6
theme.hotkeys_group_margin = 10

client.shape_clip = 4

return theme
