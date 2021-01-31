local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local watch = require('awful.widget.watch')

local return_button = function(color, space)
	local widget_content = wibox.widget {
		text = "Arch Dracula",
		widget = wibox.widget.textbox
	}

	local lenMax = 42

	watch (
--		[[bash -c "xprop -id $(xprop -root | grep '_NET_ACTIVE_WINDOW(WINDOW)' | awk {'print $5'}) | grep '_WM_NAME(UTF8_STRING)' | awk '{for(i=1; i<NF-1; ++i) $i=$(i+2); NF-=2; print $0}' | sed 's/\"//g'"]],
		[[bash -c "xdotool getwindowname $(xdotool getactivewindow)"]],
		1,
		function(_, stdout)
			local name = stdout
			if name == "" then
				name = "Arch Dracula"
			end
			if string.len(name) > lenMax then
				name = string.sub(name, 1, 42).."..."
			end
			widget_content:set_text(name)
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
					fg = 'white',
					widget = wibox.container.background
	      },
	      widget = clickable_container
	    },
			top = dpi(5),
	    left = dpi(space),
	    widget = wibox.container.margin
  	}

		widget_button:buttons(
			gears.table.join(
				awful.button(
					{},
					1,
					nil,
					function()
						awful.spawn.with_shell('rofi -no-lazy-grab -show window -theme centered.rasi')
					end
				)
			)
		)

		widget_button:connect_signal(
			"mouse::enter",
			function()
				lenMax = 300
			end
		)

		widget_button:connect_signal(
			"mouse::leave",
			function()
				lenMax = 42
			end
		)


	return widget_button
end

return return_button
