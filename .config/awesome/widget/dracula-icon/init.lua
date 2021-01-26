local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')

--- Widget for dracula icon used in all title bars

-- Icon widget
local widget_icon = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		id = 'icon',
		image = icons.dracula,
		resize = true,
		widget = wibox.widget.imagebox
	},
	nil
}

-- Icon widget container
local widget = wibox.widget {
	 {
		 {
			 {
				widget_icon,
				layout = wibox.layout.fixed.horizontal,
			},
			margins = dpi(0),
			widget = wibox.container.margin
		},
		forced_height = dpi(50),
		widget = clickable_container
	},
	shape = gears.shape.circle,
	bg = 'transparent',
	widget = wibox.container.background
}

return widget
