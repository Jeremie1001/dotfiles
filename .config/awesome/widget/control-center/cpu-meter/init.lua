local wibox = require('wibox')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local colors = require('themes.dracula.colors')
local watch = require('awful.widget.watch')

local main_color = colors.pink

local widget_text = wibox.widget {
  font = 'Inter Bold 12',
  text = "CPU",
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

local idle_i = 0
local total_i = 0

watch (
	[[ sh -c "vmstat 1 2 | tail -1 | awk '{printf \"%d\", $15}'" ]],
	5,
	function(_, stdout)
    local cpu_idle = stdout
    cpu_idle = string.gsub(cpu_idle, '^%s*(.-)%s*$', '%1')

    slider:set_values({tonumber(cpu_idle), 100 - tonumber(cpu_idle)})

		collectgarbage('collect')
	end
)

local cpu_meter = wibox.widget {
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

return cpu_meter
