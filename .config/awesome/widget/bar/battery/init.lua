--DEPENDENCIES
	--speedtest-cli

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')

local return_button = function(color, space)
	local widget_button = wibox.widget {
	     {
	       {
	         {
						 {
		          image = icons.batt_discharging,
		          widget = wibox.widget.imagebox
		        },
						top = dpi(4),
						bottom = dpi(4),
						left = dpi(12),
						right = dpi(12),
		        widget = wibox.container.margin
					},
					shape = gears.shape.rounded_bar,
					bg = color,
					widget = wibox.container.background
	      },
	      forced_width = icon_size,
	      forced_height = icon_size,
	      widget = clickable_container
	    },
			top = dpi(5),
	    right = dpi(space),
	    widget = wibox.container.margin
  	}

	widget_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					_G.exit_screen_show()
				end
			)
		)
	)

	return widget_button
end

return return_button
