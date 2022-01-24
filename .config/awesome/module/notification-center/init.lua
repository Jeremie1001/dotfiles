local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local colors = require('themes').colors
local dpi = require('beautiful').xresources.apply_dpi
local screen_geometry = require('awful').screen.focused().geometry
local format_item = require('library.format_item')

local width = dpi(410)

local title = wibox.widget {
  {
      {
      spacing = dpi(0),
    	layout = wibox.layout.flex.vertical,
    	format_item(
    		{
    			layout = wibox.layout.fixed.horizontal,
    			spacing = dpi(16),
          require('widget.dracula-icon'),
          require('widget.notification-center.title-text'),
      		require('widget.notification-center.clear-all'),
    		}
    	),
    },
    margins = dpi(5),
    widget = wibox.container.margin
  },
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
  end,
  bg = colors.alpha(colors.colorB, 'F2'),
  forced_width = width,
  forced_height = 70,
  ontop = true,
  border_width = dpi(2),
  border_color = colors.colorA,
  widget = wibox.container.background,
  layout,
}

local notification_panel = wibox.widget {
  {
      {
      spacing = dpi(0),
    	layout = wibox.layout.flex.vertical,
    	format_item(
    		{
    			layout = wibox.layout.fixed.horizontal,
    			spacing = dpi(16),
          require('widget.notification-center.notifications-panel'),

    		}
    	),
    },
    margins = dpi(5),
    widget = wibox.container.margin
  },
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
  end,
  bg = colors.alpha(colors.colorB, 'F2'),
  forced_width = width,
  ontop = true,
  border_width = dpi(2),
  border_color = colors.colorA,
  widget = wibox.container.background,
  layout,
}

notificationCenter = wibox(
  {
    x = screen_geometry.width-width-dpi(8),
    y = screen_geometry.y+dpi(35),
    visible = false,
    ontop = true,
    screen = screen.primary,
    type = 'splash',
    height = screen_geometry.height-dpi(35),
    width = width,
    bg = 'transparent',
    fg = '#FEFEFE',
  }
)

awesome.connect_signal(
  "nc:resize",
  function()
    cc_height = screen_geometry.height
    if notificationCenter.height == screen_geometry.height-dpi(35) then
      notificationCenter:geometry{height = screen_geometry.height, y = screen_geometry.y+dpi(8)}
    elseif notificationCenter.height == screen_geometry.height then
      notificationCenter:geometry{height = screen_geometry.height-dpi(35), y = screen_geometry.y+dpi(35)}
    end
  end
)

_G.nc_status = false

awesome.connect_signal(
  "notifications::center:toggle",
  function()
    if notificationCenter.visible == false then
      nc_status = true
      notificationCenter.visible = true
    elseif notificationCenter.visible == true then
      nc_status = false
      notificationCenter.visible = false
    end
  end
)

awesome.connect_signal(
  "notifications::center:toggle:off",
  function()
      nc_status = false
      notificationCenter.visible = false
  end
)

notificationCenter:setup {
  spacing = dpi(15),
  title,
  notification_panel,
  layout = wibox.layout.fixed.vertical,
}
