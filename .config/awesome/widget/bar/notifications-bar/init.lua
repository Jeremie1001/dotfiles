--DEPENDENCIES
	--Blueman

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local watch = require('awful.widget.watch')

local return_button = function(color, space)

	local widget_icon = wibox.widget {
		layout = wibox.layout.align.vertical,
		expand = 'none',
		nil,
		{
			id = 'icon',
			image = icons.noNotificationsFilled,
			resize = true,
			widget = wibox.widget.imagebox
		},
		nil
	}

	local widget_button = wibox.widget {
	     {
	       {
	         {
						 {
							widget_icon,
							layout = wibox.layout.fixed.horizontal,
		        },
						top = dpi(5),
						bottom = dpi(5),
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

		awesome.connect_signal(
			"notificationsEmpty:true",
			function()
				widget_icon.icon:set_image(icons.noNotificationsFilled)
			end
		)

		awesome.connect_signal(
			"notificationsEmpty:false",
			function()
				widget_icon.icon:set_image(icons.notificationsFilled)
			end
		)

	widget_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					awesome.emit_signal("nc:toggle")
				end
			),
			awful.button(
				{},
				3,
				nil,
				function()
					_G.resetPanelLayout()
				end
			)
		)
	)

	return widget_button
end

return return_button
