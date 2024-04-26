--DEPENDENCIES
	--speedtest-cli

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')

local return_button = function(color, lspace, rspace)
	local widget_button = wibox.widget {
			{
				{
					{
						{
						image = icons.batt_2,
						widget = wibox.widget.imagebox
					},
					top = dpi(4),
					bottom = dpi(4),
					left = dpi(12),
					right = dpi(12),
					widget = wibox.container.margin
				},
				shape = gears.shape.rounded_bar,
				bg = color.color,
				widget = wibox.container.background
			},
			forced_width = icon_size,
			forced_height = icon_size,
			widget = clickable_container
		},
		top = dpi(5),
		right = dpi(rspace),
		left = dpi(lspace),
		widget = wibox.container.margin
	}
	
	awesome.emit_signal('batteryCenter::color', color)

	local tooltip = function()
		local cmd = "upower -i $(upower -e | grep BAT) | grep 'percentage' | sed 's/%//' | sed 's/percentage://'"

		local cmdFunction = function(stdout)
			local power = stdout:gsub(" ",""):gsub("\n","").."%"
			return power
		end

		local tooltip = require('widget.tooltip')(color, widget_button, true, cmd, cmdFunction)
	end

	tooltip()

	widget_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					awesome.emit_signal("tooltip::visible:off")
					awesome.emit_signal('batteryCenter::batterySlider:update')
					awesome.emit_signal('batteryCenter::status:update')
					awesome.emit_signal("battery::center:toggle")
				end
			)
		)
	)

	return widget_button
end

return return_button
