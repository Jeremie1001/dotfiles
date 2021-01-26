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
		
		watch (
			[[bash -c "cat /home/jeremie1001/.config/awesome/widget/bar/notifications-bar/nc-status"]],
			2,
			function(_, stdout)
				local status = string.match(stdout, '%a+')
				if status == 'false' then
					widget_icon.icon:set_image(icons.notificationsFilled)
				elseif status == 'true' then
					widget_icon.icon:set_image(icons.noNotificationsFilled)
				end
				collectgarbage('collect')
			end
		)

	widget_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					_G.nc_toggle()
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
