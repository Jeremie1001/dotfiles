local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes.dracula.colors')
local watch = require('awful.widget.watch')

local user_content = wibox.widget {
	text = "notifications",
  font = 'Inter Bold 14',
	widget = wibox.widget.textbox
}

local host_content = wibox.widget {
	text = "placeholder",
  font = 'Inter Bold 14',
	widget = wibox.widget.textbox,
}

local widget_user = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		user_content,
		layout = wibox.layout.align.horizontal,

	},
	nil
}

local widget_host = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		host_content,
		layout = wibox.layout.align.horizontal,
	},
	nil
}

local spacer_bar = wibox.widget {
  {
    orientation = 'vertical',
  	forced_height = dpi(1),
    forced_width = dpi(2),
    shape = gears.shape.rounded_bar,
  	widget = wibox.widget.separator,
  },
  margins = dpi(10),
  widget = wibox.container.margin
}

local update_host = function()
	awful.spawn.easy_async_with_shell(
		[[bash -c "uname -n"]],
		function(stdout)
			local hostname = stdout
			--hostname = string.upper(hostname)
			host_content:set_text(hostname)
		end
	)
end

update_host()

local widget = wibox.widget {
   {
    widget_user,
    spacer_bar,
		widget_host,
  	layout = wibox.layout.fixed.horizontal,
	},
  fg = '#DDD',
	widget = wibox.container.background
}

return widget
