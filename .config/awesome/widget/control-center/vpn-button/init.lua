--DEPENDENCIES
	--nordvpn-bin

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
		image = icons.shield_off,
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
	bg = colors.green,
	widget = wibox.container.background
}

watch (
	[[bash -c "~/.config/awesome/scripts/vpn.sh"]],
	2,
	function(_, stdout)
		local status = string.match(stdout, '%a+')
		if status == "Disconnected" then
			widget.bg = colors.background
			widget_icon.icon:set_image(icons.shield_off)
		else
			widget.bg = colors.green
			widget_icon.icon:set_image(icons.shield)
		end
		collectgarbage('collect')
	end
)

widget:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				awful.spawn.with_shell('~/.config/awesome/scripts/vpn.sh --toggle-connection')
				widget.bg = colors.alpha(colors.green, '40')
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

return widget
