--DEPENDENCIES
	--whatever is used here idk lol

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes.dracula.colors')
local watch = require('awful.widget.watch')

local widget_icon = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		id = 'icon',
		image = icons.volume,
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
	bg = colors.yellow,
	widget = wibox.container.background
}

local mute_toggle = function()
	awful.spawn.easy_async_with_shell(
		[[bash -c "pamixer --get-mute"]],
		function(stdout)
			local status = string.match(stdout, '%a+')
			if status == 'true' then
				awful.spawn('pamixer -u')
				widget_icon.icon:set_image(icons.volume)
				widget.bg = colors.yellow
			elseif status == "false" then
				awful.spawn('pamixer -m')
				widget_icon.icon:set_image(icons.mute)
				widget.bg = colors.background
			end
		end
	)
end

widget:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				mute_toggle()
			end
		)
	)
)

return widget
