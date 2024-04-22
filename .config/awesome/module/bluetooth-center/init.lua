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
          require('widget.bluetooth-center.title-text'),
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

local buttons = wibox.widget {
  {
    {
      spacing = dpi(0),
    	layout = wibox.layout.flex.vertical,
    	format_item(
				{
          layout = wibox.layout.fixed.horizontal,
    			spacing = dpi(16),
          require('widget.bluetooth-center.power-button'),
          require('widget.bluetooth-center.devices-button'),
          require('widget.bluetooth-center.search-button'),
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
  forced_height = 70,
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
          require('widget.bluetooth-center.devices-text'),
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
          require('widget.bluetooth-center.devices-panel'),
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

bluetoothCenter = wibox(
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
    fg = '#FEFEFE'
  }
)

awesome.connect_signal(
  "bluetooth::center:toggle",
  function()
    if bluetoothCenter.visible == false then
      awesome.emit_signal("bar::centers:toggle:off")
      bluetoothCenter.visible = true
    elseif bluetoothCenter.visible == true then
      bluetoothCenter.visible = false
    end
  end
)

awesome.connect_signal(
  "bluetooth::center:toggle:off",
  function()
    bluetoothCenter.visible = false
  end
)

awesome.connect_signal(
  "bluetooth::center:tab",
  function(bar, i, cycleStatus, count)
    if cycleStatus then
      bluetoothCenter.visible = true
      return
    end
    if bluetoothCenter.visible and i == #bar then 
      bluetoothCenter.visible = false
      awesome.emit_signal(bar[1].."::center:tab",bar, 1, true, count)
    elseif bluetoothCenter.visible then
      bluetoothCenter.visible = false
      awesome.emit_signal(bar[i+1].."::center:tab",bar,i+1, true, count+1)
    elseif bluetoothCenter.visible == false and i ~= #bar then 
      awesome.emit_signal(bar[i+1].."::center:tab",bar,i+1, false, count+1)
    end
  end
)

awesome.connect_signal(
  "bluetooth::center:tab:reverse",
  function(bar, i, cycleStatus, count)
    if cycleStatus then
      bluetoothCenter.visible = true
      return
    end
    if bluetoothCenter.visible and i == 1 then 
      bluetoothCenter.visible = false
      awesome.emit_signal(bar[#bar].."::center:tab:reverse",bar, #bar, true, count)
    elseif bluetoothCenter.visible then
      bluetoothCenter.visible = false
      awesome.emit_signal(bar[i-1].."::center:tab:reverse",bar,i-1, true, count+1)
    elseif bluetoothCenter.visible == false and i ~= 1 then 
      awesome.emit_signal(bar[i-1].."::center:tab:reverse",bar,i-1, false, count+1)
    end
  end
)

local widget = wibox.widget{
  spacing = dpi(15),
  title,
  buttons,
  devices_text,
  devices_panel,
  layout = wibox.layout.fixed.vertical,
}

bluetoothCenter:set_widget(widget)
--bluetoothCenter:geometry({height = 400})