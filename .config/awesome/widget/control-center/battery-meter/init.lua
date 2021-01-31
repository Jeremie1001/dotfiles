--DEPENDENCIES
  --upower

local wibox = require('wibox')
local gears = require('gears')
local naughty = require('naughty')
local dpi = require('beautiful').xresources.apply_dpi
local colors = require('themes.dracula.colors')
local watch = require('awful.widget.watch')

local main_color = colors.green

local widget_text = wibox.widget {
  font = 'Inter Bold 12',
  text = "PWR",
  valign = "center",
  align = "center",
  widget = wibox.widget.textbox
}

local slider = wibox.widget {
  widget_text,
  colors = {'transparent', main_color},
  border_width = dpi(1),
  border_color = main_color,
  thickness = dpi(10),
  values = {96, 4},
  max_value = 130,
  min_value = 0,
  rounded_edge = true,
  start_angle = 47.5/130*2*math.pi,
  widget = wibox.container.arcchart
}

watch (
	[[bash -c "upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep 'percentage' | awk '{print $2}' | sed 's/%//'"]],
	5,
  function(_, stdout)
    local old_percentage = percentage
		local percentage = stdout
    if stdout == "" then
      percentage = 100
    end
    if old_percentage > 20 and percentage <= 20 then
      naughty.notify({title = "Battery is low", text = "Below 20%", urgency='critical'})
    end
    slider:set_values({(100-(percentage)), (percentage)})
		collectgarbage('collect')
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
  bg = colors.background,
  fg = main_color,
  widget = wibox.container.background
}

return batt_meter
