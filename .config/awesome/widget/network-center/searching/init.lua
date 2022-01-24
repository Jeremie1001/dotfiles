local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors
local watch = require('awful.widget.watch')

local box = {}

local signalIcon = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		id = 'icon',
		image = icons.wifi_2,
		resize = true,
		widget = wibox.widget.imagebox
	},
	nil
}

local wifiIcon = wibox.widget {
	{
		{
			signalIcon,
			margins = dpi(7),
			widget = wibox.container.margin
		},
		shape = gears.shape.rect,
		bg = colors.color4,
		widget = wibox.container.background
	},
	forced_width = 40,
	forced_height = 40,
	widget = clickable_container
}

local content = wibox.widget {
	{
		{
			{
				text = "Searching...",
				font = 'Inter Bold 10',
				widget = wibox.widget.textbox,
			},
			layout = wibox.layout.align.vertical,
		},
		margins = dpi(10),
		widget = wibox.container.margin
	},
	shape = gears.shape.rect,
	bg = colors.colorB,
	widget = wibox.container.background
}

box = wibox.widget {
	{
		wifiIcon,
		content,
		buttons,
		layout = wibox.layout.align.horizontal,
	},
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, dpi(4))
	end,
	fg = colors.white,
	border_width = dpi(1),
	border_color = colors.colorA,
	widget = wibox.container.background
}

return box