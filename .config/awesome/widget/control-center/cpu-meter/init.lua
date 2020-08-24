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
	[[bash -c "cat /proc/stat | grep '^cpu '"]],
	20,
	function(_, stdout)
    local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
			stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')

		local total = user + nice + system + idle + iowait + irq + softirq + steal

		local delta_idle = idle - idle_i
		local delta_total = total - total_i
    local utilization = delta_total - delta_idle

    local percentage =  utilization/delta_total*100

    slider:set_values({(100-percentage), percentage})

    idle_i = idle
    total_i = total

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
