local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local colors = require('themes.dracula.colors')


local theme = {}

theme.useless_gap   = dpi(4)
theme.border_width  = dpi(7)

theme.hotkeys_bg = colors.selection
theme.hotkeys_fg = colors.white
theme.hotkeys_modifiers_fg = colors.purple
theme.hotkeys_border_color = colors.green
theme.hotkeys_group_margin = 10

client.shape_clip = 4

return theme
