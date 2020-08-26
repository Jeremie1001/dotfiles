--DEPENDENCIES
	--pamixer
  --lm_sensors
  --free

local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local colors = require('themes.dracula.colors')
local dpi = require('beautiful').xresources.apply_dpi
local screen_geometry = require('awful').screen.focused().geometry

local format_item = function(widget)
  return wibox.widget {
		{
			{
				layout = wibox.layout.align.vertical,
				expand = 'none',
				nil,
				widget,
				nil
			},
			margins = dpi(5),
			widget = wibox.container.margin
		},
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
		end,
    bg = 'transparent',
		widget = wibox.container.background
	}
end

local dials = wibox.widget {
  {
      {
      spacing = dpi(0),
    	layout = wibox.layout.flex.horizontal,
    	format_item(
    		{
    			layout = wibox.layout.fixed.vertical,
    			spacing = dpi(10),
          require('widget.control-center.ram-meter'),
          require('widget.control-center.cpu-meter'),
    		}
    	),
      format_item(
    		{
    			layout = wibox.layout.fixed.vertical,
    			spacing = dpi(10),
          require('widget.control-center.hdd-meter'),
          require('widget.control-center.battery-meter'),
          --require('widget.control-center.temp-meter'),
    		}
    	),
    },
    margins = dpi(5),
    widget = wibox.container.margin
  },
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
  end,
  bg = colors.alpha(colors.selection, 'F2'),
  forced_width = 400,
  forced_height = 400,
  border_width = dpi(2),
  border_color = colors.background,
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
          require('widget.control-center.volume-slider'),
          require('widget.control-center.brightness-slider'),
    		}
    	),
    },
    margins = dpi(5),
    widget = wibox.container.margin
  },
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
  end,
  bg = colors.alpha(colors.selection, 'F2'),
  forced_width = 400,
  forced_height = 190,
  border_width = dpi(2),
  border_color = colors.background,
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
          require('widget.control-center.bar-button'),
          require('widget.control-center.do-not-disturb'),
          require('widget.control-center.vpn-button'),
          require('widget.control-center.screen-capture'),
          require('widget.control-center.mute-button'),
          require('widget.control-center.restart-awesome'),
    		}
    	),
    },
    margins = dpi(5),
    widget = wibox.container.margin
  },
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
  end,
  bg = colors.alpha(colors.selection, 'F2'),
  forced_width = 400,
  forced_height = 70,
  border_width = dpi(2),
  border_color = colors.background,
  widget = wibox.container.background,
  layout,
}

local title = wibox.widget {
  {
      {
      spacing = dpi(0),
    	layout = wibox.layout.flex.vertical,
    	format_item(
    		{
    			layout = wibox.layout.fixed.horizontal,
    			spacing = dpi(16),
          require('widget.control-center.dracula-icon'),
          require('widget.control-center.title-text'),
    		}
    	),
    },
    margins = dpi(5),
    widget = wibox.container.margin
  },
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
  end,
  bg = colors.alpha(colors.selection, 'F2'),
  forced_width = 400,
  forced_height = 70,
  border_width = dpi(2),
  border_color = colors.background,
  widget = wibox.container.background,
  layout,
}


controlCenter = wibox(
  {
    x = screen_geometry.x+dpi(8),
    y = screen_geometry.y+dpi(35),
    visible = false,
    ontop = true,
    type = 'splash',
    height = screen_geometry.height-dpi(35),
    width = screen_geometry.width,
    bg = 'transparent',
    fg = '#FEFEFE',
  }
)

function cc_resize()
  cc_height = screen_geometry.height
  if controlCenter.height == screen_geometry.height-dpi(35) then
    controlCenter:geometry{height = screen_geometry.height, y = screen_geometry.y+dpi(8)}
  elseif controlCenter.height == screen_geometry.height then
    controlCenter:geometry{height = screen_geometry.height-dpi(35), y = screen_geometry.y+dpi(35)}
  end
end


function cc_toggle()
  if controlCenter.visible == false then
    controlCenter.visible = true
  elseif controlCenter.visible == true then
    controlCenter.visible = false
  end
end

controlCenter:setup {
  {
    spacing = dpi(15),
    title,
    buttons,
    dials,
    sliders,
    layout = wibox.layout.fixed.vertical,
  },
  layout = wibox.layout.fixed.horizontal,
}
