local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')

--- Title text for calendar portion of Calendar/To do panel


-- Left text
local main_content = wibox.widget {
	text = "to do",
  font = 'Inter Bold 14',
	widget = wibox.widget.textbox
}

-- Right text
local date_content = wibox.widget {
	text =os.date("%Y/%m/%d", os.time(os.date('*t'))),
  font = 'Inter Bold 14',
	widget = wibox.widget.textbox,
}

-- Left text container widget
local widget_main = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		main_content,
		layout = wibox.layout.align.horizontal,

	},
	nil
}

-- Right text container widget
local widget_date = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		date_content,
		layout = wibox.layout.align.horizontal,
	},
	nil
}

-- Spacer bar between
local spacer_bar = wibox.widget {
  {
    orientation = 'vertical',
  	forced_height = dpi(1),
    forced_width = dpi(2),
    shape = gears.shape.rounded_bar,
  	widget = wibox.widget.separator,
  },
  margins = dpi(10),
  widget = wibox.container.margin
}

-- Update right text to specified string
update_to_do_date_text = function(string)
	date_content:set_text(string)
end

update_to_do_date_text2 = function(string)
	main_content:set_text(string)
end

-- Combine 2 text widgets and spacer bar into 1
local widget = wibox.widget {
   {
    widget_main,
    spacer_bar,
		widget_date,
  	layout = wibox.layout.fixed.horizontal,
	},
  fg = '#DDD',
	widget = wibox.container.background
}

return widget
