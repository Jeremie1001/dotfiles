local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors

--- Creates button that goes backwards in calendar by date on left click and by month on right click

-- Icon widget
local widget_icon = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		id = 'icon',
		image = icons.reset,
		resize = true,
		widget = wibox.widget.imagebox
	},
	nil
}

-- Button shape
local widget = wibox.widget {
		{
			{
				{
				widget_icon,
				layout = wibox.layout.fixed.horizontal,
			},
			margins = dpi(5),
			widget = wibox.container.margin
		},
		widget = clickable_container
	},
	forced_height = dpi(20),
	shape = gears.shape.circle,
	bg = colors.colorA,
	widget = wibox.container.background
}


--Change color on hover
widget:connect_signal(
	"mouse::enter",
	function()
		widget.bg = colors.color1
	end
)

widget:connect_signal(
	"mouse::leave",
	function()
		widget.bg = colors.colorA
	end
)

--Click options
widget:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				reset_date()
			end
		)
	)
)

return widget
