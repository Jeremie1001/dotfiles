local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors
local settings = require('settings')

local color = colors[settings.bar.colors["notifications-bar"]]

local notifIcon = wibox.widget {
	{
		{
			image = icons.noNotifications,
			widget = wibox.widget.imagebox,
		},
		margins = dpi(5),
		widget = wibox.container.margin
	},
	shape = gears.shape.rect,
	bg = color,
	forced_width = 40,
	forced_height = 40,
	widget = wibox.container.background
}

local content = wibox.widget {
	{
		{
				text = "You have no new notifications",
				font = 'Inter 12',
				widget = wibox.widget.textbox,
			},
		margins = dpi(10),
		widget = wibox.container.margin
		},
	shape = gears.shape.rect,
	bg = colors.colorB,
	widget = wibox.container.background
}
	
local box = wibox.widget {
	{
		notifIcon,
		content,
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
