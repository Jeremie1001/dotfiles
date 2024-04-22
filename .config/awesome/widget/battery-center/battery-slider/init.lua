local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors
local settings = require('settings')

local box = {}

local color = colors[settings.bar.colors.battery]

local batteryIcon = wibox.widget {
  layout = wibox.layout.align.vertical,
  expand = 'none',
  nil,
  {
    id = 'icon',
    image = icons.batt_4,
    resize = true,
    widget = wibox.widget.imagebox
  },
  nil
}

local battery = wibox.widget {
  {
    {
      batteryIcon,
      layout = wibox.layout.fixed.horizontal,
    },
    margins = dpi(7),
    widget = wibox.container.margin
  },
  shape = gears.shape.rect,
  forced_width = 40,
  forced_height = 40,
  bg = color,
  widget = wibox.container.background
}

local icon_table = {
  icons.batt_1,
  icons.batt_2,
  icons.batt_3,
  icons.batt_4
}

local slider = wibox.widget {
  nil,
  {
    id 					        = 'battery_slider',
    shape               = gears.shape.rounded_rect,
    bar_shape           = gears.shape.rounded_rect,
    bar_height          = dpi(40),
    background_color    = colors.colorA,
    color		            = color,
    widget              = wibox.widget.progressbar
  },
  nil,
  expand = 'none',
  forced_height = dpi(40),
  layout = wibox.layout.align.vertical
}

local battery_slider = slider.battery_slider

local update_slider = function()
  awful.spawn.easy_async_with_shell(
  [[bash -c "upower -i $(upower -e | grep BAT) | grep 'percentage' | sed 's/%//' | sed 's/percentage://'"]],
    function(stdout)
      battery_slider:set_value(tonumber(stdout)/100)
      batteryIcon.icon:set_image(icon_table[math.ceil(tonumber(stdout)/25)])
    end
  )
end

update_slider()

awesome.connect_signal(
  'batteryCenter::batterySlider:update',
  function()
    update_slider()
  end
)

box = wibox.widget {
  {
    battery,
    {
      slider,
      margins = dpi(8),
      widget = wibox.container.margin
    },
    layout = wibox.layout.align.horizontal,
  },
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, dpi(4))
  end,
  fg = colors.white,
  border_width = dpi(1),
  border_color = colors.colorA,
  widget = wibox.container.background
}

return box