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
          require('widget.system-center.title-text'),
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

local keyboardStatus = wibox.widget {
  {
      {
      spacing = dpi(0),
    	layout = wibox.layout.flex.vertical,
    	format_item(
				{
          layout = wibox.layout.fixed.horizontal,
    			spacing = dpi(16),
          require('widget.system-center.keyboard-status-icon'),
          require('widget.system-center.keyboard-status'),
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

local keyboard_panel = wibox.widget {
  {
      {
      spacing = dpi(0),
    	layout = wibox.layout.flex.vertical,
    	format_item(
				{
          layout = wibox.layout.fixed.horizontal,
    			spacing = dpi(16),
          require('widget.system-center.keyboard-panel'),
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
  ontop = true,
  border_width = dpi(2),
  border_color = colors.colorA,
  widget = wibox.container.background,
  layout,
}

local timezoneStatus = wibox.widget {
  {
      {
      spacing = dpi(0),
    	layout = wibox.layout.flex.vertical,
    	format_item(
				{
          layout = wibox.layout.fixed.horizontal,
    			spacing = dpi(16),
          require('widget.system-center.timezone-status-icon'),
          require('widget.system-center.timezone-status'),
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

systemCenter = wibox(
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
  "system::center:toggle",
  function()
    if systemCenter.visible == false then
      awesome.emit_signal("bar::centers:toggle:off")
      systemCenter.visible = true
    elseif systemCenter.visible == true then
      systemCenter.visible = false
    end
  end
)

awesome.connect_signal(
  "system::center:toggle:off",
  function()
    systemCenter.visible = false
  end
)

awesome.connect_signal(
  "system::center:tab",
  function(bar, i, cycleStatus, count)
    if cycleStatus then
      systemCenter.visible = true
      return
    end
    if systemCenter.visible and i == #bar then 
      systemCenter.visible = false
      awesome.emit_signal(bar[1].."::center:tab",bar, 1, true, count)
    elseif systemCenter.visible then
      systemCenter.visible = false
      awesome.emit_signal(bar[i+1].."::center:tab",bar,i+1, true, count+1)
    elseif systemCenter.visible == false and i ~= #bar then 
      awesome.emit_signal(bar[i+1].."::center:tab",bar,i+1, false, count+1)
    end
  end
)

awesome.connect_signal(
  "system::center:tab:reverse",
  function(bar, i, cycleStatus, count)
    if cycleStatus then
      systemCenter.visible = true
      return
    end
    if systemCenter.visible and i == 1 then 
      systemCenter.visible = false
      awesome.emit_signal(bar[#bar].."::center:tab:reverse",bar, #bar, true, count)
    elseif systemCenter.visible then
      systemCenter.visible = false
      awesome.emit_signal(bar[i-1].."::center:tab:reverse",bar,i-1, true, count+1)
    elseif systemCenter.visible == false and i ~= 1 then 
      awesome.emit_signal(bar[i-1].."::center:tab:reverse",bar,i-1, false, count+1)
    end
  end
)

systemCenter:setup {
  spacing = dpi(15),
  title,
  keyboardStatus,
  keyboard_panel,
  timezoneStatus,
  layout = wibox.layout.fixed.vertical,
}
