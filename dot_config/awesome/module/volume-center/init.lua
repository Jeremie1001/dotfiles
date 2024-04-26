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
          require('widget.volume-center.title-text'),
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
          require('widget.volume-center.volume-slider'),
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

local devices_text = wibox.widget {
  {
      {
      spacing = dpi(0),
    	layout = wibox.layout.flex.vertical,
    	format_item(
				{
          layout = wibox.layout.fixed.horizontal,
    			spacing = dpi(16),
          require('widget.volume-center.devices-text'),
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

local devices_panel = wibox.widget {
  {
      {
      spacing = dpi(0),
    	layout = wibox.layout.flex.vertical,
    	format_item(
				{
          layout = wibox.layout.fixed.horizontal,
    			spacing = dpi(16),
          require('widget.volume-center.devices-panel'),
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

volumeCenter = wibox(
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
  "volume::center:toggle",
  function()
    if volumeCenter.visible == false then
      awesome.emit_signal("bar::centers:toggle:off")
      volumeCenter.visible = true
    elseif volumeCenter.visible == true then
      volumeCenter.visible = false
    end
  end
)

awesome.connect_signal(
  "volume::center:toggle:off",
  function()
    volumeCenter.visible = false
  end
)

awesome.connect_signal(
  "volume::center:tab",
  function(bar, i, cycleStatus, count)
    if cycleStatus then
      volumeCenter.visible = true
      return
    end
    if volumeCenter.visible and i == #bar then 
      volumeCenter.visible = false
      awesome.emit_signal(bar[1].."::center:tab",bar, 1, true, count)
    elseif volumeCenter.visible then
      volumeCenter.visible = false
      awesome.emit_signal(bar[i+1].."::center:tab",bar,i+1, true, count+1)
    elseif volumeCenter.visible == false and i ~= #bar then 
      awesome.emit_signal(bar[i+1].."::center:tab",bar,i+1, false, count+1)
    end
  end
)

awesome.connect_signal(
  "volume::center:tab:reverse",
  function(bar, i, cycleStatus, count)
    if cycleStatus then
      volumeCenter.visible = true
      return
    end
    if volumeCenter.visible and i == 1 then 
      volumeCenter.visible = false
      awesome.emit_signal(bar[#bar].."::center:tab:reverse",bar, #bar, true, count)
    elseif volumeCenter.visible then
      volumeCenter.visible = false
      awesome.emit_signal(bar[i-1].."::center:tab:reverse",bar,i-1, true, count+1)
    elseif volumeCenter.visible == false and i ~= #bar then 
      awesome.emit_signal(bar[i-1].."::center:tab:reverse",bar,i-1, false, count+1)
    end
  end
)

volumeCenter:setup {
  spacing = dpi(15),
  title,
  sliders,
  devices_text,
  devices_panel,
  layout = wibox.layout.fixed.vertical,
}
