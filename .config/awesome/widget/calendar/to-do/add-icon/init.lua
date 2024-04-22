local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors
local addEvent = require('widget.calendar.to-do.add-event')

--- Creates button that goes backwards in calendar by date on left click and by month on right click

-- Icon widget
local widget_icon = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		id = 'icon',
		image = icons.add,
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
			margins = dpi(9),
			widget = wibox.container.margin
		},
		widget = clickable_container
	},
	forced_height = dpi(30),
	shape = gears.shape.circle,
	bg = colors.colorA,
	widget = wibox.container.background
}


-- Change color on hover
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

-- Click options (not complete atm)
widget:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				awesome.emit_signal("widget::add-to-do-event")
			end
		)
	)
)

return widget
