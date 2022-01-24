--DEPENDENCIES
	--whatever is used here idk lol

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors
local watch = require('awful.widget.watch')

local awful = require('awful')
local beautiful = require('beautiful')
local naughty = require('naughty')

local widget_icon = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		id = 'icon',
		image = icons.restart,
		resize = true,
		widget = wibox.widget.imagebox
	},
	nil
}

local widget = wibox.widget {
	 {
		 {
			 {
				widget_icon,
				layout = wibox.layout.fixed.horizontal,
			},
			margins = dpi(15),
			widget = wibox.container.margin
		},
		forced_height = dpi(50),
		widget = clickable_container
	},
	shape = gears.shape.circle,
	bg = colors.colorA,
	widget = wibox.container.background
}

widget:connect_signal(
	"mouse::enter",
	function()
		widget.bg = colors.color3
	end
)

widget:connect_signal(
	"mouse::leave",
	function()
		widget.bg = colors.colorA
	end
)

widget:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			awesome.restart
		)
	)
)

return widget
