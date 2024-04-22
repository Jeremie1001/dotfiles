local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local colors = require('themes').colors
local dpi = require('beautiful').xresources.apply_dpi
local screen_geometry = require('awful').screen.focused().geometry

client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local thickness = dpi(4)
    local edge_color = colors.colorB

    beautiful.titlebar_bg_normal = colors.color8
    beautiful.titlebar_bg_focus = colors.color2

    beautiful.border_normal = edge_color
    beautiful.border_focus  = edge_color

    awful.titlebar(c, {position="right", size=thickness})
    awful.titlebar(c, {position="left", size=thickness})
    awful.titlebar(c, {position="bottom", size=thickness})
    awful.titlebar(c, {position="top", size=thickness})

end)
