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
		image = icons.ship_wheel,
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
	bg = colors.comment,
	widget = wibox.container.background
}

watch (
	[[bash -c "cat /home/jeremie1001/.config/awesome/widget/control-center/bar-button/bar-status"]],
	2,
	function(_, stdout)
		local status = string.match(stdout, '%a+')
		if status == 'true' then
			widget.bg = colors.comment
		elseif status == 'false' then
			widget.bg = colors.background
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
				bar_toggle()
	      cc_resize()
				widget.bg = colors.alpha(colors.comment, '40')
			end
		)
	)
)

return widget
