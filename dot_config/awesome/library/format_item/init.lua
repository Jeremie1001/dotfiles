local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi

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

return format_item