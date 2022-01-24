local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')

local time = '%H:%M:%S'
local date = '%d.%b.%Y'

local return_button = function(color, lspace, rspace)
	local widget_button_clock = wibox.widget {
		format = time,
		refresh = 1,
		widget = wibox.widget.textclock
	}

	local widget_button = wibox.widget {
	     {
	       {
	         {
						 {
							widget_button_clock,
 							layout = wibox.layout.fixed.horizontal,
		        },
						top = dpi(4),
						bottom = dpi(4),
						left = dpi(12),
						right = dpi(12),
		        widget = wibox.container.margin
					},
					shape = gears.shape.rounded_bar,
					bg = color.color,
					fg = '#FFFFFF',
					widget = wibox.container.background
	      },
	      forced_width = icon_size,
	      forced_height = icon_size,
	      widget = clickable_container
	    },
			top = dpi(5),
	    left = dpi(lspace),
	    right = dpi(rspace),
	    widget = wibox.container.margin
  	}

	widget_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					if widget_button_clock.format == time then
						widget_button_clock:set_format(date)
					elseif widget_button_clock.format == date then
						widget_button_clock:set_format(time)
					end
				end
			),
			awful.button(
				{},
				3,
				nil,
				function()
					awesome.emit_signal("bar::centers:toggle:off")
					awesome.emit_signal("cal::center:toggle")
				end
			)
		)
	)

	return widget_button
end

return return_button
