local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors
local watch = require('awful.widget.watch')

local left_content = wibox.widget {
	text = "status",
  font = 'Inter Bold 14',
	widget = wibox.widget.textbox
}

local right_content = wibox.widget {
	text = "placeholder",
  font = 'Inter Bold 14',
	widget = wibox.widget.textbox,
}

local widget_user = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		left_content,
		layout = wibox.layout.align.horizontal,

	},
	nil
}

local widget_host = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		right_content,
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
		[[bash -c "nmcli c | awk 'NF{NF-=3};1' | sed '2!d'"]],
		function(stdout)
			local networkName = stdout:gsub("\n", "")
			right_content:set_text(networkName)
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
