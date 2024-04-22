local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local colors = require('themes').colors
local dpi = require('beautiful').xresources.apply_dpi
local screen_geometry = require('awful').screen.focused().geometry
local format_item = require('library.format_item')
local settings = require("settings")

local width = dpi(410)

local color = colors[settings.bar.right[2][2]]

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
          require('widget.battery-center.title-text'),
          widget,
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

local status = wibox.widget {
  {
      {
      spacing = dpi(0),
    	layout = wibox.layout.flex.vertical,
    	format_item(
				{
          layout = wibox.layout.fixed.horizontal,
    			spacing = dpi(16),
          require('widget.battery-center.status-icon'),
          require('widget.battery-center.status'),
					widget,
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


local sliders = wibox.widget {
  {
    {
      spacing = dpi(0),
    	layout = wibox.layout.flex.horizontal,
    	format_item(
				{
          layout = wibox.layout.fixed.vertical,
    			spacing = dpi(10),
          require('widget.battery-center.battery-slider'),
					widget,
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
  forced_width = 400,
  forced_height = 75,
  border_width = dpi(2),
  border_color = colors.colorA,
  widget = wibox.container.background,
  layout,
}

batteryCenter = wibox(
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
  "battery::center:toggle",
  function()
    if batteryCenter.visible == false then
      awesome.emit_signal("bar::centers:toggle:off")
      batteryCenter.visible = true
    elseif batteryCenter.visible == true then
      batteryCenter.visible = false
    end
  end
)

awesome.connect_signal(
  "battery::center:toggle:off",
  function()
    batteryCenter.visible = false
  end
)

awesome.connect_signal(
  "battery::center:tab",
  function(bar, i, cycleStatus, count)
    if cycleStatus then
      batteryCenter.visible = true
      return
    end
    if batteryCenter.visible and i == #bar then 
      batteryCenter.visible = false
      awesome.emit_signal(bar[1].."::center:tab",bar, 1, true, count)
    elseif batteryCenter.visible then
      batteryCenter.visible = false
      awesome.emit_signal(bar[i+1].."::center:tab",bar,i+1, true, count+1)
    elseif batteryCenter.visible == false and i ~= #bar then 
      awesome.emit_signal(bar[i+1].."::center:tab",bar,i+1, false, count+1)
    end
  end
)

awesome.connect_signal(
  "battery::center:tab:reverse",
  function(bar, i, cycleStatus, count)
    if cycleStatus then
      batteryCenter.visible = true
      return
    end
    if batteryCenter.visible and i == 1 then 
      batteryCenter.visible = false
      awesome.emit_signal(bar[#bar].."::center:tab:reverse",bar, #bar, true, count)
    elseif batteryCenter.visible then
      batteryCenter.visible = false
      awesome.emit_signal(bar[i-1].."::center:tab:reverse",bar,i-1, true, count+1)
    elseif batteryCenter.visible == false and i ~= 1 then 
      awesome.emit_signal(bar[i-1].."::center:tab:reverse",bar,i-1, false, count+1)
    end
  end
)

batteryCenter:setup {
  spacing = dpi(15),
  title,
  status,
  sliders,
  layout = wibox.layout.fixed.vertical,
}
