local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes.dracula.colors')
local watch = require('awful.widget.watch')

local search_text = wibox.widget {
	text = "search",
  font = 'Inter Bold 14',
	widget = wibox.widget.textbox
}

local widget_search_text = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		search_text,
		layout = wibox.layout.align.horizontal,

	},
	nil
}

local searchIcon = wibox.widget {
  layout = wibox.layout.align.vertical,
  expand = 'none',
  nil,
  {
    id = 'icon',
    image = icons.search,
    resize = true,
    widget = wibox.widget.imagebox
  },
  nil
}

local search = wibox.widget {
  {
    {
      {
        connectIcon,
        layout = wibox.layout.fixed.horizontal,
      },
      margins = dpi(9),
      widget = wibox.container.margin
    },
    forced_height = dpi(40),
    forced_width = dpi(40),
    widget = clickable_container
  },
  shape = gears.shape.circle,
  bg = colors.background,
  widget = wibox.container.background
}

search:connect_signal(
  "mouse::enter",
  function()
    search.bg = colors.comment
  end
)

search:connect_signal(
  "mouse::leave",
  function()
    search.bg = colors.background
  end
)

local widget = wibox.widget {
   {
    search,
    widget_search_text,
  	layout = wibox.layout.fixed.horizontal,
    spacing = dpi(16),
	},
  fg = '#DDD',
	widget = wibox.container.background
}

return widget
