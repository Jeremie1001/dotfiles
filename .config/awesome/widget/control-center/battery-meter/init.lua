--DEPENDENCIES
  --upower

local wibox = require('wibox')
local gears = require('gears')
local naughty = require('naughty')
local dpi = require('beautiful').xresources.apply_dpi
local colors = require('themes').colors
local watch = require('awful.widget.watch')

local main_color = colors.color6

local widget_text = wibox.widget {
  font = 'Inter Bold 12',
  text = "PWR",
  valign = "center",
  align = "center",
  widget = wibox.widget.textbox
}

local slider = wibox.widget {
  widget_text,
  colors = {'transparent', main_color, 'transparent'},
  border_width = dpi(1),
  border_color = main_color,
  thickness = dpi(10),
  values = {100, 0},
  max_value = 130,
  min_value = 0,
  rounded_edge = true,
  start_angle = 47.5/130*2*math.pi,
  widget = wibox.container.arcchart
}

local old_percentage = 0

watch (
  [[bash -c "upower -i $(upower -e | grep BAT) | grep 'percentage' | awk '{print $2}' | sed 's/%//'"]],
	5,
  function(_, stdout)
    local percentage = stdout
    if stdout == "" then
      percentage = 100
    elseif tonumber(stdout) < 5 then
      percentage = 5
    end
    slider:set_values({(100-(tonumber(percentage))), (tonumber(percentage))})
    widget_text:set_text("Pwr\n"..stdout)
    if tonumber(old_percentage) >= 20 and tonumber(percentage) < 20 then
      naughty.notify ({
        app_name = 'System notification',
        title = 'Battery low',
        message = 'Battery has dropped below 20% ('..percentage..'%), please charge now',
        urgency = 'critical'
      })
    end
		collectgarbage('collect')
    old_percentage = percentage
	end
)

local batt_meter = wibox.widget {
	{
    {
      slider,
  		layout = wibox.layout.fixed.horizontal
    },
    margins = dpi(30),
    widget = wibox.container.margin
  },
  shape = gears.shape.rounded_rect,
  bg = colors.colorA,
  fg = main_color,
  widget = wibox.container.background
}

return batt_meter
