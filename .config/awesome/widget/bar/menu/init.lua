--DEPENDENCIES
	--rofi

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')

local return_button = function(color, lspace, rspace)
	local widget_button = wibox.widget {
	     {
	       {
	         {
						 {
		          image = icons.ship_wheel,
		          widget = wibox.widget.imagebox
		        },
						top = dpi(3),
						bottom = dpi(3),
						left = dpi(12),
						right = dpi(12),
		        widget = wibox.container.margin
					},
					shape = gears.shape.rounded_bar,
					bg = color.color,
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
						awful.spawn.with_shell('rofi -no-lazy-grab -show drun -theme centered.rasi')
					end
				),
				awful.button(
					{},
					3,
					nil,
					function()
						awful.spawn.with_shell('./.config/xmenu/xmenu.sh')
					end
				)
			)
		)

	return widget_button
end

return return_button
