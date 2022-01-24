local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors
local watch = require('awful.widget.watch')

local devices_text = wibox.widget {
	text = "devices",
  font = 'Inter Bold 14',
	widget = wibox.widget.textbox
}

local widget_devices_text = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		devices_text,
		layout = wibox.layout.align.horizontal,
	},
	nil
}

local devicesIcon = wibox.widget {
  layout = wibox.layout.align.vertical,
  expand = 'none',
  nil,
  {
    id = 'icon',
    image = icons.devices,
    resize = true,
    widget = wibox.widget.imagebox
  },
  nil
}

local devices = wibox.widget {
    {
      {
        devicesIcon,
        layout = wibox.layout.fixed.horizontal,
      },
      margins = dpi(4),
      widget = wibox.container.margin
    },
    forced_height = dpi(40),
    forced_width = dpi(40),
    shape = gears.shape.circle,
    bg = colors.transparent,
    widget = wibox.container.background
}

local widget = wibox.widget {
   {
    devices,
    widget_devices_text,
  	layout = wibox.layout.fixed.horizontal,
    spacing = dpi(16),
	},
  fg = '#DDD',
	widget = wibox.container.background
}

return widget
