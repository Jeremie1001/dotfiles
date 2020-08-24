--DEPENDENCIES
	--nordvpn-bin

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local watch = require('awful.widget.watch')

local return_button = function(color, space)
	local widget_content = wibox.widget {
		text = "Disconnected",
		widget = wibox.widget.textbox
	}

	watch (
		[[bash -c "~/.config/awesome/scripts/vpn.sh"]],
		2,
		function(_, stdout)
			local status = stdout
			widget_content:set_text(status)
			collectgarbage('collect')
		end
	)

	local widget_button = wibox.widget {
	     {
	       {
	         {
						 {
		          widget_content,
							layout = wibox.layout.fixed.horizontal,
		        },
						top = dpi(4),
						bottom = dpi(4),
						left = dpi(12),
						right = dpi(12),
		        widget = wibox.container.margin
					},
					shape = gears.shape.rounded_bar,
					bg = color,
					fg = '#FFFFFF',
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
					awful.spawn.with_shell('~/.config/awesome/scripts/vpn.sh --toggle-connection')
				end
			),
			awful.button(
				{},
				3,
				nil,
				function()
					awful.spawn.with_shell('~/.config/awesome/scripts/vpn.sh --location-menu')
				end
			)
		)
	)

	return widget_button
end

return return_button
