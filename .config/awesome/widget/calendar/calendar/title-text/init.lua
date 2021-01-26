local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')

--- Title text for calendar portion of Calendar/To do panel


-- Left text
local main_content = wibox.widget {
	text = "calendar",
  font = 'Inter Bold 14',
	widget = wibox.widget.textbox
}

-- Right text
local host_content = wibox.widget {
	text = "placeholder",
  font = 'Inter Bold 14',
	widget = wibox.widget.textbox,
}

-- Left text container widget
local widget_main = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		main_content,
		layout = wibox.layout.align.horizontal,

	},
	nil
}

-- Right text container widget
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

-- Spacer bar between
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

-- Update right text to have lowercase host name
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

-- Update on startup
update_host()

-- Combine 2 text widgets and spacer bar into 1
local widget = wibox.widget {
   {
    widget_main,
    spacer_bar,
		widget_host,
  	layout = wibox.layout.fixed.horizontal,
	},
  fg = '#DDD',
	widget = wibox.container.background
}

return widget
