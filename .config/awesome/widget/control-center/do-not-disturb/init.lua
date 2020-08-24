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
		image = icons.moon,
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
	bg = colors.purple,
	widget = wibox.container.background
}

watch (
	[[bash -c "cat /home/jeremie1001/.config/awesome/widget/do-not-disturb/dnd-status"]],
	2,
	function(_, stdout)
		local status = string.match(stdout, '%a+')
		if status == 'true' then
			widget.bg = colors.purple
		elseif status == 'false' then
			widget.bg = colors.background
		end
		collectgarbage('collect')
	end
)

_G.dnd_status = false

local check_dnd_status = function()
	awful.spawn.easy_async_with_shell(
		'cat /home/jeremie1001/.config/awesome/widget/do-not-disturb/dnd-status',
		function(stdout)
			local status = string.match(stdout, '%a+')
			if status:match('true') then
				dnd_status = true
			elseif status:match('false') then
				dnd_status = false
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
				check_dnd_status()
				if dnd_status == true then
					awful.spawn.with_shell('echo false > /home/jeremie1001/.config/awesome/widget/do-not-disturb/dnd-status ')
				elseif dnd_status == false then
					awful.spawn.with_shell('echo true > /home/jeremie1001/.config/awesome/widget/do-not-disturb/dnd-status ')
				end
			end
		)
	)
)

return widget
